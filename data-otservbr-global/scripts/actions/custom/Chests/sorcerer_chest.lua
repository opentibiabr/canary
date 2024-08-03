local rewards = {
    { id = 31582, name = "galea mortis" },
    { id = 39164, name = "dawnfire sherwani" },
    { id = 645, name = "blue legs" },
    { id = 43884, name = "sanguine boots" },
    { id = 28714, name = "falcon circlet" },
    { id = 34092, name = "soulshanks" },
    { id = 27649, name = "gnome legs" },
    { id = 8043, name = "focus cape" },
    { id = 32619, name = "pair of nightmare boots" },
    { id = 39153, name = "arboreal crown" },
    { id = 39151, name = "arcanomancer regalia" },
    { id = 40592, name = "alchemist's boots" },
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

bagyouCovet:id(44901)
bagyouCovet:register()