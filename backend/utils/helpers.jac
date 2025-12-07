"""
Helper utility functions
"""

import std.time;
import std.log;

walker format_date {
    has date: datetime;
    has format: str = "iso";  # "iso", "human", "timestamp"
    
    with entry {
        if format == "iso":
            report date.isoformat();
        elif format == "human":
            # Simple human-readable format
            report date.strftime("%Y-%m-%d %H:%M:%S");
        elif format == "timestamp":
            report date.timestamp();
        else:
            report str(date);
    }
}

walker calculate_match_score {
    has user_skills: dict;  # {skill_id: proficiency}
    has required_skills: list;  # [{skill_id, required_level, importance}]
    
    with entry {
        total_score = 0.0;
        total_weight = 0.0;
        
        for req_skill in required_skills:
            skill_id = req_skill.get("skill_id", "");
            required_level = req_skill.get("required_level", 0.5);
            importance = req_skill.get("importance", 1.0);
            
            user_prof = user_skills.get(skill_id, 0.0);
            
            if user_prof >= required_level:
                skill_score = 1.0;
            else:
                skill_score = user_prof / required_level;
            
            contribution = skill_score * importance;
            total_score += contribution;
            total_weight += importance;
        
        if total_weight > 0:
            match_score = total_score / total_weight;
        else:
            match_score = 0.0;
        
        report match_score;
    }
}

walker validate_email {
    has email: str;
    
    with entry {
        import re;
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
        is_valid = bool(re.match(pattern, email));
        report {"valid": is_valid, "email": email};
    }
}

