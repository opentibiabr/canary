local ruptureHeal = CreatureEvent("RuptureHeal")

function ruptureHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local healthGain = math.random(5000, 10000)
	local resonanceActive = Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive)
	if resonanceActive and resonanceActive < 1 then
		resonanceActive = false
	end

	if attacker and attacker:isPlayer() and resonanceActive then
		creature:addHealth(healthGain)
		creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ruptureHeal:register()
