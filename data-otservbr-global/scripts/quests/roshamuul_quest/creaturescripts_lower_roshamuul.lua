local setting = {
	["frazzlemaw"] = ROSHAMUUL_KILLED_FRAZZLEMAWS,
	["silencer"] = ROSHAMUUL_KILLED_SILENCERS,
}

local lowerRoshamuul = CreatureEvent("RoshamuulKillsDeath")
function lowerRoshamuul.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local monster = setting[creature:getName():lower()]
	if not monster then
		return true
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		player:setStorageValue(monster, math.max(0, player:getStorageValue(monster)) + 1)
	end)
	return true
end

lowerRoshamuul:register()
