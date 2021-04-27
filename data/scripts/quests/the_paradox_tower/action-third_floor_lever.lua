local thirdFloorLever = Action()

function thirdFloorLever.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Create stair
	-- The stair is only created if all the jungles of the "position" variable (line 1) are growing again
	if item.itemid == 10044 then
		-- Checks if all levers glass are in the correct positions
		addEvent(
			function()
				Game.createMonster("ghoul", {x = 32479, y = 31900, z = 5})
			end, 2000)
			item:transform(10045)
		addEvent(
			function()
				Position.hasCreatureInArea({x= 32476, y = 31900, z = 5}, {x= 32481, y = 31901, z = 5}, true, false)
				item:transform(10044)
			end, 100000)
	elseif item.itemid == 10045 then
		player:sendCancelMessage(RETURNVALUE_CANNOTUSETHISOBJECT)
	end
	return true
end

thirdFloorLever:uid(30026)
thirdFloorLever:register()
