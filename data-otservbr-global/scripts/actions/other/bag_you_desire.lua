local rewards = {
	{ id = 34082, name = "soulcutter" },
	{ id = 34083, name = "soulshredder" },
	{ id = 34084, name = "soulbiter" },
	{ id = 34085, name = "souleater" },
	{ id = 34086, name = "soulcrusher" },
	{ id = 34087, name = "soulmaimer" },
	{ id = 34097, name = "pair of soulwalkers" },
	{ id = 34099, name = "soulbastion" },
	{ id = 34088, name = "soulbleeder" },
	{ id = 34089, name = "soulpiercer" },
	{ id = 34094, name = "soulshell" },
	{ id = 34098, name = "pair of soulstalkers" },
	{ id = 34090, name = "soultainter" },
	{ id = 34092, name = "soulshanks" },
	{ id = 34095, name = "soulmantle" },
	{ id = 34091, name = "soulhexer" },
	{ id = 34093, name = "soulstrider" },
	{ id = 34096, name = "soulshroud" },
}

local bagyouDesire = Action()

function bagyouDesire.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")
	return true
end

bagyouDesire:id(34109)
bagyouDesire:register()
