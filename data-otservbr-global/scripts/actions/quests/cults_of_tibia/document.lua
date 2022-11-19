local cultsOfTibiaDocument = Action()
function cultsOfTibiaDocument.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local posDocument = Position(33279, 32169, 8)
	-- Document
	if item:getPosition() == posDocument then
		if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Dear curator, this recently opened museum is a really nice place to be.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "But wait! What about the empty space in front of you? What a pity!")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It seems that somebody has removed one of the beautiful pictures. But come on! You have the money and we need it.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "So for a small expense allowance you'll get it back. Just talk to Iwar in Kazordoon for further information. ")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ask him: Has the cat got your tongue?")
			player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 3)
		end
	end
	return true
end

cultsOfTibiaDocument:aid(5522)
cultsOfTibiaDocument:register()