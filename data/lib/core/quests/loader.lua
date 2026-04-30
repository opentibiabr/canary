local function loadQuestCatalog(dataDirectory)
	local dirSeparator = package.config:sub(1, 1)
	local namespace = dataDirectory .. ".lib.core.quests.catalog"
	-- Guard against redundant reloads.  Since this file is loaded via dofile
	-- (no require caching), use a global to track whether quests are already
	-- loaded for the given namespace.
	if Quests and _G._questCatalogNamespace == namespace then
		return Quests
	end
	local catalogDirectory = table.concat({ dataDirectory, "lib", "core", "quests", "catalog" }, dirSeparator)

	-- Load init.lua directly via dofile instead of going through require's
	-- package.searchpath machinery.  On macOS ARM64 where LuaJIT runs in
	-- interpreter-only mode, the string operations in searchpath across many
	-- nested require calls cause severe startup delays.
	local initPath = catalogDirectory .. dirSeparator .. "init.lua"
	Quests = dofile(initPath)
	_G._questCatalogNamespace = namespace
	return Quests
end

return {
	load = loadQuestCatalog,
}
