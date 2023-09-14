local criticalLife = CreatureEvent("CriticalLife")

function criticalLife.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if (not attacker or not creature) then  
    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end

    if (attacker:isPlayer() and (attacker:getCriticalLevel() * 3) >= math.random (0, 100)) then
		primaryDamage = primaryDamage + math.ceil(primaryDamage * CRITICAL.PERCENT)
		creature:getPosition():sendMagicEffect(173)
	end
	
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

criticalLife:register()