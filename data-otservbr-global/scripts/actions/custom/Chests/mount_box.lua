local rewards = {
    { id = 24960, name = "Astral Shaper Rune" },
    { id = 12549, name = "Bamboo Leaves" },
    { id = 16155, name = "Decorative Ribbon" },
    { id = 14142, name = "Foxtail" },
    { id = 12306, name = "Leather Whip" },
    { id = 12318, name = "Giant Shirmp" },
    { id = 34258, name = "Red Silk Flower" },
    { id = 32629, name = "Spectral Scrap of Cloth" },
	{ id = 12320, name = "Sweet Smelling Bait" },
	{ id = 14143, name = "Four-Leaf Clover" },
	{ id = 12547, name = "Diapason" },
	{ id = 12509, name = "Scorpion Sceptre" },
	{ id = 12304, name = "Maxilla Maximus" },
	{ id = 28791, name = "Library Ticket" },
	{ id = 5907, name = "Slingshot" },
	
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

bagyouCovet:id(49642)
bagyouCovet:register()