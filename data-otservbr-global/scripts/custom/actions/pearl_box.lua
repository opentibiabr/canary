
local pearls = Action()
function pearls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, 15)

	player:addItem(32002, randId)
	item:remove(1)

	player:sendTextMessage(MESSAGE_INFO_DESCR, 'You received x' .. randId .. ' Nether Pearl\'s.')
	return true
end
pearls:id(32001)
pearls:register()