# Worker Component

## Responsibility
Execute approved build/update commands and stream status/log metadata back to API/state store.

## Command Allowlist (v0)
1. `./build_qat.sh --update-pkg-repo`
2. `./build_qat.sh memstickserial`

## Required Behavior
1. Capture stdout/stderr logs.
2. Track start/end time and exit code.
3. Prevent duplicate concurrent runs for same job type.
