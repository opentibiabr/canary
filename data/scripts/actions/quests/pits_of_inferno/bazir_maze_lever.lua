local pitsOfInfernoMazeLever = Action()
function pitsOfInfernoMazeLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local portal = Tile(Position(32816, 32345, 13)):getItemById(1387)
	if not portal then
		local item = Game.createItem(1387, 1, Position(32816, 32345, 13))
		if item:isTeleport() then
			item:setDestination(Position(32767, 32366, 15))
		end
	else
		portal:remove()
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

pitsOfInfernoMazeLever:uid(50105)
pitsOfInfernoMazeLever:register()