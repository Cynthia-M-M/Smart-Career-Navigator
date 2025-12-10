"""
Configuration settings for the Career Navigator
"""

import os;
from os import getenv;

# API Configuration
glob OPENAI_API_KEY = getenv("OPENAI_API_KEY", "");
glob JOB_API_KEY = getenv("JOB_API_KEY", "");
glob JOB_API_URL = getenv("JOB_API_URL", "https://api.example.com/jobs");

# Server Configuration
glob JAC_SERVER_URL = getenv("JAC_SERVER_URL", "http://localhost:8000");
glob JAC_SERVER_MODE = getenv("JAC_SERVER_MODE", "dev");

# Application Settings
glob MAX_RECOMMENDATIONS = 10;
glob DEFAULT_TIME_CONSTRAINT_DAYS = 180;
glob MARKET_ANALYSIS_WINDOW_DAYS = 90;

# LLM Settings
glob DEFAULT_LLM_MODEL = "gpt-4o-mini";
glob LLM_TEMPERATURE = 0.3;
glob LLM_MAX_TOKENS = 2000;

