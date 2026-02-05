# Scribe's Journal ✍️

## Ambiguities & Magic Logic

### 1. Auto-Configuration Magic
- **File**: `src/canary_server.cpp` (Method: `loadConfigLua`)
- **Behavior**: The server automatically copies `config.lua.dist` to `config.lua` if `config.lua` is missing.
- **Impact**: New users might not realize they are using default credentials/settings if they don't check the created file. Documentation should explicitly mention this auto-creation behavior.

### 2. Hardcoded Datapack Names
- **File**: `src/canary_server.cpp` (Method: `validateDatapack`)
- **Behavior**: The server strictly validates the datapack folder name. It MUST be `data-canary` or `data-otservbr-global` unless `USE_ANY_DATAPACK_FOLDER` is set to `true` in config.
- **Impact**: Custom datapacks will fail to load with a generic error unless this specific config flag is toggled.

### 3. Database Initialization Dependency
- **File**: `src/canary_server.cpp` (Method: `initializeDatabase`)
- **Behavior**: The server checks `DatabaseManager::isDatabaseSetup()` but relies on `schema.sql` being imported externally.
- **Impact**: The Docker setup handles this via `../schema.sql:/docker-entrypoint-initdb.d/init.sql`, but manual setup users must import `schema.sql` manually.

### 4. KV Store Coupling
- **File**: `src/kv/README.md` / `schema.sql`
- **Behavior**: The KV system is an abstraction but heavily relies on the `kv_store` table existing in the MySQL database.
- **Impact**: Any modification to the KV system backend requires ensuring the database schema is synchronized.

## Knowledge Gaps
- **Docker Environment**: The `docker/` folder contains multiple Dockerfiles (`.x86`, `.arm`, `.dev`), but `docker-compose.yml` points to `Dockerfile.dev`. It is unclear if production deployments should use `Dockerfile.x86` manually.
