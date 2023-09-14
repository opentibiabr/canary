local function chargerSpawn(pos)
	Game.createMonster("charger", pos, false, true)
	spawningCharge = false
	return true
end

local chargerSpawn = CreatureEvent("ChargerSpawn")
function chargerSpawn.onDeath(creature)
	local positions = {
		{x = 32151, y = 31356, z = 14},
		{x = 32154, y = 31353, z = 14},
		{x = 32153, y = 31361, z = 14},
		{x = 32158, y = 31362, z = 14},
		{x = 32161, y = 31360, z = 14},
		{x = 32156, y = 31357, z = 14},
		{x = 32159, y = 31354, z = 14},
		{x = 32163, y = 31356, z = 14},
		{x = 32162, y = 31352, z = 14},
		{x = 32158, y = 31350, z = 14},
	}

	local pos = positions[math.random(1, #positions)]
	addEvent(chargerSpawn, 6000, pos)
	spawningCharge = true
	return true
end

chargerSpawn:register()
