local potOfBlackjack = Action()

function potOfBlackjack.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	local remainingGulps = player:kv():get("pot-of-blackjack") or math.random(2, 4)

	if remainingGulps > 0 then
		remainingGulps = remainingGulps - 1
		player:kv():set("pot-of-blackjack", remainingGulps)

		local message
		if remainingGulps > 0 then
			message = "You take a gulp from the large bowl, but there's still some blackjack in it."
		else
			message = "You take the last gulp from the large bowl. No leftovers!"
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	end

	player:addHealth(5000)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take a gulp from the large bowl.")
	player:say("Gulp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

potOfBlackjack:id(11586)
potOfBlackjack:register()
