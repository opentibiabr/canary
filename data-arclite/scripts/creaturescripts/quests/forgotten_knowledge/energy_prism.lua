local energyPrism = CreatureEvent("EnergyPrism")
function energyPrism.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not Tile(Position(32799, 32826, 14)):getTopCreature() then
		if creature:getHealth() < creature:getMaxHealth() then
			creature:say('*zap!*', TALKTYPE_MONSTER_SAY)
			creature:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			creature:addHealth(10000, false)
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
energyPrism:register()
