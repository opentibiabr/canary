local rewards = {
	{
		id_mount = 1,
		name = "Widow Queen"
	}
}

local mount_loggi = Action()

function mount_loggi.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addMount(rewards.id_mount)
	item:remove(1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewards.name .. ' outfit.')
	return true
end

mount_loggi:id(20309)
mount_loggi:register()
