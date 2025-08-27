# React + Vite Project Configuration

Example configuration for React projects using Vite build tool.

## Package.json Scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
    "preview": "vite preview",
    "type-check": "tsc --noEmit"
  }
}
```

## Test Credentials Configuration

Update `agents/tc-frontend-tester.md`:

```markdown
### 2. Testing Credentials
**Primary Test Account:**
- Email: `demo@yourapp.com`
- Password: `DemoPassword123!`

**Test URL**: http://localhost:5173
```

## Quality Standards

Update `agents/tc-quality-reviewer.md`:

```markdown
### Performance Requirements
- Vite build completes without warnings
- Bundle size < 500KB (main chunk)
- Hot reload < 500ms

### React Specific Checks
- No React warnings in console
- Proper React hooks usage
- Component props properly typed
- No memory leaks in useEffect
```

## Codex Critique Context

Update `agents/tc-codex-critic.md`:

```markdown
## Platform Context
Single-page application with modern React patterns.

**Technology Stack:**
- React 18 with TypeScript and Vite
- React Router for client-side routing
- Styled Components / CSS Modules for styling
- Axios for API communication
- Target: Fast, responsive user interface
```