local cupOfMoltenGold = Action()

function cupOfMoltenGold.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetId = target.itemid
	if not table.contains({ 3614, 19111 }, targetId) then
		return false
	end

	if math.random(100) <= 10 then
		local transformedItemId = 12550
		if targetId == 19111 then
			item:transform(transformedItemId)
		else
			player:addItem(transformedItemId, 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Drizzling all over a fir cone you picked from the tree, the molten gold only covers about half of it - not enough.")

		if targetId == 19111 then
			target:remove(1)
		end

		item:remove(1)
	end
	return true
end

cupOfMoltenGold:id(12804)
cupOfMoltenGold:register()
