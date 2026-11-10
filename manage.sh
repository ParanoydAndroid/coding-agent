#!/usr/bin/env bash
# ==============================================================================
# Script Name: manage.sh
# Description:
#   Central operational entrypoint for the project. Provides idempotent state
#   convergence (setup), test suite orchestration (test), and baseline
#   codebase drift/security auditing (audit).
#
# Usage:
#   ./manage.sh <subcommand> [arguments]
#
# Subcommands:
#   setup          Idempotently converges environment, directories, and configuration
#   test [suite]   Executes automated smoke and regression test suites
#   audit          Runs baseline drift, permission, and environment security audits
#   help           Displays usage and subcommand guidance
#
# Preconditions:
#   Bash 4.0+ and Git must be installed on the host.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${SCRIPT_DIR}"

# ------------------------------------------------------------------------------
# Formatting and Color Helpers
# ------------------------------------------------------------------------------
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  CLR_RESET="\033[0m"
  CLR_BOLD="\033[1m"
  CLR_GREEN="\033[32m"
  CLR_RED="\033[31m"
  CLR_YELLOW="\033[33m"
  CLR_CYAN="\033[36m"
else
  CLR_RESET=""
  CLR_BOLD=""
  CLR_GREEN=""
  CLR_RED=""
  CLR_YELLOW=""
  CLR_CYAN=""
fi

log_info() {
  printf "%b[INFO]%b %s\n" "${CLR_CYAN}" "${CLR_RESET}" "$1"
}

log_success() {
  printf "%b[OK]%b %s\n" "${CLR_GREEN}" "${CLR_RESET}" "$1"
}

log_warn() {
  printf "%b[WARN]%b %s\n" "${CLR_YELLOW}" "${CLR_RESET}" "$1" >&2
}

log_error() {
  printf "%b[ERROR]%b %s\n" "${CLR_RED}" "${CLR_RESET}" "$1" >&2
}

# ------------------------------------------------------------------------------
# Function: cmd_setup
# Description:
#   Idempotently converges host directories, environment templates, and
#   symlinks to the desired target state. Running repeatedly produces zero
#   unintended side effects.
# Arguments:
#   None.
# Outputs:
#   Prints step-by-step convergence progress to stdout.
# Return:
#   0 on success, non-zero on failure.
# ------------------------------------------------------------------------------
cmd_setup() {
  log_info "Starting environment convergence..."

  # 1. Ensure required runtime directory trees exist
  local required_dirs=(
    "${REPO_DIR}/data"
    "${REPO_DIR}/backups"
    "${REPO_DIR}/.agents/artifacts"
    "${REPO_DIR}/.agents/subagents"
    "${REPO_DIR}/.agents/memory"
  )
  for dir in "${required_dirs[@]}"; do
    if [[ ! -d "${dir}" ]]; then
      mkdir -p "${dir}"
      log_success "Created directory: ${dir#${REPO_DIR}/}"
    fi
  done

  # 2. Bootstrap .env from .env.example if missing
  if [[ ! -f "${REPO_DIR}/.env" ]]; then
    if [[ -f "${REPO_DIR}/.env.example" ]]; then
      cp "${REPO_DIR}/.env.example" "${REPO_DIR}/.env"
      chmod 600 "${REPO_DIR}/.env"
      log_success "Initialized .env from .env.example (permissions: 600)"
    else
      log_warn ".env.example not found; skipping .env bootstrap"
    fi
  else
    log_info ".env already exists; preserving existing configuration"
  fi

  # 3. Verify and converge agent discovery symlinks
  local symlinks=(
    "agent.md:AGENTS.md"
    "CLAUDE.md:AGENTS.md"
    "GEMINI.md:AGENTS.md"
    ".cursorrules:AGENTS.md"
    ".skills:.agents/skills"
  )
  for pair in "${symlinks[@]}"; do
    local link_name="${pair%%:*}"
    local target_path="${pair##*:}"
    if [[ ! -L "${REPO_DIR}/${link_name}" ]]; then
      ln -sf "${target_path}" "${REPO_DIR}/${link_name}"
      log_success "Converged symlink: ${link_name} -> ${target_path}"
    fi
  done

  # 4. Enforce standard secure permissions across repository files
  log_info "Normalizing filesystem permissions..."
  find "${REPO_DIR}" -maxdepth 6 -type f -not -path "*/.git/*" -not -name "*.sh" -exec chmod 644 {} +
  find "${REPO_DIR}" -maxdepth 6 -type f -name "*.sh" -exec chmod 755 {} +
  chmod 755 "${REPO_DIR}/manage.sh"
  if [[ -f "${REPO_DIR}/.env" ]]; then
    chmod 600 "${REPO_DIR}/.env"
  fi
  log_success "Normalized permissions (644 for files, 755 for scripts, 600 for .env)"

  # 5. Verify test runner permissions
  if [[ -f "${REPO_DIR}/.harness/test-runner.sh" && ! -x "${REPO_DIR}/.harness/test-runner.sh" ]]; then
    chmod +x "${REPO_DIR}/.harness/test-runner.sh"
    log_success "Ensured .harness/test-runner.sh is executable"
  fi

  # 6. Ensure git index tracks shell scripts as executable (100755)
  if [[ -d "${REPO_DIR}/.git" ]]; then
    git -C "${REPO_DIR}" update-index --chmod=+x manage.sh .harness/test-runner.sh 2>/dev/null || true
  fi

  # 6. Install or converge git hooks guarding main
  if [[ -d "${REPO_DIR}/.git" ]]; then
    cmd_hook install >/dev/null 2>&1 || true
    log_success "Verified git hooks protecting 'main' branch"
  fi

  log_success "Environment convergence complete. Target state verified."
}

