local config = {
	[12121] = GlobalStorage.TheAncientTombs.ThalasSwitchesGlobalStorage,
	[12122] = GlobalStorage.TheAncientTombs.DiprathSwitchesGlobalStorage,
	[12123] = GlobalStorage.TheAncientTombs.AshmunrahSwitchesGlobalStorage
}

local function resetScript(position, storage)
	local item = Tile(position):getItemById(2773)
	if item then
		item:transform(2772)
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) - 1)
end

local theAncientActiveTeleport = Action()
function theAncientActiveTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storage = config[item.actionid]
	if not storage then
		return true
	end

	if item.itemid ~= 2772 then
		return false
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) + 1)
	item:transform(2773)
	addEvent(resetScript, 20 * 60 * 1000, toPosition, storage)
	return true
end

for actionId, info in pairs(config) do
	theAncientActiveTeleport:aid(actionId)
end

theAncientActiveTeleport:register()