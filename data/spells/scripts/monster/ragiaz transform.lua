function onCastSpell(creature, var)
	local pos = creature:getPosition()
	if pos.z ~= 13 then
		return
	end
	pos:sendMagicEffect(172)
	creature:say('Ragiaz encase himself in bones to regenerate.', TALKTYPE_MONSTER_SAY)
	creature:teleportTo(Position(33487, 32333, 14))
	creature:addHealth(1000)
	local capsule = Tile(Position(33485, 32333, 14)):getTopCreature()
	capsule:teleportTo(pos)
	return
end
