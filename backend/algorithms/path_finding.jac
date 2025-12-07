"""
Graph Algorithms - Path Finding and Weighted Scoring
"""

import std.time;
import std.log;

walker shortest_path_to_skill {
    has start_skill: node(Skill);
    has target_skill: node(Skill);
    has visited: set = set();
    has path: list = [];
    has min_path: list = [];
    has min_cost: float = 999999.0;
    
    can Skill;
    
    with skill_node entry {
        if skill_node.id == start_skill.id {
            path = [skill_node.id];
            take --> node::skill_node;
        }
    }
    
    with skill_node {
        if skill_node.id in visited {
            disengage;
        }
        
        visited.add(skill_node.id);
        path.push(skill_node.id);
        
        # Check if we reached the target
        if skill_node.id == target_skill.id {
            cost = std.len(path) - 1;  # Path length as cost
            if cost < min_cost {
                min_cost = cost;
                min_path = path.copy();
            }
            path.pop();
            visited.remove(skill_node.id);
            disengage;
        }
        
        # Continue traversal
        take --> node::skill_node;
        
        # Backtrack
        path.pop();
        visited.remove(skill_node.id);
    }
    
    with skill_node exit {
        if std.len(min_path) > 0 {
            report min_path;
        }
    }
}

walker weighted_relevance_scoring {
    has user_skills: dict;  # {skill_id: proficiency}
    has target_skills: list;  # List of skill nodes
    has weights: dict = {};  # Custom weights for different factors
    
    can Skill;
    can Role;
    
    with skill_node {
        skill_id = skill_node.id;
        user_prof = user_skills.get(skill_id, 0.0);
        
        # Base score from user proficiency
        base_score = user_prof;
        
        # Market demand multiplier
        market_mult = skill_node.market_demand_score;
        
        # Trend multiplier
        trend_mult = 1.0;
        if skill_node.trend_direction == "rising" {
            trend_mult = 1.2;
        } elif skill_node.trend_direction == "falling" {
            trend_mult = 0.8;
        }
        
        # Relevance to target skills
        relevance = 0.0;
        if skill_id in target_skills {
            relevance = 1.0;
        } else {
            # Check related skills
            for target_id in target_skills {
                take --> node::skill_node(-[related_to]->node::Skill);
                if here.id == target_id {
                    relevance = here.related_to.similarity;
                    break;
                }
            }
        }
        
        # Calculate weighted score
        weight_market = weights.get("market", 0.3);
        weight_trend = weights.get("trend", 0.2);
        weight_relevance = weights.get("relevance", 0.5);
        
        final_score = (
            base_score * 0.4 +
            market_mult * weight_market +
            trend_mult * weight_trend +
            relevance * weight_relevance
        );
        
        skill_node.relevance_score = final_score;
        report {"skill_id": skill_id, "score": final_score};
    }
}

walker calculate_skill_progression_path {
    has user_node: node(User);
    has target_role: node(Role);
    has max_depth: int = 10;
    
    can User;
    can Role;
    can Skill;
    
    with user_node {
        # Get user's current skills
        user_skills = {};
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id {
            user_skills[there.id] = here.user_skill.proficiency;
        }
        
        # Get required skills for target role
        required_skills = [];
        take --> node::Skill(-[required_skill]->node::Role);
        if here.id == target_role.id {
            required_skills.push({
                "skill": there,
                "required_level": here.required_skill.required_level,
                "importance": here.required_skill.importance
            });
        }
        
        # Build progression path
        progression_path = [];
        for req_skill_data in required_skills {
            skill_node = req_skill_data["skill"];
            required_level = req_skill_data["required_level"];
            current_level = user_skills.get(skill_node.id, 0.0);
            
            if current_level < required_level {
                # Find learning path to this skill
                gap = required_level - current_level;
                
                # Find courses that teach this skill
                courses = [];
                take --> node::Course(-[teaches_skill]->node::Skill);
                if here.id == skill_node.id {
                    courses.push({
                        "course": there,
                        "coverage": here.teaches_skill.coverage
                    });
                }
                
                progression_path.push({
                    "skill": skill_node.name,
                    "current_level": current_level,
                    "target_level": required_level,
                    "gap": gap,
                    "priority": req_skill_data["importance"],
                    "courses": courses
                });
            }
        }
        
        # Sort by priority and gap
        progression_path.sort(key=lambda x: x["priority"] * x["gap"], reverse=True);
        
        report progression_path;
    }
}

