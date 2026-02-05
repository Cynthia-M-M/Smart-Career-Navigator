# 🧭 Smart Career Path Navigator

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Jaseci](https://img.shields.io/badge/Jaseci-Built_with_Jac-black?style=for-the-badge)
![OpenAI](https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white)
![Status](https://img.shields.io/badge/Status-Hackathon_MVP-success?style=for-the-badge)

An enterprise-grade AI-powered career planning platform built with **Jaseci (Jac)**, **byLLM**, **Jac Client**, and **OSP Graph**.

---

## 🎯 Project Overview

The **Smart Career Path Navigator** is a comprehensive platform designed to bridge the gap between current skills and future career goals. It leverages a multi-agent AI system to:

* **Analyze** skills, resumes, experience, and certifications.
* **Detect** skill gaps using AI-powered analysis.
* **Generate** personalized career paths with learning roadmaps.
* **Visualize** skills in an OSP graph structure.
* **Recommend** courses and certifications.
* **Match** users to real job-market data.
* **Update** dynamically as job-market changes.

---

## 🏗️ Architecture

### Backend (Pure Jac)
* **OSP Graph Models:** User, Skill, Role, Certification, Course, JobPosting, MarketSignal nodes.
* **Walkers:** Modular walkers for all business logic.
* **byLLM Agents:** 5 specialized AI agents (Analyzer, Planner, Market, Critic, Explainer).
* **Graph Algorithms:** Path finding, ranking, market multiplier calculations.
* **Job API Integration:** Real-time job market data integration.

### Frontend (Jac Client)
* **Pages:** Login, Dashboard, Skill Profile, Career Path, Courses, Jobs, Graph Visualizer, Settings.
* **Components:** Reusable UI components built with Jac Client.
* **Routing:** Hash-based client-side routing.
* **State Management:** Reactive state with Jac Client's `createState`.

---

## 📋 Prerequisites

* **Python 3.8+**
* **Jac (Jaseci)** installed: `pip install jaclang`
* **OpenAI API Key** (for byLLM agents)
* **Node.js** (optional, for frontend build tools)

---

## 🚀 Installation

### 1. Clone and Setup

```bash
cd smart-career-navigator
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt
2. Configure Environment
Copy .env.example to .env and fill in your API keys:

Bash

cp .env.example .env
Edit .env:

Code snippet

OPENAI_API_KEY=your_openai_api_key_here
JOB_API_KEY=your_job_api_key_here
JOB_API_URL=[https://api.example.com/jobs](https://api.example.com/jobs)
3. Initialize Backend
Bash

# Start Jaseci server
jac run backend/main.jac

# Or serve as API
jac serve backend/main.jac
The server will start on http://localhost:8000 by default.

4. Setup Frontend
The frontend uses Jac Client.

The frontend/index.html loads the Jac Client bundle.

Open in browser or serve with a simple HTTP server.

📖 Usage
Backend API
All walkers are automatically exposed as API endpoints:

Bash

# Parse resume
POST /walker/parse_resume
Body: {"resume_text": "..."}

# Get user profile
POST /walker/get_user_profile
Body: {"user_id": "demo@example.com"}

# Recommend roles
POST /walker/recommend_roles_walker
Body: {"user_id": "demo@example.com", "limit": 10}

# Skill gap analysis
POST /walker/skill_gap_analysis
Body: {"user_id": "demo@example.com", "target_role_title": "Senior Software Engineer"}

# Generate learning path
POST /walker/generate_learning_path
Body: {"user_id": "demo@example.com", "target_role_title": "Senior Software Engineer"}
Frontend
Open frontend/index.html in a browser.

Or serve with a web server:

Bash

python -m http.server 8080
# Navigate to http://localhost:8080/frontend/
Login with demo credentials (or any email/password for demo).

Explore the dashboard and features.

🧪 Demo Data
Seed demo data to populate the graph:

Bash

jac run backend/walkers/demo_data.jac
Or use the walker via API:

Bash

POST /walker/seed_demo_data
📁 Project Structure
Plaintext

smart-career-navigator/
├── backend/
│   ├── models/          # OSP Graph models
│   ├── walkers/         # Business logic walkers
│   ├── agents/          # byLLM AI agents
│   ├── algorithms/      # Graph algorithms
│   ├── utils/           # Utilities
│   ├── main.jac         # Entry point
│   └── config.jac       # Configuration
├── frontend/
│   ├── pages/           # Page components
│   ├── components/      # Reusable components
│   ├── services/        # API services
│   ├── app.jac          # Main app
│   └── index.html       # HTML entry
├── docs/                # Documentation
└── scripts/             # Setup scripts
🔧 Development
Running Backend
Bash

# Development mode
jac run backend/main.jac

# Production mode (API server)
jac serve backend/main.jac --host 0.0.0.0 --port 8000
Testing Walkers
Bash

# Test a walker directly via CLI
jac run -walker parse_resume -ctx '{"resume_text": "..."}' backend/main.jac
📚 API Documentation
See docs/API.md for complete API documentation with examples.

🎨 Features
✅ Resume parsing with AI

✅ Skill extraction and analysis

✅ Skill gap detection

✅ Personalized career path generation

✅ Learning roadmap creation

✅ Course recommendations

✅ Job matching

✅ Market trend analysis

✅ OSP graph visualization

✅ Multi-agent AI system

🤝 Contributing
This is a hackathon project. For production use, consider:

Adding authentication/authorization.

Implementing persistent storage.

Adding more job API integrations.

Enhancing graph visualization.

Adding more AI agents.

Improving error handling.

📝 License
This project is created for the AI Hackathon.

🙏 Acknowledgments
Jaseci/Jac Language

OpenAI for LLM capabilities

Gebeya Dala for AI infrastructure
