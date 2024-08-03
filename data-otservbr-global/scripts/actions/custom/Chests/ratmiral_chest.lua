local rewards = {
    { id = 35523, name = "exotic amulet" },
    { id = 35517, name = "bast legs" },
    { id = 35518, name = "jungle bow" },
    { id = 35516, name = "exotic legs" },
    { id = 35514, name = "jungle flail" },
    { id = 35521, name = "jungle rod" },
    { id = 35519, name = "makeshift boots" },
    { id = 35524, name = "jungle quiver" },
	{ id = 35520, name = "make-do boots" }
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

bagyouCovet:id(49614)
bagyouCovet:register()