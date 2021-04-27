function onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:teleportTo(Position(33644, 32757, 11))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return
end
