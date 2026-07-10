# MCP Architecture for the Canary AI Agent

Status: initial design

## 1. Design goals

The MCP layer must expose narrow, typed and auditable operations. The language model must not receive unrestricted shell or production write access.

Each write operation must return:

- affected files,
- generated diff,
- validation result,
- warnings,
- rollback information.

## 2. MCP services

### `ots-repository-mcp`

Read operations:

- `getProjectProfile`
- `listFiles`
- `readFile`
- `searchText`
- `findSymbol`
- `findReferences`
- `getDiff`

Controlled write operations:

- `createTaskBranch`
- `writeFile`
- `deleteFile`
- `commitTaskChanges`
- `openDraftPullRequest`
- `rollbackTask`

### `ots-index-mcp`

- `buildProjectIndex`
- `refreshProjectIndex`
- `findContentDefinition`
- `findContentReferences`
- `listRegisteredScripts`
- `listLuaApiFunctions`
- `getDependencyGraph`

### `ots-id-registry-mcp`

- `scanStorageKeys`
- `scanActionIds`
- `scanUniqueIds`
- `scanItemIds`
- `findIdConflicts`
- `reserveIdRange`
- `releaseIdReservation`
- `getIdReservationReport`

### `ots-content-mcp`

Initial read-only operations:

- `getMonster`
- `getNpc`
- `getQuest`
- `getItem`
- `getSpell`
- `getRaid`

Future controlled write operations:

- `createMonster`
- `updateMonster`
- `createNpc`
- `updateNpc`
- `createQuest`
- `updateQuest`
- `createItem`
- `updateItem`
- `createSpell`
- `updateSpell`

### `ots-runtime-mcp`

- `configureBuild`
- `buildServer`
- `startTestStack`
- `stopTestStack`
- `restartTestServer`
- `getServerLogs`
- `getRuntimeHealth`

### `ots-testing-mcp`

- `runUnitTests`
- `runIntegrationTests`
- `validateLua`
- `validateXml`
- `validateSql`
- `validateContentReferences`
- `validateIdRegistry`
- `generateTestReport`

### `ots-map-mcp`

Disabled during bootstrap.

It may be enabled only after confirming:

- OTBM version,
- item metadata compatibility,
- map path,
- safe parser/writer round-trip,
- deterministic map diff representation,
- backup and rollback process.

Planned operations:

- `openMap`
- `inspectArea`
- `findFreeArea`
- `copyArea`
- `createArea`
- `placeItem`
- `createSpawn`
- `createTeleport`
- `validateMap`
- `renderMapPreview`
- `saveMapTransaction`

## 3. Permissions

| Service | Bootstrap | Content MVP | Map MVP |
|---|---:|---:|---:|
| Repository read | yes | yes | yes |
| Repository write on `ai/*` | yes | yes | yes |
| C++ modification | no | controlled | controlled |
| Lua/XML modification | no | controlled | controlled |
| Database migration | no | controlled | controlled |
| Map write | no | no | controlled |
| Production deployment | no | no | no |

## 4. Task transaction

Every agent task must follow this state machine:

```text
RECEIVED
  -> ANALYZING
  -> PLANNED
  -> BRANCH_CREATED
  -> IDS_RESERVED
  -> CHANGES_APPLIED
  -> VALIDATING
  -> TESTING
  -> REPORT_READY
  -> DRAFT_PR_READY
```

Failure at any stage moves the task to:

```text
FAILED_VALIDATION
  -> ROLLED_BACK
```

## 5. Required task record

```json
{
  "taskId": "uuid",
  "request": "natural-language request",
  "branch": "ai/task-name",
  "baseCommit": "sha",
  "affectedSystems": [],
  "reservedIds": [],
  "changedFiles": [],
  "validation": {},
  "tests": {},
  "warnings": [],
  "status": "PLANNED"
}
```

## 6. First implementation order

1. Repository read tools.
2. Project index tools.
3. ID registry scanners.
4. Lua/XML validators.
5. Build and CTest wrappers.
6. Controlled content writers.
7. Map parser and read-only inspection.
8. Transactional map writer.

## 7. Security requirements

- No direct writes to `main`.
- No production credentials in MCP configuration.
- Path allowlist restricted to the repository workspace.
- Every file write requires a task ID.
- Every destructive operation requires a reversible snapshot.
- Binary map writes require checksum verification.
- Runtime commands use an allowlist, not arbitrary command strings.
- Secrets are referenced by environment-variable name and never returned to the model.
