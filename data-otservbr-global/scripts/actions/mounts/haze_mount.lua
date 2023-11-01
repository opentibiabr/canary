local config = {
	[32629] = { mountId = 162, message = "You are now versed to ride the haze!" },
}

local hazemount = Action()

function hazemount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

hazemount:id(32629)
hazemount:register()
