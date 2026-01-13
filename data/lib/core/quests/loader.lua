local currentNamespace

local function ensureQuestCatalogLoader(namespace, catalogDirectory)
	local searchers = package.searchers or package.loaders
	local loaderRegistryName = namespace .. ".loader"
	if package.loaded[loaderRegistryName] then
		return
	end

	local dirSeparator = package.config:sub(1, 1)
	local prefix = namespace .. "."

	local function questCatalogLoader(moduleName)
		if moduleName ~= namespace and moduleName:sub(1, #prefix) ~= prefix then
			return nil
		end
		local filePath
		if moduleName == namespace then
			filePath = catalogDirectory .. dirSeparator .. "init.lua"
		else
			local relative = moduleName:sub(#prefix + 1):gsub("%.", dirSeparator)
			filePath = catalogDirectory .. dirSeparator .. relative .. ".lua"
		end
		local loader, errorMessage = loadfile(filePath)
		if not loader then
			return "\n\t" .. errorMessage
		end
		return loader, filePath
	end

	table.insert(searchers, 1, questCatalogLoader)
	package.loaded[loaderRegistryName] = true
end

local function loadQuestCatalog(dataDirectory)
	local dirSeparator = package.config:sub(1, 1)
	local namespace = dataDirectory .. ".lib.core.quests.catalog"
	if Quests and currentNamespace == namespace then
		return Quests
	end
	local catalogDirectory = table.concat({ dataDirectory, "lib", "core", "quests", "catalog" }, dirSeparator)

	ensureQuestCatalogLoader(namespace, catalogDirectory)

	Quests = require(namespace)
	currentNamespace = namespace
	return Quests
end

return {
	load = loadQuestCatalog,
}
