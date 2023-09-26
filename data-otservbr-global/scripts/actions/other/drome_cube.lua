local rewards = {
	{ id = 36723, name = "Kooldown-Aid" },
	{ id = 36724, name = "Strike Enhancement" },
	{ id = 36725, name = "Stamina Extension" },
	{ id = 36726, name = "Charm Upgrade" },
	{ id = 36727, name = "Wealth Duplex" },
	{ id = 36728, name = "Bestiary Betterment" },
	{ id = 36729, name = "Fire Resilience" },
	{ id = 36730, name = "Ice Resilience" },
	{ id = 36731, name = "Earth Resilience" },
	{ id = 36732, name = "Energy Resilience" },
	{ id = 36733, name = "Holy Resilience" },
	{ id = 36734, name = "Death Resilience" },
	{ id = 36735, name = "Physical Resilience" },
	{ id = 36736, name = "Fire Amplification" },
	{ id = 36737, name = "Ice Amplification" },
	{ id = 36738, name = "Earth Amplification" },
	{ id = 36739, name = "Energy Amplification" },
	{ id = 36740, name = "Holy Amplification" },
	{ id = 36741, name = "Death Amplification" },
	{ id = 36742, name = "Physical Amplification" },
}

local dromecube = Action()

function dromecube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]

	player:addItem(rewardItem.id, 1)
	item:remove(1)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received a " .. rewardItem.name .. ".")
	return true
end

dromecube:id(36827)
dromecube:register()
