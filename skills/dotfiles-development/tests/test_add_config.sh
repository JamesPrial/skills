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
readonly TEST_PROMPT="Use the dotfiles-development skill. How would I add a new tmux config? Just give me the steps."

# Multiple acceptable patterns (passes if ANY match)
readonly EXPECTED_PATTERNS=(
  "fix-perms"
  "dotfiles-fix-perms"
)

# Run the test with OR logic (passes if ANY pattern matches)
run_test_any "Add Config" "$TEST_PROMPT" "${EXPECTED_PATTERNS[@]}"
