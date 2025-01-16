local sickle = Action()

function sickle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 5463 then
		target:transform(5462)
		target:decay()
		Game.createItem(5466, 1, toPosition)
		return true
	end
end

sickle:id(3293)
sickle:register()
