"""
Market Analysis Walkers
"""

import std.time;
from backend.agents.market_agent import market_analyze_job_postings, market_identify_trending_skills, market_forecast_demand;
from backend.algorithms.market_multiplier import market_demand_multiplier, update_market_signals;

walker market_trends_walker {
    has time_window_days: int = 90;
    has skill_filter: list = [];  # Optional: filter specific skills
    
    can Skill;
    can MarketSignal;
    can JobPosting;
    
    with root {
        current_time = std.time.now();
        cutoff_time = current_time - std.time.duration(days=time_window_days);
        
        # Collect all market signals
        signals = [];
        take --> node::MarketSignal;
        if here.timestamp >= cutoff_time:
            if not skill_filter or here.skill_name in skill_filter:
                signals.push({
                    "skill_name": here.skill_name,
                    "signal_type": here.signal_type,
                    "intensity": here.intensity,
                    "timestamp": here.timestamp,
                    "region": here.region,
                    "industry": here.industry
                });
        
        # Collect job posting data
        job_postings = [];
        take --> node::JobPosting;
        if here.posted_date >= cutoff_time:
            job_postings.push({
                "title": here.title,
                "company": here.company,
                "posted_date": here.posted_date
            });
        
        # Analyze trends using Market Agent
        if std.len(job_postings) > 0:
            spawn here walker::market_analyze_job_postings(
                job_postings=job_postings,
                time_window_days=time_window_days
            );
            analysis = spawn_result;
        else:
            analysis = {"trending_skills": [], "role_trends": []};
        
        # Update market multipliers for skills
        skill_trends = {};
        take --> node::Skill;
        if not skill_filter or here.name in skill_filter:
            spawn here walker::market_demand_multiplier(time_window_days=time_window_days);
            multiplier_data = spawn_result;
            if multiplier_data:
                skill_trends[here.name] = multiplier_data;
        
        report {
            "time_window_days": time_window_days,
            "signals_count": std.len(signals),
            "job_postings_count": std.len(job_postings),
            "trending_skills": analysis.get("trending_skills", []),
            "role_trends": analysis.get("role_trends", []),
            "skill_multipliers": skill_trends,
            "market_insights": analysis.get("market_insights", [])
        };
    }
}

walker fetch_job_data_walker {
    has query: str = "";  # Job search query
    has location: str = "";
    has limit: int = 50;
    has use_api: bool = True;  # Whether to use real API or mock data
    
    can JobPosting;
    can Skill;
    
    with root {
        # Import job API client
        from backend.utils.job_api_client import fetch_jobs_from_api, create_job_posting_nodes;
        
        if use_api:
            # Fetch from real API
            job_data = spawn here walker::fetch_jobs_from_api(
                query=query,
                location=location,
                limit=limit
            );
        else:
            # Use mock data for demo
            job_data = [
                {
                    "title": "Senior Software Engineer",
                    "company": "Tech Corp",
                    "location": "San Francisco, CA",
                    "description": "Looking for experienced software engineer...",
                    "salary_min": 120000,
                    "salary_max": 180000,
                    "posted_date": std.time.now(),
                    "required_skills": ["Python", "React", "AWS"]
                }
            ];
        
        # Create JobPosting nodes
        created_jobs = [];
        for job in job_data:
            job_node = spawn here -[root]-> node::JobPosting(
                title=job.get("title", ""),
                company=job.get("company", ""),
                location=job.get("location", ""),
                salary_min=job.get("salary_min", 0.0),
                salary_max=job.get("salary_max", 0.0),
                description=job.get("description", ""),
                posted_date=job.get("posted_date", std.time.now()),
                application_url=job.get("application_url", ""),
                job_type=job.get("job_type", "full-time")
            );
            
            # Link required skills
            required_skills = job.get("required_skills", []);
            for skill_name in required_skills:
                skill_node = spawn here -[root]-> node::Skill(
                    name=skill_name,
                    category="Technical",
                    last_updated=std.time.now()
                );
                spawn job_node -[requires_skill]-> skill_node;
            
            created_jobs.push({
                "job_id": job_node.id,
                "title": job_node.title,
                "company": job_node.company
            });
        
        # Update market signals based on new jobs
        if std.len(created_jobs) > 0:
            spawn here walker::update_market_signals(job_postings=created_jobs);
        
        report {
            "jobs_fetched": std.len(job_data),
            "jobs_created": std.len(created_jobs),
            "job_ids": [j["job_id"] for j in created_jobs]
        };
    }
}

