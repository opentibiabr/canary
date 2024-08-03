local rewards = {
    { id = 43872, name = "sanguine bludgeon" },
    { id = 34254, name = "lion hammer" },
    { id = 27650, name = "gnome shield" },
    { id = 28721, name = "falcon shield" },
    { id = 39157, name = "naga sword" },
    { id = 34154, name = "lion shield" },
    { id = 34087, name = "soulmaimer" },
    { id = 3422, name = "great shield" },
    { id = 43866, name = "sanguine cudgel" },
    { id = 28725, name = "falcon mace" },
	{ id = 30395, name = "Cobra Club" }
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

bagyouCovet:id(44924)
bagyouCovet:register()