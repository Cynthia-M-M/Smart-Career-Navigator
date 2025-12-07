# Hackathon Demo Script

## Pre-Demo Setup (5 minutes)

1. **Start Backend Server**
   ```bash
   cd smart-career-navigator
   source venv/bin/activate  # or venv\Scripts\activate on Windows
   jac serve backend/main.jac
   ```

2. **Seed Demo Data**
   ```bash
   # In another terminal
   curl -X POST http://localhost:8000/walker/seed_demo_data
   ```

3. **Open Frontend**
   - Open `frontend/index.html` in browser
   - Or serve with: `python -m http.server 8080`

## Demo Flow (10-15 minutes)

### 1. Introduction (1 min)
- "This is the Smart Career Path Navigator, a $5B enterprise-grade AI platform"
- "Built entirely with Jac language - backend and frontend"
- "Uses OSP Graph, byLLM agents, and Jac Client"

### 2. Login & Dashboard (1 min)
- Show login page
- Login with demo credentials
- Navigate to dashboard
- **Highlight**: Clean UI, real-time data

### 3. Resume Upload & Parsing (2 min)
- Go to Settings or Dashboard
- Upload a sample resume (or paste text)
- **Show**: 
  - Resume parsing in action
  - Skills extracted automatically
  - User graph updated
- **Highlight**: AI-powered extraction using Analyzer Agent

### 4. Skill Profile & Gap Analysis (2 min)
- Navigate to Skill Profile page
- **Show**:
  - Current skills with proficiency levels
  - Skill gap heatmap
  - Critical gaps identified
- **Highlight**: 
  - Visual gap analysis
  - Prioritized skill recommendations
  - Explainer Agent providing insights

### 5. Career Path Recommendations (2 min)
- Navigate to Career Path page
- **Show**:
  - Role recommendations with match scores
  - Market demand indicators
  - Salary ranges
- **Highlight**:
  - Multi-factor ranking algorithm
  - Market Agent analyzing trends
  - Personalized recommendations

### 6. Learning Path Generation (2 min)
- Select a recommended role
- **Show**:
  - Generated learning roadmap
  - Milestones with timelines
  - Weekly study plan
  - Course recommendations
- **Highlight**:
  - Planner Agent creating personalized path
  - Critic Agent validating recommendations
  - Actionable, time-bound plan

### 7. Course Recommendations (1 min)
- Navigate to Courses page
- **Show**:
  - Filtered course recommendations
  - Match scores
  - Cost and duration
  - Direct links
- **Highlight**: Smart matching to skill gaps

### 8. Job Matching (1 min)
- Navigate to Jobs page
- **Show**:
  - Job recommendations
  - Match scores
  - Required skills
  - Application links
- **Highlight**: Real-time job market integration

### 9. Graph Visualization (1 min)
- Navigate to Graph Visualizer
- **Show**:
  - Interactive OSP graph
  - User, Skills, Roles, Courses connected
  - Different layout options
- **Highlight**: 
  - OSP Graph power
  - Visual representation of career ecosystem

### 10. Market Trends (1 min)
- Show market trends analysis
- **Highlight**:
  - Real-time market signals
  - Trending skills
  - Demand forecasting
  - Market Agent insights

## Key Points to Emphasize

1. **Pure Jac Language**: Everything in Jac - no Python, no separate React
2. **OSP Graph**: Natural graph-based modeling
3. **Multi-Agent AI**: 5 specialized agents working together
4. **Enterprise-Grade**: Production-ready architecture
5. **Real-Time**: Dynamic updates as market changes
6. **Personalized**: AI-powered personalization
7. **Scalable**: Built for scale with Jaseci

## Technical Highlights

- **byLLM Integration**: Show how `by()` keyword simplifies LLM calls
- **Graph Traversal**: Demonstrate walker patterns
- **Reactive Frontend**: Show Jac Client's reactive state
- **Modular Architecture**: Clean separation of concerns

## Q&A Preparation

**Q: How does it scale?**
A: Jaseci's scale-native execution allows deployment from local to cloud without code changes.

**Q: What about data persistence?**
A: Currently in-memory for demo. Production would use persistent storage.

**Q: How accurate are recommendations?**
A: Uses multiple AI agents (Critic, Market) to validate and improve accuracy.

**Q: Can it integrate with real job APIs?**
A: Yes, the job API client is modular and supports multiple sources.

**Q: What makes this different?**
A: Pure Jac language, OSP graph modeling, multi-agent AI system, enterprise architecture.

## Troubleshooting

- **Backend not starting**: Check Python version, Jac installation
- **Frontend not loading**: Check browser console, ensure backend is running
- **API errors**: Check .env file, API keys configured
- **No data**: Run seed_demo_data walker

## Closing

- "This demonstrates the power of Jac language and Jaseci"
- "From prototype to production with the same code"
- "AI-first development with byLLM"
- "Graph-based reasoning with OSP"

