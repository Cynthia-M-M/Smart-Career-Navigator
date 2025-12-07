"""
Market Demand Multiplier Algorithm
"""

import std.time;

walker market_demand_multiplier {
    has skill_node: node(Skill);
    has time_window_days: int = 90;
    
    can Skill;
    can MarketSignal;
    can JobPosting;
    
    with skill_node {
        current_time = std.time.now();
        cutoff_time = current_time - std.time.duration(days=time_window_days);
        
        # Collect market signals for this skill
        signal_count = 0;
        total_intensity = 0.0;
        signal_types = {};
        
        take --> node::MarketSignal(-[signals_skill]->node::Skill);
        if here.id == skill_node.id and there.timestamp >= cutoff_time {
            signal_count += 1;
            total_intensity += there.intensity;
            signal_type = there.signal_type;
            signal_types[signal_type] = signal_types.get(signal_type, 0) + 1;
        }
        
        # Collect job postings requiring this skill
        job_count = 0;
        take --> node::JobPosting(-[requires_skill]->node::Skill);
        if here.id == skill_node.id and there.posted_date >= cutoff_time {
            job_count += 1;
        }
        
        # Calculate base multiplier from signals
        if signal_count > 0:
            avg_intensity = total_intensity / signal_count;
            signal_multiplier = 0.5 + (avg_intensity * 0.5);  # 0.5 to 1.0
        else:
            signal_multiplier = 0.5;
        
        # Job posting multiplier (log scale to prevent extreme values)
        if job_count > 0:
            job_multiplier = 0.7 + (std.log(job_count + 1) / std.log(100)) * 0.3;  # 0.7 to 1.0
        else:
            job_multiplier = 0.5;
        
        # Trend direction multiplier
        trend_multiplier = 1.0;
        if skill_node.trend_direction == "rising":
            trend_multiplier = 1.15;
        elif skill_node.trend_direction == "falling":
            trend_multiplier = 0.85;
        
        # Combined multiplier (weighted average)
        final_multiplier = (
            signal_multiplier * 0.4 +
            job_multiplier * 0.4 +
            trend_multiplier * 0.2
        );
        
        # Update skill's market demand score
        skill_node.market_demand_score = final_multiplier;
        
        report {
            "skill_id": skill_node.id,
            "skill_name": skill_node.name,
            "multiplier": final_multiplier,
            "signal_count": signal_count,
            "job_count": job_count,
            "trend": skill_node.trend_direction
        };
    }
}

walker update_market_signals {
    has job_postings: list;  # List of JobPosting nodes or data
    has analysis_window_days: int = 30;
    
    can JobPosting;
    can MarketSignal;
    can Skill;
    
    # Analyze job postings and create/update market signals
    with entry {
        current_time = std.time.now();
        skill_frequency = {};  # {skill_name: count}
        skill_salaries = {};  # {skill_name: [salaries]}
        
        # Process job postings
        for job_data in job_postings {
            # Extract skills from job (assuming job has skills connected)
            # This would typically come from job posting analysis
            if std.isinstance(job_data, node(JobPosting)) {
                take --> node::Skill(-[requires_skill]->node::JobPosting);
                if here.id == job_data.id {
                    skill_name = there.name;
                    skill_frequency[skill_name] = skill_frequency.get(skill_name, 0) + 1;
                    
                    # Track salary if available
                    if job_data.salary_max > 0:
                        if skill_name not in skill_salaries:
                            skill_salaries[skill_name] = [];
                        skill_salaries[skill_name].push((job_data.salary_min + job_data.salary_max) / 2);
                }
            }
        }
        
        # Create/update market signals
        signals_created = [];
        
        for skill_name in skill_frequency.keys() {
            frequency = skill_frequency[skill_name];
            avg_salary = 0.0;
            if skill_name in skill_salaries and std.len(skill_salaries[skill_name]) > 0:
                avg_salary = std.sum(skill_salaries[skill_name]) / std.len(skill_salaries[skill_name]);
            
            # Determine signal type and intensity
            if frequency > 50:  # High demand threshold
                signal_type = "demand_spike";
                intensity = std.min(frequency / 100.0, 1.0);
            elif frequency > 20:
                signal_type = "trending";
                intensity = frequency / 50.0;
            else:
                signal_type = "stable";
                intensity = 0.5;
            
            # Find or create MarketSignal node
            # In a real implementation, you'd query the graph
            # For now, we'll report what should be created
            
            signals_created.push({
                "skill_name": skill_name,
                "signal_type": signal_type,
                "intensity": intensity,
                "frequency": frequency,
                "avg_salary": avg_salary,
                "timestamp": current_time
            });
        }
        
        report signals_created;
    }
}

