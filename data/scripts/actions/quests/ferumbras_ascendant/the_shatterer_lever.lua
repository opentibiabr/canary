local config = {
	centerRoom = Position(33406, 32418, 14),
	BossPosition = Position(33406, 32418, 14),
	playerPositions = {
		Position(33403, 32465, 13),
		Position(33404, 32465, 13),
		Position(33405, 32465, 13),
		Position(33406, 32465, 13),
		Position(33407, 32465, 13)
	},
	newPosition = Position(33398, 32414, 14)
}

local ferumbrasAscendantTheShattererLever = Action()
function ferumbrasAscendantTheShattererLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33403, 32465, 13) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 30, 30, 30, 30)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with The Shatterer.")
				return true
			end
		end
		Game.createMonster("The Shatterer", config.BossPosition, true, true)
		for x = 33403, 33407 do
			local playerTile = Tile(Position(x, 32465, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		Game.setStorageValue(Storage.FerumbrasAscension.TheShattererTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33377, 32390, 14), Position(33446, 32447, 14), Position(33319, 32318, 13), Storage.FerumbrasAscension.TheShattererTimer)
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantTheShattererLever:uid(1029)
ferumbrasAscendantTheShattererLever:register()