local rewards = {
    { id = 39150, name = "alicorn quiver" },
    { id = 30393, name = "cobra crossbow" },
    { id = 39159, name = "naga crossbow" },
    { id = 36666, name = "eldritch quiver" },
    { id = 43879, name = "sanguine crossbow" },
    { id = 35524, name = "jungle quiver" },
    { id = 34089, name = "soulpiercer" },
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

bagyouCovet:id(44925)
bagyouCovet:register()