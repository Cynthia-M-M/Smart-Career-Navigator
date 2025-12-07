"""
Analyzer Agent - Uses byLLM to extract skills, parse resumes, and classify experience
"""

import os;
from dotenv import load_dotenv;
load_dotenv();

# Import byLLM functionality
can byllm.analyze;

walker analyzer_extract_skills {
    has resume_text: str;
    has existing_skills: list = [];
    
    # Use byLLM to extract skills from resume text
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Analyze the following resume text and extract all technical skills, soft skills, 
            certifications, and domain expertise mentioned. Return a JSON object with:
            - technical_skills: list of technical skills with proficiency indicators
            - soft_skills: list of soft/communication skills
            - certifications: list of certifications mentioned
            - experience_level: estimated years of experience
            - current_role: most recent job title
            - industries: industries the person has worked in
            
            Resume text:
            {resume_text}
            
            Existing skills to consider: {existing_skills}
            
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        # Parse the result
        try {
            skills_data = JSON.parse(result);
        } except {
            # Fallback parsing if JSON is wrapped
            skills_data = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report skills_data;
    }
}

walker analyzer_parse_resume {
    has resume_text: str;
    
    # Use byLLM to parse and structure resume data
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Parse the following resume text and extract structured information. 
            Return a JSON object with:
            - personal_info: {{name, email, phone, location}}
            - work_experience: [{{company, role, start_date, end_date, description, skills_used}}]
            - education: [{{institution, degree, field, graduation_date}}]
            - certifications: [{{name, issuer, date_earned}}]
            - skills: [{{name, category, proficiency_level}}]
            - summary: professional summary
            
            Resume text:
            {resume_text}
            
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.2
        );
        
        try {
            parsed_data = JSON.parse(result);
        } except {
            parsed_data = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report parsed_data;
    }
}

walker analyzer_classify_experience {
    has experience_description: str;
    has role_title: str;
    
    # Use byLLM to classify and categorize work experience
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Classify the following work experience and return a JSON object with:
            - industry: primary industry
            - domain: specific domain/field
            - skill_categories: [list of skill categories demonstrated]
            - complexity_level: "entry", "mid", "senior", or "executive"
            - leadership_indicators: boolean indicating leadership experience
            - technical_depth: "basic", "intermediate", or "advanced"
            - transferable_skills: [skills that transfer to other roles]
            
            Role: {role_title}
            Description: {experience_description}
            
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            classification = JSON.parse(result);
        } except {
            classification = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report classification;
    }
}

