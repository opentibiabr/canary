local trees = {
	Position(32857, 32231, 11),
	Position(32857, 32232, 11),
	Position(32857, 32233, 11),
}

local deathRing = MoveEvent()

function deathRing.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid ~= 6299 then
		return true
	end

	local found = false
	for i = 1, #trees do
		local treeItem = Tile(trees[i]):getItemById(3636)
		if treeItem then
			treeItem:remove()
			trees[i]:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			moveitem:remove()
			found = true
		end
	end
	return found
end

deathRing:type("additem")
deathRing:uid(2244)
deathRing:register()
