local cracklerTransform = CreatureEvent("CracklerTransform")
function cracklerTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	if cracklerTransform == true then
		local monster = Game.createMonster("depolarized crackler", creature:getPosition(), false, true)
		monster:addHealth(-monster:getHealth() + creature:getHealth(), COMBAT_PHYSICALDAMAGE)
		creature:remove()
	end

	return true
end

cracklerTransform:register()
