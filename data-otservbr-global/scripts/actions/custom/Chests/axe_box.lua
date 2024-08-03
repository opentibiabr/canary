local rewards = {
    { id = 43875, name = "grand sanguine battleaxe" },
    { id = 34253, name = "lion axe" },
    { id = 27650, name = "gnome shield" },
    { id = 28721, name = "falcon shield" },
    { id = 30396, name = "cobra sword" },
    { id = 34154, name = "lion shield" },
    { id = 34084, name = "soulbiter" },
    { id = 3422, name = "great shield" },
    { id = 43869, name = "grand sanguine hatchet" },
    { id = 34085, name = "souleater" },
	{ id = 28724, name = "falcon battleaxe" }
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

bagyouCovet:id(44926)
bagyouCovet:register()