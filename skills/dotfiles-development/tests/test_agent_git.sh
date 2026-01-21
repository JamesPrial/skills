#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Correct agent selection for git operations
#
# This test verifies that the skill correctly recommends
# the git-ops agent for git-related tasks in the dotfiles repo.
#
# Expected: Response mentions git-ops
# Pattern: git-ops
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="I need to commit my changes in this dotfiles repo. What agent should I use?"

# The pattern we expect to find in the skill's response
readonly EXPECTED_PATTERN="git-ops"

# Run the test
run_test "Agent Selection - Git" "$TEST_PROMPT" "$EXPECTED_PATTERN"
