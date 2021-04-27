function onCastSpell(creature, var)
local center, center2 = {x=33529, y=32334, z=12, stackpos=255}, {x=33528, y=32334, z=12, stackpos=255}
	creature:say("GET OVER HERE!", TALKTYPE_ORANGE_2, false, 0, center2)
	for x = 33519, 33538 do
		for y = 32327, 32342 do
			local a = Tile(Position({x = x, y = y, z = 12})):getTopCreature()
			if a ~= 0 and isMonster(a) and creature:getName():lower() ~= "prince drazzak" or isPlayer(a) then
				a:teleportTo(center, true)
				creature:teleportTo(center2, true)
			end
		end
	end
return true
end
