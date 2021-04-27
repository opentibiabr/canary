-- NEED REVIEW
local config = {
	gatePositions = {
		Position(32569, 31421, 9),
		Position(32569, 31422, 9)
	},
	leverPositions = {
		Position(32568, 31421, 9),
		Position(32570, 31421, 9)
	},
	removeCreaturePosition = Position(32568, 31422, 9),
	wallID = 3519,
	wallID2 = 3524,
	tileID = 3154
}

local theHiddenBeregar = Action()
function theHiddenBeregar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile, thing, thing2 , creature, lever, leverstatus
	leverstatus = item.itemid
	for i = 1, #config.leverPositions do
		lever = Tile(config.leverPositions[i]):getItemById(leverstatus == 1945 and 1945 or 1946)
		lever:transform(item.itemid == 1945 and 1946 or 1945)
	end
	for i = 1, #config.gatePositions do
		tile = Tile(config.gatePositions[i])
		if tile then
			creature = tile:getTopCreature()
			if leverstatus == 1945 then
				thing = tile:getItemById(config.wallID)
				thing2 = tile:getItemById(config.wallID2)
				if thing and thing2 then
					thing:remove()
					thing2:remove()
				end
			else
				Game.createItem(config.wallID, 1, config.gatePositions[i])
				Game.createItem(config.wallID2, 1, config.gatePositions[i])
			end
			if creature then
				creature:teleportTo(config.removeCreaturePosition)
			end
		end
	end
	return true
end

--theHiddenBeregar:id()
--theHiddenBeregar:register()