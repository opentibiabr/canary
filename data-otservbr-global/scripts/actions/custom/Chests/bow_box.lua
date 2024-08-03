local rewards = {
    { id = 39150, name = "alicorn quiver" },
    { id = 43877, name = "sanguine bow" },
    { id = 34150, name = "lion longbow" },
    { id = 36666, name = "eldritch quiver" },
    { id = 34088, name = "soulbleeder" },
    { id = 35524, name = "jungle quiver" },
    { id = 43878, name = "grand sanguine bow" },
    { id = 28718, name = "falcon bow" },
    { id = 39160, name = "naga quiver" }
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

bagyouCovet:id(44927)
bagyouCovet:register()