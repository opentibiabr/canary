# Database Migration System

This document provides an overview of the current database migration system for the project. The migration process has been streamlined to ensure that all migration scripts are automatically applied in order, making it easier to maintain database updates.

## How It Works

The migration system is designed to apply updates to the database schema or data whenever a new server version is started. Migration scripts are stored in the `migrations` directory, and the system will automatically apply any scripts that have not yet been executed.

### Steps Involved

1. **Retrieve Current Database Version**:
   - The system first retrieves the current version of the database using `getDatabaseVersion()`.
   - This version is used to determine which migration scripts need to be executed.

2. **Migration Files Directory**:
   - All migration scripts are stored in the `migrations` directory.
   - Each migration script is named using a numerical pattern, such as `1.lua`, `2.lua`, etc.
   - The naming convention helps determine the order in which scripts should be applied.

3. **Execute Migration Scripts**:
   - The migration system iterates through the migration directory and applies each migration script that has a version greater than the current database version.
   - Only scripts that have not been applied are executed.
   - The Lua state (`lua_State* L`) is initialized to run each script.

4. **Update Database Version**:
   - After each migration script is successfully applied, the system updates the database version to reflect the applied change.
   - This ensures that the script is not re-applied on subsequent server startups.

## Example Migration Script

Below is an example of what a migration script might look like. Note that no return value is required, as all migration files are applied based on the current database version.

```lua
-- Migration script example (for documentation purposes only)
-- This migration script should include all necessary SQL commands or operations to apply a specific update to the database.

-- Example: Adding a new column to the "players" table
local query = [[
    ALTER TABLE players ADD COLUMN new_feature_flag TINYINT(1) NOT NULL DEFAULT 0;
]]

-- Execute the query
db.execute(query)  -- This function executes the given SQL query on the database.

-- Note: Ensure that queries are validated to avoid errors during the migration process.
