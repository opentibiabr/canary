local yalahariHealth = CreatureEvent("YalahariHealth")
function yalahariHealth.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getName():lower() == "zarcorix of yalahar" then
		if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
		if attacker and attacker:isPlayer() then
			if primaryDamage > 0 then
				attacker:addHealth(-primaryDamage)
			end
			if secondaryDamage > 0 then
				attacker:addHealth(-secondaryDamage)
			end
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

yalahariHealth:register()
