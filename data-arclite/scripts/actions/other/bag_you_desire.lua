local rewards = {
    { id = 34082, name = "Soulcutter" },
    { id = 34083, name = "Soulshredder" },
    { id = 34084, name = "Soulbiter" },
    { id = 34085, name = "Souleater" },
    { id = 34086, name = "Soulcrusher" },
    { id = 34087, name = "Soulmaimer" },
    { id = 34088, name = "Soulbleeder" },
    { id = 34089, name = "Soulpiercer" },
    { id = 34090, name = "Soultainter" },
    { id = 34091, name = "Soulhexer" },
    { id = 34092, name = "Soulshanks" },
    { id = 34093, name = "Soulstrider" },
    { id = 34094, name = "Soulshell" },
    { id = 34095, name = "Soulmantle" },
    { id = 34096, name = "Soulshroud" },
    { id = 34097, name = "Pair of Soulwalkers" },
    { id = 34098, name = "Pair of Soulstalkers" },
    { id = 34099, name = "Soulbastion" }
}

local bagyouDesire = Action()

function bagyouDesire.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardItem.name .. '.')
	return true
end

bagyouDesire:id(34109)
bagyouDesire:register()
