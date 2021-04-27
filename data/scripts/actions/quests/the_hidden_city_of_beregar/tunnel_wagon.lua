local theHiddenTunnel = Action()
function theHiddenTunnel.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rubblePosition = Position(32619, 31514, 9)
	if Tile(rubblePosition):getItemById(5709) then
		player:teleportTo(Position(32580, 31487, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY)
		return true
	end

	if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) ~= 2 then
		return false
	end

	player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 3)
	player:teleportTo(Position(32625, 31514, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("You safely passed the tunnel.", TALKTYPE_MONSTER_SAY)
	Game.createItem(5709, 1, rubblePosition)

	local wallItem = Tile(Position(32617, 31513, 9)):getItemById(1027)
	if wallItem then
		wallItem:remove()
	end

	local archwayItem = Tile(Position(32617, 31514, 9)):getItemById(1205)
	if archwayItem then
		archwayItem:remove()
	end

	return true
end

theHiddenTunnel:aid(50115)
theHiddenTunnel:register()