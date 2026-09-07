local updatePlayerOnAdvancedLevel = CreatureEvent("UpdatePlayerOnAdvancedLevel")
local advanceSaveDelay = 1000
local pendingAdvanceSaves = {}

local function saveAdvancedPlayer(playerId, playerGuid)
	if pendingAdvanceSaves[playerId] ~= playerGuid then
		return
	end

	pendingAdvanceSaves[playerId] = nil

	local currentPlayer = Player(playerId)
	if not currentPlayer or currentPlayer:getGuid() ~= playerGuid then
		return
	end

	currentPlayer:save()
end

local function scheduleAdvancedPlayerSave(player)
	local playerId = player:getId()
	local playerGuid = player:getGuid()
	if pendingAdvanceSaves[playerId] == playerGuid then
		return
	end

	pendingAdvanceSaves[playerId] = playerGuid
	addEvent(saveAdvancedPlayer, advanceSaveDelay, playerId, playerGuid)
end

function updatePlayerOnAdvancedLevel.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:getFinalLowLevelBonus()
	scheduleAdvancedPlayerSave(player)
	return true
end

updatePlayerOnAdvancedLevel:register()
