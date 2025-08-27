# Setup Guide

## Prerequisites

### Required Software
- **Node.js** 18+ with npm/yarn
- **TypeScript** (for validation)
- **Claude Code CLI** installed globally
- **Git** for version control

### Required Claude Code Configuration
This system requires several MCP (Model Context Protocol) servers to function properly.

## Step-by-Step Setup

### 1. Install Claude Code

```bash
# Install Claude Code globally
npm install -g @anthropic/claude-code

# Verify installation
claude-code --version
```

### 2. Configure MCP Servers

Add the following to your Claude Code configuration file:

**Location**: `~/.claude/config.json` (or your Claude Code config path)

```json
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
```

### 3. Install Project Dependencies

In your project directory:

```bash
# Core development dependencies
npm install -D typescript @types/node

# Linting and formatting
npm install -D eslint prettier

# Testing (if using)
npm install -D jest @types/jest

# Build tools (adapt to your project)
npm install -D webpack vite rollup  # Choose your build tool
```

### 4. Copy System Files

```bash
# Create Claude Code directories if they don't exist
mkdir -p .claude/commands
mkdir -p .claude/agents

# Copy command files
cp path/to/claude-task-system/commands/*.md .claude/commands/

# Copy agent files  
cp path/to/claude-task-system/agents/*.md .claude/agents/

# Copy configuration templates
cp path/to/claude-task-system/examples/CLAUDE.md ./CLAUDE.md
cp path/to/claude-task-system/examples/settings.local.json .claude/settings.local.json
```

### 5. Configure for Your Project

#### A. Configure CLAUDE.md (CRITICAL)

**This is the most important configuration step.** The CLAUDE.md file tells Claude Code about your project.

```bash
# Edit the CLAUDE.md file
nano CLAUDE.md

# Key sections to update:
```

**Essential Updates:**

1. **Project Overview** - Describe your domain and key goals
2. **Tech Stack** - List your exact technologies 
3. **Development Commands** - Must match your package.json scripts
4. **Architecture** - Explain your code organization patterns

**Example for Next.js project:**
```markdown
## Development Commands
```bash
npm run dev        # Next.js development server
npm run build      # Next.js production build  
npm run lint       # Next.js linting
```

## Architecture Overview
### Tech Stack
- **Frontend:** Next.js 14 + TypeScript + Tailwind CSS
- **API:** tRPC for type-safe client-server communication
- **Database:** PostgreSQL with Prisma ORM
```

⚠️ **Critical**: If your commands don't match, the system will fail during validation.

#### B. Configure Claude Permissions

The `.claude/settings.local.json` file should work as-is, but verify these permissions exist:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",      // Your lint command
      "Bash(npm run build)",     // Your build command  
      "Bash(npm run dev)",       // Your dev command
      "mcp__playwright__*",      // Frontend testing
      "mcp__gpt-codex__codex"    // External critique
    ]
  }
}
```

#### C. Update Additional Configuration

Most configuration is handled by CLAUDE.md, but you may need to update:

**Test Credentials** (edit `.claude/agents/tc-frontend-tester.md`):
```markdown
**Primary Test Account:**
- Email: `your-test-user@example.com`
- Password: `your-test-password`
```

**Technology Description** (edit `.claude/agents/tc-codex-critic.md`):
```markdown
## Platform Context
[Your project description and key objectives]

**Technology Stack:**
- Next.js 14 + TypeScript + Tailwind CSS
- PostgreSQL + Prisma ORM  
- Your specific requirements
```

**📖 For detailed configuration help, see [CLAUDE_CONFIG.md](CLAUDE_CONFIG.md)**

### 6. Verify Installation

Test that everything is working:

```bash
# Test Claude Code connection
claude-code --list-commands

# Verify MCP servers are running
claude-code --check-mcp

# Test a simple task (optional)
claude-code /task_complete "Add a simple test component"
```

## Project-Specific Configurations

### TypeScript Projects

Ensure your `tsconfig.json` includes:

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noImplicitReturns": true
  },
  "include": ["src/**/*", "**/*.ts", "**/*.tsx"]
}
```

### ESLint Configuration

Example `.eslintrc.js`:

