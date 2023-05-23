local sharedLife = CreatureEvent("SharedLife")
function sharedLife.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	if not creature:inSharedLife() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local killer = false
	 -- Monster.onReceivDamageSL(self, damage, tp)
	if primaryType == COMBAT_HEALING then
		creature:onReceivDamageSL(primaryDamage, "healing", killer)
	else
		if(creature:getHealth() - primaryDamage <= 0)then
			killer = true
		end
		creature:onReceivDamageSL(primaryDamage, "damage", killer)
	end
	killer = false
	if secondaryType == COMBAT_HEALING then
		creature:onReceivDamageSL(secondaryDamage, "healing", killer)
	else
		if(creature:getHealth() - secondaryDamage <= 0)then
			killer = true
		end
		creature:onReceivDamageSL(secondaryDamage, "damage", killer)
	end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
sharedLife:register()
