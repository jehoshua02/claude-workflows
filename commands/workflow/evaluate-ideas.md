---
description: Evaluate collected ideas against criteria, scoring each for value and effort. Use after collect-ideas.
allowed-tools: Read, Write, Edit, Glob, Grep, Agent
---

<instructions>
$ARGUMENTS
</instructions>

## Purpose

Evaluate a set of collected ideas against defined criteria. Score each idea for value and effort, update individual idea files with evaluations, and generate a ranked summary table. This is the second step in the ideation workflow.

---

## Process

### 1. Load Ideas

1. Read all `.md` files in the folder specified by `$ARGUMENTS` (excluding README.md)
2. Parse each idea file for: title, attribution, description, problem statement
3. Count total ideas and announce: `**Evaluating {N} ideas from {folder}**`

### 2. Load Evaluation Criteria

1. Look for a `REQUIREMENTS.md` in:
   - The ideas folder itself
   - The parent folder of the ideas folder
2. If found, extract the evaluation criteria (scoring guidelines, constraints, compatibility requirements)
3. If not found, use default criteria:
   - **Value (1-5):** How much impact does this idea have?
   - **Effort (1-5):** How much work is required to build it?

### 3. Evaluate Each Idea

For each idea file, append an evaluation section:

```markdown
## {N}.3 Requirement Compatibility

| Criterion | Compatible? | Notes |
|---|---|---|
| {criterion from REQUIREMENTS.md} | Yes/No/Partial | {brief justification} |

**Criteria Met: {X}/{total}**

## {N}.4 Value & Effort

- **Value: {X}/5** — {one-line justification}
- **Effort: {X}/5** — {one-line justification}
```

**Scoring guidelines:**
- Be honest about compatibility — don't inflate scores
- Value should reflect real-world impact, not just technical impressiveness
- Effort should account for complexity, risk, dependencies, and time constraints
- Use the section numbering from the existing idea file (e.g., if idea is #3, sections are 3.3, 3.4)

### 4. Generate Summary Table

Create or update `README.md` in the ideas folder:

```markdown
# Ideas Evaluation Summary

## 1. Evaluation Criteria

{If REQUIREMENTS.md was found, summarize the criteria here}
{If using defaults, state: "Default value/effort scoring (no REQUIREMENTS.md found)"}

## 2. Summary Table

| # | Idea | Attribution | Criteria Met | Value | Effort | Net Score |
|---|------|-------------|:---:|:---:|:---:|:---:|
| 1 | {title} | {name} | {X/Y} | {V} | {E} | {CriteriaMet + Value - Effort} |

## 3. Key Observations

### 3.1 Top Tier
{Ideas with highest net scores — brief note on why they score well}

### 3.2 Notable Trade-offs
{Ideas with high value but high effort, or good criteria fit but low value}
```

### 5. Summary

Print the summary table and announce:

```
**Evaluation complete.** {N} ideas scored.

### Next Steps
Run `/workflow:select-idea {folder path}` to collect team picks and make a final selection.
```
