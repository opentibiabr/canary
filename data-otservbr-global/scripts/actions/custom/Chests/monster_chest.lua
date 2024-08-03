local rewards = {
    { id = 40588, name = "Antler-Horn Helmet" },
    { id = 40592, name = "Alchemist's Boots" },
    { id = 40594, name = "Alchemist's Notepad" },
    { id = 40593, name = "Mutant Bone Boots" },
    { id = 40595, name = "Mutant Bone Kilt" },
    { id = 40591, name = "Mutated Skin Armor" },
    { id = 40590, name = "Mutated Skin Legs" },
    { id = 40589, name = "Stitched MutantHide Legs" },
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

bagyouCovet:id(49734)
bagyouCovet:register()