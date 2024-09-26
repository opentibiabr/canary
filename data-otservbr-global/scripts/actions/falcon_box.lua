local rewards = {
    { id = 28714, name = "Falcon Circlet" },
    { id = 28715, name = "Falcon Coif" },
    { id = 28718, name = "Falcon Bow" },
    { id = 28716, name = "Falcon Rod" },
    { id = 28717, name = "Falcon Wand" },
    { id = 3024, name = "Holy Falcon" },
    { id = 28721, name = "Falcon Shield" },
    { id = 28723, name = "Falcon Longsword" },
    { id = 28720, name = "Falcon Greaves" },
    { id = 28719, name = "Falcon Plate" },
    { id = 28724, name = "Falcon Battleaxe" },
    { id = 28725, name = "Falcon Mace" },
   }

local falconbox = Action()

function falconbox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardItem.name .. '.')
	return true
end

falconbox:id(26186)
falconbox:register()
