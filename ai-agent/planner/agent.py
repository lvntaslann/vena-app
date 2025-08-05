from crewai import Agent, LLM
from config import Config
from planner.prompts import PlannerPrompts


class PlannerAgentFactory:
    @staticmethod
    def create_agent_planner():
        llm = LLM(
            model="gemini/gemini-2.5-flash",
            temperature=0.5,
            verbose=True,
            api_key=Config.GOOGLE_API_KEY,
            provider=Config.LITELLM_PROVIDER,
        )

        agent = Agent(
            role="Öğrenci Temsilcisi",
            goal="Kullanıcı için 1 haftalık ders çalışma planı oluşturmak ve güncellemek",
            backstory=PlannerPrompts.BACKSTORY,
            verbose=True,
            allow_delegation=False,
            llm=llm,
        )
        return agent
    
    @staticmethod
    def create_agent_resources():
        llm = LLM(
            model="gemini/gemini-2.5-flash",
            temperature=0.5,
            verbose=True,
            api_key=Config.GOOGLE_API_KEY,
            provider=Config.LITELLM_PROVIDER,
        )

        agent = Agent(
            role="Ders kaynağı uzmanı",
            goal="Kullanıcının ders bilgilerine göre kaynak önermek. Gerektiğinde web araması yap.",
            backstory=PlannerPrompts.BACKSTORY2,
            verbose=True,
            allow_delegation=False,
            llm=llm,
        )
        return agent
