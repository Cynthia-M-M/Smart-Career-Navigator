"""
Main entry point for Smart Career Path Navigator
Initializes graph and registers walkers as API endpoints
"""

import std.log;
from backend.config import *;
from backend.models.graph_models import *;
from backend.models.data_types import *;

# Initialize graph structure
graph {
    has anchor root;
}

# Import all walkers
from backend.walkers.resume_processing import parse_resume, extract_skills;
from backend.walkers.user_management import update_user_graph, get_user_profile;
from backend.walkers.market_analysis import market_trends_walker, fetch_job_data_walker;
from backend.walkers.recommendations import recommend_roles_walker, recommend_courses;
from backend.walkers.skill_analysis import skill_gap_analysis;
from backend.walkers.learning_path import generate_learning_path, get_weekly_plan;
from backend.walkers.visualization import graph_visualization_walker;
from backend.walkers.demo_data import seed_demo_data;

# Initialize walker for server startup
walker init {
    has ctx = {};
    
    with root {
        std.log.info("Smart Career Path Navigator - Backend Initialized");
        std.log.info(f"Server Mode: {JAC_SERVER_MODE}");
        std.log.info(f"OpenAI API Key configured: {bool(OPENAI_API_KEY)}");
        
        # Seed demo data if in dev mode
        if JAC_SERVER_MODE == "dev":
            std.log.info("Seeding demo data...");
            spawn here walker::seed_demo_data();
            seed_result = spawn_result;
            std.log.info(f"Demo data seeded: {seed_result}");
        
        report {
            "status": "initialized",
            "mode": JAC_SERVER_MODE,
            "timestamp": std.time.now()
        };
    }
}

# All walkers are automatically exposed as API endpoints
# Access via: POST /walker/{walker_name}
# Example: POST /walker/parse_resume with body: {"resume_text": "..."}

