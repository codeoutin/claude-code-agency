# Claude Code Configuration Guide

This document explains the essential configuration files needed for the Task Completion System to work properly.

## Required Configuration Files

### 1. CLAUDE.md - Project Instructions

**Location**: `CLAUDE.md` (in your project root)

**Purpose**: Provides Claude Code with essential project context, architecture details, and development guidelines.

**Why Critical**: Without this file, agents won't understand:
- Your project's architecture and patterns
- Development commands specific to your setup
- Code quality standards and conventions
- Domain-specific business logic

**Setup**:
```bash
# Copy the template
cp examples/CLAUDE.md ./CLAUDE.md

# Edit for your project
# Update sections marked with [Your ...]
```

### 2. settings.local.json - Permissions

**Location**: `.claude/settings.local.json`

**Purpose**: Grants Claude Code permission to use specific tools and MCP servers required by the task completion system.

**Why Critical**: Without proper permissions, agents will fail when trying to:
- Run build/lint/test commands
- Use Playwright for frontend testing
- Access Codex for external critique
- Use MCP servers for advanced capabilities

## CLAUDE.md Template Breakdown

### Essential Sections

#### Project Overview
```markdown
## Project Overview
[Your project description - replace with your actual project details]

**Key Design Principles:**
- [Your core design principles]
- [Key user experience goals]  
- [Technical constraints or requirements]
```

#### Development Commands
```markdown
## Development Commands
```bash
# Development server
npm run dev

# Production build  
npm run build

# Linting
npm run lint

# Type checking
npm run type-check
```
```

**Critical**: These commands MUST match your actual package.json scripts. The task system relies on these exact commands.

#### Architecture Overview
```markdown
### Tech Stack
- **Frontend:** [Your frontend stack]
- **Backend:** [Your backend stack]
- **Database:** [Your database]
```

**Purpose**: Helps agents understand your technology choices and make consistent implementation decisions.

#### Common Patterns
```markdown
### Common Patterns
- **Error Handling:** [Your error handling approach]
- **State Management:** [Your state management patterns]
- **Data Fetching:** [Your data fetching patterns]
```

**Critical for Code Quality**: Agents use this to maintain consistency with your existing codebase.

## settings.local.json Breakdown

### Required Permissions

#### MCP Server Permissions
```json
{
  "permissions": {
    "allow": [
      "mcp__playwright__browser_snapshot",
      "mcp__playwright__browser_type", 
      "mcp__playwright__browser_click",
      "mcp__playwright__browser_wait_for",
      "mcp__playwright__browser_take_screenshot",
      "mcp__playwright__browser_navigate",
      "mcp__gpt-codex__codex",
      "mcp__context7__resolve-library-id",
      "mcp__context7__get-library-docs",
      "mcp__sequential-thinking__sequentialthinking",
      "mcp__ide__getDiagnostics"
    ]
  }
}
```

**Purpose**: 
- `playwright__*` - Frontend testing automation
- `gpt-codex__*` - External code critique
- `context7__*` - Library documentation lookup
- `sequential-thinking__*` - Advanced problem solving
- `ide__*` - Real-time error detection

#### Build Command Permissions
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npx tsc:*)",
      "Bash(npm run build:*)",
      "Bash(npm run dev)",
      "Bash(npm run test)"
    ]
  }
}
```

**Purpose**: Allows quality validation commands during implementation.

#### Web Access Permissions
```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:docs.anthropic.com)",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:npmjs.com)"
    ]
  }
}
```

**Purpose**: Research capabilities for documentation lookup.

## Setup Process

### 1. Create CLAUDE.md

```bash
# Copy and customize the template
cp examples/CLAUDE.md ./CLAUDE.md

# Key sections to update:
# - Project Overview (your domain/business)
# - Tech Stack (your actual technologies)
# - Development Commands (your package.json scripts)
# - Architecture patterns (your code organization)
```

### 2. Create Claude Settings

```bash
# Create Claude directory
mkdir -p .claude

