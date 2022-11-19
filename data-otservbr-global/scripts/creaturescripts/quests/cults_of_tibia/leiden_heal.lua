local leidenHeal = CreatureEvent("LeidenHeal")
function leidenHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if creature:getName():lower() == "leiden" then
		if attacker and attacker:isPlayer() then
			primaryType = COMBAT_HEALING
			secondaryType = primaryType
			if primaryDamage < 0 then
				primaryDamage = primaryDamage * -1
			end
			secondaryDamage = primaryDamage
			creature:addHealth(primaryDamage < 0 and -primaryDamage or primaryDamage)
			return primaryDamage, primaryType, secondaryDamage, secondaryType
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

leidenHeal:register()
