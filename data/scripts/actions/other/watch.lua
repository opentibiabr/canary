local watch = Action()

function watch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The time is " .. getFormattedWorldTime() .. ".")
	return true
end

watch:id(1728, 1729, 1730, 1731, 2036, 3900)
watch:register()
