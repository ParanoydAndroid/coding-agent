---
name: doc-consistency-auditor
description: >-
  Systematic audit procedure for repository documentation, enforcing style standards,
  repository-relative links, anti-slop and anti-grandiosity rules, factual accuracy,
  and cross-document coherence.
---

# Documentation Consistency Auditor Runbook

This skill provides an automated, algorithmic procedure to audit repository documentation for structural consistency, adherence to anti-slop style standards, factual accuracy against disk state, and cross-document coherence.

---

## Documentation Verification Architecture

```text
[ Documentation Audit Triggered ]
               │
               ├── 1. Repository-Relative Link Audit (assert zero broken or escaping links)
               ├── 2. Anti-Slop & Anti-Grandiosity Scan (assert zero banned marketing/LLM tokens)
               ├── 3. Factual Accuracy Check (verify cited paths & manifests against disk state)
               └── 4. Coherence & Propagation Check (ensure cross-document synchronization)
```

---

## Step-by-Step Procedure

### 1. Repository-Relative Link & Citation Standard
All documentation cross-references must remain strictly within repository bounds:
- Use file-relative links strictly within the repository (e.g., `README.md`, `CHANGELOG.md`, `.agents/rules/`).
- Links must never escape repository bounds (e.g. `../../` above repo root).

Audit assertion:
```bash
python3 -c '
import re, glob, os, sys
link_re = re.compile(r"\[.*?\]\((?!http|#|mailto:)(.*?)\)")
failed = False

for md in glob.glob("**/*.md", recursive=True):
    if ".git" in md:
        continue
    base = os.path.dirname(md)
    with open(md, "r", errors="ignore") as f:
        for line_no, target in enumerate(link_re.findall(f.read()), 1):
            clean_target = target.split("#")[0]
            if not clean_target:
                continue
            resolved = os.path.normpath(os.path.join(base, clean_target))
            if not os.path.exists(resolved):
                print(f"Broken link in {md}: {target} -> {resolved}")
                failed = True

if failed:
    sys.exit(1)
print("ALL_LINKS_VALID")
'
```

### 2. Anti-Slop & Anti-Grandiosity Scan
Prohibit marketing hype, hyperbolic buzzwords, and predictable synthetic LLM filler per `.agents/rules/communication-and-style.md`:

```bash
BANNED="seamless|robust|cutting-edge|revolutionary|production-grade|battle-tested|pristine|elegant|ultimate|bulletproof|delve|tapestry|beacon|testament|furthermore|moreover"
if grep -i -E "(${BANNED})" README.md CHANGELOG.md .agents/artifacts/*.md 2>/dev/null; then
    echo "AI slop or grandiosity detected. Refactor with factual, understated technical prose."
    exit 1
else
    echo "PROSE_AUDIT_CLEAN"
fi
```

### 3. Factual Accuracy Check (Disk Grounding)
Documentation must reflect the true state of the codebase. Verify that referenced files, configurations, and manifests exist on disk:

```bash
# Extract cited repository files and assert existence on disk
python3 -c '
import re, glob, os, sys
path_re = re.compile(r"`([a-zA-Z0-9_\-/\.]+\.[a-zA-Z0-9]+)`")
missing = []
for md in ["README.md", "CHANGELOG.md"]:
    if not os.path.exists(md):
        continue
    with open(md) as f:
        for p in path_re.findall(f.read()):
            # Check relative to repo root if path looks like a local file
            if "/" in p and not p.startswith("http") and not os.path.exists(p):
                missing.append((md, p))
if missing:
    print("Factual mismatch: missing files cited in docs:", missing)
    sys.exit(1)
print("ALL_CITED_PATHS_EXIST")
'
```

### 4. Cross-Document Coherence & Propagation Check
Whenever a component, command, or contract is renamed or modified:
1. Search repository documentation for stale names or legacy syntax:
   ```bash
   grep -rn "<old-term>" README.md CHANGELOG.md .agents/skills/
   ```
2. Assert zero stale occurrences across the documentation corpus. Update all references in the same commit sprint.
