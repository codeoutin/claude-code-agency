# Claude Code Task Completion System

A multi-agent orchestration system that automates feature implementation with production-ready quality standards.

## 🚀 Personal Motivation

*From the creator:*

I've spent whole weekends coding huge tasks with AI. Starting with Chats (ChatGPT, Claude, DeepSeek, Gemini), to Cursor, to Claude Code. I ran often into the limitations of AI coding agents and I'm always trying to optimize my prompts.

With the introduction of Sub Agents and MCP servers, I finally found a workflow for complex tasks to have them implemented with a high quality standard that suits my projects.

These commands can run for hours and you will likely run into limitations if you are not on a Max Plan of Claude.

I share this workflow because I started out with publicly available agent descriptions, MCP server configurations and other information on GitHub and Reddit too and want to open this workflow for discussion and further improvements.

I often had issues where i closed the Terminal and picking up the task again would take a long time and introduce new errors and the AI would forget my previous concerns. The agents will document their progress and the Terminal will stay clean.

This command chain is using various MCP servers that are optional but highly recommended. My subscriptions are Claude on the 100 USD plan and ChatGPT on the 20 USD plan and I often run this command parallel to develop 3-4 features at once. I am using auto-accept to almost fully automate the process of development.

## Quick Start

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/your-username/claude-code-agency/main/install.sh | bash
```

Or [**download install.sh**](install.sh) and run: `./install.sh`

### What You Get

Transform feature requests like *"Add user authentication"* into:
- ✅ Complete implementation with error handling
- ✅ TypeScript/lint error validation 
- ✅ Automated testing and quality checks
- ✅ Production-ready code documentation

## How It Works

This system uses 6 specialized AI agents working together:

1. **Context Gatherer** - Analyzes your codebase patterns
2. **Task Planner** - Creates detailed implementation roadmap  
3. **Implementation Agent** - Writes code with strict validation
4. **Quality Reviewer** - Verifies all quality gates pass
5. **Frontend Tester** - Validates UI/UX with automated tests
6. **Code Critic** - External unbiased quality assessment

## 📸 System in Action

![Task Completion System Screenshot](https://github.com/user-attachments/assets/46dccd14-2eda-4d4c-a343-03a3e5731bd1)

## Usage

```bash
# Implement any feature
claude-code /task_complete "Add user authentication with JWT"

# Complete partial implementations
claude-code /task_finish "path/to/task/directory"
```

## Perfect For

### Large Codebases (500+ files)
- Maintains consistency across complex architectures
- Prevents breaking existing functionality

### TypeScript/React Projects  
- Specialized validation for TS errors
- Component pattern consistency

### High-Stakes Features
- Mission-critical functionality that MUST work
- Code that will be reviewed by senior developers

## Not Suitable For

- Simple one-file changes
- Quick prototypes/experiments
- Non-TypeScript projects (limited validation)

## Requirements

- Node.js 18+
- Claude Code CLI ([install guide](https://docs.anthropic.com/en/docs/claude-code/setup))
- TypeScript project with lint/build commands
- 4GB+ RAM (for Claude Code)
- Anthropic account (Pro/Max plan recommended)

## Configuration

After installation, edit these files for your project:

1. **CLAUDE.md** - Project overview and development commands
2. **.claude/agents/tc-frontend-tester.md** - Test credentials  
3. **.claude/agents/tc-codex-critic.md** - Technology stack

## Sample Output

Each task creates a timestamped directory with complete audit trail:

```
claude-tasks/2025-08-27-authentication/
├── context.md              # Codebase analysis
├── plan.md                 # Implementation roadmap  
├── implementation-1.md     # Development log
├── review-1.md            # Quality validation
├── test-results.md        # UI/UX testing
├── final-critique.md      # External assessment
└── screenshots/           # Visual proof
```

## Quality Standards

- **Zero Tolerance**: No new lint/TypeScript errors
- **Baseline Tracking**: Prevents any regressions  
- **Multi-Layer Validation**: Independent verification at each step
- **Production Ready**: Comprehensive error handling and testing

## Advanced Configuration

For detailed setup and customization options, see:
- [**Setup Guide**](docs/SETUP.md) - Comprehensive configuration
- [**MCP Servers**](docs/MCP_SERVERS.md) - Required integrations
- [**Examples**](examples/) - Project-specific configurations

## Troubleshooting

**"MCP server not found"**
```bash
# Verify MCP servers installed
claude-code --check-mcp
```

**"Dev server won't start"**
```bash  
# Check your package.json scripts match CLAUDE.md configuration
npm run dev
```

**"Validation failed"**
```bash
# Run quality checks manually
npm run lint
npx tsc --noEmit
npm run build
```

## Real-World Examples

**Before**: Ask Claude to "Add user authentication"
- Gets 50% complete then claims it's done
- Breaks existing TypeScript compilation  
- No error handling for edge cases
- Missing integration with existing routing

**After**: Same request with this system
- ✅ Complete JWT auth with refresh tokens
- ✅ Integrates with existing user management
- ✅ Comprehensive error handling & validation
- ✅ TypeScript errors fixed, lint warnings resolved
- ✅ Mobile-responsive login/signup forms tested
- ✅ Ready for production deployment

**Created by:** [Patrick Steger](https://psteger.com)