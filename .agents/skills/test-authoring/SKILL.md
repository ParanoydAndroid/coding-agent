---
name: test-authoring
description: >-
  Systematic recipe and standards for authoring automated smoke, interconnect,
  routing, and security regression tests. Use when introducing new features,
  adding API endpoints, or writing reproduction tests for bug fixes.
---

# Test Authoring Runbook

This skill guides the authoring and maintenance of automated tests within the project's test framework (e.g. `./.harness/test-runner.sh` or language-specific test harness).

## Prerequisites
- Reference [Automated Test Suite Catalog and Assertion Patterns](./references/suite-catalog.md) for available test helper functions and suite organization.

---

## Authoring Workflow

### Step 1: Identify Target Test Category
Determine where the new check belongs:
- **Service/Runtime Health**: Verify process lifecycle, daemon health checks, or container runtime states.
- **Interface & Routing Contracts**: Verify HTTP/gRPC endpoints, status codes, response schemas, and client routing.
- **Interconnect & Socket Checks**: Verify internal service-to-service connectivity, database sockets, message queues, and DNS resolution.
- **Negative Security & Access Controls**: Verify authentication requirements, permission boundaries, and rejection of unauthorized or malicious inputs (e.g., 401/403 responses, path traversal blocks).
- **Data Persistence & Migrations**: Verify database migrations, schema integrity, and state durability across restarts.

### Step 2: Implement Test Case
Follow the standard naming convention `test_<feature_or_bug>`:

```bash
test_auth_token_validation() {
  log_test "Testing authentication token validation..."
  local status
  status=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer invalid-token" "http://localhost:8080/api/v1/protected")
  assert_equals "401" "${status}" "Invalid token returns 401 Unauthorized"
}

test_database_connectivity() {
  log_test "Testing database connection socket..."
  assert_success "pg_isready -h localhost -p 5432 -U app" "Postgres socket is accepting connections"
}
```

### Step 3: Register Test in Suite Runner
Ensure the test function is invoked inside the appropriate suite execution block:
```bash
suite_api() {
  init_suite "API and Interface Contracts"
  run_test test_auth_token_validation "Rejects invalid bearer token"
  run_test test_api_health "Health endpoint returns 200 OK"
}
```

### Step 4: Test Inviolability and Regression Testing
- **Never Loosen Assertions**: Never modify or weaken existing assertions just to make a broken build pass. A failing test indicates a regression or defect.
- **Reproduction First**: When fixing a bug, write a failing reproduction test case before or alongside the code fix to prove the defect and prevent regressions permanently.

### Step 5: Validate Execution
Run the specific test suite directly:
```bash
./.harness/test-runner.sh api
```
Then run the entire test suite to guarantee zero side effects:
```bash
./.harness/test-runner.sh all
```
