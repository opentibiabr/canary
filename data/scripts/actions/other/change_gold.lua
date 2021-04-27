local goldCoins = {
	[3031] = {changeTo = 3035},
	[3035] = {changeBack = 3031, changeTo = 3043},
	[3043] = {changeBack = 3035}
}

local changeGold = Action()

function changeGold.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local coin = goldCoins[item:getId()]
	if coin.changeTo and item.type == 100 then
		item:remove()
		player:addItem(coin.changeTo, 1)
	elseif coin.changeBack then
		item:remove(1)
		player:addItem(coin.changeBack, 100)
	else
		return false
	end
	return true
end

for index, value in pairs(goldCoins) do
	changeGold:id(index)
end

changeGold:register()
