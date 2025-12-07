"""
Recommendation Walkers
"""

from backend.algorithms.ranking import role_ranking_algorithm;
from backend.agents.critic_agent import critic_quality_check_recommendations;

walker recommend_roles_walker {
    has user_id: str;
    has limit: int = 10;
    has include_market_data: bool = True;
    
    can User;
    can Role;
    can Skill;
    
    with root {
        # Find user
        user_node = null;
        take --> node::User;
        if here.id == user_id or here.email == user_id:
            user_node = here;
        
        if not user_node {
            report {"error": "User not found"};
            disengage;
        }
        
        # Get all roles
        candidate_roles = [];
        take --> node::Role;
        candidate_roles.push(here);
        
        if std.len(candidate_roles) == 0 {
            report {"error": "No roles found in graph"};
            disengage;
        }
        
        # Get market data if requested
        market_data = {};
        if include_market_data:
            # Collect market demand data for roles
            take --> node::Role;
            # In a real implementation, you'd query market signals
            market_data[here.id] = {
                "demand_multiplier": 1.0 + (here.growth_rate / 100.0),
                "salary_trend": "stable"
            };
        
        # Rank roles using algorithm
        spawn user_node walker::role_ranking_algorithm(
            candidate_roles=candidate_roles,
            market_data=market_data
        );
        ranked_roles = spawn_result;
        
        # Limit results
        if std.len(ranked_roles) > limit:
            ranked_roles = ranked_roles[:limit];
        
        # Quality check recommendations
        recommendations_dict = {
            "type": "role",
            "recommendations": ranked_roles,
            "user_profile": {
                "current_role": user_node.current_role,
                "experience_years": user_node.experience_years
            }
        };
        
        spawn here walker::critic_quality_check_recommendations(
            recommendations=recommendations_dict,
            user_profile={
                "user_id": user_node.id,
                "current_role": user_node.current_role,
                "target_role": user_node.target_role
            },
            recommendation_type="role"
        );
        critique = spawn_result;
        
        # Format response
        formatted_recommendations = [];
        for role_data in ranked_roles:
            role_node = role_data["role"];
            formatted_recommendations.push({
                "role_id": role_node.id,
                "title": role_node.title,
                "industry": role_node.industry,
                "level": role_node.level,
                "match_score": role_data["score"],
                "skill_match_percentage": role_data["skill_match_percentage"],
                "market_demand": role_data["market_demand"],
                "growth_rate": role_data["growth_rate"],
                "salary_range": {
                    "min": role_node.avg_salary_min,
                    "max": role_node.avg_salary_max
                },
                "description": role_node.description
            });
        
        report {
            "recommendations": formatted_recommendations,
            "quality_check": critique,
            "total_roles_considered": std.len(candidate_roles)
        };
    }
}

walker recommend_courses {
    has user_id: str;
    has target_skills: list = [];  # List of skill names or IDs
    has limit: int = 10;
    
    can User;
    can Course;
    can Skill;
    
    with root {
        # Find user
        user_node = null;
        take --> node::User;
        if here.id == user_id or here.email == user_id:
            user_node = here;
        
        if not user_node {
            report {"error": "User not found"};
            disengage;
        }
        
        # Get user's current skills
        user_skill_ids = set();
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id:
            user_skill_ids.add(there.id);
        
        # Determine target skills
        target_skill_nodes = [];
        if std.len(target_skills) > 0:
            # Use provided target skills
            for skill_identifier in target_skills:
                take --> node::Skill;
                if here.name == skill_identifier or here.id == skill_identifier:
                    target_skill_nodes.push(here);
        else:
            # Use user's target role skills
            if user_node.target_role:
                take --> node::Role;
                if here.title == user_node.target_role:
                    take --> node::Skill(-[required_skill]->node::Role);
                    if there.id == here.id:
                        target_skill_nodes.push(here);
        
        # Find courses that teach target skills
        course_recommendations = [];
        for skill_node in target_skill_nodes:
            take --> node::Course(-[teaches_skill]->node::Skill);
            if here.id == skill_node.id:
                course_node = there;
                
                # Calculate match score
                coverage = here.teaches_skill.coverage;
                rating = course_node.rating;
                cost_factor = 1.0 - (course_node.cost / 1000.0);  # Normalize cost
                if cost_factor < 0:
                    cost_factor = 0.0;
                
                match_score = (coverage * 0.5 + rating / 5.0 * 0.3 + cost_factor * 0.2);
                
                # Check if user already has this skill
                user_has_skill = skill_node.id in user_skill_ids;
                if user_has_skill:
                    match_score *= 0.5;  # Lower priority if already known
                
                course_recommendations.push({
                    "course": course_node,
                    "skill": skill_node.name,
                    "match_score": match_score,
                    "coverage": coverage
                });
        
        # Sort by match score
        course_recommendations.sort(key=lambda x: x["match_score"], reverse=True);
        
        # Limit results
        if std.len(course_recommendations) > limit:
            course_recommendations = course_recommendations[:limit];
        
        # Format response
        formatted_courses = [];
        for rec in course_recommendations:
            course = rec["course"];
            formatted_courses.push({
                "course_id": course.id,
                "title": course.title,
                "provider": course.provider,
                "category": course.category,
                "teaches_skill": rec["skill"],
                "match_score": rec["match_score"],
                "cost": course.cost,
                "duration_hours": course.duration_hours,
                "rating": course.rating,
                "enrollment_count": course.enrollment_count,
                "url": course.url,
                "description": course.description
            });
        
        report {
            "courses": formatted_courses,
            "target_skills": [s.name for s in target_skill_nodes],
            "total_found": std.len(course_recommendations)
        };
    }
}

