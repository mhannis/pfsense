# nonSense Build Environment Playbook

## Goal
Build and publish a working nonSense (pfSense CE-derived) image and package repository with QAT enabled, so installed systems can receive updates from the custom repo.

## Canonical Hosts and Paths
1. Builder host: `codex@192.168.10.230` (FreeBSD)
2. Control workspace: `/home/redhot/pfsensece` (this machine)
3. Builder source roots:
- `/home/codex/pfsensebuild/pfsense`
- `/home/codex/pfsensebuild/FreeBSD-ports`
- `/home/codex/pfsensebuild/FreeBSD-src`
4. Active poudriere ports tree:
- `/usr/local/poudriere/ports/nonSense_devel`
5. Package publish root:
- `/usr/local/poudriere/data/packages/nonSense_master_amd64-nonSense_devel`
6. Repo web endpoint:
- `http://192.168.10.230:8080/nonSense_master_amd64-nonSense_devel`

## Hardware/Runtime Baseline
1. CPU: 16 vCPU recommended
2. RAM: 50 GB confirmed workable
3. Free space: keep significant headroom on ZFS (builds fail when pool is near full)
4. Builder OS currently used: FreeBSD 15.0-RELEASE

## Source Control Layout
1. GitHub user: `mhannis`
2. Working branches:
- `pfSense`: `nonsense/devel`
- `FreeBSD-ports`: `nonsense/devel`
- `FreeBSD-src`: `nonsense/devel`
3. Remotes:
- `origin` = upstream pfsense repos
- `github` = your forks

## Required Build Characteristics
1. Product naming: `PRODUCT_NAME=nonSense`
2. QAT enabled in `build.conf`:
- `MODULES_OVERRIDE_APPEND` includes `qat` and `qatfw/qat_c3xxx`
3. QAT loader lines in `loader.conf.append`:
- `qat_common_load="YES"`
- `qat_api_load="YES"`
- `qat_hw_load="YES"`
- `qat_load="YES"`
- `qat_c3xxx_fw_load="YES"`
4. Runtime repo URLs in build config point to local builder HTTP repo.

## Phase 1 Hardening (Must Keep)
Applied to `FreeBSD-ports` and active poudriere tree:
1. `security/pfSense-system`:
- includes patch files:
  - `patch-src_etc_inc_globals.inc`
  - `patch-src_etc_inc_pkg-utils.inc`
  - `patch-src_etc_inc_system.inc`
  - `patch-src_etc_rc.bootup`
  - `patch-src_etc_rc.update_bogons.sh`
- removes `pfSense-gnid` dependency
2. `sysutils/pfSense-upgrade/files/pfSense-repo-setup`:
- hardened for missing `*-repoc-static`
- safe when repo conf file is absent
3. `net/kea`:
- Netgate private diff fetch only when `GITLAB_TOKEN` is set

## Standard Rebuild Flow
Run on builder host:

```sh
cd /home/codex/pfsensebuild/pfsense
sudo -n env DO_NOT_SIGN_PKG_REPO=YES ./build_qat.sh --update-pkg-repo
sudo -n env DO_NOT_SIGN_PKG_REPO=YES ./build_qat.sh memstickserial
```

## Artifact and Log Locations
1. Image logs:
- `/home/codex/pfsensebuild/rebuild_memstick*.log`
2. Package repo rebuild logs:
- `/home/codex/pfsensebuild/update_pkg_repo*.log`
3. Poudriere bulk logs:
- `/usr/local/poudriere/data/logs/bulk/nonSense_master_amd64-nonSense_devel/*`
4. Final image output:
- `/home/codex/pfsensebuild/pfsense/tmp/nonSense/installer/`

## Update Path Validation (Target Firewall)
1. Confirm package manager can load available packages
2. Confirm system update page shows current version info
3. Confirm repo setup command exists and works:
- `/usr/local/sbin/pfSense-repo-setup`
4. Confirm `vendor/autoload.php` exists under `/usr/local/pfSense/include/vendor/`

## Known Risk Notes
1. Builder host kernel older than jail can emit warning; builds may still work but this is unsupported.
2. Disk pressure on ZFS is a frequent failure source.
3. Private Netgate-only components must remain removed/guarded for public reproducibility.

## Next Milestones
1. Finish first fully validated memstickserial image boot + GUI + package manager + update check.
2. Create a GitHub project/repo docs page for:
- architecture
- release process
- rollback process
- troubleshooting
3. Build web orchestrator:
- build trigger UI
- ports update control
- nightly scheduler
- build status/log viewer
- artifact promotion workflow

## Canonical Session History
Full chronological details are tracked in:
- `/home/redhot/pfsensece/RESUME_STATE.md`
