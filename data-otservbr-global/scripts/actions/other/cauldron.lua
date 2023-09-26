local cauldronWitch = Action()

function cauldronWitch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(43670)
	addEvent(function () item:transform(43672) end, 7000)
	return true
end

cauldronWitch:id(43672)
cauldronWitch:register()
