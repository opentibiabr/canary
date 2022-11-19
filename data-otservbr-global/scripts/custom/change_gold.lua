local config = {
	[ITEM_GOLD_COIN] = {changeTo = ITEM_PLATINUM_COIN},
	[ITEM_PLATINUM_COIN] = {changeBack = ITEM_GOLD_COIN, changeTo = ITEM_CRYSTAL_COIN},
	[ITEM_CRYSTAL_COIN] = {changeBack = ITEM_PLATINUM_COIN}
}
local changeGold = Action()
function changeGold.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local coin = config[item:getId()]
	if coin.changeTo and item.type == 100 then
		item:remove()
		player:addItem(coin.changeTo, 1)
		return true
	elseif coin.changeBack then
		item:remove(1)
		player:addItem(coin.changeBack, 100)
		return true
	end
	return false
end
changeGold:id(3031, 3035, 3043)
changeGold:register()
