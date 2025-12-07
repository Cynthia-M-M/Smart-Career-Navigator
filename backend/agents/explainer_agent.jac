"""
Explainer Agent - Uses byLLM to generate simple explanations and clarify skill gaps visually
"""

can byllm.analyze;

walker explainer_generate_explanation {
    has topic: str;
    has context: dict = {};
    has audience_level: str = "general";  # "beginner", "general", "technical"
    
    # Use byLLM to generate user-friendly explanations
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Generate a clear, simple explanation of: {topic}
            
            Context: {context}
            Audience Level: {audience_level}
            
            Return a JSON object with:
            - explanation: string (clear, concise explanation),
            - key_points: [list of 3-5 key points],
            - examples: [list of practical examples],
            - visual_description: string (description for visual representation),
            - related_concepts: [list of related concepts],
            - next_steps: [list of suggested next steps],
            - common_misconceptions: [list of things to clarify]
            
            Make it accessible and actionable. Use analogies if helpful.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.5
        );
        
        try {
            explanation = JSON.parse(result);
        } except {
            explanation = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report explanation;
    }
}

walker explainer_clarify_skill_gaps {
    has skill_gaps: list;
    has user_background: dict = {};
    
    # Use byLLM to explain skill gaps in an understandable way
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Explain these skill gaps in a clear, motivating way that helps the user understand what they need to learn.
            
            Skill Gaps: {skill_gaps}
            User Background: {user_background}
            
            Return a JSON object with:
            - gap_summary: string (overall summary),
            - gap_explanations: [
                {{
                    "skill_name": string,
                    "gap_description": string (what's missing),
                    "why_it_matters": string,
                    "how_to_learn": string,
                    "estimated_time": string,
                    "difficulty": "easy" | "moderate" | "challenging",
                    "prerequisites": [list],
                    "learning_resources": [list of resource types]
                }}
            ],
            - visual_representation: {{
                "type": "heatmap" | "spider_chart" | "progress_bar" | "tree",
                "data": dict,
                "description": string
            }},
            - motivational_message: string,
            - quick_wins: [list of easiest skills to improve first],
            - long_term_goals: [list of skills that take longer]
            
            Be encouraging but realistic. Focus on actionable steps.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.4
        );
        
        try {
            clarification = JSON.parse(result);
        } except {
            clarification = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report clarification;
    }
}

walker explainer_visualize_career_path {
    has career_path: dict;
    has current_position: dict;
    
    # Use byLLM to generate visual descriptions for career path
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Create a visual description and explanation of this career path.
            
            Current Position: {current_position}
            Career Path: {career_path}
            
            Return a JSON object with:
            - path_summary: string (overall journey description),
            - milestones: [
                {{
                    "milestone_name": string,
                    "description": string,
                    "visual_position": {{"x": number, "y": number, "level": number}},
                    "connections": [list of connected milestone names],
                    "key_skills": [list],
                    "estimated_time": string
                }}
            ],
            - visual_layout: {{
                "type": "timeline" | "tree" | "network" | "roadmap",
                "nodes": [list of node data],
                "edges": [list of edge data],
                "colors": dict (color scheme),
                "description": string
            }},
            - narrative: string (story-like description of the journey),
            - decision_points: [list of key decisions along the path],
            - alternative_paths: [list of alternative routes]
            
            Make it visually rich and easy to understand.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.4
        );
        
        try {
            visualization = JSON.parse(result);
        } except {
            visualization = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report visualization;
    }
}

