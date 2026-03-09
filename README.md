# Claude Workflows

Shared Claude Code workflow commands for the ideation-to-implementation lifecycle.

## Commands

| Command | Description |
|---------|-------------|
| `/workflow:collect-ideas` | Collect ideas from team members and AI with attribution |
| `/workflow:evaluate-ideas` | Score ideas against criteria, generate ranked summary |
| `/workflow:select-idea` | Collect team picks, AI recommendation, finalize selection |
| `/workflow:create-implementation-plan` | Detailed code-unit-level implementation plan from a scope doc |

These extend the existing planning workflow:

```
collect-ideas → evaluate-ideas → select-idea → create-implementation-plan → plan-feature → implement-feature → ...
```

## Install

```bash
git clone git@github.com:LendioDevs/claude-workflows.git ~/dev/lendio-infra/repositories/claude-workflows
~/dev/lendio-infra/repositories/claude-workflows/install.sh
```

## Update

```bash
cd ~/dev/lendio-infra/repositories/claude-workflows && git pull
```

Commands are symlinked, so `git pull` updates them everywhere automatically.
