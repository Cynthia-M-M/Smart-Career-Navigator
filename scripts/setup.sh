#!/bin/bash

# Setup script for Smart Career Path Navigator

echo "🚀 Setting up Smart Career Path Navigator..."

# Check Python version
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python version: $python_version"

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Check Jac installation
echo "✅ Checking Jac installation..."
jac --version

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env and add your API keys!"
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p data

echo "✨ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env and add your API keys"
echo "2. Activate virtual environment: source venv/bin/activate"
echo "3. Start backend: jac serve backend/main.jac"
echo "4. Open frontend/index.html in browser"
echo ""
echo "For demo data: jac run backend/walkers/demo_data.jac"