```javascript
module.exports = {
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended'
  ],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  rules: {
    // Customize for your project
  }
};
```

### Package.json Scripts

Ensure these scripts exist:

```json
{
  "scripts": {
    "dev": "your-dev-command",
    "build": "your-build-command", 
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "type-check": "tsc --noEmit"
  }
}
```

## Framework-Specific Setup

### Next.js Projects

```bash
# Install Next.js if not already installed
npm install next react react-dom
npm install -D @types/react @types/react-dom

# Ensure these scripts exist in package.json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  }
}
```

### React (Vite) Projects

```bash
# Install Vite dependencies
npm install -D vite @vitejs/plugin-react

# Package.json scripts
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
  }
}
```

### Express/Node.js API Projects

```bash
# Core dependencies
npm install express cors helmet
npm install -D @types/express @types/cors @types/helmet nodemon

# Package.json scripts
{
  "scripts": {
    "dev": "nodemon src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js",
    "lint": "eslint src --ext .ts"
  }
}
```

## Advanced Configuration

### Custom Quality Gates

Edit `.claude/agents/tc-quality-reviewer.md` to set project-specific standards:

```markdown
### Performance Requirements
- Page load time < 2 seconds
- Bundle size < 1MB
- Lighthouse score > 90

### Security Requirements  
- All inputs validated
- No secrets in code
- Authentication required

### Code Quality
- Test coverage > 80%
- No TODO comments in production
- Consistent error handling
```

### Integration with CI/CD

Add validation to your CI pipeline:

```yaml
# .github/workflows/validate.yml
name: Task System Validation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run lint
      - run: npx tsc --noEmit
      - run: npm run build
      - run: npm test # if tests exist
```

## Troubleshooting

### Common Issues

**1. "MCP server not found"**
```bash
# Verify MCP servers are installed
npx @anthropic/gpt-codex-mcp --version

# Check Claude Code configuration
cat ~/.claude/config.json
```

**2. "Dev server won't start"**
```bash
# Check if port is available
netstat -an | grep :3000

# Kill existing processes
pkill -f "npm run dev"
```

**3. "TypeScript errors in validation"**
```bash
# Run TypeScript check manually
npx tsc --noEmit

# Check tsconfig.json configuration
cat tsconfig.json
```

**4. "Lint errors preventing completion"**
```bash
# Run linting manually
npm run lint

# Auto-fix if possible
npm run lint -- --fix
```

### Performance Optimization

For large codebases:

```json
// tsconfig.json - optimize for performance
{
  "compilerOptions": {
    "incremental": true,
    "tsBuildInfoFile": ".tsbuildinfo"
  },
  "exclude": ["node_modules", "dist", ".next"]
}
```

```javascript
// .eslintrc.js - ignore large directories
module.exports = {
  ignorePatterns: ["dist/", ".next/", "node_modules/"]
};
```

## Testing the Setup

### Quick Validation

1. **Test MCP Connection:**
   ```bash
   claude-code --check-mcp-servers
   ```

2. **Verify Build Pipeline:**
   ```bash
   npm run lint
   npx tsc --noEmit  
   npm run build
   ```

3. **Test Development Server:**
   ```bash
   npm run dev &
   curl http://localhost:3000
   pkill -f "npm run dev"
   ```

4. **Run Simple Task:**
   ```bash
   claude-code /task_complete "Add a simple hello world function"
   ```

### Expected File Structure

After setup, your project should have:

```
your-project/
├── .claude/
│   ├── commands/
│   │   ├── task_complete.md
│   │   └── task_finish.md
│   └── agents/
│       ├── tc-context-gatherer.md
│       ├── tc-task-planner.md
│       ├── tc-implementation-agent.md
│       ├── tc-quality-reviewer.md
│       ├── tc-dev-monitor.md
│       ├── tc-frontend-tester.md
│       └── tc-codex-critic.md
├── claude-tasks/         # Created automatically
├── package.json          # With required scripts
├── tsconfig.json         # TypeScript configuration
├── .eslintrc.js         # Linting configuration  
└── src/                 # Your source code
```

You're now ready to use the Claude Code Task Completion System!