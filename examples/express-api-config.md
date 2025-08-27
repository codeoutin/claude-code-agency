# Express API Project Configuration

Example configuration for Node.js Express API projects.

## Package.json Scripts

```json
{
  "scripts": {
    "dev": "nodemon src/server.ts",
    "build": "tsc && copyfiles -u 1 src/**/*.json dist/",
    "start": "node dist/server.js",
    "lint": "eslint src --ext .ts",
    "type-check": "tsc --noEmit"
  }
}
```

## Test Credentials Configuration

Update `agents/tc-frontend-tester.md` (for API testing):

```markdown
### 2. API Testing Configuration
**Test API Endpoint**: http://localhost:3001
**Test Database**: test_db
**Admin Credentials**:
- Email: `admin@api.com`
- Password: `AdminPass123!`
```

## Quality Standards

Update `agents/tc-quality-reviewer.md`:

```markdown
### Performance Requirements
- API response time < 200ms
- Database queries optimized
- No memory leaks in long-running processes
- Graceful error handling

### Security Checks
- Input validation on all endpoints
- Authentication middleware present
- No sensitive data in logs
- CORS properly configured
```

## Codex Critique Context

Update `agents/tc-codex-critic.md`:

```markdown
## Platform Context
RESTful API backend serving web and mobile clients.

**Technology Stack:**
- Node.js with Express.js framework + TypeScript
- PostgreSQL database with TypeORM/Prisma
- JWT authentication with bcrypt
- Redis for caching and sessions
- Target: Scalable, secure API backend
```