# Task Complete Command - Production-Ready Feature Implementation

## Overview
This command orchestrates multiple specialized agents in a strict sequential workflow to ensure production-ready feature implementation with automatic context gathering and quality validation.

**Mission:** Every feature must be enterprise-grade, production-ready quality with comprehensive validation.

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

### Setup
Extract task name from $ARGUMENTS and create descriptive directory: `claude-tasks/{YYYY-MM-DD-HH-mm-ss}_{TASK_SLUG}/`

Where TASK_SLUG is derived from the task description (lowercase, alphanumeric only, max 30 chars, words separated by hyphens).

Examples:
- "Create invoice API" → `claude-tasks/2025-08-26-15-30-45_create-invoice-api/`
- "Fix button navigation issues" → `claude-tasks/2025-08-26-16-15-30_fix-button-navigation/`
- "Add user authentication" → `claude-tasks/2025-08-26-17-45-22_add-user-authentication/`

All agents will receive the full path to this directory and must save their outputs there.

### Enhanced Baseline Validation System
**CRITICAL:** Create comprehensive baseline measurements BEFORE any implementation begins:

```bash
# 1. Create baseline metrics before any changes
echo "📊 Capturing baseline validation metrics..."

npm run lint 2>&1 | tee {task_directory_path}/baseline-lint.log
LINT_EXIT_CODE=$?
npx tsc --noEmit 2>&1 | tee {task_directory_path}/baseline-typescript.log  
TS_EXIT_CODE=$?
npm run build 2>&1 | tee {task_directory_path}/baseline-build.log
BUILD_EXIT_CODE=$?

# 2. Extract precise error counts for delta comparison
BASELINE_LINT_ERRORS=$(grep -c "error\|Error" {task_directory_path}/baseline-lint.log || echo 0)
BASELINE_TS_ERRORS=$(grep -c "error TS" {task_directory_path}/baseline-typescript.log || echo 0)
BASELINE_BUILD_SUCCESS=$([ $BUILD_EXIT_CODE -eq 0 ] && echo "true" || echo "false")

# 3. Create comprehensive validation tracking file
cat > {task_directory_path}/validation-tracking.json << EOF
{
  "baseline": {
    "lint_errors": $BASELINE_LINT_ERRORS,
    "lint_exit_code": $LINT_EXIT_CODE,
    "typescript_errors": $BASELINE_TS_ERRORS,
    "typescript_exit_code": $TS_EXIT_CODE,
    "build_success": $BASELINE_BUILD_SUCCESS,
    "build_exit_code": $BUILD_EXIT_CODE,
    "captured_at": "$(date -Iseconds)"
  },
  "cycles": {},
  "final": {
    "lint_errors": null,
    "typescript_errors": null,
    "build_success": null,
    "captured_at": null
  },
  "validation_passed": false,
  "completion_percentage": 0,
  "dev_monitor_active": false
}
EOF

echo "✅ Baseline captured: Lint: $BASELINE_LINT_ERRORS errors, TypeScript: $BASELINE_TS_ERRORS errors, Build: $BASELINE_BUILD_SUCCESS"
```

**Validation Rules:**
- Implementation CANNOT introduce new lint errors (current ≤ baseline)
- Implementation CANNOT introduce new TypeScript errors (current ≤ baseline) 
- Build MUST succeed with same or better status than baseline
- All validation outputs MUST be captured to files for verification
- Dev monitor status MUST be "stable" before completion claims

## STEP 1: Context Gatherer Agent

**Agent:** `tc-context-gatherer`
**Mission:** Automatically gather ALL project context without manual intervention

Pass the task directory path to the agent which will analyze the complete codebase and create comprehensive context documentation at `{task_directory_path}/context.md`.

Wait for this agent to complete before proceeding.

---

## STEP 2: Task Planner Agent

**Agent:** `tc-task-planner`
**Mission:** Create detailed implementation plan based on context and task

Pass the task directory path and task description to the agent which will create a comprehensive implementation roadmap at `{task_directory_path}/plan.md`.

Wait for this agent to complete before proceeding.

---

## STEP 3-4: Implementation-Review Loop with Continuous Monitoring (Maximum 5 cycles)

### STEP 3A: Development Server Monitor (PARALLEL EXECUTION) - **NOW ACTIVE**

