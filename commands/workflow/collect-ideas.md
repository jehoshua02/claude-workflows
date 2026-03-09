---
description: Collect ideas from team members and AI for a feature or project decision. Use when brainstorming before planning.
allowed-tools: Read, Write, Glob, Grep, Agent, AskUserQuestion
---

<instructions>
$ARGUMENTS
</instructions>

## Purpose

Collect ideas from team members and AI, saving each as a structured markdown file with attribution. This is the first step in the ideation workflow, before evaluation and selection.

---

## Process

### 1. Setup

1. Determine the output folder:
   - If `$ARGUMENTS` contains a folder path, use that
   - Otherwise, ask the user where to save ideas (suggest `docs/features/{feature}/ideas/`)
2. Create the output folder if it doesn't exist
3. Check for existing idea files in the folder — if found, announce them and ask if we're adding more or starting fresh

### 2. Identify Contributors

Ask the user: "Who are the contributors for this brainstorm?" using AskUserQuestion.
- Provide options for common team sizes (e.g., "Just me", "Me + 1 other", "Me + 2 others", or "Other")
- For each contributor, get their name

### 3. Collect Ideas from Each Contributor

For each contributor:

1. Ask: "{Name}, what ideas do you have?" using AskUserQuestion
   - Option: "I'll type my ideas" (user provides in text)
   - Option: "Skip for now" (contributor will add later)
2. For each idea provided, create a markdown file:

**Filename:** `{contributor-slug}-{idea-slug}.md` (e.g., `stephen-bank-data-indicator.md`)

**Template:**
```markdown
# {N}. {Idea Title}

**Attribution:** {Contributor Name}

## {N}.1 Description

{Description of the idea — what it does, how it works}

## {N}.2 Problem It Solves

{What problem or pain point this addresses}
```

3. Number ideas sequentially across all contributors (not per-contributor)
4. If a contributor provides multiple ideas in one response, create separate files for each

### 4. Contribute AI Ideas

1. Launch an Explore agent to analyze the codebase for opportunities:
   - Existing pain points (TODOs, complex files, repeated patterns)
   - Areas where AI could add value
   - Gaps in tooling or developer experience
2. Generate 2-3 AI ideas based on findings
3. Save each with `**Attribution:** AI (Claude)`

### 5. Summary

Print a summary of all collected ideas:

```
## Ideas Collected

| # | Idea | Attribution |
|---|------|-------------|
| 1 | {title} | {name} |
| 2 | {title} | {name} |
...

**Total:** {N} ideas from {M} contributors
**Saved to:** {folder path}

### Next Steps
Run `/workflow:evaluate-ideas {folder path}` to score and rank these ideas.
```
