local unnatural = Action()
function unnatural.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_54.UnnaturalSelection.Mission05) == 1 then
		player:setStorageValue(Storage.Quest.U8_54.UnnaturalSelection.Questline, 11)
		player:setStorageValue(Storage.Quest.U8_54.UnnaturalSelection.Mission05, 2) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
		player:say("A ray of sunlight comes down from the heaven and hits the crystal. Wow. That probably means Fasuon is supporting.", TALKTYPE_MONSTER_SAY)
		toPosition:sendMagicEffect(CONST_ME_HOLYAREA)
	end
	return true
end

unnatural:uid(1052)
unnatural:register()
