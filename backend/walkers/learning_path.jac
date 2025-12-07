"""
Learning Path Generation Walkers
"""

from backend.agents.planner_agent import planner_create_roadmap, planner_split_milestones, planner_propose_weekly_plan;
from backend.agents.critic_agent import critic_validate_learning_path;
from backend.algorithms.path_finding import calculate_skill_progression_path;

walker generate_learning_path {
    has user_id: str;
    has target_role_id: str = "";
    has target_role_title: str = "";
    has time_constraint_days: int = 180;
    has learning_style: str = "balanced";
    
    can User;
    can Role;
    can Skill;
    can Course;
    can Certification;
    
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
        
        # Find target role
        target_role = null;
        if target_role_id:
            take --> node::Role;
            if here.id == target_role_id:
                target_role = here;
        elif target_role_title:
            take --> node::Role;
            if here.title == target_role_title:
                target_role = here;
        elif user_node.target_role:
            take --> node::Role;
            if here.title == user_node.target_role:
                target_role = here;
        
        if not target_role {
            report {"error": "Target role not found"};
            disengage;
        }
        
        # Get user's current skills
        current_skills = [];
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id:
            current_skills.push({
                "name": there.name,
                "proficiency": here.user_skill.proficiency
            });
        
        # Get target skills
        target_skills = [];
        take --> node::Skill(-[required_skill]->node::Role);
        if here.id == target_role.id:
            target_skills.push(there.name);
        
        # Calculate skill progression path
        spawn user_node walker::calculate_skill_progression_path(
            target_role=target_role
        );
        progression_data = spawn_result;
        
        # Use Planner Agent to create roadmap
        spawn here walker::planner_create_roadmap(
            current_skills=[s["name"] for s in current_skills],
            target_role=target_role.title,
            target_skills=target_skills,
            time_constraint_days=time_constraint_days,
            learning_style=learning_style
        );
        roadmap = spawn_result;
        
        # Split milestones into detailed tasks
        if roadmap and "roadmap" in roadmap:
            spawn here walker::planner_split_milestones(
                roadmap=roadmap["roadmap"],
                granularity="weekly"
            );
            detailed_milestones = spawn_result;
            roadmap["roadmap"]["detailed_milestones"] = detailed_milestones;
        
        # Validate learning path
        user_constraints = {
            "time_available_days": time_constraint_days,
            "learning_style": learning_style,
            "experience_level": user_node.experience_years
        };
        
        spawn here walker::critic_validate_learning_path(
            learning_path=roadmap,
            user_constraints=user_constraints
        );
        validation = spawn_result;
        
        # Enhance roadmap with course recommendations
        enhanced_milestones = [];
        if roadmap and "roadmap" in roadmap:
            milestones = roadmap["roadmap"].get("milestones", []);
            for milestone in milestones:
                target_skills_milestone = milestone.get("target_skills", []);
                
                # Find courses for these skills
                courses_for_milestone = [];
                for skill_name in target_skills_milestone:
                    take --> node::Skill;
                    if here.name == skill_name:
                        take --> node::Course(-[teaches_skill]->node::Skill);
                        if there.id == here.id:
                            courses_for_milestone.push({
                                "course_id": here.id,
                                "title": here.title,
                                "provider": here.provider,
                                "url": here.url,
                                "duration_hours": here.duration_hours,
                                "cost": here.cost
                            });
                
                milestone["recommended_courses"] = courses_for_milestone;
                enhanced_milestones.push(milestone);
            
            roadmap["roadmap"]["milestones"] = enhanced_milestones;
        
        report {
            "user_id": user_node.id,
            "target_role": target_role.title,
            "learning_path": roadmap,
            "progression_data": progression_data,
            "validation": validation,
            "estimated_duration_days": roadmap.get("roadmap", {}).get("total_estimated_days", time_constraint_days) if roadmap else time_constraint_days
        };
    }
}

walker get_weekly_plan {
    has user_id: str;
    has current_week: int;
    has available_hours_per_week: int = 10;
    
    can User;
    
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
        
        # Get active milestones (simplified - in real app, track user progress)
        # For now, get from learning path
        active_milestones = [
            {
                "name": "Foundation Skills",
                "target_skills": ["Python", "SQL"],
                "estimated_days": 30
            }
        ];
        
        # Use Planner Agent to create weekly plan
        spawn here walker::planner_propose_weekly_plan(
            current_week=current_week,
            active_milestones=active_milestones,
            available_hours_per_week=available_hours_per_week
        );
        weekly_plan = spawn_result;
        
        report weekly_plan;
    }
}

