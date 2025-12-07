"""
User Management Walkers
"""

import std.time;

walker update_user_graph {
    has user_id: str;
    has updates: dict;  # Dictionary of fields to update
    
    can User;
    can Skill;
    can Role;
    
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
        
        # Update user fields
        if "name" in updates:
            user_node.name = updates["name"];
        if "email" in updates:
            user_node.email = updates["email"];
        if "target_role" in updates:
            user_node.target_role = updates["target_role"];
        if "current_role" in updates:
            user_node.current_role = updates["current_role"];
        if "experience_years" in updates:
            user_node.experience_years = updates["experience_years"];
        
        user_node.updated_at = std.time.now();
        
        # Update skills if provided
        if "skills" in updates:
            skills_data = updates["skills"];
            for skill_update in skills_data {
                skill_name = skill_update.get("name", "");
                proficiency = skill_update.get("proficiency", 0.5);
                
                if skill_name:
                    # Find or create skill
                    skill_node = spawn here -[root]-> node::Skill(
                        name=skill_name,
                        category=skill_update.get("category", "Technical"),
                        last_updated=std.time.now()
                    );
                    
                    # Update or create edge
                    spawn user_node -[user_skill]-> skill_node;
                    if spawn_result:
                        spawn_result.proficiency = proficiency;
                        spawn_result.last_used = std.time.now();
            }
        
        report {
            "user_id": user_node.id,
            "updated_fields": std.list(updates.keys()),
            "status": "success"
        };
    }
}

walker get_user_profile {
    has user_id: str;
    
    can User;
    can Skill;
    can Certification;
    can Role;
    
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
        
        # Collect user skills
        user_skills = [];
        take --> node::Skill(-[user_skill]->node::User);
        if here.id == user_node.id:
            user_skills.push({
                "skill_id": there.id,
                "skill_name": there.name,
                "category": there.category,
                "proficiency": here.user_skill.proficiency,
                "years_experience": here.user_skill.years_experience,
                "last_used": here.user_skill.last_used
            });
        
        # Collect certifications
        certifications = [];
        take --> node::Certification(-[has_certification]->node::User);
        if here.id == user_node.id:
            certifications.push({
                "cert_id": there.id,
                "name": there.name,
                "issuer": there.issuer,
                "date_earned": here.has_certification.date_earned
            });
        
        # Build profile
        profile = {
            "user_id": user_node.id,
            "name": user_node.name,
            "email": user_node.email,
            "current_role": user_node.current_role,
            "target_role": user_node.target_role,
            "experience_years": user_node.experience_years,
            "skills": user_skills,
            "certifications": certifications,
            "created_at": user_node.created_at,
            "updated_at": user_node.updated_at
        };
        
        report profile;
    }
}

