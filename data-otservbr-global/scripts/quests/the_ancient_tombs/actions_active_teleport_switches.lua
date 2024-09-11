local config = {
	[12121] = {
		storage = Storage.Quest.U7_4.TheAncientTombs.ThalasSwitchesGlobalStorage,
		specificCheck = function(player)
			if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.ThalasTreasure) <= 0 then
				player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.ThalasTreasure, 1)
			end
		end,
	},
	[12122] = {
		storage = Storage.Quest.U7_4.TheAncientTombs.DiprathSwitchesGlobalStorage,
		specificCheck = function(player)
			if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure) <= 1 then
				player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure, 2)
			end
		end,
	},
	[12123] = {
		storage = Storage.Quest.U7_4.TheAncientTombs.AshmunrahSwitchesGlobalStorage,
		specificCheck = function(player) end,
	},
}

local function resetScript(position, storage, configEntry, playerId)
	local item = Tile(position):getItemById(2773)
	if item then
		item:transform(2772)
	end

	local player = Player(playerId)
	if player then
		if configEntry.specificCheck then
			configEntry.specificCheck(player)
		end

		player:setStorageValue(storage, player:getStorageValue(storage) - 1)
	end
end

local theAncientActiveTeleport = Action()
function theAncientActiveTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local configEntry = config[item.actionid]
	if not configEntry then
		return true
	end

	local storage = configEntry.storage or configEntry
	if item.itemid ~= 2772 then
		return false
	end

	player:setStorageValue(storage, player:getStorageValue(storage) + 1)
	item:transform(2773)
	addEvent(resetScript, 20 * 60 * 1000, toPosition, storage, configEntry, player:getId())
	return true
end

for actionId, info in pairs(config) do
	theAncientActiveTeleport:aid(actionId)
end

theAncientActiveTeleport:register()
