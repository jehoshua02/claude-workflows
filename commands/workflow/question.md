---
description: Investigate a question and document findings with evidence, observations, and conclusions.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent, AskUserQuestion
---

<instructions>
$ARGUMENTS
</instructions>

## Purpose

Capture and investigate a question, documenting the research process — evidence gathered, observations made, and conclusions drawn — in a structured markdown file for future reference.

---

## Process

### 1. Clarify Question and Output Location

1.1. If `$ARGUMENTS` contains a clear question, use it and skip to 1.3
1.2. Otherwise, ask the user: "What question are you investigating?" using AskUserQuestion
1.3. Ask where to save the question file using AskUserQuestion:
   - Option: `~/.claude/memory/questions/` — persists across sessions, accessible to Claude's memory
   - Option: `./questions/` — saved in the current working directory
   - Option: "Other (I'll specify)"
1.4. Create the folder if it doesn't exist

### 2. Create the Question File

2.1. Generate a slug from the question (lowercase, hyphenated, max ~6 words)
2.2. Create the file with name: `{YYYY-MM-DD}_{HH-mm}_{slug}.md`
   - Example: `2026-03-11_14-30_api-cron-execution-rates.md`
2.3. Write the initial template:

```markdown
# {Question}

**Date:** {YYYY-MM-DD HH:mm}
**Tags:** {suggest tags based on the question and confirm with user — e.g., deployment, api, data-analysis, architecture}
**Research depth:** shallow | moderate | thorough

## 1. Question

{The full question being investigated}

## 2. Relevant Information

## 3. Queries

## 4. Observations

## 5. Conclusion

```

### 3. Investigate

3.1. Use `$ARGUMENTS` and the question context to determine the appropriate research approach (codebase search, Snowflake queries, web search, log analysis, etc.). If the investigation path is unclear, ask the user for guidance.
3.2. As findings are gathered, update the **Relevant Information** section with numbered sub-sections:
   - Use fully qualified numbering: `### 2.1 {Finding title}`, `### 2.2 {Finding title}`, etc.
   - Each finding should include the evidence (SQL query + results, code snippet + file path, link, data table, etc.)
   - Sub-findings within a finding use deeper numbering: `#### 2.1.1`, `#### 2.1.2`, etc.
3.3. If the investigation involves data queries (SQL, API calls, log searches, etc.), add reusable queries to the **Queries** section (`### 3.1 {Query title}`, etc.):
   - Add a brief description of what the query finds and its use case (replay, monitoring, dashboards)
   - Use fenced code blocks with the appropriate language tag (e.g., ```sql)
   - Parameterize where sensible (e.g., time windows) and add comments explaining non-obvious filters
3.4. Update **Observations** (`### 4.1`, `### 4.2`, etc.) with patterns, anomalies, or insights as they emerge. Reference findings by number (e.g., "Based on 2.1 and 2.3...").
3.5. Update the file after each meaningful finding so progress is preserved if the session ends. Replace placeholder sections entirely — do not leave empty sections alongside content.
3.6. Aim for at least 2-3 distinct findings before moving to review. After each pass, update the **Research depth** field:
   - `shallow` — 1-2 findings, single data source, surface-level
   - `moderate` — 3-5 findings, multiple sources or angles
   - `thorough` — 6+ findings, cross-referenced, edge cases explored

### 4. Review with User

4.1. Present a brief summary of findings so far, including the current research depth
4.2. Ask the user using AskUserQuestion:
   - Option: "Looks good, wrap it up"
   - Option: "Go deeper" — make another investigation pass, exploring new angles, cross-referencing existing findings, and adding new sub-sections. Then return to this step.
   - Option: "I have additional context to add"
   - Option: "Investigate a specific direction" (ask what)
4.3. If the user wants more investigation, repeat step 3 — append new findings with the next sequential number (e.g., if the first pass ended at 2.3, the next pass starts at 2.4)

### 5. Conclude

5.1. Synthesize observations into a conclusion
5.2. Update the **Conclusion** section (`### 5.1`, `### 5.2`, etc.) with:
   - A direct answer to the question
   - Confidence level (high / medium / low)
   - Any caveats or open threads
   - If research was cut short, note what areas remain unexplored under `### 5.x Open threads`
5.3. If the file was saved to `~/.claude/memory/questions/`, check for a `MEMORY.md` in the same memory directory:
   - If `MEMORY.md` doesn't exist, create it with a `## Questions` section
   - If it exists but has no `## Questions` section, add one
   - Append a reference: `- [{slug}](questions/{filename}) — {one-line summary of conclusion}`
5.4. Copy the file path to the clipboard (e.g., `echo -n "{path}" | pbcopy`) and print the file path and a brief summary to the user
