local gravediggerFlask = Action()

function gravediggerFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isCreature() or target:getName():lower() ~= "snake" then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission11) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission12) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission12, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Done! Report back to Omrabas.")
		player:addItem(19086, 1)
		item:remove()
		target:remove()
	end
	return true
end

gravediggerFlask:id(19085)
gravediggerFlask:register()
