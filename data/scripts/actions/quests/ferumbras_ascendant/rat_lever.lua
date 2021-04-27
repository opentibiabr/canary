local config = {
	centerRoom = Position(33215, 31456, 12),
	BossPosition = Position(33220, 31460, 12),
	playerPositions = {
		Position(33197, 31475, 11),
		Position(33198, 31475, 11),
		Position(33199, 31475, 11),
		Position(33200, 31475, 11),
		Position(33201, 31475, 11)
	},
	newPosition = Position(33215, 31470, 12)
}

local ferumbrasAscendantRatLever = Action()
function ferumbrasAscendantRatLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33201, 31475, 11) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 30, 30, 30, 30)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with The Lord of The Lice.")
				return true
			end
		end
		Game.createMonster("the lord of the lice", config.BossPosition, true, true)
		for x = 33197, 33201 do
			local playerTile = Tile(Position(x, 31475, 11)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33187, 31429, 12), Position(33242, 31487, 12), Position(33319, 32318, 13))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantRatLever:uid(1030)
ferumbrasAscendantRatLever:register()