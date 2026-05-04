local cupOfMoltenGold = Action()

local config = {
	goldenFirCone = 12550,
	[3614] = {
		successMsg = "Carefully you drizzle some of the gold on top of the finest fir cone you could find on this tree.",
		failMsg = "Drizzling all over a fir cone you picked from the tree, the molten gold only covers about half of it - not enough.",
	},
	[19111] = {
		successMsg = "Carefully you drizzle some of the gold on top of the fir cone.",
		failMsg = "Drizzling all over the fir cone, the molten gold only covers about half of it - not enough.",
	},
}

function cupOfMoltenGold.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or not target.itemid then
		return false
	end

	local targetConfig = config[target.itemid]
	if not targetConfig then
		return false
	end

	if math.random(100) <= 50 then
		if target.itemid == 19111 then
			target:remove(1)
		end
		item:remove(1)
		player:addItem(config.goldenFirCone, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetConfig.successMsg)
	else
		if target.itemid == 19111 then
			target:remove(1)
		end
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetConfig.failMsg)
	end
	return true
end

cupOfMoltenGold:id(12804)
cupOfMoltenGold:register()
