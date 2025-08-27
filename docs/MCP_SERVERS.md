# MCP Server Requirements

The Claude Code Task Completion System requires several MCP (Model Context Protocol) servers to function properly. This document explains each server's purpose and setup requirements.

## Overview

MCP servers provide specialized capabilities to Claude Code agents. Each server serves a specific purpose in the task completion workflow:

| Server | Purpose | Required For | Fallback Available |
|--------|---------|--------------|-------------------|
| gpt-codex | External code critique | Final validation | No |
| playwright | Browser automation | Frontend testing | Manual testing |
| context7 | Library documentation | Research tasks | Web search |
| sequential-thinking | Advanced reasoning | Complex planning | Basic planning |
| ide | IDE integration | Error detection | Manual checking |

## Required MCP Servers

### 1. GPT-Codex (`gpt-codex`)

**Purpose**: Provides external, unbiased code critique through the Codex system.

**Used By**: `tc-codex-critic` agent

**Critical For**: 
- Final external validation of implementation quality
- Market competitiveness assessment
- Architecture review from independent perspective

**Configuration**:
```json
{
  "gpt-codex": {
    "command": "npx",
    "args": ["-y", "@anthropic/gpt-codex-mcp"],
    "env": {}
  }
}
```

**Installation**:
```bash
npm install -g @anthropic/gpt-codex-mcp
```

**Failure Impact**: HIGH
- Final critique step will fail
- No external validation of code quality
- Reduced confidence in production readiness

---

### 2. Playwright (`playwright`)

**Purpose**: Browser automation for comprehensive frontend testing.

**Used By**: `tc-frontend-tester` agent

**Critical For**:
- Cross-device UI testing (desktop/mobile)
- Screenshot capture for visual validation  
- Performance testing and user flow verification
- Real user interaction simulation

**Configuration**:
```json
{
  "playwright": {
    "command": "npx",
    "args": ["-y", "@anthropic/playwright-mcp"],
    "env": {}
  }
}
```

**Installation**:
```bash
npm install -g @anthropic/playwright-mcp
npx playwright install chromium  # Install browser
```

**Failure Impact**: MEDIUM
- Frontend testing will fall back to manual checks
- No automated screenshot capture
- Reduced mobile testing coverage

---

### 3. Context7 (`context7`)

**Purpose**: Retrieves up-to-date library documentation and code examples.

**Used By**: `tc-context-gatherer` agent

**Critical For**:
- Library documentation lookup
- Best practices research
- Framework-specific implementation guidance

**Configuration**:
```json
{
  "context7": {
    "command": "npx",
    "args": ["-y", "@anthropic/context7-mcp"],
    "env": {}
  }
}
```

**Installation**:
```bash
npm install -g @anthropic/context7-mcp
```

**Failure Impact**: LOW
- Context gathering will use web search fallback
- Slightly reduced research capability
- May miss latest library updates

---

### 4. Sequential Thinking (`sequential-thinking`)

**Purpose**: Advanced reasoning and problem-solving for complex tasks.

**Used By**: Multiple agents for complex decision-making

**Critical For**:
- Breaking down complex problems
- Multi-step solution planning
- Error analysis and debugging strategies

**Configuration**:
```json
{
  "sequential-thinking": {
    "command": "npx",
    "args": ["-y", "@anthropic/sequential-thinking-mcp"],
    "env": {}
  }
}
```

**Installation**:
```bash
npm install -g @anthropic/sequential-thinking-mcp
```

**Failure Impact**: MEDIUM
- Reduced quality of complex problem-solving
- Less structured approach to multi-step tasks
- May struggle with intricate integration scenarios

---

### 5. IDE Integration (`ide`)

**Purpose**: Direct IDE integration for error detection and diagnostics.

**Used By**: `tc-implementation-agent`, `tc-quality-reviewer`

**Critical For**:
- Real-time error detection during implementation
- TypeScript diagnostics integration
- Build system integration

**Configuration**:
```json
{
  "ide": {
    "command": "npx",
    "args": ["-y", "@anthropic/ide-mcp"],
    "env": {}
  }
}
```

**Installation**:
```bash
npm install -g @anthropic/ide-mcp
```

**Failure Impact**: MEDIUM
- Reduced real-time error detection
- Manual validation processes required
- Less efficient debugging workflow

## Optional MCP Servers

### Puppeteer (`puppeteer`)

**Purpose**: Alternative browser automation (fallback for Playwright).

**Configuration**:
```json
{
  "puppeteer": {
    "command": "npx",
    "args": ["-y", "@anthropic/puppeteer-mcp"],
    "env": {}
  }
}
```

**Use Case**: Backup browser automation if Playwright fails.

