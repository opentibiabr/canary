local blessedSteak = Action()

function blessedSteak.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("special-foods-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:addMana(player:getMaxMana())
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your mana has been refilled.")
	player:say("Chomp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT, player:isInGhostMode() and nil or player)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

blessedSteak:id(9086)
blessedSteak:register()
