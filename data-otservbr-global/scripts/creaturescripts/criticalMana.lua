local criticalMana = CreatureEvent("CriticalMana")

function criticalMana.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if (not attacker or not creature) then  
    	return primaryDamage, primaryType, secondaryDamage, secondaryType 
    end

    local qnt = attacker:getStorageValue(48901)
	print(qnt)
	if attacker:isPlayer() then
		if ((qnt * 3) >= math.random (0, 100)) then
			primaryDamage = primaryDamage + math.ceil(primaryDamage * CRITICAL.PERCENT)
			creature:getPosition():sendMagicEffect(173)
		end
	end
	
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

criticalMana:register()