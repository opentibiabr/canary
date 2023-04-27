
local healEnergyDamage = CreatureEvent("healEnergyDamage")

function healEnergyDamage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_ENERGYDAMAGE or secondaryType == COMBAT_ENERGYDAMAGE then
		primaryType = COMBAT_HEALING
		primaryDamage = (primaryDamage + secondaryDamage)
		secondaryType = COMBAT_NONE
		secondaryDamage = 0
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
healEnergyDamage:register()

