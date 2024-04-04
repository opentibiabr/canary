local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()
	creaturePos:getNextPosition(creature:getDirection())
	local tile = Tile(creaturePos)
	local house = tile and tile:getHouse()
	local doorId = house and house:getDoorIdByPosition(creaturePos)
	if not doorId or not house:canEditAccessList(doorId, creature) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	creature:setEditHouse(house, doorId)
	creature:sendHouseWindow(house, doorId)
	return true
end

spell:name("House Door List")
spell:words("aleta grav")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_EDIT_DOOR)
spell:needCasterTargetOrDirection(true)
spell:isAggressive(false)
spell:register()