# Copy settings template
cp examples/settings.local.json .claude/settings.local.json

# The template should work as-is for most projects
```

### 3. Verify Configuration

```bash
# Test that Claude can read your project context
claude-code --validate-config

# Test MCP permissions
claude-code --check-permissions
```

## Project-Specific Customization

### For Next.js Projects

**CLAUDE.md Updates**:
```markdown
## Development Commands
```bash
npm run dev     # Next.js dev server
npm run build   # Next.js production build
npm run lint    # Next.js linting
```

### Tech Stack
- **Frontend:** Next.js 14 + TypeScript + Tailwind CSS
- **API:** Next.js API routes / tRPC
```

### For React + Vite Projects

**CLAUDE.md Updates**:
```markdown
## Development Commands
```bash
npm run dev     # Vite dev server  
npm run build   # Vite production build
npm run lint    # ESLint
```

### Tech Stack
- **Frontend:** React 18 + TypeScript + Vite
- **Styling:** Tailwind CSS / Styled Components
```

### For Express API Projects

**CLAUDE.md Updates**:
```markdown
## Development Commands
```bash
npm run dev     # Nodemon dev server
npm run build   # TypeScript compilation
npm run start   # Production server
```

### Tech Stack
- **Backend:** Express.js + TypeScript
- **Database:** PostgreSQL + Prisma/TypeORM
```

**Additional Settings Permission**:
```json
{
  "permissions": {
    "allow": [
      "Bash(node dist/server.js)",
      "Bash(nodemon src/server.ts)"
    ]
  }
}
```

## Common Issues & Solutions

### "Permission denied" errors

**Problem**: Claude can't run build commands
**Solution**: Add missing permissions to settings.local.json

```json
{
  "permissions": {
    "allow": [
      "Bash(your-exact-command)"
    ]
  }
}
```

### "Unknown project structure" errors

**Problem**: Agents can't understand your codebase
**Solution**: Improve CLAUDE.md architecture section

```markdown
## File Structure Notes
- `src/` - Source code
- `components/` - React components
- `lib/` - Utility functions
- `api/` - Backend API routes
```

### MCP server connection failures

**Problem**: External services not working
**Solution**: Verify MCP server installation and permissions

```bash
# Test MCP servers
claude-code --test-mcp gpt-codex
claude-code --test-mcp playwright
```

## Security Considerations

### Principle of Least Privilege

Only grant permissions actually needed:

```json
{
  "permissions": {
    "allow": [
      // Only include commands your project actually uses
      "Bash(npm run lint)",     // ✅ If you use npm
      "Bash(yarn lint)",        // ❌ Don't add if you use npm
    ]
  }
}
```

### Safe Web Domains

Only allow trusted documentation domains:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:docs.anthropic.com)",  // ✅ Official docs
      "WebFetch(domain:github.com)",          // ✅ Code repositories  
      "WebFetch(domain:random-blog.com)"      // ❌ Untrusted sources
    ]
  }
}
```

## Validation Checklist

### Before First Use

- [ ] CLAUDE.md exists and describes your project
- [ ] All development commands in CLAUDE.md work locally
- [ ] .claude/settings.local.json grants required permissions
- [ ] MCP servers installed and accessible
- [ ] Test credentials configured in frontend tester

### Regular Maintenance

- [ ] Update CLAUDE.md when architecture changes
- [ ] Add new permissions when adding new tools
- [ ] Remove unused permissions for security
- [ ] Update tech stack descriptions

## Advanced Configuration

### Custom Quality Standards

Add project-specific quality requirements to CLAUDE.md:

```markdown
## Quality Standards
- Code coverage > 80%
- Bundle size < 1MB
- Page load time < 2s
- Accessibility score > 90
```

### Integration with CI/CD

Align Claude settings with your CI pipeline:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run ci)",
      "Bash(npm run test:ci)",
      "Bash(npm run build:production)"
    ]
  }
}
```

This configuration ensures the Task Completion System understands your project and has the necessary permissions to operate effectively.