local config = {
	[2246] = {
		[1] = {pos = Position(32763, 32292, 14), id = 1026},
		[2] = {pos = Position(32762, 32292, 14), id = 1026},
		[3] = {pos = Position(32761, 32292, 14), id = 1026}
	},
	[2247] = {
		[1] = {pos = Position(32760, 32289, 14), id = 1025},
		[2] = {pos = Position(32760, 32290, 14), id = 1025},
		[3] = {pos = Position(32760, 32291, 14), id = 1025},
		[4] = {pos = Position(32760, 32292, 14), id = 1030}
	},
	[2248] = {
		[1] = {pos = Position(32764, 32292, 14), id = 1029},
		[2] = {pos = Position(32764, 32291, 14), id = 1025},
		[3] = {pos = Position(32764, 32290, 14), id = 1025},
		[4] = {pos = Position(32764, 32289, 14), id = 1025}
	},
	[2249] = {
		[1] = {pos = Position(32760, 32288, 14), id = 1027},
		[2] = {pos = Position(32761, 32288, 14), id = 1026},
		[3] = {pos = Position(32762, 32288, 14), id = 1026},
		[4] = {pos = Position(32763, 32288, 14), id = 1026},
		[5] = {pos = Position(32764, 32288, 14), id = 1028}
	}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

local dreamerWalls = Action()
function dreamerWalls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local walls = config[item.uid]
	if not walls then
		return true
	end

	if item.itemid ~= 1945 then
		return false
	end

	item:transform(1946)
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