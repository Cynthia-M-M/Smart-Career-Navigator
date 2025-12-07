"""
Planner Agent - Uses byLLM to create learning roadmaps, milestones, and study plans
"""

can byllm.analyze;

walker planner_create_roadmap {
    has current_skills: list;
    has target_role: str;
    has target_skills: list;
    has time_constraint_days: int = 180;
    has learning_style: str = "balanced";
    
    # Use byLLM to create a comprehensive learning roadmap
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Create a detailed learning roadmap for transitioning from current skills to a target role.
            
            Current Skills: {current_skills}
            Target Role: {target_role}
            Required Skills: {target_skills}
            Time Available: {time_constraint_days} days
            Learning Style: {learning_style}
            
            Return a JSON object with:
            - roadmap: {{
                - milestones: [
                    {{
                        "name": string,
                        "description": string,
                        "target_skills": [list],
                        "estimated_days": number,
                        "dependencies": [list of milestone names],
                        "resources": [list of resource types]
                    }}
                ],
                - weekly_plan: [
                    {{
                        "week": number,
                        "focus": string,
                        "activities": [list],
                        "time_commitment_hours": number
                    }}
                ],
                - total_estimated_days: number,
                - difficulty: "beginner" | "intermediate" | "advanced",
                - total_estimated_cost: number
            }}
            
            Make it realistic, actionable, and progressive. Include both theoretical learning and practical projects.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.4
        );
        
        try {
            roadmap = JSON.parse(result);
        } except {
            roadmap = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report roadmap;
    }
}

walker planner_split_milestones {
    has roadmap: dict;
    has granularity: str = "weekly";  # "daily", "weekly", "monthly"
    
    # Use byLLM to break down milestones into detailed tasks
    with entry {
        milestones = roadmap.get("milestones", []);
        detailed_milestones = [];
        
        for milestone in milestones {
            result = byllm.analyze(
                prompt=f"""
                Break down this learning milestone into detailed {granularity} tasks.
                
                Milestone: {milestone.get("name", "")}
                Description: {milestone.get("description", "")}
                Target Skills: {milestone.get("target_skills", [])}
                Estimated Days: {milestone.get("estimated_days", 0)}
                
                Return a JSON object with:
                - milestone_name: string
                - tasks: [
                    {{
                        "task_name": string,
                        "description": string,
                        "duration_hours": number,
                        "order": number,
                        "resources_needed": [list],
                        "success_criteria": string
                    }}
                ]
                
                Return only valid JSON, no markdown formatting.
                """,
                model="gpt-4o-mini",
                temperature=0.3
            );
            
            try {
                detailed = JSON.parse(result);
                detailed_milestones.push(detailed);
            } except {
                detailed = JSON.parse(result.replace("```json", "").replace("```", "").strip());
                detailed_milestones.push(detailed);
            }
        }
        
        report detailed_milestones;
    }
}

walker planner_propose_weekly_plan {
    has current_week: int;
    has active_milestones: list;
    has available_hours_per_week: int = 10;
    
    # Use byLLM to create a specific weekly study plan
    with entry {
        result = byllm.analyze(
            prompt=f"""
            Create a detailed weekly study plan for week {current_week}.
            
            Active Milestones: {active_milestones}
            Available Hours: {available_hours_per_week} hours per week
            
            Return a JSON object with:
            - week: {current_week}
            - daily_schedule: [
                {{
                    "day": "Monday" | "Tuesday" | etc.,
                    "activities": [
                        {{
                            "time": string (e.g., "9:00 AM"),
                            "activity": string,
                            "duration_minutes": number,
                            "milestone": string,
                            "type": "learning" | "practice" | "project" | "review"
                        }}
                    ]
                }}
            ],
            - weekly_goals: [list of goals to achieve],
            - resources: [list of resources to use],
            - review_checklist: [list of items to review at week end]
            
            Make it realistic and balanced. Include breaks and review time.
            Return only valid JSON, no markdown formatting.
            """,
            model="gpt-4o-mini",
            temperature=0.4
        );
        
        try {
            weekly_plan = JSON.parse(result);
        } except {
            weekly_plan = JSON.parse(result.replace("```json", "").replace("```", "").strip());
        }
        
        report weekly_plan;
    }
}

