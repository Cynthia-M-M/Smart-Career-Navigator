"""
Supporting data types and structures for the Career Navigator
"""

# Data structures for walker returns and API responses

obj SkillAnalysis {
    has skill_name: str;
    has current_proficiency: float;
    has required_proficiency: float;
    has gap: float;
    has priority: float;
    has recommended_courses: list;
    has recommended_certifications: list;
}

obj RoleRecommendation {
    has role_title: str;
    has match_score: float;
    has skill_match_percentage: float;
    has missing_skills: list;
    has market_demand: float;
    has salary_range: dict;
    has growth_projection: float;
    has learning_path: list;
}

obj LearningPath {
    has target_role: str;
    has milestones: list;
    has estimated_duration_days: int;
    has total_cost: float;
    has difficulty: str;
    has weekly_plan: list;
}

obj CourseRecommendation {
    has course_title: str;
    has provider: str;
    has teaches_skills: list;
    has match_score: float;
    has cost: float;
    has duration_hours: int;
    has rating: float;
    has url: str;
}

obj JobRecommendation {
    has job_title: str;
    has company: str;
    has location: str;
    has match_score: float;
    has salary_range: dict;
    has required_skills: list;
    has user_skill_match: float;
    has application_url: str;
}

obj MarketTrend {
    has skill_name: str;
    has current_demand: float;
    has trend_direction: str;
    has projected_demand: float;
    has growth_rate: float;
    has salary_impact: float;
}

obj GraphVisualization {
    has nodes: list;
    has edges: list;
    has layout: str = "force";  # "force", "hierarchical", "circular"
    has focus_node: str = None;
}

