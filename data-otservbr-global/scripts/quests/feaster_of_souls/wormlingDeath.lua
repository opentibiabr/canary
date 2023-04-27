local area = createCombatArea(AREA_CIRCLE2X2)

local wormlingDeath = CreatureEvent("wormlingDeath")
function wormlingDeath.onPrepareDeath(creature)
	doAreaCombatHealth(creature, COMBAT_EARTHDAMAGE, creature:getPosition(), area, -750, -750, CONST_ME_HITBYPOISON)
	return true
end
wormlingDeath:register()