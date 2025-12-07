"""
Skill Analysis Walkers
"""

from backend.algorithms.ranking import skill_gap_scoring_formula;
from backend.agents.explainer_agent import explainer_clarify_skill_gaps;
from backend.agents.critic_agent import critic_identify_weak_areas;

walker skill_gap_analysis {
    has user_id: str;
    has target_role_id: str = "";
    has target_role_title: str = "";
    
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
        
        # Get user skills with proficiency
        user_skills = {};
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id:
            user_skills[there.id] = here.user_skill.proficiency;
        
        # Get required skills for target role
        target_skills = [];
        take --> node::Skill(-[required_skill]->node::Role);
        if here.id == target_role.id:
            target_skills.push({
                "skill": there,
                "required_level": here.required_skill.required_level,
                "importance": here.required_skill.importance
            });
        
        # Calculate skill gaps using algorithm
        spawn here walker::skill_gap_scoring_formula(
            user_skills=user_skills,
            target_skills=target_skills
        );
        gap_analysis = spawn_result;
        
        # Get explanation from Explainer Agent
        gap_list = gap_analysis.get("gap_analysis", []);
        spawn here walker::explainer_clarify_skill_gaps(
            skill_gaps=gap_list,
            user_background={
                "current_role": user_node.current_role,
                "experience_years": user_node.experience_years
            }
        );
        explanation = spawn_result;
        
        # Get weak areas from Critic Agent
        user_skills_list = [
            {
                "name": skill_name,
                "proficiency": prof
            }
            for skill_name, prof in user_skills.items()
        ];
        
        spawn here walker::critic_identify_weak_areas(
            user_skills=user_skills_list,
            target_role=target_role.title,
            role_requirements=target_skills
        );
        weak_areas = spawn_result;
        
        report {
            "user_id": user_node.id,
            "target_role": target_role.title,
            "overall_gap_score": gap_analysis.get("overall_gap_score", 0.0),
            "gap_analysis": gap_analysis.get("gap_analysis", []),
            "critical_gaps": gap_analysis.get("critical_gaps", []),
            "moderate_gaps": gap_analysis.get("moderate_gaps", []),
            "minor_gaps": gap_analysis.get("minor_gaps", []),
            "explanation": explanation,
            "weak_areas": weak_areas
        };
    }
}

