local heartDestructionEggs = Action()
function heartDestructionEggs.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local config = {
		[26194] = {mountId = 94, message = "You receive the permission to ride a sparkion"},
		[26340] = {mountId = 98, message = "You receive the permission to ride a neon sparkid"},
		[26341] = {mountId = 99, message = "You receive the permission to ride a vortexion"},
	}

	local mount = config[item.itemid]

	if not mount then
		return true
	end

	if not player:hasMount(mount.mountId) then
		player:addMount(mount.mountId)
		player:say(mount.message, TALKTYPE_MONSTER_SAY)
		item:remove(1)
	else
		player:sendTextMessage(19, "You already have this mount")
	end
	return true
end

heartDestructionEggs:id(26194,26340,26341)
heartDestructionEggs:register()