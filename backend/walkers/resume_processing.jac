"""
Resume Processing Walkers
"""

import std.time;
import std.log;
from backend.agents.analyzer_agent import analyzer_extract_skills, analyzer_parse_resume;

walker parse_resume {
    has resume_text: str;
    has user_id: str = "";
    
    can User;
    can Skill;
    
    # Use Analyzer Agent to parse resume
    with entry {
        if not resume_text or std.len(resume_text) < 10 {
            report {"error": "Invalid resume text"};
            disengage;
        }
        
        # Call analyzer agent
        spawn here walker::analyzer_parse_resume(resume_text=resume_text);
        parsed_data = spawn_result;
        
        if not parsed_data or "error" in parsed_data {
            report {"error": "Failed to parse resume"};
            disengage;
        }
        
        # Find or create user node
        user_node = null;
        if user_id {
            user_node = spawn here walker::get_user_by_id(user_id=user_id);
        }
        
        if not user_node {
            # Create new user
            user_node = spawn here -[root]-> node::User(
                name=parsed_data.get("personal_info", {}).get("name", "Unknown"),
                email=parsed_data.get("personal_info", {}).get("email", ""),
                resume_text=resume_text,
                created_at=std.time.now(),
                updated_at=std.time.now()
            );
        } else {
            # Update existing user
            user_node.resume_text = resume_text;
            user_node.updated_at = std.time.now();
        }
        
        # Process work experience
        work_experience = parsed_data.get("work_experience", []);
        if std.len(work_experience) > 0:
            latest_job = work_experience[0];
            user_node.current_role = latest_job.get("role", "");
            user_node.experience_years = std.len(work_experience) * 1.5;  # Rough estimate
        
        # Extract and link skills
        spawn user_node walker::extract_skills(resume_text=resume_text, parsed_data=parsed_data);
        
        report {
            "user_id": user_node.id,
            "parsed_data": parsed_data,
            "status": "success"
        };
    }
}

walker extract_skills {
    has resume_text: str;
    has parsed_data: dict = {};
    
    can User;
    can Skill;
    
    with user_node {
        # Use Analyzer Agent to extract skills
        spawn here walker::analyzer_extract_skills(resume_text=resume_text);
        skills_data = spawn_result;
        
        if not skills_data or "error" in skills_data {
            # Fallback: use parsed_data if available
            if parsed_data:
                skills_data = {
                    "technical_skills": parsed_data.get("skills", []),
                    "soft_skills": [],
                    "certifications": parsed_data.get("certifications", [])
                };
            else {
                report {"error": "Failed to extract skills"};
                disengage;
            }
        }
        
        # Process technical skills
        technical_skills = skills_data.get("technical_skills", []);
        for skill_data in technical_skills {
            skill_name = "";
            proficiency = 0.5;
            
            if std.isinstance(skill_data, str):
                skill_name = skill_data;
            elif std.isinstance(skill_data, dict):
                skill_name = skill_data.get("name", skill_data.get("skill", ""));
                proficiency = skill_data.get("proficiency", skill_data.get("level", 0.5));
            
            if skill_name:
                # Find or create skill node
                skill_node = spawn here -[root]-> node::Skill(
                    name=skill_name,
                    category="Technical",
                    market_demand_score=0.5,
                    last_updated=std.time.now()
                );
                
                # Create or update UserSkill edge
                spawn user_node -[user_skill]-> skill_node;
                if spawn_result:
                    spawn_result.proficiency = proficiency;
                    spawn_result.last_used = std.time.now();
        }
        
        # Process certifications
        certifications = skills_data.get("certifications", []);
        for cert_data in certifications {
            cert_name = "";
            issuer = "";
            
            if std.isinstance(cert_data, str):
                cert_name = cert_data;
            elif std.isinstance(cert_data, dict):
                cert_name = cert_data.get("name", "");
                issuer = cert_data.get("issuer", cert_data.get("issuing_organization", ""));
            
            if cert_name:
                # Find or create certification node
                cert_node = spawn here -[root]-> node::Certification(
                    name=cert_name,
                    issuer=issuer,
                    category="Professional",
                    last_updated=std.time.now()
                );
                
                # Link to user
                spawn user_node -[has_certification]-> cert_node;
        }
        
        report {
            "skills_extracted": std.len(technical_skills),
            "certifications_extracted": std.len(certifications),
            "status": "success"
        };
    }
}

walker get_user_by_id {
    has user_id: str;
    
    can User;
    
    with root {
        take --> node::User;
        if here.id == user_id or here.email == user_id:
            report here;
            disengage;
        }
    }
    
    with entry {
        report null;
    }
}

