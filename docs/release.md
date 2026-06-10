# Canary Release Flow

Canary releases are published from stable SemVer tags such as `v3.6.0`. Pushing
a release tag starts `.github/workflows/release.yml`, materializes release
metadata from the tag, moves the tag to that materialized commit when needed,
builds the release artifacts, copies `otservbr.otbm` from the latest published
release, publishes the GitHub release after all assets are uploaded, and opens a
pull request that syncs tracked release metadata back to `main`.

## Publish

Create and push the tag from the `main` commit you want to release. For a
normal release, update your local `main` first:

```bash
git switch main
git pull --ff-only origin main
git fetch --force --tags origin
git tag -a v3.6.0 -m v3.6.0
git push origin v3.6.0
```

The tag is the source of truth for the release version. The workflow rewrites
release-only metadata before building and force-updates the release tag to that
materialized commit when the tracked files were stale. This keeps GitHub's
automatic `Source code (zip)` and `Source code (tar.gz)` archives aligned with
the published release.

After publishing, the workflow opens or updates a branch named like
`release-v3.6.0-metadata` from the same materialized commit used by the release
tag. Review and merge that pull request to keep `main` aligned with the latest
release. After the pull request is merged, `.github/workflows/sync-release-tag.yml`
moves the release tag to the merged `main` commit when that commit has the same
tree as the materialized release commit. If `main` advanced with other changes
before the metadata pull request was merged, the workflow leaves the tag on the
release commit so the source archive does not accidentally include post-release
changes.

## Choosing The Next Version

Use the smallest SemVer bump that accurately describes the user, operator, and
developer impact since the previous release.

- Patch, for example `v3.6.0` to `v3.6.1`: bug fixes, crash fixes,
  non-breaking CI/build/release fixes, documentation updates, world-data fixes,
  or small compatibility corrections that do not add a new public feature and do
  not require operators to change configs, schemas, clients, or deployment
  steps.
- Minor, for example `v3.6.0` to `v3.7.0`: new backwards-compatible gameplay
  features, new systems, new optional config, new supported protocol/client
  functionality, compatible database migrations, new Docker/operator
  convenience, or meaningful content additions.
- Major, for example `v3.6.0` to `v4.0.0`: breaking config or deployment
  changes, required manual operator migration, incompatible database/storage
  changes, removed Lua/C++ APIs, removed supported behavior, protocol changes
  that make existing clients or integrations incompatible, or any change where a
  server owner should expect a migration project instead of a routine update.

When a release contains both fixes and features, choose the highest required
bump. When unsure between patch and minor, prefer minor if users or operators
will notice new behavior. When unsure between minor and major, choose major only
when an existing supported setup can break without a deliberate migration.

## Tagging Tutorial

This is the normal maintainer flow for publishing a new release:

1. Inspect the changes since the latest stable release tag.
2. Choose the next SemVer tag.
3. Push the new annotated tag to GitHub.
4. Wait for the `Release` workflow to finish.
5. Check that the GitHub release has the expected assets.
6. Merge the generated `release-vX.Y.Z-metadata` pull request.

The release itself does not wait for the metadata pull request. The workflow
uses the materialized release commit to publish the release and to keep GitHub's
automatic source archives correct. The metadata pull request only keeps `main`
aligned after the release is already published.

First inspect the range since the latest stable release tag.

On Bash:

```bash
git fetch origin main --tags
previous_tag="$(git tag --sort=-version:refname --list 'v[0-9]*.[0-9]*.[0-9]*' | head -n 1)"
git log --oneline --decorate --first-parent "${previous_tag}..origin/main"
git diff --name-only "${previous_tag}..origin/main"
```

On PowerShell:

```powershell
git fetch origin main --tags
$previousTag = git tag --sort=-version:refname --list "v[0-9]*.[0-9]*.[0-9]*" | Select-Object -First 1
git log --oneline --decorate --first-parent "$previousTag..origin/main"
git diff --name-only "$previousTag..origin/main"
```

Then choose the next version:

- Patch: increment only the third number, for example `v3.6.0` to `v3.6.1`.
- Minor: increment the second number and reset patch to zero, for example
  `v3.6.0` to `v3.7.0`.
- Major: increment the first number and reset minor and patch to zero, for
  example `v3.6.0` to `v4.0.0`.

After choosing the version, create and push an annotated tag. Replace `v3.7.0`
with the version selected for the release.

```bash
git switch main
git pull --ff-only origin main
git fetch --force --tags origin
git tag -a v3.7.0 -m v3.7.0
git push origin v3.7.0
```

PowerShell uses the same Git commands:

