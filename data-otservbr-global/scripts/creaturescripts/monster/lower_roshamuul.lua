local setting = {
	["frazzlemaw"] = ROSHAMUUL_KILLED_FRAZZLEMAWS,
	["silencer"] = ROSHAMUUL_KILLED_SILENCERS,
}

local lowerRoshamuul = CreatureEvent("LowerRoshamuul")
function lowerRoshamuul.onKill(creature, target)
	local monster = setting[target:getName():lower()]
	if monster then
		creature:setStorageValue(monster, math.max(0, creature:getStorageValue(monster)) + 1)
	end
	return true
end

lowerRoshamuul:setMonster("frazzlemaw", "silencer")
lowerRoshamuul:register()
