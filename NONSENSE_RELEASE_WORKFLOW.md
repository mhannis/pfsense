# nonSense Release and Promotion Workflow

## Channels
1. `dev`: every successful build candidate.
2. `test`: manually promoted builds that passed install/update validation.
3. `stable`: manually promoted builds approved for production.

## Versioning
1. Keep upstream-derived base version.
2. Append build timestamp and revision metadata.
3. Record build commit hashes for:
   - `pfSense`
   - `FreeBSD-ports`
   - `FreeBSD-src`

## Build Inputs (Required)
1. Branch/tag for each source repo.
2. Build profile (`memstickserial`, QAT enabled).
3. Ports tree state.
4. Build host metadata (CPU, RAM, FreeBSD version).

## Promotion Gates

### Gate A: Build Success
1. `--update-pkg-repo` completes with `Failed: 0` for required ports.
2. image build completes and artifact checksums are generated.

### Gate B: Install Validation
1. New image installs cleanly.
2. First boot reaches GUI and services start correctly.
3. Package manager can retrieve available package list.

### Gate C: Update Validation
1. Target points to custom repo successfully.
2. Update check completes without repo-setup/runtime errors.
3. In-place update path succeeds on at least one test instance.

## Promotion Actions
1. `dev -> test`:
   - create release note draft
   - attach logs/checksums
   - mark candidate as tested
2. `test -> stable`:
   - explicit approval required
   - publish final release note
   - pin rollback target

## Rollback
1. Keep at least one previous promoted repo snapshot.
2. Keep previous image artifact and checksum manifest.
3. Rollback procedure:
   - repoint repo channel to previous snapshot
   - reinstall or update target to previous known-good image/package set

## Minimum Release Record
1. build ID and timestamp
2. git commit hashes (all source repos)
3. package repo URL
4. image artifact names + checksums
5. validation checklist results
6. known issues and mitigations
