# Test Suite Manifest

Complete test suite for the dotfiles-development Claude Code skill, created at `/Users/jamesprial/code/dotfiles/.claude/skills/dotfiles-development/tests/`

## Files Created

### Core Files

#### 1. `helpers.sh` (3,880 bytes, chmod 700)
**Purpose**: Shared helper functions and utilities for all tests

**Contains**:
- Color code constants (GREEN, RED, YELLOW, BLUE)
- `pass()` - Print passing test messages with green checkmark
- `fail()` - Print failing test messages with red X
- `info()` - Print informational messages in yellow
- `section()` - Print formatted section headers in blue
- `run_test()` - Core test execution function that:
  - Sends prompt to Claude with skill access (GREEN phase)
  - Checks output for expected regex pattern
  - Reports pass/fail with colored output
  - Shows first 30 lines of output on failure
- `run_test_with_comparison()` - Extended test function that shows RED and GREEN output for manual inspection

**Used By**: All test scripts and the test runner

---

#### 2. `run_tests.sh` (2,660 bytes, chmod 700)
**Purpose**: Main test orchestration and reporting

**Functionality**:
- Discovers all test scripts in the directory
- Executes each test sequentially
- Collects pass/fail results
- Calculates statistics (total, passed, failed)
- Displays formatted summary report
- Returns exit code 0 (all pass) or 1 (any failure)

**Output**:
- Formatted section headers
- Individual test results with pass/fail status
- Summary statistics
- Overall result indicator

**Exit Codes**:
- 0: All tests passed
- 1: One or more tests failed

---

### Test Scripts

#### 3. `test_add_config.sh` (934 bytes, chmod 700)
**Test Name**: Add Config

**Tests**: Adding a new config file to the dotfiles repo

**Prompt**: "How would I add a new tmux config to this dotfiles repo? Just give me the steps."

**Expected Pattern**: `fix-perms`

**What It Validates**:
- Skill guides users through three-step process
- Users understand they must update fix-perms.sh when adding new files
- Response mentions the permission fixing step

---

#### 4. `test_agent_git.sh` (829 bytes, chmod 700)
**Test Name**: Agent Selection - Git

**Tests**: Correct agent recommendation for git operations

**Prompt**: "I need to commit my changes in this dotfiles repo. What agent should I use?"

**Expected Pattern**: `git-ops`

**What It Validates**:
- Skill correctly identifies git-related tasks
- Users are directed to the git-ops agent
- Agent selection guidance is accurate

---

#### 5. `test_agent_script.sh` (901 bytes, chmod 700)
**Test Name**: Agent Selection - Script Writing

**Tests**: Correct agent recommendation for shell script development

**Prompt**: "I need to write a new shell script for this repo. What agent should I use?"

**Expected Pattern**: `bash-script-architect`

**What It Validates**:
- Skill correctly identifies script writing tasks
- Users are directed to the bash-script-architect agent
- Appropriate agent is suggested for infrastructure code

---

#### 6. `test_symlink.sh` (994 bytes, chmod 700)
**Test Name**: Symlink Architecture

**Tests**: Understanding of symlink-based file structure

**Prompt**: "Where is the actual zshrc file I should edit in this dotfiles repo?"

**Expected Pattern**: `\.dotfiles/zshrc`

**What It Validates**:
- Skill explains symlink architecture correctly
- Users understand source files are in `.dotfiles/`
- Users know to edit files in the repo, not symlinked versions
- Architecture model is clearly communicated

---

#### 7. `test_permissions.sh` (832 bytes, chmod 700)
**Test Name**: Permission Model

**Tests**: Understanding of the dotfiles permission scheme

**Prompt**: "What permissions should config files have in this dotfiles repo?"

**Expected Pattern**: `600`

**What It Validates**:
- Skill teaches correct permission model
- Users understand 600 (owner read/write) for config files
- Users know 700 (owner rwx) for scripts/directories
- Permission enforcement expectations are clear

---

#### 8. `test_agent_tdd.sh` (700 bytes, chmod 700)
**Test Name**: Agent Selection - TDD Workflow

**Tests**: Correct agent recommendation for TDD with bash scripts

**Prompt**: "I need to create a new bash script for this repo. What agents should I use?"

**Expected Pattern**: `bash-tdd-architect`

