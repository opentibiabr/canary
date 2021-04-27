local dreamerTicTac = Action()
function dreamerTicTac.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end

	local position = {x = 32838, y = 32264, z = 14}
	if player:getStorageValue(Storage.DreamersChallenge.TicTac) < 1 then
		player:setStorageValue(Storage.DreamersChallenge.TicTac, 1)
		Game.createItem(2638, 8, position)
		Game.createItem(2639, 12, {x = 32839, y = 32263, z = 14})
		position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	else
		player:say("You have used and can not use more.", TALKTYPE_ORANGE_1)
	end
	return true
end

dreamerTicTac:uid(2272)
dreamerTicTac:register()