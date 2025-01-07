local enrage = CreatureEvent("enrageSoulPit")
function enrage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature or not creature:isMonster() and creature:getMaster() then
		return true
	end

	local healthPercentage = creature:getHealth() / creature:getMaxHealth()

	for bounds, reduction in pairs(SoulPit.bossAbilities.enrageSoulPit.bounds) do
		if healthPercentage > bounds[2] and healthPercentage <= bounds[1] then
			return primaryDamage * reduction, primaryType, secondaryDamage * reduction, secondaryType
		end
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
enrage:register()
