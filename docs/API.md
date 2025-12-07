# API Documentation

Complete API reference for Smart Career Path Navigator walkers.

## Base URL

```
http://localhost:8000
```

All walkers are accessible via POST requests to `/walker/{walker_name}`.

## Authentication

For production, include JWT token in headers:
```
Authorization: Bearer {token}
```

## Walkers

### Resume Processing

#### `parse_resume`

Parse a resume and extract user information.

**Endpoint:** `POST /walker/parse_resume`

**Request Body:**
```json
{
  "resume_text": "John Doe\nSoftware Engineer\n5 years experience...",
  "user_id": "optional_user_id"
}
```

**Response:**
```json
{
  "user_id": "user_node_id",
  "parsed_data": {
    "personal_info": {...},
    "work_experience": [...],
    "skills": [...]
  },
  "status": "success"
}
```

#### `extract_skills`

Extract skills from resume text.

**Endpoint:** `POST /walker/extract_skills`

**Request Body:**
```json
{
  "resume_text": "...",
  "parsed_data": {}
}
```

### User Management

#### `get_user_profile`

Get complete user profile with skills and certifications.

**Endpoint:** `POST /walker/get_user_profile`

**Request Body:**
```json
{
  "user_id": "demo@example.com"
}
```

**Response:**
```json
{
  "user_id": "...",
  "name": "Demo User",
  "email": "demo@example.com",
  "current_role": "Software Engineer",
  "target_role": "Senior Software Engineer",
  "skills": [...],
  "certifications": [...]
}
```

#### `update_user_graph`

Update user information in the graph.

**Endpoint:** `POST /walker/update_user_graph`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "updates": {
    "target_role": "Senior Software Engineer",
    "current_role": "Software Engineer"
  }
}
```

### Market Analysis

#### `market_trends_walker`

Analyze market trends and skill demand.

**Endpoint:** `POST /walker/market_trends_walker`

**Request Body:**
```json
{
  "time_window_days": 90,
  "skill_filter": ["Python", "React"]
}
```

**Response:**
```json
{
  "trending_skills": [...],
  "role_trends": [...],
  "skill_multipliers": {...},
  "market_insights": [...]
}
```

#### `fetch_job_data_walker`

Fetch job postings from APIs.

**Endpoint:** `POST /walker/fetch_job_data_walker`

**Request Body:**
```json
{
  "query": "software engineer",
  "location": "San Francisco",
  "limit": 50,
  "use_api": true
}
```

### Recommendations

#### `recommend_roles_walker`

Get role recommendations for a user.

**Endpoint:** `POST /walker/recommend_roles_walker`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "limit": 10,
  "include_market_data": true
}
```

**Response:**
```json
{
  "recommendations": [
    {
      "role_id": "...",
      "title": "Senior Software Engineer",
      "match_score": 0.85,
      "skill_match_percentage": 0.75,
      "market_demand": 1.2,
      "salary_range": {"min": 120000, "max": 180000}
    }
  ]
}
```

#### `recommend_courses`

Get course recommendations.

**Endpoint:** `POST /walker/recommend_courses`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "target_skills": ["Python", "AWS"],
  "limit": 10
}
```

### Skill Analysis

#### `skill_gap_analysis`

Analyze skill gaps for a target role.

**Endpoint:** `POST /walker/skill_gap_analysis`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "target_role_title": "Senior Software Engineer"
}
```

**Response:**
```json
{
  "overall_gap_score": 0.35,
  "gap_analysis": [...],
  "critical_gaps": [...],
  "moderate_gaps": [...],
  "explanation": {...}
}
```

### Learning Path

#### `generate_learning_path`

Generate a personalized learning path.

**Endpoint:** `POST /walker/generate_learning_path`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "target_role_title": "Senior Software Engineer",
  "time_constraint_days": 180,
  "learning_style": "balanced"
}
```

**Response:**
```json
{
  "learning_path": {
    "roadmap": {
      "milestones": [...],
      "weekly_plan": [...],
      "total_estimated_days": 180
    }
  },
  "validation": {...}
}
```

### Visualization

#### `graph_visualization_walker`

Get graph data for visualization.

**Endpoint:** `POST /walker/graph_visualization_walker`

**Request Body:**
```json
{
  "user_id": "demo@example.com",
  "layout": "force",
  "depth": 2
}
```

**Response:**
```json
{
  "nodes": [...],
  "edges": [...],
  "layout": "force"
}
```

### Demo Data

#### `seed_demo_data`

Seed the graph with demo data.

**Endpoint:** `POST /walker/seed_demo_data`

**Request Body:**
```json
{
  "data_file": "scripts/demo_data.json"
}
```

## Error Handling

All endpoints return errors in this format:

```json
{
  "error": "Error message here"
}
```

## Rate Limiting

For production, implement rate limiting based on:
- User authentication
- API key
- IP address

## Example Usage with curl

```bash
# Parse resume
curl -X POST http://localhost:8000/walker/parse_resume \
  -H "Content-Type: application/json" \
  -d '{"resume_text": "John Doe\nSoftware Engineer..."}'

# Get recommendations
curl -X POST http://localhost:8000/walker/recommend_roles_walker \
  -H "Content-Type: application/json" \
  -d '{"user_id": "demo@example.com", "limit": 5}'
```

## Frontend Usage (Jac Client)

In Jac Client, use the API service:

```jac
cl import from frontend.services.api { recommendRoles };

async def loadRecommendations() -> None {
    result = await recommendRoles("demo@example.com", 10);
    # Use result
}
```

