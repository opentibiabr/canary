
local function respawnWorm()
	local weakSpot = Creature("A Weak Spot")
	if weakSpot then
		Game.createMonster("Hunger Worm", Position({x = 33805, y = 31499, z = 14}), false, true)
	end
end
local respawnHungerWorm = CreatureEvent("respawnHungerWorm")
function respawnHungerWorm.onDeath(creature)
	addEvent(respawnWorm, 5000)
	return true
end
respawnHungerWorm:register()
