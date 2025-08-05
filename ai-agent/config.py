import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
    SERPER_API_KEY = os.getenv("SERPER_API_KEY")
    LITELLM_PROVIDER = os.getenv("LITELLM_PROVIDER")

    PLANNER_BACKSTORY = os.getenv("PLANNER_BACKSTORY")
    PLANNER_BACKSTORY_2 = os.getenv("PLANNER_BACKSTORY_2")
    PLANNER_TASK_DESCRIPTION = os.getenv("PLANNER_TASK_DESCRIPTION")