**Agent:** `tc-dev-monitor`
**Mission:** Continuous real-time monitoring of development server during implementation

**CRITICAL**: Launch this agent FIRST and run in parallel with implementation. This agent:
- Starts your dev server (e.g., `npm run dev`, `yarn dev`, etc.) in background and monitors for runtime errors
- Creates `{task_directory_path}/dev-status.json` for real-time error reporting  
- Detects build failures, TypeScript errors, runtime crashes immediately
- Provides early warning system preventing false completion claims
- Creates `{task_directory_path}/dev-output.log` for comprehensive error tracking
- Runs until implementation completes or 45 minutes maximum

**Dev Monitor Requirements:**
- Must create dev-status.json with real-time status updates
- Must log all errors and warnings with timestamps
- Must detect compilation failures immediately
- Implementation agent CANNOT claim completion without "stable" status

### STEP 3B: Implementation Agent (PARALLEL WITH MONITOR)

**Agent:** `tc-implementation-agent`
**Mission:** Implement the feature completely according to plan with continuous validation

Pass the task directory path and cycle number to the agent which will implement the feature with enterprise quality standards.

**ENHANCED REQUIREMENTS:**
- MUST check `{task_directory_path}/dev-status.json` before claiming completion
- CANNOT mark work complete if dev monitor reports active errors
- MUST address any runtime errors detected by monitor during development
- MUST capture actual command output for lint, TypeScript, and build validation
- MUST update `{task_directory_path}/validation-tracking.json` with real metrics
- MUST verify no regressions from baseline measurements

**QUALITY GATES** (All must pass - NO EXCEPTIONS):
1. Dev monitor status shows "stable" (no active runtime errors)
2. Current lint errors ≤ baseline lint errors (no regressions allowed)
3. Current TypeScript errors ≤ baseline TypeScript errors (no regressions allowed)
4. Build command succeeds WITHOUT validation disabled
5. All manual testing scenarios verified
6. validation-tracking.json shows validation_passed: true

### STEP 4: Enhanced Quality Reviewer Agent  

**Agent:** `tc-quality-reviewer`
**Mission:** Independent verification of all implementation claims

Pass the task directory path and cycle number to the agent which will:
- **Independently verify** all claims from implementation agent
- Run its own lint, TypeScript, and build commands to confirm results
- Check dev monitor logs for any errors during implementation
- Verify dev server is running without errors
- Require screenshot evidence of working features
- Compare before/after metrics (lint error count, TypeScript error count)

**ENHANCED LOOP LOGIC:** If reviewer finds issues and cycle < 5, return to Step 3. If cycle = 5 or approved, proceed to Step 5.

**COMPLETION TRACKING:** Each cycle must track completion percentage. If >90% complete after cycle 5, allow continuation to Step 5 with conditional approval.

**VALIDATION CHECKPOINTS:**
- Baseline capture before implementation (existing error counts)
- Delta comparison after implementation (no new errors allowed)
- Dev monitor log review (no unresolved errors during development)
- Independent command execution (no reliance on implementation agent claims)

---

## STEP 5: Frontend Tester Agent

**Agent:** `tc-frontend-tester`
**Mission:** Comprehensive UI/UX testing with Playwright

Pass the task directory path to the agent which will conduct comprehensive UI/UX testing using Playwright, including cross-device validation, performance testing, and screenshot capture.

**Test Credentials:** [Configure for your project]
**Quality Gate:** Feature must score 8/10+ to proceed to final critique.

Wait for testing to complete before proceeding.

---

## STEP 6: Codex Critic Agent

**Agent:** `tc-codex-critic`
**Mission:** Final critique using Codex MCP for external validation

Pass the task directory path to the agent which will use Codex MCP to provide independent external validation of the implementation quality, market readiness, and competitive positioning.

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

**Task Directory:** `claude-tasks/{YYYY-MM-DD-HH-mm-ss}_{TASK_SLUG}/`

---

**Usage Examples:**
- `/task_complete "Create user authentication API"`
- `/task_complete "Fix responsive navigation issues"`
- `/task_complete "Add real-time notifications"`

**Required:** Task description must be provided via $ARGUMENTS

Problem: $ARGUMENTS