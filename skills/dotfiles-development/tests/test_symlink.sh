#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test: Symlink architecture understanding
#
# This test verifies that the skill correctly teaches users
# about the symlink architecture - specifically that the actual
# files live in .dotfiles/, not in ~/, and users should edit
# the files in the repo, not the symlinked versions.
#
# Expected: Response mentions .dotfiles/zshrc
# Pattern: \.dotfiles/zshrc
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# The test prompt
readonly TEST_PROMPT="Where is the actual zshrc file I should edit in this dotfiles repo?"

# The pattern we expect to find in the skill's response
# Escape the dot to match it literally
readonly EXPECTED_PATTERN="\.dotfiles/zshrc"

# Run the test
run_test "Symlink Architecture" "$TEST_PROMPT" "$EXPECTED_PATTERN"
