# Canary Release Flow

Canary releases are published from stable SemVer tags such as `v3.6.0`. Pushing
a release tag starts `.github/workflows/release.yml`, materializes release
metadata from the tag inside the GitHub Actions checkout, builds the release
artifacts, copies `otservbr.otbm` from the latest published release, publishes
the GitHub release after all assets are uploaded, and opens a pull request that
syncs tracked release metadata back to `main`.

## Publish

Create and push the tag from the commit you want to release:

```bash
git tag -a v3.6.0 -m v3.6.0
git push origin v3.6.0
```

The tag is the source of truth for the release version. The workflow rewrites
release-only metadata in its own checkout before building, so a release does not
need a separate pull request just to change `3.5.0` to `3.6.0`.

After publishing, the workflow opens or updates a branch named like
`release-v3.6.0-metadata` with the permanent metadata changes. Review
and merge that pull request to keep `main` aligned with the latest release.

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
copy the map from the latest release, and prepare release notes. They skip
release creation, asset upload, publishing, and the metadata pull request.

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