## Installation Script

Create this script to install all required MCP servers:

```bash
#!/bin/bash
# install-mcp-servers.sh

echo "Installing Claude Code Task System MCP servers..."

# Required servers
npm install -g @anthropic/gpt-codex-mcp
npm install -g @anthropic/playwright-mcp
npm install -g @anthropic/context7-mcp
npm install -g @anthropic/sequential-thinking-mcp
npm install -g @anthropic/ide-mcp

# Install browser for Playwright
npx playwright install chromium

echo "MCP servers installed successfully!"
echo "Add the configuration from docs/MCP_SERVERS.md to your Claude Code config."
```

## Complete Configuration

Add this complete configuration to your Claude Code config file:

```json
{
  "mcp_servers": {
    "gpt-codex": {
      "command": "npx",
      "args": ["-y", "@anthropic/gpt-codex-mcp"],
      "env": {},
      "timeout": 30000
    },
    "playwright": {
      "command": "npx", 
      "args": ["-y", "@anthropic/playwright-mcp"],
      "env": {
        "PLAYWRIGHT_BROWSERS_PATH": "~/.cache/ms-playwright"
      },
      "timeout": 60000
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@anthropic/context7-mcp"], 
      "env": {},
      "timeout": 15000
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic/sequential-thinking-mcp"],
      "env": {},
      "timeout": 30000
    },
    "ide": {
      "command": "npx",
      "args": ["-y", "@anthropic/ide-mcp"],
      "env": {},
      "timeout": 10000
    }
  }
}
```

## Verification

### Test MCP Server Connections

```bash
# Check all MCP servers are running
claude-code --check-mcp-servers

# Test specific servers
claude-code --test-mcp gpt-codex
claude-code --test-mcp playwright
claude-code --test-mcp context7
```

### Manual Testing

```bash
# Test Codex
echo "Testing Codex critique..." | claude-code --mcp gpt-codex

# Test Playwright browser
claude-code --mcp playwright --eval "browser.navigate('https://example.com')"

# Test Context7 library lookup
claude-code --mcp context7 --lookup "react-hook-form"
```

## Troubleshooting

### Common Issues

**1. "MCP server not found"**
```bash
# Check if server is installed
npm list -g @anthropic/gpt-codex-mcp

# Reinstall if missing
npm install -g @anthropic/gpt-codex-mcp
```

**2. "Playwright browser not installed"**
```bash
# Install Chromium browser
npx playwright install chromium

# Check installation
npx playwright --version
```

**3. "Context7 API limit exceeded"**
```bash
# Check API usage
claude-code --mcp context7 --status

# Wait for rate limit reset or use fallback
```

**4. "Sequential thinking timeout"**
```bash
# Increase timeout in config
{
  "sequential-thinking": {
    "timeout": 60000  // Increase from 30s to 60s
  }
}
```

### Performance Optimization

**For Large Projects:**
- Increase timeouts for all servers
- Cache MCP responses where possible
- Use selective server activation

```json
{
  "mcp_servers": {
    "gpt-codex": { "timeout": 60000 },
    "playwright": { "timeout": 120000 },
    "sequential-thinking": { "timeout": 45000 }
  }
}
```

## Fallback Strategies

### If GPT-Codex is unavailable:
- Skip final external critique
- Rely on internal quality reviewer
- Manual code review recommended

### If Playwright is unavailable:
- Use manual testing checklist
- Screenshots via browser dev tools
- Reduced mobile testing coverage

### If Context7 is unavailable:
- Use WebFetch for documentation
- Manual library research
- Check official documentation sites

## Security Considerations

### Network Access
MCP servers may require internet access for:
- External API calls (Codex, Context7)
- Browser downloads (Playwright)
- Documentation fetching

### Data Privacy
- Code snippets sent to external servers (Codex)
- Screenshot data processed locally (Playwright)
- Library queries may be logged (Context7)

### Firewall Configuration
Ensure these domains are accessible:
- `*.anthropic.com` (Codex API)
- `*.github.com` (Context7 documentation)
- `*.playwright.dev` (Browser downloads)

## Alternative Configurations

### Minimal Setup (Core functionality only)
```json
{
  "mcp_servers": {
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

### Enterprise Setup (All servers with redundancy)
```json
{
  "mcp_servers": {
    "gpt-codex": { /* primary critique */ },
    "playwright": { /* primary browser */ },
    "puppeteer": { /* backup browser */ },
    "context7": { /* primary docs */ },
    "sequential-thinking": { /* reasoning */ },
    "ide": { /* diagnostics */ }
  }
}
```

This completes the MCP server documentation. All servers are now documented with installation, configuration, and troubleshooting information.