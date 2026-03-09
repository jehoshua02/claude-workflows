---
description: Create a feature plan from requirements
allowed-tools: Read, Write, Glob, ExitPlanMode
---

<instructions>
$ARGUMENTS
</instructions>

## Context Detection

Before proceeding, detect the current project context:
1. Read `~/.claude/projects.json`
2. Match the current working directory to a project entry
3. Extract the **project name** and **framework** for use below
4. Output: `**Project:** {name} ({framework})`
5. Read the project's `AGENTS.md` if it exists — these are non-negotiable constraints that must be considered during planning

If no match is found, use the current directory name as the project and "unknown" as the framework.

---

## Process

### 1. Scope Assessment

Before generating a full specification, assess the size of the change:

- **Small** (bug fix, config change, 1-3 files): Generate a minimal spec — just acceptance criteria, files to modify, and a one-line approach. Skip detailed architecture sections.
- **Medium** (new endpoint, moderate feature, 4-10 files): Generate the full spec template below.
- **Large** (new domain, 10+ files, cross-cutting): Generate the full spec template with multiple slice sections. Each slice should be a shippable increment that passes tests independently.

State the assessed scope: `**Scope:** small | medium | large`

#### Small Scope Template

For small scope changes, use this minimal template instead of the full template below:

# Project: [Name]
## Feature: [Name]

### Acceptance Criteria
- [ ] Given [...], when [...], then [...]

### Files to Modify
- `path/to/file` - [what changes]

### Approach
[One-line description of the fix/change]

### 2. Research and Requirements

1. Read any referenced project files
2. **Check for existing feature specs:** Glob `docs/features/**/*.md` in the project repo. If any existing specs relate to the planned feature (same domain, overlapping files, or extending existing behavior), read them and incorporate their business rules into the "Current Behavior" section. This prevents accidentally breaking or contradicting established behavior.
3. If the feature **modifies existing functionality**, explore the current codebase to document existing behavior, endpoints, and test coverage in the "Current Behavior" section before proposing changes
4. Fill in the requirements template below based on the instructions above
5. Ask clarifying questions if requirements are vague
6. Ensure business rules are specific and testable
7. Write acceptance criteria in Given/When/Then format from the end user's perspective
8. Identify edge cases the user may not have considered
9. Load the framework-specific coding standards skill and validate the technical approach against it:
   - **Laravel:** Read `/laravel-coding-standards` patterns (controllers, services, repositories, models, tests, migrations)
   - **Vue:** Read `/vue-coding-standards` patterns (when available)
   - **Angular:** Read `/angular-coding-standards` patterns (when available)
   The technical plan MUST comply with these patterns. Do not defer mandatory patterns (e.g., service extraction, repository usage) to "follow-up work."

### 3. Validate Against Project Standards

If the project's `AGENTS.md` was loaded, validate the proposed implementation plan against it. Flag any planned approach that would violate a documented standard.

### 4. Save and Signal

1. **MANDATORY: Save the plan file before completing.**
   - Location: `~/.claude/output/requirements/`
   - Naming: `{feature-slug}-{project-name}.md` (semantic, kebab-case)
   - Examples: `document-upload-api.md`, `user-auth-borrower-portal.md`
2. Do not write code. Only output the plan.
3. If the plan has multiple slices, tell the user: "This plan has N slices. Each `/workflow:implement-feature` invocation implements one slice = one PR."
4. **MANDATORY: Call `ExitPlanMode` immediately after saving the plan file.** This is NOT optional. The plan is not complete until `ExitPlanMode` has been called. Do not end the conversation or summarize without calling it first.
5. Tell the user they can proceed with `/workflow:implement-feature ~/.claude/output/requirements/{plan-file}.md`

---

## Requirements Template (Medium / Large Scope)

# Project: [Name]
## Feature: [Name]
## Slice: [Name or "N/A" for single-slice features]

---
## Functional Specification

> Human-owned. Changes here represent scope changes and should be flagged.

### Functional Requirements
- System shall [do X]
- System shall [validate X]
- System shall [handle X edge case]

### Business Rules
- [Rule 1: condition -> outcome]
- [Rule 2: constraint]

### Acceptance Criteria
Write from the end user's perspective. Describe what the user
experiences, not internal system behavior.

- [ ] Given [user context], when [user action], then [user-visible outcome]
- [ ] Given [user context], when [user action], then [user-visible outcome]

### Out of Scope
- [What this doesn't include]

### Current Behavior (for modifications only)
> Skip this section for greenfield features.
- Current endpoint/behavior: [describe what exists today]
- Files involved: [existing files that will be modified]
- Existing tests: [test files covering current behavior]

---
## Technical Plan

> Claude-proposed. May evolve during implementation without ceremony.
> Deviations from this section are expected and should be noted but don't require approval.

### Files to Create/Modify
- `path/to/file.php` - [purpose]
- `path/to/test.php` - [test coverage]

### Approach
[High-level implementation strategy and key technical decisions]

### Dependencies
- [External packages, services, or existing code to leverage]

### Risks & Considerations
- [Potential issues, edge cases requiring special attention, or areas needing human review]

### Slices (large scope only)

> For large-scope features, break the technical plan into ordered slices.
> Each slice must be independently shippable (tests pass, no broken state).
> For small/medium scope, omit this section — the plan is one implicit slice.

#### Slice 1: [Name]
**Acceptance Criteria for this slice:**
- [ ] Given [...], when [...], then [...]

**Files to Create/Modify:**
- `path/to/file` - [purpose]

#### Slice 2: [Name]
**Acceptance Criteria for this slice:**
- [ ] Given [...], when [...], then [...]

**Files to Create/Modify:**
- `path/to/file` - [purpose]

---
## Implementation Status

> Auto-updated by `update-requirements`, `implement-feature`, and `verify-feature`. Do not fill in during planning.

**Status:** PLANNED
**Last updated:** {date}
**Current slice:** {slice name or "N/A"}

### Progress
<!-- For single-slice plans: checked off as files are completed -->
<!-- For multi-slice plans: one entry per slice -->
- [ ] {For single-slice: from Files to Create/Modify}
- [ ] Slice 1: [Name] {For multi-slice plans}
- [ ] Slice 2: [Name]

### Deviations from Plan
None yet.

### Verification
- **Tests:** _not yet run_
- **Lint:** _not yet run_
- **Security:** _not yet run_
- **Acceptance criteria verified:** _not yet_

### Follow-up Work
None yet.
