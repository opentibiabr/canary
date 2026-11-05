# World file publication and recovery

The server, editor and migration tool read the same catalog and explicitly listed
documents. A writer publishes dependencies before the catalog. No OTBM fields
are used for this protocol.

## Publication boundary

The shared `world_files` service uses the following catalog sidecars:

| Suffix | Purpose |
| --- | --- |
| `.lock` | Operating-system lock shared by cooperating readers and writers |
| `.pending` | Indicates an incomplete publication requiring recovery |
| `.revision` | Detects publication overlapping an initial reader, before a lock existed |
| `.transactions/<transaction-id>/` | Journal, immutable before/after snapshots and displaced files |

These are recovery metadata, not active World definitions. Discovery must never
activate files inside transaction directories. Do not remove a pending marker to
bypass recovery: its files may belong to different revisions.

A publication has an explicit authorized root, exact expected file bytes and an
ordered set of replacements. Absence is distinct from an empty file. The service
rejects repeated targets, reserved sidecars, targets outside that root and stale
revisions before changing active files. Read-only dependencies can be outside
the publication root and remain revision guards during recovery.

Each previous file is displaced into recovery storage and verified again. A new
file name is installed only if absent. A competing version found during either
operation is preserved; publication stays incomplete. Existing files are never
replaced using an unchecked overwrite after a separate existence test.

Windows uses `MoveFileExW` without replacement for data files. Linux uses
[`renameat2` with `RENAME_NOREPLACE`](https://man7.org/linux/man-pages/man2/rename.2.html).
macOS uses `renamex_np` with the
[`RENAME_EXCL` flag](https://github.com/apple-oss-distributions/xnu/blob/main/bsd/sys/stdio.h).
Unsupported exclusive rename operations fail rather than falling back to a
link/unlink sequence. On POSIX systems, locks are advisory: other applications
can ignore them, so snapshots and revision checks remain necessary.

Only after all files and dependencies still match the publication does the
writer publish its revision token and remove the pending marker. Readers reject
pending projects. Readers also retain the exact bytes they parsed and verify
them before exposing the loaded project.

## Recovery

In RME, **Worlds > Manage > Review external changes** offers to finish an
interrupted save or restore the previous files. Opening an associated map also
checks for an interrupted publication. Recovery checks the catalog, authorized
root, every target and all recorded read-only dependencies before proceeding.

Recovery accepts only known before/after versions or files displaced by a
recorded interrupted operation. A later unrecognized edit remains untouched.
Resolve that conflict explicitly before retrying. Recovery can itself be
interrupted and retried; its displaced files remain available.

Completed transaction directories are retained for inspection and recovery of
displaced content. No automatic cleanup policy is applied to them.

## Editor revisions

RME observes document directories, groups short bursts of write notifications
and periodically checks the actual files. It also checks after regaining focus.
Modal property edits finish before any external revision is published into the
editor session.

Unrelated file changes reload while retaining local edits. Same-file conflicts
provide base/local/disk comparison, a separate draft copy, and confirmed reload.
Invalid JSON leaves the last valid document and unsaved edits in memory. A
removed file is not interpreted as an empty document. Changed descriptor fields
retain incompatible instance values and report validation errors.

History commands carry document revisions. Commands depending on replaced
revisions are retired before their map or World changes can execute. Independent
map actions and unaffected document actions remain available.

## Validation coverage

The standalone file contract exercises stale revisions, cooperating reader
locks, the first-publication race, interruption between files, interruption
after displacement, competing replacement and creation, recovery races,
interrupted recovery and external dependency changes. Fault-injection hooks
exist only in that test target.

Editor document tests cover unrelated reload with undo/redo, overlapping edits,
invalid JSON, draft preservation, confirmed discard limited to conflicting
files, deletion, catalog-directed rename and unchanged OTBM bytes. Native UI
walkthroughs and in-game validation remain separate acceptance checks.
