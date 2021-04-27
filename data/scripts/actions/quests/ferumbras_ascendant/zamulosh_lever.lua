local config = {
	centerRoom = Position(33643, 32756, 11),
	BossPosition = Position(33643, 32756, 11),
	newPosition = Position(33644, 32760, 11),
	zamuloshSummons = {
		Position(33642, 32756, 11),
		Position(33642, 32756, 11),
		Position(33642, 32756, 11),
		Position(33644, 32756, 11),
		Position(33644, 32756, 11),
		Position(33644, 32756, 11)
	}
}

local ferumbrasAscendantZamulosh = Action()
function ferumbrasAscendantZamulosh.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33680, 32741, 11) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local specs, spec = Game.getSpectators(config.centerRoom, false, false, 15, 15, 15, 15)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with Zamulosh.")
				return true
			end
		end
		Game.createMonster("Zamulosh", config.BossPosition, true, true)
		for d = 1, #config.zamuloshSummons do
			Game.createMonster('Zamulosh3', config.zamuloshSummons[d], true, true)
		end
		for y = 32741, 32745 do
			local playerTile = Tile(Position(33680, y, 11)):getTopCreature()
			if playerTile and playerTile:isPlayer() then
				playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
				playerTile:teleportTo(config.newPosition)
				playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		Game.setStorageValue(GlobalStorage.FerumbrasAscendant.ZamuloshTimer, 1)
		addEvent(clearForgotten, 30 * 60 * 1000, Position(33634, 32749, 11), Position(33654, 32765, 11), Position(33319, 32318, 13), GlobalStorage.FerumbrasAscendant.ZamuloshTimer)
		item:transform(9826)
	elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end

ferumbrasAscendantZamulosh:uid(1026)
ferumbrasAscendantZamulosh:register()