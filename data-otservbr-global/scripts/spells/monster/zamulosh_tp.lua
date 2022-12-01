local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:teleportTo(Position(33644, 32757, 11))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return
end

spell:name("zamulosh tp")
spell:words("###415")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()