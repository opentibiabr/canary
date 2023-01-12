local chargingOutDeath = CreatureEvent("ChargingOutDeath")
function chargingOutDeath.onDeath(creature)
	if chargingOutKilled == false then
		local monster = Game.createMonster("outburst", {x = 32234, y = 31285, z = 14}, false, true)
		monster:addHealth(-monster:getHealth() + outburstHealth, COMBAT_PHYSICALDAMAGE)
	end
	return true
end
chargingOutDeath:register()
