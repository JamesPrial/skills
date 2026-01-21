# Dotfiles Development Skill - Test Suite

This directory contains a comprehensive test suite for the `dotfiles-development` Claude Code skill. The tests verify that the skill correctly guides Claude on best practices for working with the dotfiles repository.

## Overview

The test suite consists of:

1. **Helper functions** (`helpers.sh`) - Shared utilities for running tests
2. **Individual test scripts** - Five separate tests covering different aspects of the skill
3. **Test runner** (`run_tests.sh`) - Orchestrates all tests and reports results

## Test Cases

### 1. `test_add_config.sh` - Adding a New Config

Tests that the skill correctly guides users through the three-step process of adding a new config file:

- **Prompt**: "How would I add a new tmux config to this dotfiles repo? Just give me the steps."
- **Expected**: Response mentions `fix-perms.sh`
- **Validates**: Users are guided to update the fix-perms.sh script when adding new configs

### 2. `test_agent_git.sh` - Git Operations Agent Selection

Tests that the skill recommends the correct agent for git operations:

- **Prompt**: "I need to commit my changes in this dotfiles repo. What agent should I use?"
- **Expected**: Response mentions `git-ops`
- **Validates**: Users are directed to the git-ops agent for version control tasks

### 3. `test_agent_script.sh` - Script Writing Agent Selection

Tests that the skill recommends the correct agent for writing shell scripts:

- **Prompt**: "I need to write a new shell script for this repo. What agent should I use?"
- **Expected**: Response mentions `bash-script-architect`
- **Validates**: Users are directed to the bash-script-architect agent for writing shell scripts

### 4. `test_symlink.sh` - Symlink Architecture Understanding

Tests that the skill correctly explains the symlink structure:

- **Prompt**: "Where is the actual zshrc file I should edit in this dotfiles repo?"
- **Expected**: Response mentions `.dotfiles/zshrc`
- **Validates**: Users understand that source files are in `.dotfiles/`, not in home directory

### 5. `test_permissions.sh` - Permission Model

Tests that the skill teaches the correct permission model:

- **Prompt**: "What permissions should config files have in this dotfiles repo?"
- **Expected**: Response mentions `600`
- **Validates**: Users understand the 600 (owner read/write) permission model for config files

## Running the Tests

### Run All Tests

Execute the test runner to run all five tests:

```bash
./run_tests.sh
```

This will:
- Run each test in sequence
- Display progress for each test
- Show a summary of passed/failed tests
- Exit with code 0 if all tests pass, 1 if any fail

### Run a Single Test

Each test script is standalone and can be run individually:

```bash
./test_add_config.sh
./test_agent_git.sh
./test_agent_script.sh
./test_symlink.sh
./test_permissions.sh
```

## Test Mechanics

### GREEN vs RED Phases

Each test runs Claude in two modes:

**GREEN Phase** (with skill access):
```bash
claude --model haiku \
  --print \
  --allowedTools "Read,Glob,Grep,Skill" \
  -p "PROMPT"
```

**RED Phase** (without skill access):
```bash
claude --model haiku \
  --print \
  --allowedTools "Read,Glob,Grep" \
  --disable-slash-commands \
  -p "PROMPT"
```

The tests verify that the GREEN phase (with skill) produces responses containing expected patterns that indicate the skill is being invoked and providing correct guidance.

### Pattern Matching

Each test checks for a specific regex pattern in the GREEN output:

- `fix-perms` - Add Config test
- `git-ops` - Git Operations test
- `bash-script-architect` - Script Writing test
- `\.dotfiles/zshrc` - Symlink Architecture test
- `600` - Permission Model test

If the pattern is found, the test passes. Otherwise, it fails and displays the first 30 lines of the response for debugging.

## Output Format

Tests use color-coded output:

- **✓ PASS** (Green) - Test passed
- **✗ FAIL** (Red) - Test failed
- **ℹ INFO** (Yellow) - Informational messages
- **Section headers** (Blue) - Test section dividers

Example output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dotfiles Development Skill - Test Suite
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Testing: Add Config
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ INFO: Running GREEN phase (with skill access)...
✓ PASS: Add Config

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Test Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Tests: 5
Passed: 5
Failed: 0

✓ PASS: test_add_config
✓ PASS: test_agent_git
✓ PASS: test_agent_script
✓ PASS: test_symlink
✓ PASS: test_permissions

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
All tests passed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Requirements

- `claude` CLI tool must be available in PATH
- Must be run from a dotfiles repository directory
- Bash 4.0+
- Standard Unix utilities: grep, echo, basename

## Troubleshooting

### Tests hang or timeout

If a test hangs, the Claude CLI may be waiting for input. Ensure the `-p` flag is used with the complete prompt, and that `--print` is specified to avoid interactive mode.

### Pattern not found in output

If a test fails because the expected pattern isn't found:

1. Check that the skill file (`.claude/skills/dotfiles-development/SKILL.md`) exists
2. Verify the skill content teaches the expected topics
3. Run the test script directly to see the full response
4. Check for case-sensitivity in regex patterns

### Claude CLI not found

Ensure the `claude` command is installed and in your PATH:

```bash
which claude
```

## Extending the Tests

To add a new test:

1. Create a new test script (e.g., `test_new_feature.sh`)
2. Source the helpers: `source "${SCRIPT_DIR}/helpers.sh"`
3. Define the prompt and expected pattern
4. Call `run_test "Test Name" "prompt" "pattern"`
5. Make it executable: `chmod 700 test_new_feature.sh`
6. Add the test to `run_tests.sh` in the `test_scripts` array

## Helper Functions

The `helpers.sh` file provides reusable functions:

- `pass()` - Print a passing test message
- `fail()` - Print a failing test message
- `info()` - Print an informational message
- `section()` - Print a section header
- `run_test()` - Run a test and check for a pattern
- `run_test_with_comparison()` - Run a test and show both RED and GREEN output

## Development Notes

- Tests are designed to be run from the dotfiles repository root
- Each test is independent and can be run in any order
- The test runner collects results and reports them together
- Color output can be disabled by piping through `cat` (strips ANSI codes)

## Exit Codes

- `0` - All tests passed
- `1` - One or more tests failed

Test scripts use these codes, making them suitable for CI/CD integration.
