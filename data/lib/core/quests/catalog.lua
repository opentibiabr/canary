local function validateMissionId(missionId, questName, owners)
	if not missionId then
		return
	end
	local questOwners = owners[questName]
	if not questOwners then
		questOwners = {}
		owners[questName] = questOwners
	end
	if questOwners[missionId] then
		error(string.format('Duplicate mission id %d found in quest "%s"', missionId, questName))
	end
	questOwners[missionId] = true
end

local function validateStartStorage(quest, questName, owners)
	local storage = quest.startStorageId
	if not storage then
		return
	end
	local owner = owners[storage]
	if owner and owner ~= questName then
		error(string.format('Duplicate quest start storage %d found in quests "%s" and "%s"', storage, owner, questName))
	end
	owners[storage] = questName
end

local function buildCatalog(namespace, questModules)
	local quests = {}
	local missionOwners = {}
	local storageOwners = {}

	for index, moduleName in ipairs(questModules) do
		local quest = require(namespace .. "." .. moduleName)
		if type(quest) ~= "table" then
			error(string.format("Quest module %s did not return a table", moduleName))
		end
		local questName = quest.name or moduleName
		quests[index] = quest
		validateStartStorage(quest, questName, storageOwners)
		local missions = quest.missions
		if missions then
			for _, mission in pairs(missions) do
				if type(mission) == "table" then
					validateMissionId(mission.missionId, questName, missionOwners)
				end
			end
		end
	end

	return quests
end

return {
	build = buildCatalog,
}
