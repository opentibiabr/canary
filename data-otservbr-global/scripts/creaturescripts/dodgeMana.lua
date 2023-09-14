local dodgeMana = CreatureEvent("DodgeMana")

function dodgeMana.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if creature:getZone() == ZONE_PROTECTION then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

    if attacker then
        if not attacker:isPlayer() or creature == attacker then
            return primaryDamage, primaryType, secondaryDamage, secondaryType
        
        elseif (creature:getDodgeLevel() * 3) >= math.random (0, 100) then
            return true
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

dodgeMana:register()