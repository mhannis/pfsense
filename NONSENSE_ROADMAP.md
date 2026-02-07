# nonSense Roadmap

## Objective
Deliver a reproducible nonSense build platform that can:

1. build images reliably
2. publish package repositories
3. update installed systems from that repository
4. run unattended nightly builds
5. expose build/repo operations through a web interface

## Phase 1: Stabilize Build and Update Path

### Scope
1. Produce a bootable `memstickserial` image.
2. Ensure package manager works in GUI.
3. Ensure update checks work from custom repo.
4. Ensure repo setup scripts do not depend on private-only components.

### Exit Criteria
1. Fresh install boots and loads GUI without crash.
2. `System > Package Manager > Available Packages` works.
3. `System > Update` resolves correctly from custom repo.
4. QAT modules are present in build and load on target hardware.

## Phase 2: Release Discipline

### Scope
1. Define dev/test/stable channels.
2. Define package and image promotion process.
3. Define rollback and hotfix workflow.

### Exit Criteria
1. Promotion requires explicit checks and sign-off.
2. Rollback process is tested and documented.
3. Release notes template is used for each build.

## Phase 3: Build Orchestration UI

### Scope
1. API and worker for build control.
2. Web UI for triggering builds and viewing status/logs.
3. Ports update controls and delta visibility.
4. Artifact/repo publishing controls.

### Exit Criteria
1. Operator can run full build workflow from UI.
2. Logs and status are visible in near real-time.
3. Failure notifications are generated automatically.

## Phase 4: Scheduled Automation

### Scope
1. Nightly build scheduling.
2. Optional automatic update checks against upstream repos.
3. Optional gated auto-promotion to test channel.

### Exit Criteria
1. Nightly jobs run without manual intervention.
2. Failures produce actionable notifications.
3. Build history is queryable and retained.

## Risks
1. Host/jail version mismatch can produce unsupported behavior.
2. Disk pressure can stall or fail builds.
3. Private upstream deltas may require public fallback implementations.

## Working Rule
Do not advance to orchestration automation until Phase 1 stays stable for repeated build/install/update cycles.
