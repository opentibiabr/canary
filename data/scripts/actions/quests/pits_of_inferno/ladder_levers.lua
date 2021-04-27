local pos = { Position(32861, 32305, 11), Position(32860, 32313, 11) }

local pitsOfInfernoLadderLevers = Action()
function pitsOfInfernoLadderLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return false
	end

	item:transform(1946)

	if item.uid == 3301 then
		local lava = Tile(pos[1]):getItemById(598)
		if lava then
			lava:transform(1284)
		end

		local dirtId, dirtItem = { 4808, 4810 }
		for i = 1, #dirtId do
			dirtItem = Tile(pos[1]):getItemById(dirtId[i])
			if dirtItem then
				dirtItem:remove()
			end
		end
	elseif item.uid == 3302 then
		local item = Tile(pos[2]):getItemById(387)
		if item then
			item:remove()
		end
	end
	return true
end

pitsOfInfernoLadderLevers:uid(3301,3302)
pitsOfInfernoLadderLevers:register()