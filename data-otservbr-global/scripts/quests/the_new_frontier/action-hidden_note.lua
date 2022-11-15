local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local hiddenNote = Action()

function hiddenNote.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(TheNewFrontier.Mission07.HiddenNote) < 1 then
		local note = player:addItem(8747, 1)
		note:setAttribute(ITEM_ATTRIBUTE_TEXT, "Go to the secret door to the north")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a piece of paper.')
		player:setStorageValue(TheNewFrontier.Mission07.HiddenNote, 1)
		return true
	end
end

hiddenNote:position(Position(33165, 31249, 11))
hiddenNote:register()
