#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Correct agent selection for TDD workflow
#
# This test verifies that the skill correctly recommends
# the bash-tdd-architect agent (alongside bash-script-architect)
# for creating new bash scripts in the dotfiles repo.
#
# Expected: Response mentions bash-tdd-architect
# Pattern: bash-tdd-architect
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="I need to create a new bash script for this repo. What agents should I use?"

# The pattern we expect to find in the skill's response
readonly EXPECTED_PATTERN="bash-tdd-architect"

# Run the test
run_test "Agent Selection - TDD Workflow" "$TEST_PROMPT" "$EXPECTED_PATTERN"
