local ruptureHeal = CreatureEvent("RuptureHeal")

function ruptureHeal.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local resonanceActive = Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive)
	if attacker and attacker:isPlayer() and resonanceActive == 1 then
		local healthGain = math.random(5000, 10000)
		creature:addHealth(healthGain)
		creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

ruptureHeal:register()
