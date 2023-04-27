
local healFireDamage = CreatureEvent("healFireDamage")

function healFireDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_FIREDAMAGE or secondaryType == COMBAT_FIREDAMAGE then
		primaryType = COMBAT_HEALING
		primaryDamage = (primaryDamage + secondaryDamage)
		secondaryType = COMBAT_NONE
		secondaryDamage = 0
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
healFireDamage:register()

