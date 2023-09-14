local rewards = {
	{
		addon = 3, -- 3 full
		id_male = 128,
		id_female = 136,
		name = "Citizen"
	}
}

local outfit_loggi = Action()

function outfit_loggi.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addOutfitAddon(rewards.id_male, rewards.addon)
	player:addOutfitAddon(rewards.id_female, rewards.addon)
	item:remove(1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewards.name .. ' outfit.')
	return true
end

outfit_loggi:id(21218)
outfit_loggi:register()
