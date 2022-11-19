local watch = Action()

function watch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_LOOK, "The time is " .. getFormattedWorldTime() .. ".")
	return true
end

watch:id(751, 2445, 2446, 2447, 2448, 2906, 2771)
watch:register()
