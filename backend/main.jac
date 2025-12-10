"""
Main entry point for Smart Career Path Navigator
Initializes graph and registers walkers as API endpoints
"""

import std;
# import from config {*}
# import from .models.graph_models {*}
# import from models.data_types {*}

# Initialize graph structure
# graph {
#     has anchor root;
# }

# Import all walkers
# import from walkers.resume_processing {parse_resume, extract_skills}
# import from walkers.user_management {update_user_graph, get_user_profile}
# import from walkers.market_analysis {market_trends_walker, fetch_job_data_walker}
# import from walkers.recommendations {recommend_roles_walker, recommend_courses}
# import from walkers.skill_analysis {skill_gap_analysis}
# import from walkers.learning_path {generate_learning_path, get_weekly_plan}
# import from walkers.visualization {graph_visualization_walker}
import from walkers.demo_data {seed_demo_data}

# Initialize walker for server startup
walker init {
    has ctx:obj = {};
    
    can start with `root entry {
        std.log.info("Smart Career Path Navigator - Backend Initialized");
        std.log.info(f"Server Mode: {JAC_SERVER_MODE}");
        std.log.info(f"OpenAI API Key configured: {bool(OPENAI_API_KEY)}");
        
        # Seed demo data if in dev mode
        if JAC_SERVER_MODE == "dev" {
            std.log.info("Seeding demo data...");
            seed_result = spawn seed_demo_data();
            std.log.info(f"Demo data seeded: {seed_result}");
        }
        report {
            "status": "initialized",
            "mode": JAC_SERVER_MODE,
            "timestamp": std.time.now()
        };
    }
}