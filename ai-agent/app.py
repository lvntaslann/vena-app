from flask import Flask, request, jsonify
from planner.planner_service import PlannerService
from datetime import datetime

app = Flask(__name__)

@app.route("/generate-plan", methods=["POST"])
def generate_plan():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Geçerli JSON gönderilmedi"}), 400

    examCalendar = data.get("examCalendar")
    startingTime = data.get("startingTime", "09:00")
    endTime = data.get("endTime", "20:00")
    breakTimeMinutes = data.get("breakTimeMinutes", 30)

    if not examCalendar:
        return jsonify({"error": "examCalendar alanı gereklidir"}), 400

    try:
        plan = PlannerService.generate_plan(
            examCalendar,
            startingTime,
            endTime,
            breakTimeMinutes,
        )
        return jsonify(plan)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    
@app.route("/get-resources", methods=["POST"])
def get_resources():
    data = request.get_json()
    print("DEBUG: GELEN DATA =", data)

    examCalendar = data.get("examCalendar")
    print("DEBUG: EXAM CALENDAR =", examCalendar)

    try:
        resources = PlannerService.get_resources_with_agent(examCalendar)
        return jsonify(resources)
    except Exception as e:
        import traceback
        print("DEBUG TRACEBACK:", traceback.format_exc())
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=7000, debug=True)
