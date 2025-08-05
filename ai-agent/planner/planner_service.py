from datetime import datetime, timedelta
import json
import re
from collections import OrderedDict
from crewai import Task, Crew
from planner.agent import PlannerAgentFactory
from planner.prompts import PlannerPrompts
from config import Config
from crewai_tools import SerperDevTool


class PlannerService:

    @staticmethod
    def _clean_json_text(text_output: str) -> str:
        """
        LLM çıktısını temizler: baştaki/sondaki gereksiz kod blokları, açıklamalar ve whitespace'leri kaldırır.
        """
        cleaned = text_output.strip()
        cleaned = re.sub(r"^```(?:json)?", "", cleaned, flags=re.IGNORECASE | re.MULTILINE).strip()
        cleaned = re.sub(r"```$", "", cleaned, flags=re.MULTILINE).strip()
        cleaned = re.sub(r"^(json|JSON)", "", cleaned).strip()
        if "{" in cleaned and "}" in cleaned:
            first = cleaned.find("{")
            last = cleaned.rfind("}")
            if first < last:
                cleaned = cleaned[first:last + 1].strip()

        return cleaned


    @staticmethod
    def generate_plan(examCalendar, startingTime, endTime, breakTimeMinutes, startingDate=None):
        if not startingDate:
            startingDate = datetime.now().date().isoformat()

        baslangic_dt = datetime.fromisoformat(startingDate)
        gun_sirasi = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]

        todayDateStr = baslangic_dt.strftime("%d.%m.%Y")
        todayDayStr = gun_sirasi[baslangic_dt.weekday()]

        start_weekday = baslangic_dt.weekday()
        hafta_sonu = 6  # Pazar

        gunler_1 = [(baslangic_dt + timedelta(days=i)) for i in range(hafta_sonu - start_weekday + 1)]
        gunler_2 = [(baslangic_dt - timedelta(days=start_weekday - i)) for i in range(start_weekday)]
        gunler_2 = sorted(gunler_2)

        haftalik_tarihler = gunler_1 + gunler_2

        prompt = PlannerPrompts.TASK_DESCRIPTION.format(
            examCalendar=examCalendar,
            startingTime=startingTime,
            endTime=endTime,
            breakTimeMinutes=breakTimeMinutes,
            todayDate=todayDateStr,
            todayDay=todayDayStr
        )

        agent = PlannerAgentFactory.create_agent_planner()

        task = Task(
            description=prompt,
            expected_output="Tam geçerli JSON formatında 1 haftalık çalışma planı.",
            agent=agent
        )

        crew = Crew(tasks=[task])
        response = crew.kickoff(inputs={
            "examCalendar": examCalendar,
            "startingTime": startingTime,
            "endTime": endTime,
            "breakTimeMinutes": breakTimeMinutes
        })

        if hasattr(response, "text"):
            text_output = response.text
        elif hasattr(response, "output"):
            text_output = response.output
        else:
            text_output = str(response)

        cleaned = re.sub(r"^```json|```$", "", text_output, flags=re.MULTILINE).strip()
        cleaned = re.sub(r"^json", "", cleaned).strip()

        try:
            plan_data = json.loads(cleaned)
        except json.JSONDecodeError as e:
            raise ValueError(f"LLM geçersiz JSON döndürdü: {e}\nÇıktı:\n{cleaned}")

        aiConfidence = plan_data.pop("ai_confidence", plan_data.pop("aiConfidence", 0.0))

        sirali_plan = OrderedDict()
        haftalik_toplam_saat = 0.0

        for tarih_dt in haftalik_tarihler:
            gun_ismi = gun_sirasi[tarih_dt.weekday()]
            tarih_str = tarih_dt.strftime("%Y-%m-%d")

            if gun_ismi in plan_data:
                gunluk_plan = plan_data[gun_ismi]
                toplam_saat = sum(oturum.get("lessonsDuration", 0) for oturum in gunluk_plan)
                haftalik_toplam_saat += toplam_saat

                sirali_plan[tarih_str] = {
                    "day": gun_ismi,
                    "plan": gunluk_plan,
                    "dailyTotalHours": round(toplam_saat, 2)
                }

        sirali_plan["meta"] = {
            "weeklyTotalHours": round(haftalik_toplam_saat, 2),
            "aiConfidence": aiConfidence
        }

        return sirali_plan
    

    @staticmethod
    def get_resources_with_agent(examCalendar):
        prompt = PlannerPrompts.RESOURCE_SUGGESTION_DESCRIPTION.format(
            examCalendar=json.dumps(examCalendar, ensure_ascii=False, indent=2)
        )

        serper_tool = SerperDevTool()

        agent = PlannerAgentFactory.create_agent_resources()

        task = Task(
            description=prompt,
            expected_output="Her ders ve konu için JSON formatında kaynak listesi",
            agent=agent,
            tools=[serper_tool]
        )

        crew = Crew(tasks=[task])
        response = crew.kickoff(inputs={"examCalendar": examCalendar})

        text_output = getattr(response, "text", getattr(response, "output", str(response)))
        cleaned = re.sub(r"^```json|```$", "", text_output, flags=re.MULTILINE).strip()

        try:
            return json.loads(cleaned)
        except json.JSONDecodeError as e:
            raise ValueError(f"LLM geçersiz JSON döndürdü: {e}\nÇıktı:\n{cleaned}")