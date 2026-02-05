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
