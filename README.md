# nonSense Build Fork

## Purpose

This fork is focused on building and operating a reproducible pfSense CE-derived environment under the `nonSense` product name, with:

1. reproducible image builds
2. a custom package repository
3. working in-place updates from that repository
4. Intel QAT support enabled in the built images

The practical target is operational: build once, publish artifacts, point installed systems to the repo, and deliver reliable updates.

## Current Focus

1. get a fully working first build and update path end-to-end
2. keep the environment reproducible for other operators
3. document every required patch and process decision

## Documentation

1. Environment and process playbook:
- `NONSENSE_BUILD_ENVIRONMENT_PLAYBOOK.md`
2. QAT-specific workflow:
- `QAT_RUNBOOK.md`
3. Session state and detailed change log (operator workspace):
- `<userhome>/pfsensece/RESUME_STATE.md`

## Quick Start (Builder)

From the FreeBSD builder host:

```sh
cd <builderhome>/pfsensebuild/pfsense
sudo -n env DO_NOT_SIGN_PKG_REPO=YES ./build_qat.sh --update-pkg-repo
sudo -n env DO_NOT_SIGN_PKG_REPO=YES ./build_qat.sh memstickserial
```

## Scope Notes

1. This project is not attempting to reproduce private Netgate-only components.
2. Some ports and runtime behaviors are adjusted for public, reproducible builds.
3. Build and update reliability takes priority over feature parity with non-public variants.

## Roadmap

1. finalize stable first image + package/update workflow
2. publish structured release and rollback process
3. add build orchestration UI (build trigger, status/logs, scheduled nightly runs)
4. support controlled ports update/promotion workflows

## Upstream Attribution

This repository is derived from the upstream pfSense project. For upstream contribution guidance, see:

- `.github/CONTRIBUTING.md`
