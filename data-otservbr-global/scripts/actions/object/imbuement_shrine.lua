local imbuement = Action()

function imbuement.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if configManager.getBoolean(configKeys.TOGGLE_IMBUEMENT_SHRINE_STORAGE) and player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) ~= 1 then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You did not collect enough knowledge from the ancient Shapers. Visit the Shaper temple in Thais for help.")
	end

	if type(target) ~= "userdata" or not target:isItem() then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the shrine on an valid item.")
	end

	player:openImbuementWindow(target)
	return true
end

imbuement:id(25060, 25061, 25174, 25175, 25182, 25183, 24964)
imbuement:register()
