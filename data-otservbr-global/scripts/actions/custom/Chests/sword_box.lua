local rewards = {
    { id = 43870, name = "sanguine razor" },
    { id = 27651, name = "gnome sword" },
    { id = 27650, name = "gnome shield" },
    { id = 28721, name = "falcon shield" },
    { id = 34155, name = "lion longsword" },
    { id = 34154, name = "lion shield" },
    { id = 34083, name = "soulshredder" },
    { id = 3422, name = "great shield" },
    { id = 43865, name = "grand sanguine blade" },
    { id = 34099, name = "soulbastion" },
    { id = 34082, name = "soulcutter" },
	{ id = 28722, name = "falcon escutcheon" }
}

local bagyouCovet = Action()

function bagyouCovet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardItem.name .. '.')
	return true
end

bagyouCovet:id(44923)
bagyouCovet:register()