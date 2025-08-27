# Next.js Project Configuration

Example configuration for Next.js projects with TypeScript.

## Package.json Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build", 
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  }
}
```

## Test Credentials Configuration

Update `agents/tc-frontend-tester.md`:

```markdown
### 2. Testing Credentials
**Primary Test Account:**
- Email: `test@yourapp.com`
- Password: `TestPassword123!`

**Test URL**: http://localhost:3000
```

## Quality Standards

Update `agents/tc-quality-reviewer.md`:

```markdown
### Performance Requirements
- Next.js build completes successfully
- Page load time < 2 seconds
- Lighthouse score > 85

### Next.js Specific Checks
- No runtime errors in browser console
- Server-side rendering works correctly
- API routes respond within 500ms
- Image optimization properly configured
```

## Codex Critique Context

Update `agents/tc-codex-critic.md`:

```markdown
## Platform Context
Modern web application built with enterprise-grade architecture.

**Technology Stack:**
- Next.js 14 with App Router + TypeScript
- Tailwind CSS for styling with shadcn/ui components
- PostgreSQL database with Prisma ORM
- NextAuth.js for authentication
- Target: Professional SaaS application quality
```