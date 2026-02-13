local etcher = Action()

function etcher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or not item:isItem() then
		return false
	end

	if not target or not target:isItem() then
		return false
	end

	local clearImbuements = player:clearAllImbuements(target)

	if clearImbuements then 
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have cleared all imbuements from the item.")
		item:remove(1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		player:sendCancelMessage("This item has no imbuements to clear.")
	end

	return true
end

etcher:id(51443)
etcher:register()
