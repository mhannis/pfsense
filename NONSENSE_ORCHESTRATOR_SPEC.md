# nonSense Build Orchestrator Spec (v0)

## Goal
Provide a web-driven control plane for builds, package repo refresh, and promotion workflows without requiring manual SSH command sequences.

## Core Features
1. Trigger operations:
   - setup/update package repo
   - image build (`memstickserial`, future variants)
   - validation job runs
2. Status and logs:
   - current phase
   - elapsed time
   - live tail of logs
3. Artifact view:
   - generated image files
   - package repo snapshots
   - checksums
4. Promotion controls:
   - dev/test/stable state transitions
   - rollback target selection
5. Scheduling:
   - nightly build jobs
   - optional upstream-delta checks

## Proposed Components
1. `api` service:
   - REST endpoints for job control and metadata
2. `worker` service:
   - executes build commands on builder host
   - captures logs and updates job state
3. `ui`:
   - operator dashboard
   - job history and logs
4. `scheduler`:
   - cron-like recurring jobs
5. `state` store:
   - sqlite or postgres for jobs/artifacts/promotions

## Suggested Initial API
1. `POST /jobs`
2. `GET /jobs`
3. `GET /jobs/{id}`
4. `GET /jobs/{id}/logs`
5. `POST /promotions`
6. `GET /artifacts`
7. `POST /schedules`
8. `GET /health`

## Job Types (v0)
1. `update_pkg_repo`
2. `build_image_memstickserial`
3. `validate_install_smoke`
4. `validate_update_smoke`

## Security Baseline
1. Authentication required for mutating endpoints.
2. Role split:
   - viewer
   - operator
   - approver
3. Command allowlist (no arbitrary shell from UI).
4. Audit log for every trigger/promotion action.

## Non-Goals (v0)
1. Multi-builder cluster scheduling.
2. Full package-level CI for every port change.
3. Automatic stable promotion without approval.

## Build Before UI Rule
Do not rely on orchestration until manual build/install/update path is stable and repeatable.