```powershell
git switch main
git pull --ff-only origin main
git fetch --force --tags origin
git tag -a v3.7.0 -m v3.7.0
git push origin v3.7.0
```

Pushing the tag is the only action that starts the release. The workflow then:

- materializes `SERVER_RELEASE_VERSION` from the tag;
- updates release map URLs to the new tag;
- updates Docker and MyAAC defaults from the current `CLIENT_VERSION` in
  `src/core.hpp`;
- creates a materialized release commit and moves the tag to it when tracked
  metadata was stale;
- runs checks and release builds;
- downloads the GitHub Actions artifact zips and uploads them as release assets;
- copies `otservbr.otbm` from the latest published release;
- publishes the GitHub release;
- opens `release-vX.Y.Z-metadata` so the same metadata can be merged into
  `main`.

After the workflow finishes, check the release page and confirm that these
assets exist:

- `canary-linux-release.zip`
- `canary-linux-debug.zip`
- `canary-windows-cmake-release.zip`
- `canary-windows-solution-debug.zip`
- `canary-macos-release.zip`
- `canary-docker.zip`
- `otservbr.otbm`

Then merge the generated metadata pull request. That merge is required to keep
`main` current, but it is not required for the already published release assets
or GitHub source archives to be correct.

If the supported Tibia protocol changed, update `CLIENT_VERSION` in
`src/core.hpp` on a normal pull request before tagging. The release automation
uses that value to update Docker and MyAAC defaults.

Do not reuse an already published tag for a different release unless correcting
a release automation incident. For routine releases, create the next SemVer tag.

## AI Version Prompt

Use this prompt when a maintainer wants help choosing the next tag. Paste the
command output from the tagging tutorial into the placeholders.

```markdown
You are helping choose the next Canary release version.

Previous release tag: <previous tag>
Candidate release target: origin/main
Commit range: <previous tag>..origin/main

Use this SemVer policy:
- PATCH for bug fixes, crash fixes, non-breaking CI/build/release fixes,
  documentation updates, world-data fixes, or compatibility corrections that do
  not require config, schema, client, deployment, or operator changes.
- MINOR for backwards-compatible gameplay features, new systems, optional
  config, new supported protocol/client functionality, compatible migrations,
  Docker/operator convenience, or meaningful content additions.
- MAJOR for breaking config/deployment changes, required manual migrations,
  incompatible database/storage changes, removed APIs, removed supported
  behavior, or protocol/client incompatibility.

Analyze these inputs:

Commit log:
<paste git log --oneline --decorate --first-parent output>

Changed files:
<paste git diff --name-only output>

Return:
1. Recommended next tag.
2. Whether the bump is patch, minor, or major.
3. The concrete commits or file areas that justify the bump.
4. Any release risks or manual notes maintainers should check.
5. The exact tag commands to run.
```

## Optional Metadata Update

If the supported Tibia protocol changed, update it on a normal branch and merge
it before tagging:

```bash
python .github/scripts/release_metadata.py update --version 3.6.0 --client-version 1511
```

The same helper can also update tracked release defaults when you want `main` to
show the latest release metadata:

```bash
python .github/scripts/release_metadata.py update --version 3.6.0
```

The helper updates:

- `src/core.hpp`
- `config.lua.dist`
- `docker/data/start.sh`
- `docker/.env.dist`
- `docker/docker-compose.yml`
- `docker/DOCKER.md`
- `docker/quickstart/myaac/bootstrap.php`

If you also need to update a local ignored runtime config, pass
`--include-local-config`. That option is for local operator files only; it is not
used by CI.

## Validation

The release workflow validates the materialized metadata before it builds
anything. For local checks, run:

```bash
python .github/scripts/release_metadata.py materialize --tag v3.6.0
python .github/scripts/release_metadata.py check --tag v3.6.0 --strict
```

To test the GitHub Actions flow without creating a release, run the `Release`
workflow manually with:

- `tag`: an existing `vX.Y.Z` tag
- `dry_run`: `true`

Dry runs validate metadata, build artifacts, download the Action artifact zips,
copy the map from the latest release, and prepare release notes. They skip tag
updates, release creation, asset upload, publishing, and the metadata pull
request.

## Assets

The release workflow uploads the GitHub Actions artifact archives directly as
release assets:

- `canary-linux-release.zip`
- `canary-linux-debug.zip`
- `canary-windows-cmake-release.zip`
- `canary-windows-solution-debug.zip`
- `canary-macos-release.zip`
- `canary-docker.zip`
- `otservbr.otbm`

`otservbr.otbm` is copied from the latest published GitHub release. If the map
needs a new file, replace the map asset on the release after the automated
publish step.
