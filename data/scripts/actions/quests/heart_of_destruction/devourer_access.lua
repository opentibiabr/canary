local heartDestructionDevourer = Action()
function heartDestructionDevourer.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(14333) > os.time() then
		player:setStorageValue(14333, -1)
		player:sendTextMessage(19, "You access to World Devourer was released!")
		item:transform(26343)
	else
		player:sendTextMessage(19, "You access to World Devourer is already released!")
	end

	return true
end

heartDestructionDevourer:id(26342)
heartDestructionDevourer:register()