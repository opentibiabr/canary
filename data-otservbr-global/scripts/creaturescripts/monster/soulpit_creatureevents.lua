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

local overpower = CreatureEvent("overpowerSoulPit")
function overpower.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature and attacker and attacker:isMonster() and attacker:getForgeStack() == 40 and not attacker:getMaster() then
		local bonusCriticalDamage = SoulPit.bossAbilities.overpowerSoulPit.bonusCriticalDamage
		primaryDamage = primaryDamage * bonusCriticalDamage
		secondaryDamage = secondaryDamage * bonusCriticalDamage
		creature:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
overpower:register()

local opressor = CreatureEvent("opressorSoulPit")
function opressor.onThink() end
opressor:register()
