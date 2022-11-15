local config = {
	[2246] = {
		[1] = {pos = Position(32763, 32292, 14), id = 1271},
		[2] = {pos = Position(32762, 32292, 14), id = 1271},
		[3] = {pos = Position(32761, 32292, 14), id = 1271}
	},
	[2247] = {
		[1] = {pos = Position(32760, 32289, 14), id = 1270},
		[2] = {pos = Position(32760, 32290, 14), id = 1270},
		[3] = {pos = Position(32760, 32291, 14), id = 1270},
		[4] = {pos = Position(32760, 32292, 14), id = 1275}
	},
	[2248] = {
		[1] = {pos = Position(32764, 32292, 14), id = 1274},
		[2] = {pos = Position(32764, 32291, 14), id = 1270},
		[3] = {pos = Position(32764, 32290, 14), id = 1270},
		[4] = {pos = Position(32764, 32289, 14), id = 1270}
	},
	[2249] = {
		[1] = {pos = Position(32760, 32288, 14), id = 1027},
		[2] = {pos = Position(32761, 32288, 14), id = 1271},
		[3] = {pos = Position(32762, 32288, 14), id = 1271},
		[4] = {pos = Position(32763, 32288, 14), id = 1271},
		[5] = {pos = Position(32764, 32288, 14), id = 1273}
	}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(2773)
	if leverItem then
		leverItem:transform(2772)
	end
end

local dreamerWalls = Action()
function dreamerWalls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local walls = config[item.uid]
	if not walls then
		return true
	end

	if item.itemid ~= 2772 then
		return false
	end

	item:transform(2773)
	addEvent(revertLever, 8 * 1000, toPosition)

	local wallItem
	for i = 1, #walls do
		wallItem = Tile(walls[i].pos):getItemById(walls[i].id)
		if wallItem then
			wallItem:remove()
			addEvent(Game.createItem, 7 * 1000, walls[i].id, 1 , walls[i].pos)
		end
	end

	return true
end

for index, value in pairs(config) do
	dreamerWalls:uid(index)
end

dreamerWalls:register()