local theHiddenGapWagon = Action()
function theHiddenGapWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(32571, 31508, 9))
	if not tile:getItemById(7122) then
		player:teleportTo(Position(32580, 31487, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) ~= 1 then
		return false
	end

	player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 2)
	player:teleportTo(Position(32578, 31507, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("You safely passed the gap but your bridge collapsed behind you.", TALKTYPE_MONSTER_SAY)

	local items = tile:getItems()
	for i = 1, tile:getItemCount() do
		local tmpItem = items[i]
		if isInArray({7122, 5770}, tmpItem:getId()) then
			tmpItem:remove()
		end
	end

	return true
end

theHiddenGapWagon:aid(50112)
theHiddenGapWagon:register()