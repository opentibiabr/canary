local bananaChocolateShake = Action()

function bananaChocolateShake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't really know what this did to you, but suddenly you feel very happy.")
	player:say("Slurp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

bananaChocolateShake:id(9083)
bananaChocolateShake:register()
