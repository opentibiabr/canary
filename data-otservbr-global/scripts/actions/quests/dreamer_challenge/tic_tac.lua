local dreamerTicTac = Action()
function dreamerTicTac.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 2772 and 2773 or 2772)

	if item.itemid ~= 2772 then
		return true
	end

	local position = Position(32838, 32264, 14)
	if player:getStorageValue(Storage.DreamersChallenge.TicTac) < 1 then
		player:setStorageValue(Storage.DreamersChallenge.TicTac, 1)
		Game.createItem(3547, 8, position)
		Game.createItem(3548, 12, {x = 32839, y = 32263, z = 14})
		position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	else
		player:say("You have used and can not use more.", TALKTYPE_ORANGE_1)
	end
	return true
end

dreamerTicTac:uid(2272)
dreamerTicTac:register()