local rewards = {
    { id_mount = 1, name = "Widow Queen" },
    { id_mount = 2, name = "Racing Bird" },
    { id_mount = 3, name = "War Bear" }
}

local mount_rand = Action()

function mount_rand.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardRand = rewards[randId]
	player:addMount(rewardRand.id_mount)
	item:remove(1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You received a ' .. rewardRand.name .. ' mount.')
	return true
end

mount_rand:id(44064)
mount_rand:register()
