---
description: TDD a code unit from a spec. Strict RED/GREEN/REFACTOR cycle with user review at every step.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent, AskUserQuestion, TodoWrite
---

<instructions>
$ARGUMENTS
</instructions>

## Context Detection

1. Read `~/.claude/projects.json`
2. Match the current working directory to a project entry
3. Extract the project's **test command** and **testFilter command** — these are used for all test runs
4. If no project matches, ask the user for the test command before proceeding

---

## Process

### 1. Load Spec

1. Read the spec section referenced in `$ARGUMENTS`
2. Read existing production code and test files related to the unit
3. Extract:
   - **Inputs** and **outputs** of the unit
   - **Side effects**
   - **Dependencies**
   - **Testing expectations** (the list of behaviors to verify)

### 2. Determine Test Type

Decide whether this is a **unit test** or **integration test** (both use `StatelessTestCase`):

- **Unit test:** The subject has dependencies that can be mocked (models, services, repositories). All dependencies are mocked. The subject should resolve dependencies via constructor injection or `resolve()` so they're mockable.
- **Integration test:** The subject's core behavior IS database interaction (repositories, queries, migrations). Real database, factories, no mocks.

### 3. Build Plan

- Build a todo list from the spec's testing expectations — one item per test case
- Present the plan (including test type decision) to the user
- Wait for confirmation before starting

### 4. RED/GREEN/REFACTOR Cycle

Process **one test at a time**, never batch.

**All pause points use AskUserQuestion with multiple-choice options. Never ask open-ended questions.**

**Labeling:** Use clear headers so the user always knows where they are:
- Format text output as: `### RED — Test N/M: <test name>` or `### GREEN — Test N/M: <test name>`
- AskUserQuestion `header` field: `"N/M RED"` or `"N/M GREEN"` (short, fits 12-char limit)

#### RED
1. Write the minimal test code to get a failure
2. Run the test and show the failure output
3. Pause — ask with options like "Write production code", "Change the test first"

#### GREEN
4. Write the minimal production code to make the test pass
5. Run the test and show the green output
6. If the test was already green (characterization test), note this — no new production code needed
7. Pause — ask with options like "Looks good, next test", "I have a refactor idea"

#### REFACTOR
8. If user wants refactoring, make changes and re-run tests to confirm still green
9. Move to the next test after user approval

### 5. Completion

After all tests pass:
1. Run the full test file to confirm everything passes together
2. Run any related test files to confirm no regressions
3. Mark the todo list complete
4. Print summary:

```
## TDD Complete

**Test file:** {path}
**Production file:** {path}
**Tests:** {N} passing

### Next Steps
- Review the changes
- Run `/commit` to commit
```

---

## Test Style

Follow these conventions for all tests:

- **No static mocks** — no `Mockery::mock('alias:...')`
- **No `#[RunInSeparateProcess]`** — ever
- **Arrange / Act / Assert** blocks with descriptive intent comments:

```php
// Arrange: borrower with an active deal and one unpublished application
...

// Act: query for unpublished applications for this borrower
...

// Assert: returns the one unpublished application
...
```

Comments describe the *intent*, not just label the section.

### Test Class Groups

Every test class MUST have exactly 3 `#[Group(...)]` attributes:
1. **Owner/team** — `#[Group(OwnerEnum::Transactions->value)]` (use the SOA owner enum)
2. **Feature** — `#[Group('FeatureOcrolusEncore')]` (feature flag or epic name)
3. **Class** — `#[Group('LenderApplicationPublishOneJob')]` (the class under test)

### Unit Tests
- File location: `tests/Unit/` (mirror production path, e.g., `tests/Unit/Jobs/`)
- Use `StatelessTestCase`
- All dependencies MUST be mocked
- Use `$this->mock(ClassName::class)` to mock and bind in container (preferred for `resolve()`-based deps)
- Use constructor injection for direct constructor deps
- Fast, isolated, no database side effects

### Integration Tests
- File location: `tests/Integration/` (mirror production path, e.g., `tests/Integration/Repositories/`)
- Use `StatelessTestCase`
- Real database queries; factories CAN be used (not mandatory)
- Use `resolve(ClassName::class)` to get instances from the container

---

## Rules

- One test at a time. Never skip ahead.
- Always run the test after writing it. Never assume it will pass or fail.
- Pause for user review at every RED, GREEN, and REFACTOR step.
- Mark todo items complete as each test passes.
- If a test is already green (characterization test), acknowledge it and still do the REFACTOR step.
- Keep production code minimal — only write what's needed to pass the current test.
- Do not add features, comments, or improvements beyond what the current test demands.
