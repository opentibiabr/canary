local config = { 
	antlers = 10297,
	antler_talisman = 22008
}

local starHerb = Action()
function starHerb.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if target.itemid == config.antlers then
		item:transform(config.antler_talisman)
		item:remove(1)
		target:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You entwine the antler with fresh star herb")
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return true
end

starHerb:id(3736)
starHerb:register()