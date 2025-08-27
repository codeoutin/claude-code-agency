# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

[Your project description - replace with your actual project details]

**Key Design Principles:**
- [Your core design principles]
- [Key user experience goals]  
- [Technical constraints or requirements]

## Task Completion Standards
- NEVER mark a task as complete until:
  - All code is written and integrated
  - All imports and dependencies are resolved
  - The feature runs without errors in dev environment
  - No broken references remain
  - Solution is production-ready, not a proof of concept
- Always pause for testing feedback on significant changes
- Use great npm packages and tools if available instead of coding from scratch
- Ask for architectural decisions rather than assuming

## Development Commands

```bash
# Development server
npm run dev

# Production build  
npm run build

# Start production server
npm start

# Linting
npm run lint

# Type checking
npm run type-check

# Database operations (if using Prisma)
npx prisma generate    # Generate Prisma client
npx prisma db push     # Push schema to database (development)
npx prisma migrate dev # Create and apply migration
npx prisma studio      # Database GUI

# Testing (if applicable)
npm test
npm run test:watch
```

## Architecture Overview

### Tech Stack
- **Frontend:** [Your frontend stack - e.g., React 18 + TypeScript + Vite]
- **Backend:** [Your backend - e.g., Express.js + TypeScript]
- **Database:** [Your database - e.g., PostgreSQL with Prisma ORM]
- **Auth:** [Your auth solution - e.g., NextAuth.js]
- **Styling:** [Your styling - e.g., Tailwind CSS + shadcn/ui]

### Core Data Model
[Describe your main entities and relationships]

```
User
├── Projects
├── Tasks
└── [Your core entities]

Project  
├── Tasks
├── Members
└── [Related entities]
```

### API Structure
[Describe your API organization]
Located in `[your-api-directory]`:
- `users.ts` - User management
- `projects.ts` - Project CRUD operations
- `[your-routes].ts` - [Description]

### File Upload System (if applicable)
[Describe file handling patterns]
- Drag and drop support
- File validation and processing
- Storage integration

### Authentication Context
[Describe auth patterns]
- Session management
- Route protection
- User context

## Development Workflows

### Database Setup
1. [Your database setup steps]
2. [Environment configuration]
3. [Migration commands]

### Adding New Features
- [Your feature development patterns]
- [Code organization rules]
- [Testing requirements]

### Common Patterns
- **Error Handling:** [Your error handling approach]
- **State Management:** [Your state management patterns]
- **Data Fetching:** [Your data fetching patterns]
- **Form Handling:** [Your form patterns]

### Testing
[Your testing approach and commands]

## Environment Variables

Required for development:
```bash
# Database
DATABASE_URL=

# Authentication
AUTH_SECRET=
# [Your auth provider variables]

# External Services
# [Your API keys and external service configs]
```

## File Structure Notes

- `src/` - Source code
- `components/` - Reusable components
- `pages/` or `app/` - Application pages/routes
- `lib/` - Utility functions and configurations
- `[your-directories]/` - [Description]

## Development Workflow & Project Management

### Always Reference These Files First:
1. **PROJECT_STATUS.md** - Update completed tasks and track progress here
2. **PROJECT_DESCRIPTION.md** - Reference when continuing work to understand what we're building
3. When completing tasks, always update PROJECT_STATUS.md to reflect new completion status
4. Add suggestions and improvements encountered during development to PROJECT_STATUS.md

### User-Centered Design Approach:
- **Target Users**: [Your target users]
- **Core Pain Points**: 
  - [User problem 1]
  - [User problem 2]
  - [User problem 3]
- **Design Principle**: [Your core UX principle]

### UX/UI Flow Considerations:
- [Your UX patterns and guidelines]
- [Interaction patterns to follow]
- [Performance considerations]

## Known Architecture Decisions

- [Decision 1] - [Reasoning]
- [Decision 2] - [Reasoning]
- [Decision 3] - [Reasoning]