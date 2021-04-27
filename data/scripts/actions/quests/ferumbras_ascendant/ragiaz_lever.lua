local config = {
	centerRoom = Position(33481, 32334, 13),
	BossPosition = Position(33481, 32334, 13),
	newPosition = Position(33482, 32339, 13),
	deathDragons = {
		Position(33476, 32331, 13),
		Position(33476, 32340, 13),
		Position(33487, 32340, 13),
		Position(33488, 32331, 13)
	}
}

local ferumbrasAscendantRagiaz = Action()
function ferumbrasAscendantRagiaz.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33456, 32356, 13) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Ragiaz.")
				return true
			end
		end
		Game.createMonster("Ragiaz", config.BossPosition, true, true)
		for d = 1, #config.deathDragons do
			Game.createMonster('Death Dragon', config.deathDragons[d], true, true)
		end
		for x = 33456, 33460 do
			local playerTile = Tile(Position(x, 32356, 13)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		Game.setStorageValue(GlobalStorage.FerumbrasAscendant.RagiazTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33472, 32323, 13), Position(33493, 32347, 13), Position(33319, 32318, 13), GlobalStorage.FerumbrasAscendant.RagiazTimer)
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantRagiaz:uid(1023)
ferumbrasAscendantRagiaz:register()