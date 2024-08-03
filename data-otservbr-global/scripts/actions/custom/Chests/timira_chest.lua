local rewards = {
    { id = 39159, name = "naga crossbow" },
    { id = 39163, name = "naga rod" },
    { id = 39162, name = "naga wand" },
    { id = 39157, name = "naga club" },
    { id = 39156, name = "naga axe" },
    { id = 39155, name = "naga sword" },
    { id = 39160, name = "naga quiver" },
    { id = 39161, name = "feverbloom boots" },
    { id = 39158, name = "frostflower boots" },
    { id = 39164, name = "dawnfire sherwani" },
    { id = 39167, name = "midnight sarong" },
    { id = 39165, name = "midnight tunic" }
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

bagyouCovet:id(49612)
bagyouCovet:register()