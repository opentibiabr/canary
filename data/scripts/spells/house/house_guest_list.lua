local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	local house = player:getTile():getHouse()
	if not house then
		return false
	end

	if house:canEditAccessList(GUEST_LIST, player) then
		player:setEditHouse(house, GUEST_LIST)
		player:sendHouseWindow(house, GUEST_LIST)
	else
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

spell:name("House Guest List")
spell:words("aleta sio")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "knight;true", "elite knight;true", "paladin;true", "royal paladin;true", "sorcerer;true", "master sorcerer;true", "monk;true", "exalted monk;true")
spell:level(8)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_INVITE_GUESTS)
spell:isAggressive(false)
spell:register()
