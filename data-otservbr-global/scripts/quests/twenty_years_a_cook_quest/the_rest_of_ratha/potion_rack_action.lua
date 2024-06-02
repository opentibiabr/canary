local potionRack = Action()

function potionRack.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) == 6 then
		item:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:getPosition():sendMagicEffect(CONST_ME_STUN)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Oops, that was the wrong potion! It seems you have accidently drunken Ratha!")
		player:say("GULP!", TALKTYPE_MONSTER_SAY)
		player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 7)
	end
end

potionRack:id(TwentyYearsACookQuest.TheRestOfRatha.Items.PotionRack)
potionRack:register()
