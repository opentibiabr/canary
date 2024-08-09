local pirate = MoveEvent()

function pirate.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03) == 1 then
		player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03, 2)
		Game.createMonster("pirate buccaneer", Position(32641, 32733, 7))
		Game.createMonster("pirate buccaneer", Position(32642, 32733, 7))
	end
	return true
end

pirate:type("stepin")
pirate:aid(12571)
pirate:register()
