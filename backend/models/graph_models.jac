"""
OSP Graph Models for Smart Career Path Navigator
Defines all nodes and edges for the career navigation graph
"""

# ============================================================================
# NODE DEFINITIONS
# ============================================================================

node User {
    has name: str;
    has email: str;
    has resume_text: str = "";
    has experience_years: float = 0.0;
    has current_role: str = "";
    has target_role: str = "";
    has created_at: datetime;
    has updated_at: datetime;
    
    # Graph relationships
    can user_skill;
    can has_certification;
    can has_experience;
    can interested_in_role;
}

node Skill {
    has name: str;
    has category: str;  # e.g., "Technical", "Soft", "Domain"
    has description: str = "";
    has market_demand_score: float = 0.0;  # 0-1 scale
    has trend_direction: str = "stable";  # "rising", "falling", "stable"
    has last_updated: datetime;
    
    # Graph relationships
    can required_by_role;
    can taught_by_course;
    can prerequisite_for;
    can related_to;
}

node Role {
    has title: str;
    has industry: str;
    has level: str;  # "entry", "mid", "senior", "executive"
    has description: str = "";
    has avg_salary_min: float = 0.0;
    has avg_salary_max: float = 0.0;
    has growth_rate: float = 0.0;  # percentage
    has created_at: datetime;
    
    # Graph relationships
    can requires_skill;
    can requires_certification;
    can similar_to;
}

node Certification {
    has name: str;
    has issuer: str;  # e.g., "AWS", "Google", "Microsoft"
    has category: str;
    has difficulty: str = "intermediate";  # "beginner", "intermediate", "advanced"
    has cost: float = 0.0;
    has duration_days: int = 0;
    has validity_years: int = 0;
    has description: str = "";
    
    # Graph relationships
    has_certification;
    validates_skill;
}

node Course {
    has title: str;
    has provider: str;  # e.g., "Coursera", "Udemy", "edX"
    has category: str;
    has difficulty: str = "intermediate";
    has cost: float = 0.0;
    has duration_hours: int = 0;
    has rating: float = 0.0;
    has enrollment_count: int = 0;
    has description: str = "";
    has url: str = "";
    
    # Graph relationships
    can teaches_skill;
    can requires_certification;
    can prerequisite_course;
}

node JobPosting {
    has title: str;
    has company: str;
    has location: str;
    has salary_min: float = 0.0;
    has salary_max: float = 0.0;
    has job_type: str = "full-time";  # "full-time", "part-time", "contract"
    has description: str = "";
    has posted_date: datetime;
    has application_url: str = "";
    has match_score: float = 0.0;  # Calculated match with user
    
    # Graph relationships
    can requires_skill;
    can requires_role;
}

node MarketSignal {
    has skill_name: str;
    has signal_type: str;  # "demand_spike", "supply_shortage", "trending"
    has intensity: float = 0.0;  # 0-1 scale
    has source: str = "";  # "job_postings", "salary_data", "trend_analysis"
    has timestamp: datetime;
    has region: str = "global";
    has industry: str = "";
    
    # Graph relationships
    can signals_skill;
}

# ============================================================================
# EDGE DEFINITIONS
# ============================================================================

edge UserSkill {
    has proficiency: float = 0.0;  # 0-1 scale
    has years_experience: float = 0.0;
    has last_used: datetime;
    has verified: bool = False;  # Whether verified by resume/certification
}

edge RequiredSkill {
    has importance: float = 1.0;  # Weight for matching
    has required_level: float = 0.5;  # Minimum proficiency needed
    has is_mandatory: bool = True;
}

edge RoleSkill {
    has importance: float = 1.0;
    has typical_level: float = 0.5;  # Typical proficiency in this role
}

edge HasCertification {
    has date_earned: datetime;
    has expiry_date: datetime = None;
    has verification_url: str = "";
}

edge TeachesSkill {
    has coverage: float = 1.0;  # How well the course covers this skill
    has depth: str = "intermediate";  # "basic", "intermediate", "advanced"
}

edge RequiresCertification {
    has is_mandatory: bool = True;
}

edge PrerequisiteFor {
    has order: int = 0;  # Sequence order
}

edge RelatedTo {
    has similarity: float = 0.5;  # 0-1 similarity score
}

edge SimilarTo {
    has similarity: float = 0.5;
}

edge SignalsSkill {
    has relevance: float = 1.0;
}

edge ValidatesSkill {
    has validation_level: float = 1.0;  # How well cert validates the skill
}

edge PrerequisiteCourse {
    has is_mandatory: bool = True;
}

edge RequiresRole {
    has min_level: str = "entry";
}

edge InterestedInRole {
    has priority: float = 1.0;  # User's interest level
    has target_date: datetime = None;
}

edge HasExperience {
    has role_title: str;
    has company: str;
    has start_date: datetime;
    has end_date: datetime = None;
    has is_current: bool = False;
    has description: str = "";
}

