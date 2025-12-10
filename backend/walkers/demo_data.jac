"""
Demo Data Seeding Walker
"""

import std.time;
import std.json;


node Role {
    has title: str;
    has industry: str;
    has level: str;
    has avg_salary_min: float;
    has avg_salary_max: float;
    has growth_rate: float;
    has description: str;
    has created_at: datetime;
}
node User{}
node Skill{}
node Role{}
node Course{}
node Certification{}
node JobPosting{}

walker seed_demo_data {
    has data_file: str = "scripts/demo_data.json";
    
    # node User;
    # node Skill;
    # can Role
    # can Course;
    # can Certification;
    # can JobPosting;
    
    can start with `root entry {
        # Create sample skills
        skills_created = [];
        skill_names = [
            "Python", "JavaScript", "React", "Node.js", "AWS", "Docker",
            "Kubernetes", "SQL", "MongoDB", "PostgreSQL", "Git", "CI/CD",
            "Machine Learning", "Data Science", "TensorFlow", "PyTorch",
            "Agile", "Scrum", "Project Management", "Leadership"
        ];
        
        for skill_name in skill_names{
            category = "Technical";
            if skill_name in ["Agile", "Scrum", "Project Management", "Leadership"]{
                category = "Soft";
            }
            skill_node = Skill( #""; #spawn here -[root]-> node::
                name=skill_name,
                category=category,
                market_demand_score=0.7,
                trend_direction="stable",
                last_updated=std.time.now()
            );
            skills_created.push(skill_node);
        }
        # Create sample roles
        roles_created = [];
        role_data = [
            {
                "title": "Software Engineer",
                "industry": "Technology",
                "level": "mid",
                "salary_min": 80000,
                "salary_max": 120000,
                "growth_rate": 15.0,
                "required_skills": ["Python", "JavaScript", "Git", "Agile"]
            },
            {
                "title": "Senior Software Engineer",
                "industry": "Technology",
                "level": "senior",
                "salary_min": 120000,
                "salary_max": 180000,
                "growth_rate": 12.0,
                "required_skills": ["Python", "React", "AWS", "Docker", "Leadership"]
            },
            {
                "title": "Data Scientist",
                "industry": "Technology",
                "level": "mid",
                "salary_min": 90000,
                "salary_max": 140000,
                "growth_rate": 20.0,
                "required_skills": ["Python", "Machine Learning", "SQL", "Data Science"]
            },
            {
                "title": "DevOps Engineer",
                "industry": "Technology",
                "level": "mid",
                "salary_min": 100000,
                "salary_max": 150000,
                "growth_rate": 18.0,
                "required_skills": ["AWS", "Docker", "Kubernetes", "CI/CD", "Python"]
            }
        ];
        
        for role_info in role_data{
            role_node = Role(
                title=role_info["title"],
                industry=role_info["industry"],
                level=role_info["level"],
                avg_salary_min=role_info["salary_min"],
                avg_salary_max=role_info["salary_max"],
                growth_rate=role_info["growth_rate"],
                description=f"Role: {role_info['title']}",
                created_at=std.time.now()
            );
            
            # Link required skills
            for skill_name in role_info["required_skills"]{
                for skill_node in skills_created{
                    if skill_node.name == skill_name{
                        spawn_result = spawn role_node -[required_skill]; #-> skill_node;
                        if spawn_result{
                            spawn_result.required_level = 0.6;
                            spawn_result.importance = 1.0;
                        };
                        break;
                    }
                }
            }
            roles_created.push(role_node);
        }
        # Create sample courses
        courses_created = [];
        course_data = [
            {
                "title": "Complete Python Bootcamp",
                "provider": "Udemy",
                "category": "Programming",
                "cost": 89.99,
                "duration_hours": 60,
                "rating": 4.6,
                "teaches_skills": ["Python"]
            },
            {
                "title": "React - The Complete Guide",
                "provider": "Udemy",
                "category": "Web Development",
                "cost": 94.99,
                "duration_hours": 50,
                "rating": 4.7,
                "teaches_skills": ["React", "JavaScript"]
            },
            {
                "title": "AWS Certified Solutions Architect",
                "provider": "Coursera",
                "category": "Cloud Computing",
                "cost": 49.99,
                "duration_hours": 40,
                "rating": 4.5,
                "teaches_skills": ["AWS"]
            }
        ];
        
        for course_info in course_data{
            course_node = root spawn Course(
                title=course_info["title"],
                provider=course_info["provider"],
                category=course_info["category"],
                cost=course_info["cost"],
                duration_hours=course_info["duration_hours"],
                rating=course_info["rating"],
                description=f"Course: {course_info['title']}",
                url=f"https://example.com/course/{course_info['title'].lower().replace(' ', '-')}"
            );
            
            # Link to skills
            for skill_name in course_info["teaches_skills"]{
                for skill_node in skills_created{
                    if skill_node.name == skill_name{
                        spawn_result = course_node[teaches_skill] spawn skill_node;
                        if spawn_result{
                            spawn_result.coverage = 0.8;
                            spawn_result.depth = "intermediate";
                        }
                        break;
                    }
                }
            }
            courses_created.push(course_node);
        }
        # Create sample user
        user_node = root spawn User(
            name="Demo User",
            email="demo@example.com",
            current_role="Software Engineer",
            target_role="Senior Software Engineer",
            experience_years=3.0,
            created_at=std.time.now(),
            updated_at=std.time.now()
        );
        
        # Link user to some skills
        user_skills = ["Python", "JavaScript", "Git", "Agile"];
        for skill_name in user_skills{
            for skill_node in skills_created{
                if skill_node.name == skill_name{
                    spawn_result = user_node[user_skill] spawn skill_node;
                    if spawn_result {
                        spawn_result.proficiency = 0.7;
                        spawn_result.years_experience = 2.0;
                        spawn_result.last_used = std.time.now();
                    }
                    break;
                }
            }
        }
        
        report {
            "skills_created": std.len(skills_created),
            "roles_created": std.len(roles_created),
            "courses_created": std.len(courses_created),
            "user_created": user_node.id,
            "status": "success"
        };
    }
}