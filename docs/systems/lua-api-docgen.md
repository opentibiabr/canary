# Lua API Documentation Generator

Canary generates Lua API reference files from the C++ Lua binding layer during
startup when `generateLuaApiDocs` is enabled. The generated files live under
`docs/lua-api`:

- `lua_api.d.lua`: Lua Language Server definitions for editor autocomplete.
- `lua_api.md`: human-readable API reference.
- `lua_api.json`: structured metadata for tooling and CI checks.

The generator uses a hybrid model. Automatic scanning discovers most bindings,
while explicit `/*** */` docblocks correct signatures that need LuaLS-specific
types, overloads, fields, or multiple return values.

## VSCode IntelliSense Setup

Install the `Lua` extension for VSCode, then run this from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tools/setup_vscode_lua_api.ps1
```

The repository `.luarc.json` already includes `docs/lua-api` in
`workspace.library` and sets `workspace.preloadFileSize` high enough for
`lua_api.d.lua`. The script still updates the local `.vscode/settings.json`
file to include `${workspaceFolder}/docs/lua-api` in `Lua.workspace.library`.
If `.luarc.json` exists, it also keeps that project configuration aligned,
because LuaLS reads `.luarc.json` as project configuration and those settings
do not use the `Lua.` prefix. The helper also keeps generated build, cache,
Visual Studio, and vcpkg directories in `workspace.ignoreDir` so LuaLS does not
scan unrelated LuaJIT/vcpkg files.

For manual VSCode workspace setup, add this to `.vscode/settings.json`:

```json
{
  "Lua.workspace.library": [
    "${workspaceFolder}/docs/lua-api"
  ],
  "Lua.workspace.checkThirdParty": false
}
```

For manual project setup in `.luarc.json`, use unprefixed LuaLS keys:

```json
{
  "workspace.library": ["docs/lua-api"],
  "workspace.preloadFileSize": 1000,
  "workspace.checkThirdParty": false
}
```

The stub used by LuaLS is `docs/lua-api/lua_api.d.lua`. Canary updates the file
automatically during startup when `generateLuaApiDocs` is enabled, and CI also
checks that the committed generated docs stay synchronized.

## Adding Or Updating Bindings

When a C++ Lua binding is added or changed, update the generated docs in the
same PR. If the inferred signature uses weak placeholders such as `any`,
`argN`, `...`, or plain `table`, add a docblock immediately before the handler
or the relevant `Lua::register*` call:

```cpp
/***
 * @function Player:addItem
 * @param itemId number|string
 * @param count? number
 * @param canDropOnMap? boolean
 * @return Item|Item[]|nil|false
 */
int PlayerFunctions::luaPlayerAddItem(lua_State* L) {
```

Use registration-level docblocks when several Lua names share one C++ handler:

```cpp
/***
 * @function TalkAction:onSay
 * @param callback fun(player: Player, words: string, param: string, type: integer): boolean
 * @return boolean
 */
Lua::registerMethod(L, "TalkAction", "onSay", TalkActionFunctions::luaTalkActionOnSay);
```

For callable classes, document constructor signatures on the constructor
handler:

```cpp
/***
 * @class NetworkMessage
 * @overload fun(): NetworkMessage
 */
int NetworkMessageFunctions::luaNetworkMessageCreate(lua_State* L) {
```

Manual docblock types are LuaLS types. Preserve valid LuaLS expressions such as
`Item[]`, `table<string, MonsterType>`, `fun(success: boolean)`, `integer`,
`string|false`, and named multiple returns.

## Quality Baseline

`tools/check_lua_api_quality.py` reads `docs/lua-api/lua_api.json` and compares
the current weak-signature metrics against
`docs/lua-api/lua_api_quality_baseline.json`.

The check intentionally accepts the current documentation debt and fails only
when a PR increases one of these metrics:

- parameters typed as `any`;
- parameters named `argN`;
- vararg parameters;
- returns typed as `any`;
- returns typed as plain `table`.

After intentionally improving signatures, update the baseline with:

```bash
python3 tools/check_lua_api_quality.py --update-baseline
```

Do not raise the baseline unless a deliberate API change requires it and the PR
explains why the weaker signature is acceptable.

## CI Enforcement

The CI uses three checks to keep the generated docs useful and synchronized.

### Generated Docs Stay Current

The Linux release build runs the docgen-only startup mode:

```bash
./canary --generate-lua-api-docs-only
git diff --exit-code -- docs/lua-api
```

This mode loads `config.lua`, forces Lua API documentation generation, and
exits. It still uses `luaApiDocsOutputDirectory`, but it does not skip
generation if `generateLuaApiDocs` is disabled. It must not start the game
server, validate the datapack, load maps, connect to the database, or run
runtime smoke tests. The diff check fails if the committed files under
`docs/lua-api` are stale.

### Quality Does Not Regress

`tools/check_lua_api_quality.py` allows the existing weak-signature debt but
fails when a PR increases it.

### New Weak Bindings Need Docblocks

`tools/check_lua_api_binding_docs.py` inspects PR diffs for new Lua binding
registrations such as:

- `Lua::registerMethod`;
- `Lua::registerGlobalMethod`;
- `Lua::registerSharedClass`;
- `Lua::registerClass`.

For each new binding, map the registered Lua function to the generated
`lua_api.json` entry. If the generated signature contains weak placeholders
such as `any`, `argN`, `...`, `return: any`, or `return: table`, require a
nearby `/*** */` docblock with `@function`, `@param`, `@return`, `@class`, or
`@overload`.

The rule is:

```text
new binding + clean generated signature = allowed
new binding + weak generated signature = explicit docblock required
```

## Callback Signatures

Prefer precise LuaLS callback function types when the C++ callback contract is
known. Check the runtime callback invocation before documenting a callback, then
write the callback type in the binding docblock. Do not guess signatures.

When several Lua event names share one C++ registration handler, document each
`Lua::registerMethod` line separately. This keeps the generated `.d.lua`,
Markdown, and JSON entries precise without duplicating C++ handler functions.
