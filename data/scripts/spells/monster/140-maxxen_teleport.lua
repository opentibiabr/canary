local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:teleportTo(Position(math.random(33704, 33718), math.random(32040, 32053), 15))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return
end

spell:name("maxxen teleport")
spell:words("###140")
spell:needTarget(true)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
