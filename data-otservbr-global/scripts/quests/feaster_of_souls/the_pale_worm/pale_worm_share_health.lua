
local paleWormShareHealth = CreatureEvent("paleWormShareHealth")

function paleWormShareHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_UNDEFINEDDAMAGE or (primaryType == COMBAT_HEALING and origin == ORIGIN_NONE) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	if primaryType == COMBAT_DEATHDAMAGE or secondaryType == COMBAT_DEATHDAMAGE then
		primaryType = COMBAT_HEALING
		primaryDamage = (primaryDamage + secondaryDamage) * -1
		secondaryType = COMBAT_NONE
		secondaryDamage = 0
	end
	local brother = Creature("A Weak Spot")
	local unwelcome = Creature("The Pale Worm")
	if brother and unwelcome then
		local other = brother == creature and unwelcome or brother
		local value = primaryDamage + secondaryDamage
		if primaryType == COMBAT_HEALING then
			doTargetCombatHealth(0, other, COMBAT_HEALING, value, value, CONST_ME_NONE, ORIGIN_NONE)
		else
			doTargetCombatHealth(attacker and attacker or 0, other, COMBAT_UNDEFINEDDAMAGE, value, value, CONST_ME_NONE)
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
paleWormShareHealth:register()

