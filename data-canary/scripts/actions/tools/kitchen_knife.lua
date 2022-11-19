local kitchenKnife = Action()

function kitchenKnife.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
end

kitchenKnife:id(3469)
kitchenKnife:register()
