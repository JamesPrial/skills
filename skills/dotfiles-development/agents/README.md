# Agents for Personal Skills

## Agent Inventory

| Agent | Model | Purpose | File |
|-------|-------|---------|------|
| bash-script-architect | Haiku | Production bash scripting | 175 lines |
| bash-tdd-architect | inherit | TDD for bash scripts | - |
| devops-infra-lead | Sonnet | Infrastructure & CI/CD | - |
| gh-cli-expert | Sonnet | GitHub CLI & Actions | - |
| git-ops | Haiku | Git operations isolation | 12 lines |

## Agent-Skill Relationship

These agents are registered under `personal-skills` plugin and support `dotfiles-development` skill:

1. **Skill** (SKILL.md) teaches WHEN to use each agent
2. **Agents** (*.md) define HOW to execute specialized tasks
3. **Tests** verify skill guidance is accurate

## Usage Patterns

### Parallel Execution
When creating bash scripts, launch BOTH agents:
- `bash-script-architect` - writes implementation
- `bash-tdd-architect` - designs tests FIRST (before seeing implementation)

### Context Isolation
ALL git operations go through `git-ops` to keep git output separate from main conversation.

## Model Selection Rationale

| Agent | Model | Reason |
|-------|-------|--------|
| bash-script-architect | Haiku | Fast for well-defined scripting |
| git-ops | Haiku | Simple git operations |
| devops-infra-lead | Sonnet | Complex infrastructure reasoning |
| gh-cli-expert | Sonnet | Actions debugging needs analysis |
