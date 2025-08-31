# Task Complete Command - Production-Ready Feature Implementation

## Overview
This command orchestrates multiple specialized agents in a strict sequential workflow to ensure production-ready feature implementation with automatic context gathering and quality validation.

**Mission:** Every feature must be enterprise-grade, paid-feature quality with perfect design/branding alignment.

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

### Setup
**AUTOMATIC TASK DIRECTORY CREATION:**

```bash
# 1. Generate task directory name from $ARGUMENTS
TASK_DESCRIPTION="$ARGUMENTS"
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# 2. Generate intelligent task summary for folder name
TASK_SUMMARY=$(echo "$TASK_DESCRIPTION" | claude --model claude-3-haiku-20240307 --prompt "
Summarize this task description into 2-4 words that capture the main feature/work being done. 
Use format like: 'invoice-redesign', 'timer-system', 'auth-fixes', 'ui-improvements', etc.
Only return the summary, nothing else.

Task: $TASK_DESCRIPTION
")

# Clean up the summary and create slug
TASK_SLUG=$(echo "$TASK_SUMMARY" | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/[^a-z0-9 -]//g' | \
  tr -s ' ' | \
  tr ' ' '-' | \
  sed 's/^-\|-$//g')

# 3. Create full directory path in project folder
TASK_DIRECTORY="./claude-tasks/${TIMESTAMP}_${TASK_SLUG}"
mkdir -p "$TASK_DIRECTORY"

echo "📁 Created task directory: $TASK_DIRECTORY"
echo "📝 Task: $TASK_DESCRIPTION"
```

**Examples:**
- "Create invoice API" → `claude-tasks/2025-08-26-15-30-45_create-invoice-api/`
- "Fix button navigation issues" → `claude-tasks/2025-08-26-16-15-30_fix-button-navigation/`
- "Add user authentication" → `claude-tasks/2025-08-26-17-45-22_add-user-authentication/`

**Variable:** `$TASK_DIRECTORY` contains the full path for all subsequent agents.

### Enhanced Baseline Validation System
**CRITICAL:** Context gatherer will capture baseline validation state using MCP diagnostics before implementation begins.

This creates `$TASK_DIRECTORY/validation-tracking.json` with:
- Current diagnostic state via MCP
- Build validation using pre-approved commands (npm run build, lint, tsc)
- Baseline metrics for comparison

**Validation Rules:**
- Implementation CANNOT introduce new lint errors (current ≤ baseline)
- Implementation CANNOT introduce new TypeScript errors (current ≤ baseline) 
- Build MUST succeed with same or better status than baseline
- All validation outputs MUST be captured to files for verification

## STEP 1: Context Gatherer Agent

**Agent:** `tc-context-gatherer`
**Mission:** Automatically gather ALL project context without manual intervention

Pass `$TASK_DIRECTORY` to the agent which will analyze the complete codebase and create comprehensive context documentation at `$TASK_DIRECTORY/context.md`.

Wait for this agent to complete before proceeding.

---

## STEP 2: Task Planner Agent

**Agent:** `tc-task-planner`
**Mission:** Create detailed implementation plan based on context and task

Pass `$TASK_DIRECTORY` and `$TASK_DESCRIPTION` to the agent which will create a comprehensive implementation roadmap at `$TASK_DIRECTORY/plan.md`.

Wait for this agent to complete before proceeding.

---

## STEP 3-4: Implementation-Review Loop (Maximum 5 cycles)

### STEP 3: Implementation Agent

**Agent:** `tc-implementation-agent`
**Mission:** Implement the feature completely according to plan with continuous validation

Pass `$TASK_DIRECTORY` and cycle number to the agent which will implement the feature with enterprise quality standards.

**ENHANCED REQUIREMENTS:**
- MUST capture actual command output for lint, TypeScript, and build validation
- MUST update `$TASK_DIRECTORY/validation-tracking.json` with real metrics
- MUST verify no regressions from baseline measurements

**QUALITY GATES** (All must pass - NO EXCEPTIONS):
1. Current lint errors ≤ baseline lint errors (no regressions allowed)
2. Current TypeScript errors ≤ baseline TypeScript errors (no regressions allowed)
3. `npm run build` succeeds WITHOUT validation disabled
4. All manual testing scenarios verified
5. validation-tracking.json shows validation_passed: true

### STEP 4: Enhanced Quality Reviewer Agent  

**Agent:** `tc-quality-reviewer`
**Mission:** Independent verification of all implementation claims

Pass `$TASK_DIRECTORY` and cycle number to the agent which will:
- **Independently verify** all claims from implementation agent
- Use MCP diagnostics to confirm results
- Require screenshot evidence of working features
- Compare before/after metrics (lint error count, TypeScript error count)

**ENHANCED LOOP LOGIC:** If reviewer finds issues and cycle < 5, return to Step 3. If cycle = 5 or approved, proceed to Step 5.

**COMPLETION TRACKING:** Each cycle must track completion percentage. If >90% complete after cycle 5, allow continuation to Step 5 with conditional approval.

**VALIDATION CHECKPOINTS:**
- Baseline capture before implementation (existing error counts)
- Delta comparison after implementation (no new errors allowed)
- Independent validation via MCP diagnostics (no reliance on implementation agent claims)

---

## STEP 5: Frontend Tester Agent

**Agent:** `tc-frontend-tester`
**Mission:** Comprehensive UI/UX testing with Playwright

Pass `$TASK_DIRECTORY` to the agent which will conduct comprehensive UI/UX testing using Playwright, including cross-device validation, performance testing, and screenshot capture.

**Test Credentials:** [Configure for your project]
**Quality Gate:** Feature must score 8/10+ to proceed to final critique.

Wait for testing to complete before proceeding.

---

## STEP 6: Codex Critic Agent

**Agent:** `tc-codex-critic`
**Mission:** Final critique using Codex MCP for external validation

Pass `$TASK_DIRECTORY` to the agent which will use Codex MCP to provide independent external validation of the implementation quality, market readiness, and competitive positioning.

---

## FINAL PRESENTATION

After all agents complete, present to user:

1. **Task Summary:** What was implemented
2. **Quality Report:** All validation results
3. **Screenshots:** Visual proof of implementation
4. **Codex Critique:** External validation
5. **Project Status:** Updated completion status
6. **Next Steps:** Recommendations for follow-up

## Task Detection

**Task Input:** Use $ARGUMENTS as task description (required).

**Context Understanding:** Your project documentation provides current project state and development context for informed implementation decisions.

**Task Directory:** Automatically created as `$TASK_DIRECTORY`

---

**Usage:**
- `/task_complete "Create user authentication API"`
- `/task_complete "Fix responsive navigation issues"`
- `/task_complete "Add real-time notifications"`

**Required:** Task description must be provided via $ARGUMENTS

Problem: $ARGUMENTS