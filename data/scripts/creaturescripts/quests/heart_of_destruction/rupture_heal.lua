local ruptureHeal = CreatureEvent()
function ruptureHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local healthGain = math.random(5000, 10000)
	if attacker and attacker:isPlayer() and resonanceActive == true then
		creature:addHealth(healthGain)
		creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ruptureHeal:register()
