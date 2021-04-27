local config = {
	centerRoom = Position(33422, 32467, 14),
	BossPosition = Position(33422, 32467, 14),
	newPosition = Position(33419, 32467, 14)
}

local ferumbrasAscendantRazzagornLever = Action()
function ferumbrasAscendantRazzagornLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33386, 32455, 14) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Razzagorn.")
				return true
			end
		end
		Game.createMonster("Razzagorn", config.BossPosition, true, true)
		for x = 33386, 33390 do
			local playerTile = Tile(Position(x, 32455, 14)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33408, 32454, 14), Position(33440, 32480, 14), Position(33319, 32318, 13))
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantRazzagornLever:uid(1024)
ferumbrasAscendantRazzagornLever:register()