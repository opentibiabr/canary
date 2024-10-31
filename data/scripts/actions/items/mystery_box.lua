local mysteryBox = Action()

function mysteryBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local items = { 25361, 25360 }
	local randomItem = items[math.random(#items)]
	player:addItem(randomItem, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	item:remove(1)
	return true
end

mysteryBox:id(26186)
mysteryBox:register()
