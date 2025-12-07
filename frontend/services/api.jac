"""
API Service Wrapper for Jac Client
Provides helper functions for calling backend walkers
"""

cl import from jac:client_runtime { __jacSpawn, };

cl {
    # Parse resume
    async def parseResume(resumeText: str) -> dict {
        result = await __jacSpawn("parse_resume", "", {
            "resume_text": resumeText
        });
        return result;
    }
    
    # Get user profile
    async def getUserProfile(userId: str) -> dict {
        result = await __jacSpawn("get_user_profile", "", {
            "user_id": userId
        });
        return result;
    }
    
    # Update user graph
    async def updateUserGraph(userId: str, updates: dict) -> dict {
        result = await __jacSpawn("update_user_graph", "", {
            "user_id": userId,
            "updates": updates
        });
        return result;
    }
    
    # Get market trends
    async def getMarketTrends(timeWindowDays: int = 90) -> dict {
        result = await __jacSpawn("market_trends_walker", "", {
            "time_window_days": timeWindowDays
        });
        return result;
    }
    
    # Fetch job data
    async def fetchJobData(query: str = "", location: str = "", limit: int = 50) -> dict {
        result = await __jacSpawn("fetch_job_data_walker", "", {
            "query": query,
            "location": location,
            "limit": limit
        });
        return result;
    }
    
    # Recommend roles
    async def recommendRoles(userId: str, limit: int = 10) -> dict {
        result = await __jacSpawn("recommend_roles_walker", "", {
            "user_id": userId,
            "limit": limit
        });
        return result;
    }
    
    # Recommend courses
    async def recommendCourses(userId: str, targetSkills: list = [], limit: int = 10) -> dict {
        result = await __jacSpawn("recommend_courses", "", {
            "user_id": userId,
            "target_skills": targetSkills,
            "limit": limit
        });
        return result;
    }
    
    # Skill gap analysis
    async def analyzeSkillGaps(userId: str, targetRoleId: str = "", targetRoleTitle: str = "") -> dict {
        result = await __jacSpawn("skill_gap_analysis", "", {
            "user_id": userId,
            "target_role_id": targetRoleId,
            "target_role_title": targetRoleTitle
        });
        return result;
    }
    
    # Generate learning path
    async def generateLearningPath(userId: str, targetRoleId: str = "", targetRoleTitle: str = "", timeConstraintDays: int = 180) -> dict {
        result = await __jacSpawn("generate_learning_path", "", {
            "user_id": userId,
            "target_role_id": targetRoleId,
            "target_role_title": targetRoleTitle,
            "time_constraint_days": timeConstraintDays
        });
        return result;
    }
    
    # Get weekly plan
    async def getWeeklyPlan(userId: str, currentWeek: int, availableHours: int = 10) -> dict {
        result = await __jacSpawn("get_weekly_plan", "", {
            "user_id": userId,
            "current_week": currentWeek,
            "available_hours_per_week": availableHours
        });
        return result;
    }
    
    # Get graph visualization
    async def getGraphVisualization(userId: str = "", focusNodeId: str = "", layout: str = "force") -> dict {
        result = await __jacSpawn("graph_visualization_walker", "", {
            "user_id": userId,
            "focus_node_id": focusNodeId,
            "layout": layout
        });
        return result;
    }
}

