# Skills Repository

Curated Claude Code skills plugin repository forked from anthropics/skills with personal workflow additions.

## Quick Reference

### Plugin Installation
```bash
/plugin marketplace add /path/to/skills
/plugin install personal-skills@skills-by-james
```

### Testing
```bash
./skills/dotfiles-development/tests/run_tests.sh
```

## Repository Structure

| Plugin | Skills | Purpose | Source |
|--------|--------|---------|--------|
| **document-skills** (4) | xlsx, docx, pptx, pdf | Document processing | Anthropic |
| **example-skills** (12) | skill-creator, mcp-builder, etc. | Development examples | Anthropic |
| **personal-skills** (1 + 5 agents) | dotfiles-development + agents | Personal workflow | James Prial |

### Content Ownership
- **Anthropic-owned**: document-skills, example-skills, spec/, template/ (protected by CI)
- **Personal**: personal-skills plugin (safe to modify)

## Agents Overview

| Agent | Model | Purpose |
|-------|-------|---------|
| **bash-script-architect** | Haiku | Production bash scripting with defensive programming |
| **bash-tdd-architect** | inherit | TDD for bash - runs IN PARALLEL with bash-script-architect |
| **devops-infra-lead** | Sonnet | Infrastructure, CI/CD, GitHub Actions |
| **gh-cli-expert** | Sonnet | GitHub CLI, PR management, workflow debugging |
| **git-ops** | Haiku | Git operations isolation |

### Agent Selection Pattern
```
Git operation? → git-ops (Haiku)
GitHub/Actions? → gh-cli-expert (Sonnet)
Writing script? → bash-script-architect + bash-tdd-architect (parallel)
Infrastructure? → devops-infra-lead (Sonnet)
```

## Skills with Tests

### dotfiles-development
- **Location**: `skills/dotfiles-development/tests/`
- **Tests**: 6 test cases (agent selection, symlinks, permissions)
- **CI**: `.github/workflows/test.yml`

## Adding New Skills

1. Create `skills/my-skill/SKILL.md`
2. Register in `.claude-plugin/marketplace.json` under appropriate plugin
3. Add tests following `skills/dotfiles-development/tests/` pattern
4. Update CI if tests added

## Quick Commands

```bash
# View marketplace
cat .claude-plugin/marketplace.json

# Run tests
./skills/dotfiles-development/tests/run_tests.sh

# Find skills without tests
find skills/ -mindepth 1 -maxdepth 1 -type d ! -exec test -d {}/tests \; -print
```

## Related Documentation

- `agents/README.md` - Agent inventory and usage patterns
- `docs/TESTING-GUIDE.md` - How to add tests to skills
- `../claude-plugins/version-control/` - Related version-control plugin with gh-cli and github-actions-writer skills
