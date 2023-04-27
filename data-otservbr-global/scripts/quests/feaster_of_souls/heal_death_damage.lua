
local healDeathDamage = CreatureEvent("healDeathDamage")

function healDeathDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_DEATHDAMAGE or secondaryType == COMBAT_DEATHDAMAGE then
		primaryType = COMBAT_HEALING
		primaryDamage = (primaryDamage + secondaryDamage)
		secondaryType = COMBAT_NONE
		secondaryDamage = 0
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
healDeathDamage:register()