**What It Validates**:
- Skill correctly identifies that script creation requires TDD approach
- Users are directed to use bash-tdd-architect alongside bash-script-architect
- Parallel agent execution pattern is communicated
- TDD workflow is recommended for new scripts

---

### Documentation Files

#### 8. `README.md`
**Purpose**: Comprehensive test suite documentation

**Contains**:
- Overview of test structure
- Detailed explanation of each test case
- Usage instructions (running all or individual tests)
- Test mechanics explanation (GREEN vs RED phases)
- Pattern matching details
- Output format examples
- Requirements and dependencies
- Troubleshooting guide
- Instructions for extending tests
- Helper function reference
- Development notes
- Exit code documentation

---

#### 9. `MANIFEST.md` (this file)
**Purpose**: Complete inventory of all created files

**Contains**:
- Summary of what was created
- Purpose and contents of each file
- File sizes and permissions
- Test case descriptions
- Relationship between files

---

## Directory Structure

```
.claude/skills/dotfiles-development/tests/
├── README.md                    # Complete documentation
├── MANIFEST.md                  # This file
├── helpers.sh                   # Shared helper functions
├── run_tests.sh                 # Main test runner
├── test_add_config.sh           # Test: Adding configs
├── test_agent_git.sh            # Test: Git agent selection
├── test_agent_script.sh         # Test: Script agent selection
├── test_agent_tdd.sh            # Test: TDD workflow agent selection
├── test_symlink.sh              # Test: Symlink architecture
└── test_permissions.sh          # Test: Permission model
```

## Quick Start

### Run all tests:
```bash
cd /Users/jamesprial/code/dotfiles/.claude/skills/dotfiles-development/tests
./run_tests.sh
```

### Run a specific test:
```bash
./test_add_config.sh
```

## File Statistics

| File | Size | Type | Purpose |
|------|------|------|---------|
| helpers.sh | 3,880 B | Script | Shared functions |
| run_tests.sh | 2,660 B | Script | Test orchestration |
| test_add_config.sh | 934 B | Script | Test case |
| test_agent_git.sh | 829 B | Script | Test case |
| test_agent_script.sh | 901 B | Script | Test case |
| test_agent_tdd.sh | ~700 B | Script | Test case |
| test_symlink.sh | 994 B | Script | Test case |
| test_permissions.sh | 832 B | Script | Test case |
| README.md | ~5 KB | Docs | Full documentation |
| MANIFEST.md | ~3 KB | Docs | This inventory |

**Total**: 9 executable scripts + 2 documentation files = 11 files

## Permissions Model

All files follow the dotfiles repository standards:
- Executable scripts: `chmod 700` (owner rwx, no group/other access)
- Documentation files: Standard markdown (readable)

## Dependencies

The test suite requires:
- Bash 4.0 or higher
- `claude` CLI tool in PATH
- Standard Unix utilities: grep, echo, basename, find
- Read/Glob/Grep tools accessible to Claude

## How Tests Work

1. **Test Execution Flow**:
   - run_tests.sh reads all test_*.sh scripts
   - For each test, bash executes the script
   - Test script sources helpers.sh
   - Test script calls run_test() with prompt and expected pattern
   - run_test() executes Claude with skill access (GREEN phase)
   - Output is checked for expected pattern
   - Result (pass/fail) is returned

2. **Result Collection**:
   - run_tests.sh collects exit codes from each test
   - Exit code 0 = test passed, 1 = test failed
   - Statistics are calculated and displayed
   - Final exit code: 0 if all pass, 1 if any fail

3. **Output Reporting**:
   - Color-coded messages for clarity
   - Formatted section headers
   - Individual test results
   - Summary statistics
   - Diagnostic output on failure

## Integration Notes

The test suite is designed for:
- **Manual testing**: Run ./run_tests.sh locally during development
- **CI/CD integration**: Exit codes allow integration into automated pipelines
- **Debugging**: Individual test scripts can be run and their output inspected
- **Maintenance**: Helper functions centralize common logic for easy updates

## Future Extensions

The framework supports adding new tests by:
1. Creating a new test_*.sh script
2. Sourcing helpers.sh
3. Calling run_test() with appropriate prompt and pattern
4. Making it executable (chmod 700)
5. Adding to run_tests.sh's test_scripts array

The modular design allows for:
- Adding more test cases without modifying core infrastructure
- Creating specialized test variants (e.g., run_test_with_comparison)
- Extending helper functions for additional test types
