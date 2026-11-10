#!/usr/bin/env bash
# ==============================================================================
# Script: .harness/test-runner.sh
# Purpose: Master test runner and assertion library for automated smoke,
#          contract, and regression testing across arbitrary projects.
# Usage:   ./.harness/test-runner.sh [suite_name | test_function_name]
#
# Examples:
#   ./.harness/test-runner.sh                 # Run all test suites
#   ./.harness/test-runner.sh runtime         # Run runtime health checks only
#   ./.harness/test-runner.sh security        # Run security assertion tests only
#   ./.harness/test-runner.sh test_env_syntax # Run a single test function
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ------------------------------------------------------------------------------
# Test Counter Globals
# ------------------------------------------------------------------------------
TEST_COUNT_TOTAL=0
TEST_COUNT_PASS=0
TEST_COUNT_FAIL=0
TEST_COUNT_SKIP=0
SUITE_START_TIME=0

# Formatting and Colors (disabled if not a TTY or NO_COLOR is set)
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  CLR_RESET="\033[0m"
  CLR_BOLD="\033[1m"
  CLR_GREEN="\033[32m"
  CLR_RED="\033[31m"
  CLR_YELLOW="\033[33m"
  CLR_CYAN="\033[36m"
  CLR_GRAY="\033[90m"
else
  CLR_RESET=""
  CLR_BOLD=""
  CLR_GREEN=""
  CLR_RED=""
  CLR_YELLOW=""
  CLR_CYAN=""
  CLR_GRAY=""
fi

# ------------------------------------------------------------------------------
# Function: init_suite
# Description:
#   Initializes test execution timer and prints the suite title header.
# Arguments:
#   $1 (suite_title) - Display name for the test suite.
# ------------------------------------------------------------------------------
init_suite() {
  local suite_title="$1"
  SUITE_START_TIME="$(date +%s)"
  printf "\n%b=== Suite: %s ===%b\n" "${CLR_BOLD}${CLR_CYAN}" "${suite_title}" "${CLR_RESET}"
}

# ------------------------------------------------------------------------------
# Function: record_pass
# Description:
#   Records a successful test assertion and increments pass counter.
# Arguments:
#   $1 (test_name) - Symbolic test identifier.
#   $2 (message)   - Explanatory success message.
#   $3 (duration)  - Optional duration string (e.g. "0.05s").
# ------------------------------------------------------------------------------
record_pass() {
  local test_name="$1"
  local message="$2"
  local duration="${3:-}"
  ((TEST_COUNT_TOTAL++)) || true
  ((TEST_COUNT_PASS++)) || true

  if [[ -n "${duration}" ]]; then
    printf "  %b[PASS]%b %s: %s %b(%s)%b\n" \
      "${CLR_BOLD}${CLR_GREEN}" "${CLR_RESET}" \
      "${test_name}" "${message}" \
      "${CLR_GRAY}" "${duration}" "${CLR_RESET}"
  else
    printf "  %b[PASS]%b %s: %s\n" \
      "${CLR_BOLD}${CLR_GREEN}" "${CLR_RESET}" \
      "${test_name}" "${message}"
  fi
}

# ------------------------------------------------------------------------------
# Function: record_fail
# Description:
#   Records a failed test assertion and increments fail counter.
# Arguments:
#   $1 (test_name) - Symbolic test identifier.
#   $2 (message)   - Explanatory failure reason.
#   $3 (duration)  - Optional duration string.
# ------------------------------------------------------------------------------
record_fail() {
  local test_name="$1"
  local message="$2"
  local duration="${3:-}"
  ((TEST_COUNT_TOTAL++)) || true
  ((TEST_COUNT_FAIL++)) || true

  if [[ -n "${duration}" ]]; then
    printf "  %b[FAIL]%b %s: %s %b(%s)%b\n" \
      "${CLR_BOLD}${CLR_RED}" "${CLR_RESET}" \
      "${test_name}" "${message}" \
      "${CLR_GRAY}" "${duration}" "${CLR_RESET}" >&2
  else
    printf "  %b[FAIL]%b %s: %s\n" \
      "${CLR_BOLD}${CLR_RED}" "${CLR_RESET}" \
      "${test_name}" "${message}" >&2
  fi
}

# ------------------------------------------------------------------------------
# Function: record_skip
# Description:
#   Records a skipped test assertion and increments skip counter.
# Arguments:
#   $1 (test_name) - Symbolic test identifier.
#   $2 (reason)    - Explanatory skip reason.
# ------------------------------------------------------------------------------
record_skip() {
  local test_name="$1"
  local reason="$2"
  ((TEST_COUNT_TOTAL++)) || true
  ((TEST_COUNT_SKIP++)) || true

  printf "  %b[SKIP]%b %s: %s\n" \
    "${CLR_BOLD}${CLR_YELLOW}" "${CLR_RESET}" \
    "${test_name}" "${reason}"
}

