"""
Market Agent - Uses byLLM to analyze job postings, identify trending skills, and forecast demand
"""

can byllm.analyze;

walker market_analyze_job_postings {
    has job_postings: list;  # List of job posting texts or summaries
    has time_window_days: int = 30;
    
    # Use byLLM to analyze job posting trends
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Analyze the following job postings from the last {time_window_days} days and identify trends.
            
            Job Postings: {job_postings}
            
            Return a JSON object with:
            - trending_skills: [
                {{
                    "skill_name": string,
                    "frequency": number,
                    "growth_rate": number (percentage),
                    "average_salary_impact": number,
                    "industries": [list],
                    "urgency": "high" | "medium" | "low"
                }}
            ],
            - emerging_skills: [list of newly appearing skills],
            - declining_skills: [list of skills appearing less frequently],
            - role_trends: [
                {{
                    "role_title": string,
                    "demand_trend": "rising" | "stable" | "falling",
                    "skill_requirements": [list],
                    "salary_trend": "increasing" | "stable" | "decreasing"
                }}
            ],
            - market_insights: [list of key insights]
            
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            analysis = JSON.parse(result);
        } except {
            analysis = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report analysis;
    }
}

walker market_identify_trending_skills {
    has skill_data: list;  # List of skills with frequency data
    has historical_data: dict = {};
    
    # Use byLLM to identify which skills are trending
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Analyze skill demand data and identify trending skills.
            
            Current Skill Data: {skill_data}
            Historical Data: {historical_data}
            
            Return a JSON object with:
            - hot_skills: [
                {{
                    "skill_name": string,
                    "trend_score": number (0-1),
                    "reason": string,
                    "projected_growth": number (percentage),
                    "time_to_peak": string (e.g., "3-6 months")
                }}
            ],
            - stable_skills: [list of consistently in-demand skills],
            - declining_skills: [list of skills losing demand],
            - emerging_skills: [list of new/emerging skills],
            - skill_clusters: [groups of related trending skills]
            
            Consider both current demand and trajectory.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            trends = JSON.parse(result);
        } except {
            trends = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report trends;
    }
}

walker market_forecast_demand {
    has skill_name: str;
    has historical_trend: dict;
    has market_factors: list = [];
    
    # Use byLLM to forecast future demand for a skill
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Forecast future demand for the skill: {skill_name}
            
            Historical Trend: {historical_trend}
            Market Factors: {market_factors}
            
            Return a JSON object with:
            - skill_name: "{skill_name}",
            - current_demand: number (0-1 scale),
            - forecast_3_months: number,
            - forecast_6_months: number,
            - forecast_12_months: number,
            - confidence: number (0-1),
            - factors_influencing: [
                {{
                    "factor": string,
                    "impact": "positive" | "negative" | "neutral",
                    "magnitude": number (0-1)
                }}
            ],
            - recommendation: "invest" | "maintain" | "deprioritize",
            - reasoning: string
            
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.3
        );
        
        try {
            forecast = JSON.parse(result);
        } except {
            forecast = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report forecast;
    }
}

