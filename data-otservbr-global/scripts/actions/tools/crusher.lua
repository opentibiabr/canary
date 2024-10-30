local crusher = Action()

function crusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target:isItem() or target:getId() == item:getId() or player:getItemCount(target:getId()) <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use the crusher on a valid gem in your inventory.")
		return false
	end

	local fragmentType, fragmentRange = getGemData(target:getId())
	if not fragmentType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item can't be broken into fragments.")
		return false
	end

	local crusherCharges = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
	if not crusherCharges or crusherCharges <= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has no more charges.")
		return false
	end

	target:remove(1)

	player:addItem(fragmentType, math.random(fragmentRange[1], fragmentRange[2]))
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have broken the gem into fragments.")

	crusherCharges = crusherCharges - 1
	if crusherCharges > 0 then
		local container = item:getParent()
		item:setAttribute(ITEM_ATTRIBUTE_CHARGES, crusherCharges)
		if container:isContainer() then
			player:sendUpdateContainer(container)
		end
	else
		item:remove()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your crusher has been consumed.")
	end

	return true
end

crusher:id(46627)
crusher:register()
