#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Adding a new config to dotfiles
#
# This test verifies that the skill properly guides users through
# the three-step process of adding a new config:
# 1. Add the file
# 2. Update fix-perms.sh
# 3. Update install.sh or setup_symlinks
#
# Expected: Response mentions fix-perms.sh AND (install.sh OR setup_symlinks)
# Pattern: fix-perms
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="How would I add a new tmux config to this dotfiles repo? Just give me the steps."

# The pattern we expect to find in the skill's response
readonly EXPECTED_PATTERN="fix-perms"

# Run the test
run_test "Add Config" "$TEST_PROMPT" "$EXPECTED_PATTERN"
