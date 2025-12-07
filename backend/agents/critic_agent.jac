"""
Critic Agent - Uses byLLM to quality-check recommendations and identify weak areas
"""

can byllm.analyze;

walker critic_quality_check_recommendations {
    has recommendations: dict;  # Role, course, or job recommendations
    has user_profile: dict;
    has recommendation_type: str;  # "role", "course", "job"
    
    # Use byLLM to quality-check recommendations
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Critically evaluate these {recommendation_type} recommendations for quality and appropriateness.
            
            User Profile: {user_profile}
            Recommendations: {recommendations}
            
            Return a JSON object with:
            - overall_quality_score: number (0-1),
            - strengths: [list of what's good about the recommendations],
            - weaknesses: [
                {{
                    "issue": string,
                    "severity": "critical" | "major" | "minor",
                    "impact": string,
                    "suggestion": string
                }}
            ],
            - missing_elements: [list of important things not considered],
            - bias_check: {{
                "detected_biases": [list],
                "fairness_score": number (0-1)
            }},
            - improvement_suggestions: [list of specific improvements],
            - validated_recommendations: [filtered/improved recommendations]
            
            Be thorough and critical. Identify gaps, biases, and areas for improvement.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.2
        );
        
        try {
            critique = JSON.parse(result);
        } except {
            critique = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report critique;
    }
}

walker critic_identify_weak_areas {
    has user_skills: list;
    has target_role: str;
    has role_requirements: list;
    
    # Use byLLM to identify user's weak areas
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Identify weak areas in the user's skill profile relative to target role requirements.
            
            User Skills: {user_skills}
            Target Role: {target_role}
            Role Requirements: {role_requirements}
            
            Return a JSON object with:
            - critical_gaps: [
                {{
                    "skill": string,
                    "current_level": number (0-1),
                    "required_level": number (0-1),
                    "gap": number,
                    "priority": "critical" | "high" | "medium" | "low",
                    "impact": string,
                    "time_to_improve": string (e.g., "3-6 months")
                }}
            ],
            - moderate_gaps: [similar structure],
            - minor_gaps: [similar structure],
            - strengths: [skills where user exceeds requirements],
            - risk_assessment: {{
                "overall_readiness": number (0-1),
                "biggest_risks": [list],
                "recommendations": [list]
            }},
            - improvement_roadmap: [prioritized list of skills to improve]
            
            Be specific and actionable. Prioritize based on impact and feasibility.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            weak_areas = JSON.parse(result);
        } except {
            weak_areas = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report weak_areas;
    }
}

walker critic_validate_learning_path {
    has learning_path: dict;
    has user_constraints: dict;  # time, budget, learning style
    
    # Use byLLM to validate and critique a learning path
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Validate and critique this learning path for realism, effectiveness, and alignment with user constraints.
            
            Learning Path: {learning_path}
            User Constraints: {user_constraints}
            
            Return a JSON object with:
            - validity_score: number (0-1),
            - is_realistic: boolean,
            - is_feasible: boolean,
            - alignment_score: number (0-1),
            - issues: [
                {{
                    "issue": string,
                    "type": "timeline" | "difficulty" | "cost" | "sequence" | "other",
                    "severity": "critical" | "major" | "minor",
                    "fix": string
                }}
            ],
            - strengths: [list of what's good],
            - suggested_improvements: [list of improvements],
            - alternative_approaches: [list of alternative paths],
            - validated_path: {improved version of the path}
            
            Be critical but constructive. Ensure the path is achievable and well-structured.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            validation = JSON.parse(result);
        } except {
            validation = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report validation;
    }
}

