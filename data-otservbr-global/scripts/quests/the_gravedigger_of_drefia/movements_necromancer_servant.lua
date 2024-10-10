local necromancerServant = MoveEvent()

function necromancerServant.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission56) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission57) < 1 then
		Game.createMonster("necromancer servant", Position(33011, 32437, 11))
	end

	return true
end

necromancerServant:type("stepin")
necromancerServant:aid(4536)
necromancerServant:register()
