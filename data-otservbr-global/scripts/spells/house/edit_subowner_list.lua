local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local house = player:getTile():getHouse()
	if not house then
		return false
	end

	if house:canEditAccessList(SUBOWNER_LIST, player) then
		player:setEditHouse(house, SUBOWNER_LIST)
		player:sendHouseWindow(house, SUBOWNER_LIST)
	else
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

spell:name("House Subowner List")
spell:words("aleta som")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_INVITE_SUBOWNERS)
spell:isAggressive(false)
spell:register()
