local dodgeLife = CreatureEvent("DodgeLife")

function dodgeLife.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
   if creature:getZone() == ZONE_PROTECTION then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

   if attacker then
       
        if not attacker:isPlayer() or creature == attacker then
            return primaryDamage, primaryType, secondaryDamage, secondaryType
        
        elseif (creature:getDodgeLevel() * 3) >= math.random (0, 100) then
            creature:getPosition():sendMagicEffect(231)
            return true
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

dodgeLife:register()