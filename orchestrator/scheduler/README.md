# Scheduler Component

## Responsibility
Trigger recurring jobs based on configured schedules.

## v0 Schedule Targets
1. Nightly `update_pkg_repo`
2. Nightly `build_image_memstickserial`

## Required Behavior
1. Skip run if same job type is already active.
2. Emit schedule execution record to state store.
3. Support manual disable/enable per schedule.
