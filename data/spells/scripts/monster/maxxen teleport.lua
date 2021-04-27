function onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:teleportTo(Position(math.random(33704, 33718), math.random(32040, 32053), 15))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return
end
