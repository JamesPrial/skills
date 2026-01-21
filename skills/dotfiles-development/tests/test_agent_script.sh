#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Correct agent selection for script writing
#
# This test verifies that the skill correctly recommends
# the bash-script-architect agent for writing shell scripts
# in the dotfiles repo.
#
# Expected: Response mentions bash-script-architect
# Pattern: bash-script-architect
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="I need to write a new shell script for this repo. What agent should I use?"

# The pattern we expect to find in the skill's response
readonly EXPECTED_PATTERN="bash-script-architect"

# Run the test
run_test "Agent Selection - Script Writing" "$TEST_PROMPT" "$EXPECTED_PATTERN"
