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
if ! command -v claude &> /dev/null; then
    echo "⚠️  Claude Code CLI not found. Installing..."
    echo "   Attempting npm installation (recommended)..."
    
    if npm install -g @anthropic-ai/claude-code; then
        echo "✅ Claude Code CLI installed via npm"
    else
        echo "❌ npm installation failed. Please install manually:"
        echo "   npm install -g @anthropic-ai/claude-code"
        echo ""
        echo "   Or use the native binary installation:"
        echo "   curl -fsSL https://claude.ai/install.sh | sh"
        echo ""
        echo "   For more details, visit: https://docs.anthropic.com/en/docs/claude-code/setup"
        exit 1
    fi
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

# Download and copy files from GitHub
echo ""
echo "📋 Downloading system files from GitHub..."

GITHUB_RAW_URL="https://raw.githubusercontent.com/codeoutin/claude-code-agency/main"

# Download command files
COMMANDS=("task_complete" "task_finish" "task_easy")

for cmd in "${COMMANDS[@]}"; do
    if [ ! -f ".claude/commands/${cmd}.md" ]; then
        if curl -fsSL "$GITHUB_RAW_URL/commands/${cmd}.md" -o ".claude/commands/${cmd}.md"; then
            echo "✅ Downloaded ${cmd} command"
        else
            echo "❌ Failed to download ${cmd} command"
        fi
    fi
done

# Also copy commands to root level for consolidated access
mkdir -p commands
for cmd in "${COMMANDS[@]}"; do
    if [ -f ".claude/commands/${cmd}.md" ] && [ ! -f "commands/${cmd}.md" ]; then
        cp ".claude/commands/${cmd}.md" "commands/${cmd}.md"
        echo "✅ Copied ${cmd} command to root level"
    fi
done

# Download agent files  
AGENTS=("tc-context-gatherer" "tc-task-planner" "tc-implementation-agent" "tc-quality-reviewer" "tc-frontend-tester" "tc-codex-critic")

for agent in "${AGENTS[@]}"; do
    if [ ! -f ".claude/agents/${agent}.md" ]; then
        if curl -fsSL "$GITHUB_RAW_URL/agents/${agent}.md" -o ".claude/agents/${agent}.md"; then
            echo "✅ Downloaded ${agent} agent"
        else
            echo "❌ Failed to download ${agent} agent"
        fi
    fi
done

# Download CLAUDE.md template
if [ ! -f "CLAUDE.md" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/examples/CLAUDE.md" -o "./CLAUDE.md"; then
        echo "✅ Downloaded CLAUDE.md template"
        echo "⚠️  IMPORTANT: Edit CLAUDE.md with your project details"
    else
        echo "❌ Failed to download CLAUDE.md template"
    fi
fi

# Download Claude settings
if [ ! -f ".claude/settings.json" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/.claude/settings.json" -o ".claude/settings.json"; then
        echo "✅ Downloaded Claude core settings"
    else
        echo "❌ Failed to download Claude core settings"
    fi
fi

if [ ! -f ".claude/settings.local.json" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/examples/settings.local.json" -o ".claude/settings.local.json"; then
        echo "✅ Downloaded Claude local settings template"
    else
        echo "❌ Failed to download Claude local settings template"
    fi
fi

# Download documentation files
echo "📚 Downloading documentation..."
mkdir -p docs examples

if [ ! -f "docs/SETUP.md" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/docs/SETUP.md" -o "docs/SETUP.md"; then
        echo "✅ Downloaded setup documentation"
    else
        echo "❌ Failed to download setup documentation"
    fi
fi

if [ ! -f "docs/MCP_SERVERS.md" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/docs/MCP_SERVERS.md" -o "docs/MCP_SERVERS.md"; then
        echo "✅ Downloaded MCP servers documentation"
    else
        echo "❌ Failed to download MCP servers documentation"
    fi
fi

# Download template files
if [ ! -f "examples/PROJECT_STATUS.md" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/examples/PROJECT_STATUS.md" -o "examples/PROJECT_STATUS.md"; then
        echo "✅ Downloaded PROJECT_STATUS.md template"
    else
        echo "❌ Failed to download PROJECT_STATUS.md template"
    fi
fi

if [ ! -f "examples/PROJECT_DESCRIPTION.md" ]; then
    if curl -fsSL "$GITHUB_RAW_URL/examples/PROJECT_DESCRIPTION.md" -o "examples/PROJECT_DESCRIPTION.md"; then
        echo "✅ Downloaded PROJECT_DESCRIPTION.md template"
    else
        echo "❌ Failed to download PROJECT_DESCRIPTION.md template"
    fi
fi

# Note: MCP servers will be configured to use npx for on-demand installation
echo ""
echo "🔧 MCP servers will be configured for on-demand installation..."
echo "✅ MCP configuration ready (packages installed on first use)"

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
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "env": {}
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {}
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
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
echo "2. Set up project templates (optional but recommended):"
echo "   cp examples/PROJECT_STATUS.md ."
echo "   cp examples/PROJECT_DESCRIPTION.md ."
echo "   # Then use Claude to customize them:"
echo "   claude \"Please customize PROJECT_STATUS.md and PROJECT_DESCRIPTION.md for my project\""
echo ""
echo "3. Configure agent settings:"
echo "   # Update test credentials:"
echo "   claude \"Update .claude/agents/tc-frontend-tester.md with my email: your-email@example.com\""
echo "   # Update tech stack info:"
echo "   claude \"Update .claude/agents/tc-codex-critic.md with my tech stack details\""
echo ""
echo "4. Add MCP servers to Claude Code:"
echo "   claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking"
echo "   claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem" 
echo "   claude mcp add memory -- npx -y @modelcontextprotocol/server-memory"
echo ""
echo "5. Test the installation:"
echo "   claude /task_easy \"Test the task completion system setup\""
echo ""
echo "6. Read the documentation:"
echo "   - README.md for overview and usage"
echo "   - docs/SETUP.md for detailed configuration"  
echo "   - docs/MCP_SERVERS.md for MCP server troubleshooting"
echo "   - examples/ for customizable project templates"
echo ""
echo "✨ You're ready to build production-ready features with Claude Code!"