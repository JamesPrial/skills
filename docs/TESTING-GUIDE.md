# Testing Guide for Skills

This guide shows how to add a comprehensive test suite to Claude Code skills, following the proven pattern from `dotfiles-development`.

## When to Add Tests

Tests are valuable when a skill:
- Has complex decision trees (agent selection, workflow branches)
- Teaches domain-specific knowledge that must be accurate
- Provides guidance that could become stale
- Has multiple interconnected concepts

## Test Architecture

The dotfiles-development skill demonstrates a 3-tier architecture:

```
tests/
├── helpers.sh          # Reusable test utilities (tier 1)
├── run_tests.sh        # Test orchestrator (tier 2)
├── test_*.sh           # Individual test cases (tier 3)
├── README.md           # Test documentation
└── MANIFEST.md         # File inventory
```

## Tier 1: helpers.sh

Provides reusable functions for all tests:

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Color codes
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'

pass() { echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: $*"; }
fail() { echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: $*"; }
info() { echo -e "${COLOR_YELLOW}ℹ INFO${COLOR_RESET}: $*"; }
section() {
  echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
  echo -e "${COLOR_BLUE}$*${COLOR_RESET}"
  echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
}

run_test() {
  local test_name="$1"
  local prompt="$2"
  local expected_pattern="$3"

  section "Testing: $test_name"
  info "Running GREEN phase (with skill access)..."

  local green_output
  green_output=$(claude --model haiku --print --allowedTools "Read,Glob,Grep,Skill" -p "$prompt" 2>&1 || true)

  if echo "$green_output" | grep -qE "$expected_pattern"; then
    pass "$test_name"
    return 0
  else
    fail "$test_name"
    echo "Expected pattern: $expected_pattern"
    echo "First 30 lines:"
    echo "$green_output" | head -30
    return 1
  fi
}
```

## Tier 2: run_tests.sh

Discovers and runs all test_*.sh scripts, collects results, reports summary:

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/helpers.sh"

section "My Skill - Test Suite"

# Discover all test scripts
test_scripts=($(find "$SCRIPT_DIR" -name "test_*.sh" -type f | sort))

passed=0
failed=0

for test_script in "${test_scripts[@]}"; do
  if bash "$test_script"; then
    ((passed++))
  else
    ((failed++))
  fi
done

section "Test Summary"
echo "Total: $((passed + failed)) | Passed: $passed | Failed: $failed"

[[ $failed -eq 0 ]] && exit 0 || exit 1
```

## Tier 3: Individual Tests (test_*.sh)

Each test verifies a specific aspect of the skill:

```bash
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/helpers.sh"

run_test "Concept Being Tested" \
  "Question that tests this concept" \
  "regex-pattern-to-find"
```

## Test Development Workflow

### 1. Identify Testable Concepts

For each skill, list critical concepts that must be accurate:
- Agent selection recommendations
- Multi-step workflows
- File locations or paths
- Configuration values
- Decision trees

### 2. Write Test Cases

For each concept, create a test_*.sh file with:
- A natural language prompt a user would ask
- A regex pattern that should appear in the response

### 3. Run Tests Locally

```bash
chmod 700 tests/*.sh
./tests/run_tests.sh
```

### 4. Document Tests

Create `tests/README.md` with:
- Overview of test structure
- Description of each test case
- How to run tests
- Troubleshooting guide

## GREEN vs RED Testing

The testing pattern uses two phases:

**GREEN Phase** (with skill access):
```bash
claude --model haiku --print --allowedTools "Read,Glob,Grep,Skill" -p "PROMPT"
```

**RED Phase** (without skill - for comparison):
```bash
claude --model haiku --print --allowedTools "Read,Glob,Grep" --disable-slash-commands -p "PROMPT"
```

This validates that the SKILL provides correct guidance, not just that Claude answers correctly.

## CI/CD Integration

Add to `.github/workflows/test.yml`:

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'skills/my-skill/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Make scripts executable
        run: chmod +x ./skills/my-skill/tests/*.sh
      - name: Run tests
        run: ./skills/my-skill/tests/run_tests.sh
```

## File Permissions

All executable files use `chmod 700` (owner rwx, no group/other access).

## Troubleshooting

### Tests hang or timeout
- Ensure `-p` flag is used with complete prompt
- Ensure `--print` is specified to avoid interactive mode

### Pattern not found
1. Verify skill file exists
2. Check pattern is case-insensitive if needed
3. Run test script directly to see full output

### Claude CLI not found
```bash
which claude  # Verify in PATH
```

## Reference Implementation

See `skills/dotfiles-development/tests/` for a complete, production-ready test suite.
