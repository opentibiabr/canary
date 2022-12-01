local grinder = Action()

function grinder.onUse(player, item, frompos, item2, topos)
	if(item2.itemid == 21573)then
		return onGrindItem(player, item, frompos, item2, topos)
	end
end

grinder:id(16122)
grinder:register()
