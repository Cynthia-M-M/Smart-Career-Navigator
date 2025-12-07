"""
Ranking Algorithms - Role Ranking and Skill Gap Scoring
"""

walker role_ranking_algorithm {
    has user_node: node(User);
    has candidate_roles: list;  # List of Role nodes
    has market_data: dict = {};
    
    can User;
    can Role;
    can Skill;
    
    with user_node {
        # Get user skills with proficiency
        user_skills = {};
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id {
            user_skills[there.id] = {
                "proficiency": here.user_skill.proficiency,
                "years": here.user_skill.years_experience
            };
        }
        
        # Score each role
        role_scores = [];
        
        for role_node in candidate_roles {
            # Get required skills for this role
            required_skills = [];
            take --> node::Skill(-[required_skill]->node::Role);
            if here.id == role_node.id {
                required_skills.push({
                    "skill": there,
                    "required_level": here.required_skill.required_level,
                    "importance": here.required_skill.importance,
                    "mandatory": here.required_skill.is_mandatory
                });
            }
            
            # Calculate match score
            total_score = 0.0;
            total_weight = 0.0;
            matched_skills = 0;
            mandatory_matched = 0;
            mandatory_total = 0;
            
            for req_skill in required_skills {
                skill_id = req_skill["skill"].id;
                user_skill_data = user_skills.get(skill_id, None);
                
                if req_skill["mandatory"] {
                    mandatory_total += 1;
                }
                
                if user_skill_data {
                    user_prof = user_skill_data["proficiency"];
                    required_prof = req_skill["required_level"];
                    importance = req_skill["importance"];
                    
                    # Calculate skill match
                    if user_prof >= required_prof {
                        skill_score = 1.0;
                        matched_skills += 1;
                        if req_skill["mandatory"] {
                            mandatory_matched += 1;
                        }
                    } else {
                        # Partial match based on how close
                        skill_score = user_prof / required_prof;
                    }
                    
                    # Weighted contribution
                    contribution = skill_score * importance;
                    total_score += contribution;
                    total_weight += importance;
                } else {
                    # Missing skill - penalty
                    penalty = req_skill["importance"] * 0.5;
                    total_weight += req_skill["importance"];
                }
            }
            
            # Normalize score
            if total_weight > 0 {
                normalized_score = total_score / total_weight;
            } else {
                normalized_score = 0.0;
            }
            
            # Mandatory skills check
            mandatory_penalty = 0.0;
            if mandatory_total > 0:
                mandatory_match_rate = mandatory_matched / mandatory_total;
                if mandatory_match_rate < 1.0 {
                    mandatory_penalty = (1.0 - mandatory_match_rate) * 0.3;
                }
            
            # Market demand multiplier
            market_mult = 1.0;
            if market_data.get(role_node.id):
                market_mult = market_data[role_node.id].get("demand_multiplier", 1.0);
            
            # Growth rate bonus
            growth_bonus = role_node.growth_rate / 100.0 * 0.1;  # Max 10% bonus
            
            # Final score
            final_score = (
                normalized_score * 0.6 +
                (matched_skills / std.max(std.len(required_skills), 1)) * 0.2 -
                mandatory_penalty * 0.2
            ) * market_mult + growth_bonus;
            
            # Cap at 1.0
            final_score = std.min(final_score, 1.0);
            
            role_scores.push({
                "role": role_node,
                "score": final_score,
                "skill_match_percentage": matched_skills / std.max(std.len(required_skills), 1),
                "mandatory_match": mandatory_match_rate,
                "market_demand": market_mult,
                "growth_rate": role_node.growth_rate
            });
        }
        
        # Sort by score
        role_scores.sort(key=lambda x: x["score"], reverse=True);
        
        report role_scores;
    }
}

walker skill_gap_scoring_formula {
    has user_skills: dict;  # {skill_id: proficiency}
    has target_skills: list;  # List of {skill: node, required_level: float, importance: float}
    
    can Skill;
    
    gap_analysis = [];
    total_gap_score = 0.0;
    total_weight = 0.0;
    
    with skill_node {
        # Find this skill in target_skills
        target_data = None;
        for target in target_skills {
            if target["skill"].id == skill_node.id {
                target_data = target;
                break;
            }
        }
        
        if target_data {
            required_level = target_data["required_level"];
            importance = target_data["importance"];
            current_level = user_skills.get(skill_node.id, 0.0);
            
            # Calculate gap
            gap = required_level - current_level;
            if gap < 0 {
                gap = 0;  # User exceeds requirement
            }
            
            # Weighted gap score
            weighted_gap = gap * importance;
            total_gap_score += weighted_gap;
            total_weight += importance;
            
            # Priority calculation
            priority = gap * importance;
            
            # Time estimate (rough heuristic)
            if gap <= 0.2 {
                time_estimate = "1-2 months";
            } elif gap <= 0.4 {
                time_estimate = "2-4 months";
            } elif gap <= 0.6 {
                time_estimate = "4-6 months";
            } else {
                time_estimate = "6+ months";
            }
            
            gap_analysis.push({
                "skill": skill_node.name,
                "skill_id": skill_node.id,
                "current_level": current_level,
                "required_level": required_level,
                "gap": gap,
                "importance": importance,
                "priority": priority,
                "time_estimate": time_estimate,
                "category": skill_node.category
            });
        }
    }
    
    with entry {
        # Calculate overall gap score
        if total_weight > 0 {
            overall_gap_score = total_gap_score / total_weight;
        } else {
            overall_gap_score = 0.0;
        }
        
        # Sort by priority
        gap_analysis.sort(key=lambda x: x["priority"], reverse=True);
        
        report {
            "overall_gap_score": overall_gap_score,
            "gap_analysis": gap_analysis,
            "critical_gaps": [g for g in gap_analysis if g["gap"] > 0.5],
            "moderate_gaps": [g for g in gap_analysis if 0.2 < g["gap"] <= 0.5],
            "minor_gaps": [g for g in gap_analysis if 0 < g["gap"] <= 0.2]
        };
    }
}

