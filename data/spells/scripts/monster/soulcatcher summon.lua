function onCastSpell(creature, var)
	if creature:getCondition(CONDITION_POISON) or creature:getCondition(CONDITION_BLEEDING) then
		local pos = creature:getPosition()
		pos.y = pos.y - 1
		Game.createMonster('corrupted soul', pos, true, true)
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		return
	end
    return true
end
