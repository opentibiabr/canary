local enrage = CreatureEvent("enrageSoulPit")
function enrage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature or not creature:isMonster() then
		return true
	end

	local healthPercentage = creature:getHealth() / creature:getMaxHealth()

	if healthPercentage >= 0.6 and healthPercentage <= 0.8 then
		primaryDamage = primaryDamage * 0.9 -- 10% damage reduction
		secondaryDamage = secondaryDamage * 0.9 -- 10% damage reduction
	elseif healthPercentage >= 0.4 and healthPercentage < 0.6 then
		primaryDamage = primaryDamage * 0.75 -- 25% damage reduction
		secondaryDamage = secondaryDamage * 0.75 -- 25% damage reduction
	elseif healthPercentage >= 0.2 and healthPercentage < 0.4 then
		primaryDamage = primaryDamage * 0.6 -- 40% damage reduction
		secondaryDamage = secondaryDamage * 0.6 -- 40% damage reduction
	elseif healthPercentage > 0 and healthPercentage < 0.2 then
		primaryDamage = primaryDamage * 0.4 -- 60% damage reduction
		secondaryDamage = secondaryDamage * 0.4 -- 60% damage reduction
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
enrage:register()

local overpower = CreatureEvent("overpowerSoulPit")
function overpower.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if creature and attacker and attacker:isMonster() and attacker:getForgeStack() == 40 then
		primaryDamage = primaryDamage * 1.1
		secondaryDamage = secondaryDamage * 1.1
		creature:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
overpower:register()

local opressor = CreatureEvent("opressorSoulPit")
function opressor.onThink() end
opressor:register()
