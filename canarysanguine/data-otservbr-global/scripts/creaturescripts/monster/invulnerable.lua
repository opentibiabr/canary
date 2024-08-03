local invulnerable = CreatureEvent("monster.invulnerable")
function invulnerable.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	return false
end
invulnerable:register()

function Monster:setInvulnerable()
	self:registerEvent("monster.invulnerable")
	return true
end

function Monster:removeInvulnerable()
	self:unregisterEvent("monster.invulnerable")
	return true
end