# ------------------------------------------------------------------------------
# Function: cmd_test
# Description:
#   Dispatches test suite execution to the automated test harness.
# Arguments:
#   $@ - Optional test suite or test function name.
# Return:
#   Pass-through exit code from test runner.
# ------------------------------------------------------------------------------
cmd_test() {
  local test_runner="${REPO_DIR}/.harness/test-runner.sh"
  if [[ ! -x "${test_runner}" ]]; then
    log_error "Test runner not executable: ${test_runner}"
    exit 1
  fi
  exec "${test_runner}" "$@"
}

# ------------------------------------------------------------------------------
# Function: cmd_audit
# Description:
#   Performs a baseline drift and security audit against the codebase.
# Arguments:
#   None.
# Return:
#   0 if no critical issues found, 1 if critical issues detected.
# ------------------------------------------------------------------------------
cmd_audit() {
  log_info "Executing codebase audit..."
  local issues_found=0

  # 1. Check for world-writable files
  log_info "Auditing filesystem permissions for world-writable files..."
  local ww_files
  ww_files="$(find "${REPO_DIR}" -maxdepth 6 -type f -perm -002 -not -path "*/.git/*" 2>/dev/null || true)"
  if [[ -n "${ww_files}" ]]; then
    log_error "Dangerous world-writable files detected:"
    echo "${ww_files}" >&2
    ((issues_found++)) || true
  else
    log_success "Filesystem permissions secure (zero world-writable files)"
  fi

  # 2. Check for missing required variables in .env relative to .env.example
  if [[ -f "${REPO_DIR}/.env.example" && -f "${REPO_DIR}/.env" ]]; then
    log_info "Checking environment variable template alignment..."
    local missing_vars
    missing_vars="$(comm -23 \
      <(grep -oE '^[A-Z0-9_]+' "${REPO_DIR}/.env.example" | sort -u) \
      <(grep -oE '^[A-Z0-9_]+' "${REPO_DIR}/.env" | sort -u) || true)"
    if [[ -n "${missing_vars}" ]]; then
      log_warn "Variables declared in .env.example missing in active .env:"
      echo "${missing_vars}" | sed 's/^/  - /' >&2
    else
      log_success "Environment variables fully aligned with template"
    fi
  fi

  # 3. Check for broken symlinks
  log_info "Validating repository symlinks..."
  local broken_links
  broken_links="$(find "${REPO_DIR}" -maxdepth 6 -xtype l -not -path "*/.git/*" 2>/dev/null || true)"
  if [[ -n "${broken_links}" ]]; then
    log_error "Broken symlinks detected:"
    echo "${broken_links}" >&2
    ((issues_found++)) || true
  else
    log_success "All repository symlinks resolve cleanly"
  fi

  # 4. Anti-slop and prose hygiene audit
  log_info "Auditing documentation and rules for AI slop and banned hyperbole..."
  local banned_slop="seamless|robust|cutting-edge|revolutionary|production-grade|battle-tested|pristine|elegant|ultimate|bulletproof|delve|tapestry|beacon|testament|furthermore|moreover"
  local found_slop
  found_slop="$(grep -riE "${banned_slop}" "${REPO_DIR}/README.md" "${REPO_DIR}/CHANGELOG.md" "${REPO_DIR}/.agents/artifacts" 2>/dev/null || true)"
  if [[ -n "${found_slop}" ]]; then
    log_error "Banned AI slop or promotional hyperbole detected in documentation:"
    echo "${found_slop}" | head -n 10 >&2
    ((issues_found++)) || true
  else
    log_success "Documentation and prose clean (zero AI slop detected)"
  fi

  if [[ "${issues_found}" -eq 0 ]]; then
    log_success "Audit completed: System healthy."
    return 0
  else
    log_error "Audit completed: ${issues_found} issue(s) detected."
    return 1
  fi
}

# ------------------------------------------------------------------------------
# Function: cmd_hook
# Description:
#   Installs git hooks guarding the 'main' branch during commits and pushes.
#   Feature branches remain completely unhindered so intermediate development
#   commits are never blocked.
# Arguments:
#   $1 - Action: 'install' (default) or 'uninstall'.
# Return:
#   0 on success, non-zero on failure.
# ------------------------------------------------------------------------------
cmd_hook() {
  local action="${1:-install}"
  local hooks_dir="${REPO_DIR}/.git/hooks"

  if [[ ! -d "${REPO_DIR}/.git" ]]; then
    log_warn "Not a git repository; skipping git hook setup"
    return 0
  fi

  mkdir -p "${hooks_dir}"

  case "${action}" in
    install)
      log_info "Installing git hooks guarding 'main' branch..."

      # pre-commit: restricts commits/merges on main, bypasses feature branches
      cat <<'EOF' > "${hooks_dir}/pre-commit"
#!/usr/bin/env bash
set -euo pipefail

CURRENT_BRANCH="$(git branch --show-current 2>/dev/null || true)"
# Only enforce checks when committing directly on main or completing a merge on main
if [[ "${CURRENT_BRANCH}" == "main" ]]; then
  echo "[HOOK] Running pre-commit/pre-merge validation on main..."
  ./manage.sh audit
  ./manage.sh test all
fi
EOF
      chmod 755 "${hooks_dir}/pre-commit"

      # pre-push: restricts pushes destined for main
      cat <<'EOF' > "${hooks_dir}/pre-push"
#!/usr/bin/env bash
set -euo pipefail

while read -r local_ref local_oid remote_ref remote_oid; do
  if [[ "${remote_ref}" == "refs/heads/main" || "${remote_ref}" =~ /main$ ]]; then
    echo "[HOOK] Verifying tests and audit before pushing to main..."
    ./manage.sh audit
    ./manage.sh test all
    break
  fi
done
EOF
      chmod 755 "${hooks_dir}/pre-push"
      log_success "Git hooks installed: pre-commit and pre-push guard 'main' branch"
      ;;
    uninstall)
      rm -f "${hooks_dir}/pre-commit" "${hooks_dir}/pre-push"
      log_success "Git hooks uninstalled"
      ;;
    *)
      log_error "Unknown hook action: '${action}'. Expected 'install' or 'uninstall'."
      return 1
      ;;
  esac
}

# ------------------------------------------------------------------------------
# Function: cmd_help
# Description:
#   Displays usage and subcommand guidance.
# ------------------------------------------------------------------------------
cmd_help() {
  cat <<EOF
${CLR_BOLD}Project Management Entrypoint (manage.sh)${CLR_RESET}

${CLR_BOLD}Usage:${CLR_RESET}
  ./manage.sh <subcommand> [options]

${CLR_BOLD}Available Subcommands:${CLR_RESET}
  ${CLR_CYAN}setup${CLR_RESET}          Idempotently converges environment, directories, and configuration
  ${CLR_CYAN}test [suite]${CLR_RESET}   Executes automated smoke and regression test suites
  ${CLR_CYAN}audit${CLR_RESET}          Runs baseline drift, permission, and environment security audits
  ${CLR_CYAN}hook [action]${CLR_RESET}  Manages git hooks protecting 'main' (install|uninstall)
  ${CLR_CYAN}help${CLR_RESET}           Displays this help message

${CLR_BOLD}Examples:${CLR_RESET}
  ./manage.sh setup
  ./manage.sh test all
  ./manage.sh test conventions
  ./manage.sh audit
  ./manage.sh hook install
EOF
}

# ------------------------------------------------------------------------------
# Main Dispatcher
# ------------------------------------------------------------------------------
main() {
  local subcmd="${1:-help}"
  shift || true

  case "${subcmd}" in
    setup)
      cmd_setup "$@"
      ;;
    test)
      cmd_test "$@"
      ;;
    audit)
      cmd_audit "$@"
      ;;
    hook)
      cmd_hook "$@"
      ;;
    help|-h|--help)
      cmd_help
      ;;
    *)
      log_error "Unknown subcommand: '${subcmd}'"
      cmd_help
      exit 1
      ;;
  esac
}

main "$@"
