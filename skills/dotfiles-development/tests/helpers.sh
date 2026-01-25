#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Helper functions for dotfiles skill tests
#######################################

#######################################
# Run a command with timeout (cross-platform)
# Falls back to running without timeout if unavailable.
#
# Args:
#   $1 - timeout in seconds
#   $@ - command and arguments to run
#
# Returns:
#   Exit code from the command (or 124 on timeout)
#######################################
run_with_timeout() {
  local timeout_secs="$1"
  shift

  if command -v timeout &>/dev/null; then
    timeout "$timeout_secs" "$@"
  elif command -v gtimeout &>/dev/null; then
    gtimeout "$timeout_secs" "$@"
  else
    # No timeout available, run without
    "$@"
  fi
}

# Color codes for output
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'

#######################################
# Print a PASS message with color
#######################################
pass() {
  echo -e "${COLOR_GREEN}✓ PASS${COLOR_RESET}: $*"
}

#######################################
# Print a FAIL message with color
#######################################
fail() {
  echo -e "${COLOR_RED}✗ FAIL${COLOR_RESET}: $*"
}

#######################################
# Print an INFO message with color
#######################################
info() {
  echo -e "${COLOR_YELLOW}ℹ INFO${COLOR_RESET}: $*"
}

#######################################
# Print a debug/section message
#######################################
section() {
  echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
  echo -e "${COLOR_BLUE}$*${COLOR_RESET}"
  echo -e "${COLOR_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOR_RESET}"
}

#######################################
# Run a test with RED and GREEN phases
#
# Args:
#   $1 - test_name: Name of the test
#   $2 - prompt: The prompt to send to Claude
#   $3 - expected_pattern: Regex pattern expected in GREEN output
#
# Returns:
#   0 if test passes, 1 if test fails
#######################################
run_test() {
  local test_name="$1"
  local prompt="$2"
  local expected_pattern="$3"

  section "Testing: $test_name"

  # Run GREEN phase (with skill access)
  info "Running GREEN phase (with skill access)..."

  local green_output
  green_output=$(
    run_with_timeout 60 claude --model haiku \
      --print \
      --allowedTools "Read,Glob,Grep,Skill" \
      -p "$prompt" 2>&1 || true
  )

  # Check if expected pattern is in GREEN output
  if echo "$green_output" | grep -qE "$expected_pattern"; then
    pass "$test_name"
    echo ""
    return 0
  else
    fail "$test_name"
    echo "Expected pattern: $expected_pattern"
    echo ""
    echo "GREEN output (first 30 lines):"
    echo "$green_output" | head -30
    echo ""
    return 1
  fi
}

#######################################
# Run a test with multiple acceptable patterns (OR logic)
#
# Args:
#   $1 - test_name: Name of the test
#   $2 - prompt: The prompt to send to Claude
#   $3+ - patterns: One or more regex patterns (passes if ANY match)
#
# Returns:
#   0 if any pattern matches, 1 if none match
#######################################
run_test_any() {
  local test_name="$1"
  local prompt="$2"
  shift 2
  local patterns=("$@")

  section "Testing: $test_name"

  info "Running GREEN phase (with skill access)..."

  local green_output
  green_output=$(
    run_with_timeout 60 claude --model haiku \
      --print \
      --allowedTools "Read,Glob,Grep,Skill" \
      -p "$prompt" 2>&1 || true
  )

  # Check if ANY expected pattern matches
  for pattern in "${patterns[@]}"; do
    if echo "$green_output" | grep -qE "$pattern"; then
      pass "$test_name"
      echo ""
      return 0
    fi
  done

  fail "$test_name"
  echo "Expected one of: ${patterns[*]}"
  echo ""
  echo "GREEN output (first 30 lines):"
  echo "$green_output" | head -30
  echo ""
  return 1
}

#######################################
# Run a test and show comparison
# Useful for manual inspection
#######################################
run_test_with_comparison() {
  local test_name="$1"
  local prompt="$2"
  local expected_pattern="$3"

  section "Testing: $test_name (with RED/GREEN comparison)"

  # Run RED phase (without skill)
  info "Running RED phase (without skill access)..."
  local red_output
  red_output=$(
    claude --model haiku \
      --print \
      --allowedTools "Read,Glob,Grep" \
      --disable-slash-commands \
      -p "$prompt" 2>&1 || true
  )

  # Run GREEN phase (with skill)
  info "Running GREEN phase (with skill access)..."
  local green_output
  green_output=$(
    claude --model haiku \
      --print \
      --allowedTools "Read,Glob,Grep,Skill" \
      -p "$prompt" 2>&1 || true
  )

  # Check if expected pattern is in GREEN output
  local test_passed=1
  if echo "$green_output" | grep -qE "$expected_pattern"; then
    test_passed=0
  fi

  # Display results
  if [[ $test_passed -eq 0 ]]; then
    pass "$test_name"
  else
    fail "$test_name"
    echo "Expected pattern: $expected_pattern"
  fi

  echo ""
  echo "------- RED PHASE OUTPUT (first 20 lines) -------"
  echo "$red_output" | head -20
  echo ""
  echo "------- GREEN PHASE OUTPUT (first 20 lines) -------"
  echo "$green_output" | head -20
  echo ""

  return $test_passed
}
