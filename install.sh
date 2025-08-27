#!/bin/bash

# Claude Code Task Completion System Installation Script

set -e  # Exit on error

echo "🚀 Installing Claude Code Task Completion System..."
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed."
    echo "Please install Node.js 18+ from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18 or higher is required. Current version: $(node --version)"
    exit 1
fi

echo "✅ Node.js $(node --version) found"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is required but not installed."
    exit 1
fi
echo "✅ npm $(npm --version) found"

# Check Claude Code
if ! command -v claude-code &> /dev/null; then
    echo "⚠️  Claude Code CLI not found. Installing..."
    npm install -g @anthropic/claude-code
else
    echo "✅ Claude Code CLI found"
fi

# Create directory structure
echo ""
echo "📁 Setting up directory structure..."

mkdir -p .claude/commands
mkdir -p .claude/agents
mkdir -p claude-tasks
mkdir -p docs

echo "✅ Directories created"

# Copy files
echo ""
echo "📋 Copying system files..."

if [ ! -f ".claude/commands/task_complete.md" ]; then
    cp commands/task_complete.md .claude/commands/
    echo "✅ Copied task_complete command"
fi

if [ ! -f ".claude/commands/task_finish.md" ]; then
    cp commands/task_finish.md .claude/commands/
    echo "✅ Copied task_finish command"
fi

# Copy agent files
AGENTS=("tc-context-gatherer" "tc-task-planner" "tc-dev-monitor" "tc-implementation-agent" "tc-quality-reviewer" "tc-frontend-tester" "tc-codex-critic")

for agent in "${AGENTS[@]}"; do
    if [ ! -f ".claude/agents/${agent}.md" ]; then
        cp "agents/${agent}.md" ".claude/agents/"
        echo "✅ Copied ${agent} agent"
    fi
done

# Copy CLAUDE.md template
if [ ! -f "CLAUDE.md" ]; then
    cp examples/CLAUDE.md ./CLAUDE.md
    echo "✅ Copied CLAUDE.md template"
    echo "⚠️  IMPORTANT: Edit CLAUDE.md with your project details"
fi

# Copy Claude settings
if [ ! -f ".claude/settings.local.json" ]; then
    cp examples/settings.local.json .claude/settings.local.json
    echo "✅ Copied Claude settings"
fi

# Install MCP servers
echo ""
echo "🔧 Installing MCP servers..."

echo "Installing gpt-codex..."
npm install -g @anthropic/gpt-codex-mcp 2>/dev/null || echo "⚠️  gpt-codex installation failed (may require manual setup)"

echo "Installing playwright..."
npm install -g @anthropic/playwright-mcp 2>/dev/null || echo "⚠️  playwright installation failed"

echo "Installing context7..."
npm install -g @anthropic/context7-mcp 2>/dev/null || echo "⚠️  context7 installation failed"

echo "Installing sequential-thinking..."
npm install -g @anthropic/sequential-thinking-mcp 2>/dev/null || echo "⚠️  sequential-thinking installation failed"

echo "Installing ide integration..."
npm install -g @anthropic/ide-mcp 2>/dev/null || echo "⚠️  ide-mcp installation failed"

# Install Playwright browser
echo "Installing Playwright browser..."
npx playwright install chromium 2>/dev/null || echo "⚠️  Playwright browser installation failed"

# Create sample configuration
echo ""
echo "⚙️  Creating configuration files..."

# Create package.json scripts if package.json exists
if [ -f "package.json" ]; then
    # Check if scripts section exists and add missing scripts
    if ! grep -q '"lint"' package.json; then
        echo "⚠️  Adding lint script to package.json"
        # Note: This would require jq for proper JSON manipulation
        echo "Please add this script to your package.json:"
        echo '  "lint": "eslint . --ext .ts,.tsx,.js,.jsx"'
    fi
    
    if ! grep -q '"type-check"' package.json; then
        echo "⚠️  Adding type-check script to package.json"
        echo "Please add this script to your package.json:"
        echo '  "type-check": "npx tsc --noEmit"'
    fi
fi

# Create MCP configuration template
cat > claude-mcp-config.json << EOF
{
  "mcp_servers": {
    "gpt-codex": {
      "command": "npx",
      "args": ["-y", "@anthropic/gpt-codex-mcp"],
      "env": {}
    },
    "playwright": {
      "command": "npx", 
      "args": ["-y", "@anthropic/playwright-mcp"],
      "env": {}
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@anthropic/context7-mcp"], 
      "env": {}
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic/sequential-thinking-mcp"],
      "env": {}
    },
    "ide": {
      "command": "npx",
      "args": ["-y", "@anthropic/ide-mcp"],
      "env": {}
    }
  }
}
EOF

echo "✅ Created claude-mcp-config.json"

# Final instructions
echo ""
echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. 🎯 CRITICAL: Configure CLAUDE.md for your project:"
echo "   nano CLAUDE.md"
echo "   # Update project overview, tech stack, and development commands"
echo ""
echo "2. Add the MCP configuration to your Claude Code config:"
echo "   cat claude-mcp-config.json"
echo ""
echo "3. Configure for your project:"
echo "   - Update test credentials in .claude/agents/tc-frontend-tester.md"
echo "   - Update tech stack in .claude/agents/tc-codex-critic.md"
echo ""
echo "3. Test the installation:"
echo "   claude-code --list-commands"
echo "   claude-code /task_complete \"Add a simple test component\""
echo ""
echo "4. Read the documentation:"
echo "   - README.md for overview and usage"
echo "   - docs/SETUP.md for detailed configuration"
echo "   - docs/MCP_SERVERS.md for MCP server troubleshooting"
echo "   - examples/ for project-specific configurations"
echo ""
echo "✨ You're ready to build production-ready features with Claude Code!"