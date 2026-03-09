---
description: Collect team picks and finalize idea selection. Use after evaluate-ideas.
allowed-tools: Read, Write, Glob, AskUserQuestion
---

<instructions>
$ARGUMENTS
</instructions>

## Purpose

Facilitate team selection of an idea from a set of evaluated ideas. Collect individual picks with reasoning, generate an AI recommendation, and record the final consensus decision. This is the third step in the ideation workflow.

---

## Process

### 1. Load Context

1. Read the `README.md` summary table from the folder specified by `$ARGUMENTS`
2. Read all idea files to understand each option
3. Identify contributors from the idea files (unique attribution values)
4. Create a `pick/` subfolder in the ideas folder (or its parent, matching folder structure)

### 2. Collect Team Picks

For each contributor identified in step 1:

1. Present the summary table with scores
2. Use AskUserQuestion: "{Name}, which idea do you pick and why?"
   - Options: list each idea by title (top-scored first)
   - Allow "Other" for write-in responses
3. Save their pick to `pick/{NAME}.md`:

```markdown
# {Name}'s Pick

## 1. Choice

**{Idea title}** (#{idea number})

## 2. Reasoning

{Their stated reasoning}
```

If a contributor is not available, ask the user to relay their pick or skip them.

### 3. AI Recommendation

Generate `pick/AI.md` with the AI's recommendation:

```markdown
# AI's Pick

## 1. Choice

**{Idea title}** (#{idea number})

## 2. Reasoning

{2-3 concise reasons based on:}
- Criteria compatibility scores
- Value-to-effort ratio
- Risk and feasibility for the given context
- Synergies between ideas (if recommending a combination)
```

### 4. Final Decision

1. Present all picks (team + AI) to the user
2. Use AskUserQuestion: "What's the final decision?"
   - Options: each unique pick from the team, plus "Other"
3. Save to `pick/FINAL.md`:

```markdown
# Final Pick

## 1. Decision

**{Idea title}** (#{idea number})
{Note if unanimous or majority}

## 2. Strategy

{Brief description of how to approach this}

## 3. Next Steps

- Write scope doc
- Create implementation plan
```

### 5. Summary

Print:

```
## Idea Selected: {title}

**Picks:** {who picked what}
**Decision:** {unanimous/majority/tiebreaker}

### Next Steps
1. Write a scope doc for {title}
2. Run `/workflow:create-implementation-plan {scope-doc-path}` to generate the implementation plan
```
