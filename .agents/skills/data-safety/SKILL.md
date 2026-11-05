---
name: data-safety
description: >-
  Operational runbook for data protection, pre-mutation snapshots, zero-downtime
  database staging, disaster recovery, and automated sandbox restore drills.
  Use when modifying databases, running backups, or verifying snapshot integrity.
---

# Data Safety and Disaster Recovery Runbook

An unverified backup is an untested liability. This skill provides procedural runbooks for executing non-disruptive data backups, taking pre-mutation safety snapshots, performing disaster recovery, and conducting automated sandbox restore drills.

## Prerequisites
- Reference [Disaster Recovery and Snapshot Mechanics](./references/recovery-runbook.md) for restoration sequences and staging details.

---

## Operations

### Operation 1: Pre-Mutation Safety Snapshot
Before running destructive schema migrations, major version upgrades, or refactoring persistent state:
1. Create an atomic, timestamped backup archive of the target data directory:
   ```bash
   SNAPSHOT_DIR="backups/snapshots/pre-mutation-$(date +%Y%m%d%H%M%S)"
   mkdir -p "${SNAPSHOT_DIR}"
   # If database is active, execute online dump first
   # Then snapshot files
   tar -czf "${SNAPSHOT_DIR}/data-snapshot.tar.gz" data/
   ```
2. Confirm the archive exists and is non-empty before executing state mutations.

---

### Operation 2: Online Database Staging & Volume Backups
To protect database state without stopping running containers or incurring downtime:
1. **PostgreSQL**:
   ```bash
   # Run online logical dump inside running container or host
   pg_dumpall -U postgres -f "data/backups/staged/postgres_globals.sql"
   ```
2. **SQLite**:
   ```bash
   # Use SQLite backup API for read-consistent online snapshot
   sqlite3 "data/app.db" ".backup 'data/backups/staged/app.db.bak'"
   ```
3. Stream the persistent data directories and staged dumps into the backup engine (e.g. Restic, Borg, or backup archive):
   ```bash
   tar -czf "backups/backup-$(date +%Y%m%d).tar.gz" data/
   ```

---

### Operation 3: Sandbox Disaster Recovery Drill (Verification)
Conduct periodic restore drills in an isolated temporary directory to prove that backups can actually be restored without touching production data:

1. **Prepare Sandbox Staging Directory**:
   ```bash
   DRILL_DIR="/tmp/dr-drill-$(date +%Y%m%d%H%M%S)"
   mkdir -p "${DRILL_DIR}"
   ```
2. **Restore Target Snapshot into Sandbox**:
   ```bash
   # Extract snapshot strictly into sandbox
   tar -xzf "backups/backup-latest.tar.gz" -C "${DRILL_DIR}"
   ```
3. **Verify Database Integrity**:
   - **PostgreSQL Dump Validation**:
     ```bash
     PG_DUMP="${DRILL_DIR}/data/backups/staged/postgres_globals.sql"
     if [[ -f "${PG_DUMP}" ]]; then
       grep -q "PostgreSQL database cluster dump" "${PG_DUMP}" && echo "PostgreSQL header: VALID"
     else
       echo "ERROR: PostgreSQL dump missing from snapshot!"
     fi
     ```
   - **SQLite PRAGMA Integrity Probes**:
     ```bash
     for db in $(find "${DRILL_DIR}" -name "*.db" -o -name "*.sqlite"); do
       integrity="$(sqlite3 "${db}" "PRAGMA integrity_check;" 2>/dev/null || echo "failed")"
       echo "Checking ${db}: ${integrity}"
       if [[ "${integrity}" != "ok" ]]; then
         echo "CORRUPTION DETECTED in ${db}!"
       fi
     done
     ```
4. **Teardown Sandbox**:
   ```bash
   rm -rf "${DRILL_DIR}"
   ```
5. Report drill results (snapshot tested, file count, database verification status).
