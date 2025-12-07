# Architecture Documentation

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend (Jac Client)                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │  Pages   │  │Components │  │ Services │  │  Router  │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘ │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP/REST API
                       │ (Spawn calls)
┌──────────────────────▼──────────────────────────────────────┐
│                  Backend (Jaseci Server)                     │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              OSP Graph (In-Memory/DB)                   │ │
│  │  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐   │ │
│  │  │ User │  │Skill │  │ Role │  │Course│  │ Job  │   │ │
│  │  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘   │ │
│  │     │         │         │         │         │        │ │
│  │     └─────────┴─────────┴─────────┴─────────┘        │ │
│  │              (Edges: user_skill, required_skill)      │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐ │
│  │                    Walkers                             │ │
│  │  • parse_resume  • recommend_roles  • skill_gap_analysis│ │
│  │  • generate_learning_path  • market_trends_walker      │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              byLLM Agents (OpenAI)                     │ │
│  │  • Analyzer  • Planner  • Market  • Critic  • Explainer│ │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              Graph Algorithms                           │ │
│  │  • Path Finding  • Ranking  • Market Multiplier        │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              External APIs                              │ │
│  │  • Job APIs (LinkedIn, Indeed, etc.)                    │ │
│  └──────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

## OSP Graph Schema

```
                    ┌─────────┐
                    │  User   │
                    └────┬────┘
                         │
            ┌────────────┼────────────┐
            │            │            │
      ┌─────▼─────┐ ┌───▼────┐ ┌───▼──────┐
      │UserSkill  │ │HasCert │ │HasExp    │
      └─────┬─────┘ └───┬────┘ └───┬──────┘
            │           │           │
      ┌─────▼─────┐ ┌───▼────┐
      │  Skill    │ │Cert    │
      └─────┬─────┘ └────────┘
            │
      ┌─────┼─────┐
      │     │     │
┌─────▼──┐ ┌▼────┐ ┌▼──────┐
│Required│ │Teach│ │Related│
│  Skill │ │Skill│ │  To   │
└───┬────┘ └─┬───┘ └───┬───┘
    │        │          │
┌───▼────┐ ┌▼──────┐ ┌──▼────┐
│  Role  │ │Course │ │ Skill │
└────────┘ └───────┘ └───────┘
```

## Agent Interaction Flow

```
User Uploads Resume
        │
        ▼
┌───────────────┐
│ Analyzer Agent│  Extract skills, parse resume
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  User Graph   │  Update user nodes and edges
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Market Agent  │  Analyze job market trends
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Ranking Algo  │  Calculate role match scores
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Planner Agent │  Generate learning roadmap
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Critic Agent  │  Quality check recommendations
└───────┬───────┘
        │
        ▼
┌───────────────┐
│Explainer Agent│  Generate user-friendly explanations
└───────┬───────┘
        │
        ▼
   Return Results
```

## Data Flow

### Resume Processing Flow

1. User uploads resume → `parse_resume` walker
2. Analyzer Agent extracts structured data
3. Create/update User node
4. Extract skills → Create Skill nodes and UserSkill edges
5. Extract certifications → Create Certification nodes
6. Return parsed data

### Recommendation Flow

1. Get user profile and skills
2. Get target role requirements
3. Calculate skill gaps
4. Market Agent analyzes trends
5. Ranking algorithm scores roles
6. Planner Agent creates learning path
7. Critic Agent validates recommendations
8. Return formatted results

### Market Analysis Flow

1. Fetch job postings from APIs
2. Create JobPosting nodes
3. Link required skills
4. Update MarketSignal nodes
5. Calculate market multipliers
6. Update Skill nodes with demand scores
7. Return trend analysis

## Technology Stack

### Backend
- **Language**: Jac (Jaseci)
- **Runtime**: Jaseci Server
- **AI**: OpenAI GPT-4 (via byLLM)
- **Graph**: OSP Graph (in-memory or persistent)

### Frontend
- **Language**: Jac Client (cl construct)
- **UI**: JSX with Tailwind CSS
- **State**: Reactive signals (Jac Client)
- **Routing**: Hash-based routing

### External Services
- OpenAI API (for byLLM agents)
- Job APIs (LinkedIn, Indeed, custom)

## Scalability Considerations

1. **Graph Storage**: Consider persistent storage (database) for production
2. **Caching**: Cache market data and recommendations
3. **Rate Limiting**: Implement for API endpoints
4. **Load Balancing**: Multiple Jaseci server instances
5. **CDN**: For frontend assets
6. **Background Jobs**: For market data updates

## Security

1. **Authentication**: JWT tokens for API access
2. **Authorization**: Role-based access control
3. **Data Privacy**: Encrypt sensitive user data
4. **API Keys**: Secure storage of external API keys
5. **Input Validation**: Validate all walker inputs

## Performance Optimization

1. **Graph Traversal**: Optimize walker paths
2. **Caching**: Cache frequently accessed data
3. **Lazy Loading**: Load graph data on demand
4. **Pagination**: For large result sets
5. **Async Processing**: For long-running operations

