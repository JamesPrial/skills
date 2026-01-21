#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#######################################
# Test suite runner for dotfiles-development skill
#
# This script runs all test cases and reports overall results.
# Each test verifies that the Claude Code skill correctly guides
# Claude on various aspects of dotfiles repository management.
#
# Usage: ./run_tests.sh
#
# Exit codes:
#   0 - All tests passed
#   1 - One or more tests failed
#######################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helper functions
source "${SCRIPT_DIR}/helpers.sh"

# Array to track test results
declare -a test_results=()
declare -a test_names=()

#######################################
# Run a single test file and capture result
#######################################
run_single_test() {
  local test_file="$1"
  local test_name
  test_name=$(basename "$test_file" .sh)

  test_names+=("$test_name")

  # Run the test script
  if bash "$test_file"; then
    test_results+=(0)
  else
    test_results+=(1)
  fi
}

#######################################
# Main test execution
#######################################
main() {
  section "Dotfiles Development Skill - Test Suite"

  # Get all test scripts
  local test_scripts=(
    "${SCRIPT_DIR}/test_add_config.sh"
    "${SCRIPT_DIR}/test_agent_git.sh"
    "${SCRIPT_DIR}/test_agent_script.sh"
    "${SCRIPT_DIR}/test_symlink.sh"
    "${SCRIPT_DIR}/test_permissions.sh"
  )

  # Run each test
  for test_script in "${test_scripts[@]}"; do
    if [[ -f "$test_script" ]]; then
      run_single_test "$test_script"
    else
      fail "Test script not found: $test_script"
      test_names+=("$(basename "$test_script" .sh)")
      test_results+=(1)
    fi
  done

  # Calculate results
  local total_tests=${#test_results[@]}
  local passed_tests=0
  for result in "${test_results[@]}"; do
    if [[ $result -eq 0 ]]; then
      ((passed_tests++)) || true
    fi
  done
  local failed_tests=$((total_tests - passed_tests))

  # Display summary
  section "Test Summary"

  echo ""
  echo "Total Tests: $total_tests"
  echo "Passed: $passed_tests"
  echo "Failed: $failed_tests"
  echo ""

  # Show detailed results
  for i in "${!test_names[@]}"; do
    if [[ ${test_results[$i]} -eq 0 ]]; then
      pass "${test_names[$i]}"
    else
      fail "${test_names[$i]}"
    fi
  done

  echo ""

  # Exit with appropriate code
  if [[ $failed_tests -eq 0 ]]; then
    section "All tests passed!"
    return 0
  else
    section "Some tests failed. Please review the output above."
    return 1
  fi
}

# Run main function
main "$@"