# ------------------------------------------------------------------------------
# Assertion Helper Functions
# ------------------------------------------------------------------------------
assert_equals() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-Assertion failed}"
  if [[ "${expected}" != "${actual}" ]]; then
    echo "Expected '${expected}', but got '${actual}'" >&2
    return 1
  fi
}

assert_success() {
  local cmd="$1"
  local msg="${2:-Command should succeed}"
  if ! eval "${cmd}"; then
    echo "Command failed: ${cmd}" >&2
    return 1
  fi
}

assert_failure() {
  local cmd="$1"
  local msg="${2:-Command should fail}"
  if eval "${cmd}" >/dev/null 2>&1; then
    echo "Command succeeded unexpectedly: ${cmd}" >&2
    return 1
  fi
}

assert_matches() {
  local pattern="$1"
  local actual="$2"
  local msg="${3:-Pattern match failed}"
  if [[ ! "${actual}" =~ ${pattern} ]]; then
    echo "Value '${actual}' did not match pattern '${pattern}'" >&2
    return 1
  fi
}

log_test() {
  # Optional verbose logging hook
  :
}

# ------------------------------------------------------------------------------
# Function: run_test
# Description:
#   Executes a single test function, measures elapsed time, and traps failures.
# Arguments:
#   $1 (fn_name)     - Name of the shell function implementing the test case.
#   $2 (description) - Human-readable description of what is being verified.
# ------------------------------------------------------------------------------
run_test() {
  local fn_name="$1"
  local description="$2"
  local start_ts end_ts elapsed duration

  start_ts="$(date +%s%N 2>/dev/null || date +%s)"

  local output rc=0
  if output="$("${fn_name}" 2>&1)"; then
    rc=0
  else
    rc=$?
  fi

  end_ts="$(date +%s%N 2>/dev/null || date +%s)"

  if [[ ${#start_ts} -gt 10 && ${#end_ts} -gt 10 ]]; then
    local diff_ns=$((end_ts - start_ts))
    local diff_ms=$((diff_ns / 1000000))
    duration="$(awk -v ms="${diff_ms}" 'BEGIN { printf "%.2fs", ms / 1000 }')"
  else
    local diff_s=$((end_ts - start_ts))
    duration="${diff_s}s"
  fi

  if [[ "${rc}" -eq 0 ]]; then
    local msg="${description}"
    if [[ -n "${output}" ]]; then
      msg="${description} -> ${output}"
    fi
    record_pass "${fn_name}" "${msg}" "${duration}"
  elif [[ "${rc}" -eq 77 ]]; then
    local skip_msg="${output:-skipped}"
    record_skip "${fn_name}" "${description} (${skip_msg})"
  else
    local err_msg="${output:-exit code ${rc}}"
    record_fail "${fn_name}" "${description} (Failed: ${err_msg})" "${duration}"
  fi
}

# ------------------------------------------------------------------------------
# Function: print_summary
# Description:
#   Prints final execution summary across all executed test suites.
# Returns:
#   0 if zero failures, 1 if any failure occurred.
# ------------------------------------------------------------------------------
print_summary() {
  local end_time
  end_time="$(date +%s)"
  local total_elapsed=$((end_time - SUITE_START_TIME))

  printf "\n%b=======================================================%b\n" "${CLR_BOLD}" "${CLR_RESET}"
  printf "%bTest Suite Summary:%b %d Total | %b%d Passed%b | %b%d Failed%b | %b%d Skipped%b (%ds elapsed)\n" \
    "${CLR_BOLD}" "${CLR_RESET}" \
    "${TEST_COUNT_TOTAL}" \
    "${CLR_GREEN}" "${TEST_COUNT_PASS}" "${CLR_RESET}" \
    "${CLR_RED}" "${TEST_COUNT_FAIL}" "${CLR_RESET}" \
    "${CLR_YELLOW}" "${TEST_COUNT_SKIP}" "${CLR_RESET}" \
    "${total_elapsed}"
  printf "%b=======================================================%b\n" "${CLR_BOLD}" "${CLR_RESET}"

  [[ "${TEST_COUNT_FAIL}" -eq 0 ]]
}

# ------------------------------------------------------------------------------
# Built-In Baseline Project Invariant Suites
# ------------------------------------------------------------------------------
test_conventions_entrypoint() {
  [[ -f "${REPO_DIR}/AGENTS.md" ]]
}

test_skills_symlink() {
  [[ -L "${REPO_DIR}/.skills" ]] || [[ -d "${REPO_DIR}/.skills" ]]
}

test_ecosystem_symlinks() {
  [[ -L "${REPO_DIR}/CLAUDE.md" || -f "${REPO_DIR}/CLAUDE.md" ]] && \
  [[ -L "${REPO_DIR}/GEMINI.md" || -f "${REPO_DIR}/GEMINI.md" ]] && \
  [[ -L "${REPO_DIR}/.cursorrules" || -f "${REPO_DIR}/.cursorrules" ]] && \
  [[ -L "${REPO_DIR}/agent.md" || -f "${REPO_DIR}/agent.md" ]]
}

test_manage_executable() {
  [[ -x "${REPO_DIR}/manage.sh" ]] && \
  (! git -C "${REPO_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1 || git -C "${REPO_DIR}" ls-files -s manage.sh | grep -q "^100755")
}

test_env_example_presence() {
  [[ -f "${REPO_DIR}/.env.example" ]]
}

test_gitignore_secrets() {
  grep -q "\.env" "${REPO_DIR}/.gitignore"
}

test_subagents_presence() {
  [[ -d "${REPO_DIR}/.agents/subagents" ]] && \
  [[ -f "${REPO_DIR}/.agents/subagents/principal-reviewer.md" ]] && \
  [[ -f "${REPO_DIR}/.agents/subagents/grep-worker.md" ]] && \
  [[ -f "${REPO_DIR}/.agents/subagents/diff-worker.md" ]]
}

test_memory_bank_presence() {
  [[ -s "${REPO_DIR}/.agents/memory/activeContext.md" ]] && \
  [[ -s "${REPO_DIR}/.agents/memory/systemPatterns.md" ]] && \
  [[ -s "${REPO_DIR}/.agents/memory/progress.md" ]]
}

test_ci_workflow_presence() {
  [[ -f "${REPO_DIR}/.github/workflows/ci.yml" ]]
}

test_modular_rules_presence() {
  [[ -f "${REPO_DIR}/.agents/rules/shell-scripting.md" ]] && \
  [[ -f "${REPO_DIR}/.agents/rules/containers-and-env.md" ]]
}

test_modular_rules_syntax() {
  local rule_file
  for rule_file in "${REPO_DIR}/.agents/rules"/*.md; do
    [[ -f "${rule_file}" ]] || continue
    head -n 1 "${rule_file}" | grep -q "^---$" || return 1
    grep -q "^trigger: " "${rule_file}" || return 1
    grep -E -q "^(glob:|globs:|trigger: always_on)" "${rule_file}" || return 1
  done
}

test_polyglot_conventions_presence() {
  grep -q "TypeScript / TSX" "${REPO_DIR}/AGENTS.md" && \
  grep -q "Python (3.12+ Baseline)" "${REPO_DIR}/AGENTS.md" && \
  grep -q "\*\*Go\*\*:" "${REPO_DIR}/AGENTS.md" && \
  [[ -f "${REPO_DIR}/.agents/skills/component-authoring/references/polyglot-idioms.md" ]]
}

suite_conventions() {
  init_suite "Project Conventions and Agent Structure"
  run_test test_conventions_entrypoint "AGENTS.md canonical entrypoint exists"
  run_test test_skills_symlink ".skills directory/symlink is available"
  run_test test_ecosystem_symlinks "Multi-agent ecosystem entrypoints (CLAUDE.md, GEMINI.md, .cursorrules) exist"
  run_test test_manage_executable "manage.sh operational entrypoint is executable"
  run_test test_env_example_presence ".env.example template exists"
  run_test test_gitignore_secrets ".gitignore protects .env secrets"
  run_test test_subagents_presence ".agents/subagents/ prompt directory exists"
  run_test test_memory_bank_presence ".agents/memory/ session memory bank exists and is populated"
  run_test test_modular_rules_presence ".agents/rules/ glob-scoped rules exist"
  run_test test_modular_rules_syntax ".agents/rules/ YAML frontmatter and triggers are valid"
  run_test test_polyglot_conventions_presence "AGENTS.md polyglot coding invariants and reference templates exist"
  run_test test_ci_workflow_presence ".github/workflows/ci.yml continuous integration workflow exists"
}

# ------------------------------------------------------------------------------
# Main Dispatcher
# ------------------------------------------------------------------------------
main() {
  local target="${1:-all}"
  SUITE_START_TIME="$(date +%s)"

  case "${target}" in
    all|"")
      suite_conventions
      ;;
    conventions)
      suite_conventions
      ;;
    *)
      if declare -f "${target}" >/dev/null; then
        init_suite "Single Test: ${target}"
        run_test "${target}" "${target}"
      else
        echo "Error: Unknown test target or function: '${target}'" >&2
        exit 1
      fi
      ;;
  esac

  print_summary
}

main "$@"
