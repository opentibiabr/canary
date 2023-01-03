local ec = EventCallback

function ec.onDrainHealth(creature, attacker, typePrimary, damagePrimary,
				typeSecondary, damageSecondary, colorPrimary, colorSecondary)
	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	return damagePrimary, typePrimary, damageSecondary, typeSecondary
end

ec:register(--[[0]])
