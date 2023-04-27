
local phobiaDeath = CreatureEvent("phobiaDeath")
function phobiaDeath.onDeath(creature)
	local chance = math.random(2)
	if chance == 1 then
		creature:say("THE PHOBIA EVOLVES INTO HORROR!")
		Game.createMonster("Horror", ({Position({x = 33708, y = 31468, z = 14}),	Position({x = 33711, y = 31468, z = 14}), Position({x = 33714, y = 31468, z = 14})})[math.random(1,3)], false, true)
	else
		creature:say("THE PHOBIA EVOLVES INTO FEAR!")
		Game.createMonster("Fear", ({Position({x = 33708, y = 31468, z = 14}),	Position({x = 33711, y = 31468, z = 14}), Position({x = 33714, y = 31468, z = 14})})[math.random(1,3)], false, true)
	end
	return true
end
phobiaDeath:register()
