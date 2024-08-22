local chargingOutDeath = CreatureEvent("ChargingOutDeath")

function chargingOutDeath.onDeath(creature)
	local chargingOutKilled = Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstChargingKilled)
	if chargingOutKilled < 1 then
		local monster = Game.createMonster("Outburst", Position(32234, 31285, 14), false, true)
		if monster then
			local outburstHealth = Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth) or 0
			monster:addHealth(-monster:getHealth() + outburstHealth, COMBAT_PHYSICALDAMAGE)
		end
	end
	return true
end

chargingOutDeath:register()
