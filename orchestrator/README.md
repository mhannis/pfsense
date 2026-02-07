# nonSense Orchestrator (Scaffold)

## Purpose
Web/API control plane for build, repo refresh, validation, promotion, and scheduling workflows.

## Components
1. `api/` HTTP API for job control and metadata.
2. `worker/` command executor for builder operations.
3. `scheduler/` recurring job runner.
4. `ui/` operator dashboard.
5. `state/` local runtime state (sqlite by default in v0).

## Initial Job Types
1. `update_pkg_repo`
2. `build_image_memstickserial`
3. `validate_install_smoke`
4. `validate_update_smoke`

## Next Build Steps
1. Implement `api` health and job create/list endpoints.
2. Implement `worker` command allowlist and job runner.
3. Wire `scheduler` for nightly build trigger.
4. Add simple `ui` page for active jobs + logs.

## Safety Rules
1. No arbitrary shell command execution from API.
2. Use explicit allowlist per job type.
3. Persist all action logs for audit.
