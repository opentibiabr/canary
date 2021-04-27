local config = {
	centerRoom = Position(33172, 31501, 13),
	BossPosition = Position(33172, 31501, 13),
	playerPositions = {
		Position(33229, 31500, 13),
		Position(33229, 31501, 13),
		Position(33229, 31502, 13),
		Position(33229, 31503, 13),
		Position(33229, 31504, 13)
	},
	newPosition = Position(33173, 31504, 13)
}

local ferumbrasAscendantPlagirathLever = Action()
function ferumbrasAscendantPlagirathLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33229, 31500, 13) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Plagirath.")
				return true
			end
		end
		Game.createMonster("Plagirath", config.BossPosition, true, true)
		for y = 31500, 31504 do
			local playerTile = Tile(Position(33229, y, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		Game.setStorageValue(GlobalStorage.FerumbrasAscendant.PlagirathTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33159, 31491, 13), Position(33185, 31513, 13), Position(33319, 32318, 13), GlobalStorage.FerumbrasAscendant.PlagirathTimer)
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantPlagirathLever:uid(1022)
ferumbrasAscendantPlagirathLever:register()