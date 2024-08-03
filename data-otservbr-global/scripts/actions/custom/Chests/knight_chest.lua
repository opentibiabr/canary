local rewards = {
    { id = 34097, name = "pair of soulwalkers" },
    { id = 39158, name = "frostflower boot" },
    { id = 3366, name = "magic plate armor" },
    { id = 28720, name = "falcon greaves" },
    { id = 39148, name = "spiritthorn helmet" },
    { id = 30394, name = "cobra boots" },
    { id = 3364, name = "golden legs" },
    { id = 31577, name = "terra helmet" },
    { id = 34157, name = "lion plate" },
    { id = 32617, name = "fabulous legs" },
    { id = 39147, name = "spiritthorn armor" },
    { id = 30397, name = "cobra hood" },
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

bagyouCovet:id(44903)
bagyouCovet:register()