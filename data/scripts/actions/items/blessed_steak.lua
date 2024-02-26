local blessedSteak = Action()

function blessedSteak.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("jean-pierre-foods") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:addMana(player:getMaxMana())
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your mana has been refilled.")
	player:say("Chomp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("jean-pierre-foods", 10 * 60)
	item:remove(1)
	return true
end

blessedSteak:id(9086)
blessedSteak:register()
