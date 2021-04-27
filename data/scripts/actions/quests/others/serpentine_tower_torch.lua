local othersSerpentineTorch = Action()
function othersSerpentineTorch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem = Tile(33151, 32866, 8):getItemById(1100)
	if wallItem then
		wallItem:remove()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

othersSerpentineTorch:aid(5632)
othersSerpentineTorch:register()