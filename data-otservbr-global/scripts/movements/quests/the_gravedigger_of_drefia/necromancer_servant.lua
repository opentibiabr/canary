local necromancerServant = MoveEvent()

function necromancerServant.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission56) == 1
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) ~= 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission57, 1)
		Game.createMonster('necromancer servant', Position(33011, 32437, 11))
	end
end

necromancerServant:type("stepin")
necromancerServant:aid(4541, 4542)
necromancerServant:register()
