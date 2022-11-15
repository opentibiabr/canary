local spell = Spell("instant")

function spell.onCastSpell(creature, var)
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

spell:name("soulcatcher summon")
spell:words("###431")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()