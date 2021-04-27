local sickle = Action()

function sickle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
if target.itemid == 5465 then
		target:transform(5464)
		target:decay()
		Game.createItem(5467, 1, toPosition)
		return true
	end
end

sickle:id(2405)
sickle:register()
