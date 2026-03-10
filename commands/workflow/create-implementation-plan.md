---
description: Create a detailed implementation plan with code units, inputs/outputs, dependencies, and test cases from a scope doc.
allowed-tools: Read, Write, Edit, Glob, Grep, Agent
---

<instructions>
$ARGUMENTS
</instructions>

## Context Detection

Detect ALL relevant project contexts:

1. Read `~/.claude/projects.json`
2. Match the current working directory AND all additional workspace directories to project entries
3. For each matched project, extract:
   - **Project name** and **framework**
   - **AGENTS.md** constraints (if exists)
4. Output all detected projects:
   ```
   **Workspace Projects:**
   - {name} ({framework}) — {path}
   - {name} ({framework}) — {path}
   ```
5. After reading the scope doc, determine which projects are relevant to this feature
6. Output: `**Relevant Projects:** {list}`

Features may span multiple projects (e.g., API + bank-service + pipeline). Code units must be tagged with their target project.

---

## Process

### 1. Load Scope

1. Read the scope doc referenced in `$ARGUMENTS`
2. Extract: problem statement, knowns, unknowns, in-scope items, out-of-scope items
3. If a `REQUIREMENTS.md` exists in the same folder or parent, read it for additional context

### 2. Research Codebase

Launch Explore agent(s) to understand the existing codebase across relevant projects:

1. **Existing patterns:** How does each project solve similar problems? What patterns, base classes, services, and utilities exist that should be reused?
2. **Integration points:** How do the projects communicate? What APIs, events, jobs, or shared databases connect them?
3. **Test patterns:** How are similar features tested in each project? What test utilities, factories, and base classes exist?

Summarize findings before proceeding.

### 3. Define Code Units

Break the feature into discrete code units. A code unit is a single class, function, migration, config change, etc.

**Test files are NOT separate code units.** Each code unit includes a `Test Cases` section — the corresponding test file is created implicitly during implementation. Do not list test files as standalone units.

For each code unit, document:

```markdown
### 3.{slice}.{unit} {UnitName}

**Project:** {project name}
**Type:** {Controller | Service | Repository | Model | Migration | Job | Policy | Resource | Config | Route | Component | etc.}
**File:** `{path/to/file}`

**Purpose:** {One sentence — what this unit does}

**Inputs:**
- {parameter/dependency}: {type} — {description}

**Outputs:**
- {return type} — {description}

**Dependencies:**
- {ExistingClass}: {why it's needed}
- {ExternalService}: {what it provides}

**Side Effects:**
- {Database writes, events dispatched, jobs queued, external API calls, etc.}
- {None if pure function}

**Test Cases:**
- {Given X, when Y, then Z}
- {Given edge case, when Y, then Z}
- {Given invalid input, when Y, then expected error}
```

### 4. Organize into Slices

Group code units into logical, independently shippable slices:

```markdown
## 3.1 Slice 1: {Name}

{Brief description — what this slice delivers}

### 3.1.1 {FirstCodeUnit}
...
### 3.1.2 {SecondCodeUnit}
...

## 3.2 Slice 2: {Name}

### 3.2.1 {FirstCodeUnit}
...
```

**Numbering:** Use fully qualified section numbers. Code units under Slice 1 (section 3.1) are numbered 3.1.1, 3.1.2, etc. Code units under Slice 2 (section 3.2) are numbered 3.2.1, 3.2.2, etc.

**Slice principles:**
- Each slice should be independently testable and deployable
- Earlier slices should not depend on later slices
- Core infrastructure and models come first, UI/integration last
- Each slice should deliver visible value (not just scaffolding)
- For multi-project features, a slice may span projects but should minimize cross-project dependencies within a single slice
- Note which project each code unit belongs to

### 5. Write IMPLEMENTATION.md

Save the implementation plan to `IMPLEMENTATION.md` in the same folder as the scope doc:

```markdown
# Implementation Plan: {Feature Name}

## 1. Overview

**Relevant Projects:**
- {name} ({framework}) — {role in this feature}

**Scope doc:** {link to SCOPE.md}
**Total slices:** {N}
**Total code units:** {N}

## 2. Codebase Research Summary

### 2.1 Existing Patterns to Reuse
- {Pattern}: `{project}:{file path}` — {how it applies}

### 2.2 Integration Points
- {Project A → Project B}: {how they communicate, what interface exists}

### 2.3 Test Infrastructure
- {project}: {Base class/factory}: `{file path}` — {what it provides}

## 3. Slices

### 3.1 Slice 1: {Name}
{code units with project tags...}

### 3.2 Slice 2: {Name}
{code units with project tags...}

## 4. Open Questions

- {Any remaining unknowns that need answers before implementation}
```

### 6. Summary

Print:

```
## Implementation Plan Created

**File:** {path to IMPLEMENTATION.md}
**Projects:** {list of relevant projects}
**Slices:** {N}
**Code units:** {N}

### Next Steps
1. Review the plan with your team
2. Run `/workflow:implement-feature {IMPLEMENTATION.md path}` to begin building slice by slice
```

---

## Rules

- Use structured numbering throughout (1.1, 1.2, 2.1, etc.)
- Every code unit must have all fields filled in (no "TBD" or empty sections)
- Every code unit must be tagged with its project
- Test cases should cover happy path, edge cases, and error cases
- Reference existing code by project and file path — don't reinvent what exists
- If a project's `AGENTS.md` defines patterns (e.g., SecureController, SOA jobs), every code unit in that project must comply
- Keep descriptions concise — this is a reference doc, not prose
