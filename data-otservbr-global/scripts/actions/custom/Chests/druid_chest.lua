local rewards = {
    { id = 43887, name = "sanguine galoshes" },
    { id = 645, name = "blue legs" },
    { id = 27647, name = "gnome helmet" },
    { id = 29423, name = "dream shroud" },
    { id = 32619, name = "pair of nightmare boots" },
    { id = 34096, name = "soulshroud" },
    { id = 28714, name = "falcon circlet" },
    { id = 8043, name = "focus cape" },
    { id = 27649, name = "gnome legs" },
    { id = 39153, name = "arboreal crown" },
    { id = 29424, name = "pair of dreamwalkers" },
    { id = 34093, name = "soulstrider" },
	{ id = 3555, name = "golden boots" }
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

bagyouCovet:id(44902)
bagyouCovet:register()