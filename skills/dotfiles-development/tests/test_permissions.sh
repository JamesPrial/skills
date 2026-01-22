#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Permission model understanding
#
# This test verifies that the skill correctly teaches users
# about the dotfiles permission model: 600 for configs,
# 700 for scripts/directories.
#
# Expected: Response mentions 600 for config files
# Pattern: 600
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="What permissions should config files have in this dotfiles repo?"

# The pattern we expect to find in the skill's response
readonly EXPECTED_PATTERN="600"

# Run the test
run_test "Permission Model" "$TEST_PROMPT" "$EXPECTED_PATTERN"
