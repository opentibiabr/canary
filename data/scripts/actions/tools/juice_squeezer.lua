local fruits = {2673, 2674, 2675, 2676, 2677, 2678, 2679, 2680, 2681, 2682, 2684, 2685, 5097, 8839, 8840, 8841}

local juiceSqueezer = Action()

function juiceSqueezer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray(fruits, target.itemid) and player:removeItem(2006, 1, 0) then
		target:remove(1)
		player:addItem(2006, target.itemid == 2678 and 14 or 21)
		return true
	end
end

juiceSqueezer:id(5865)
juiceSqueezer:register()
