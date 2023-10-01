
local netherPearl = Action()
function netherPearl.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, 15)

	player:addItem(32004, randId)
	item:remove(1)

	player:sendTextMessage(MESSAGE_INFO_DESCR, 'You received x' .. randId .. ' Pearl\'s.')
	return true
end
netherPearl:id(32003)
netherPearl:register()