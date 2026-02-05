# 🧭 Smart Career Path Navigator

![Jac](https://img.shields.io/badge/Built_with-Jac-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Hackathon_MVP-success?style=for-the-badge)

An enterprise-grade AI-powered career planning platform built with **Jaseci (Jac)**, **byLLM**, **Jac Client**, and **OSP Graph**.

---

## 🎯 Project Overview

The **Smart Career Path Navigator** bridges the gap between current skills and future career goals using a multi-agent AI system that:

* **Analyzes** skills, resumes, experience, and certifications.
* **Detects** skill gaps using AI-powered reasoning.
* **Generates** personalized career paths and learning roadmaps.
* **Visualizes** skills in an OSP graph structure.
* **Recommends** courses and certifications.
* **Matches** users to real job-market data.
* **Dynamically updates** as market trends change.

---

## 🏗️ Architecture

### Backend (Pure Jac)
* **OSP Graph Models:** User, Skill, Role, Certification, Course, JobPosting, MarketSignal.
* **Walkers:** Modular walkers implementing all business logic.
* **byLLM Agents:** Analyzer, Planner, Market, Critic, Explainer.
* **Graph Algorithms:** Pathfinding, ranking, market multiplier calculations.
* **Job API Integration:** Real-time job market ingestion.

### Frontend (Jac Client)
* **Pages:** Login, Dashboard, Skill Profile, Career Path, Courses, Jobs, Graph Visualizer, Settings.
* **Components:** Reusable UI components.
* **Routing:** Hash-based client-side routing.
* **State Management:** Reactive state using `createState`.

---

## 📋 Prerequisites

* **Python 3.8+**
* **Jac (Jaseci)** installed:
  ```bash
  pip install jaclang

```

* **OpenAI API Key** (for byLLM agents)
* **Node.js** (optional, for frontend tooling)

---

## 🚀 Installation

### 1. Clone & Setup

```bash
git clone [https://github.com/your-username/smart-career-navigator.git](https://github.com/your-username/smart-career-navigator.git)
cd smart-career-navigator
python -m venv venv

```

### 2. Activate Virtual Environment

**For Windows:**

```bash
venv\Scripts\activate

```

**For Linux / macOS:**

```bash
source venv/bin/activate

```

**Install dependencies:**

```bash
pip install -r requirements.txt

```

### 3. Configure Environment

Copy the example environment file:

```bash
cp .env.example .env

```

Edit your `.env` file with these keys:

```env
OPENAI_API_KEY=your_openai_api_key_here
JOB_API_KEY=your_job_api_key_here
JOB_API_URL=[https://api.example.com/jobs](https://api.example.com/jobs)

```

### 4. Initialize Backend

**Run in Development Mode:**

```bash
jac run backend/main.jac

```

**Or Serve as API:**

```bash
jac serve backend/main.jac

```

> Server runs at: `http://localhost:8000`

### 5. Setup Frontend

The frontend uses Jac Client.

1. `frontend/index.html` loads the Jac Client bundle.
2. Open directly in browser or serve via HTTP server:

```bash
python -m http.server 8080

```

> Navigate to: `http://localhost:8080/frontend/`

---

## 📖 Usage

### Backend API

All walkers are automatically exposed as API endpoints.

**Parse Resume**

```bash
POST /walker/parse_resume
Content-Type: application/json

{ "resume_text": "..." }

```

**Skill Gap Analysis**

```bash
POST /walker/skill_gap_analysis
Content-Type: application/json

{ "user_id": "demo@example.com", "target_role_title": "Senior Software Engineer" }

```

**Generate Learning Path**

```bash
POST /walker/generate_learning_path
Content-Type: application/json

{ "user_id": "demo@example.com", "target_role_title": "Senior Software Engineer" }

```

---

## 🧪 Demo Data

Seed demo graph data:

```bash
jac run backend/walkers/demo_data.jac

```

Or via API:

```bash
POST /walker/seed_demo_data

```

---

## 📁 Project Structure

```text
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

```

---

## 🔧 Development

**Run Backend (Development):**

```bash
jac run backend/main.jac

```

**Run Backend (Production):**

```bash
jac serve backend/main.jac --host 0.0.0.0 --port 8000

```

**Test Walkers via CLI:**

```bash
jac run -walker parse_resume -ctx '{"resume_text": "..."}' backend/main.jac

```

---

## 🎨 Features

* ✅ AI resume parsing
* ✅ Skill extraction and analysis
* ✅ Skill gap detection
* ✅ Personalized career path generation
* ✅ Learning roadmap creation
* ✅ Course recommendations
* ✅ Job matching
* ✅ Market trend analysis
* ✅ OSP graph visualization
* ✅ Multi-agent AI architecture

---

## 📝 License

Created for an AI Hackathon.

## 🙏 Acknowledgments

* **Jaseci / Jac Language**
* **OpenAI** for LLM capabilities
* **Gebeya Dala** for AI infrastructure

```

```
