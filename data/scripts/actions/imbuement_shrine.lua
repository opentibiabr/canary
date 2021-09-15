local imbuement = Action()

function imbuement.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:sendImbuementPanel(target, true)
	return true
end

imbuement:id(25201, 25202, 25060, 25061, 25101, 25102, 25104, 25174, 25175, 25182, 25183)
imbuement:register()
