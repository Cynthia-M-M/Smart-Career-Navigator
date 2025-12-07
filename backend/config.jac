"""
Configuration settings for the Career Navigator
"""

import os;
from dotenv import load_dotenv;
load_dotenv();

# API Configuration
can OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "");
can JOB_API_KEY = os.getenv("JOB_API_KEY", "");
can JOB_API_URL = os.getenv("JOB_API_URL", "https://api.example.com/jobs");

# Server Configuration
can JAC_SERVER_URL = os.getenv("JAC_SERVER_URL", "http://localhost:8000");
can JAC_SERVER_MODE = os.getenv("JAC_SERVER_MODE", "dev");

# Application Settings
can MAX_RECOMMENDATIONS = 10;
can DEFAULT_TIME_CONSTRAINT_DAYS = 180;
can MARKET_ANALYSIS_WINDOW_DAYS = 90;

# LLM Settings
can DEFAULT_LLM_MODEL = "gpt-4o-mini";
can LLM_TEMPERATURE = 0.3;
can LLM_MAX_TOKENS = 2000;

