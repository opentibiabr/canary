local rewards = {
    { id = 34158, name = "Lion Amulet" },
    { id = 34253, name = "Lion Axe" },
    { id = 34254, name = "Lion Hammer" },
    { id = 34150, name = "Lion Longbow" },
    { id = 34155, name = "Lion Longsword" },
    { id = 34157, name = "Lion Plate" },
    { id = 34151, name = "Lion Rod" },
    { id = 34154, name = "Lion Shield" },
    { id = 34156, name = "Lion Spangenhelmet" },
	{ id = 34153, name = "Lion Spellbook" },
	{ id = 34152, name = "Lion Wand" },
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

bagyouCovet:id(49611)
bagyouCovet:register()