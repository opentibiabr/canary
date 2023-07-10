local config = {
	{railPos = Position(32696, 31453, 13), leverpos = Position(32697, 31454, 13)}, -- 11
	{railPos = Position(32692, 31453, 13), leverpos = Position(32691, 31452, 13)}, -- 10
	{railPos = Position(32687, 31452, 13), leverpos = Position(32686, 31452, 13)}, -- 9
	{railPos = Position(32682, 31455, 13), leverpos = Position(32683, 31455, 13)}, -- 8
	{railPos = Position(32688, 31456, 13), leverpos = Position(32687, 31457, 13)}, -- 7
	{railPos = Position(32692, 31459, 13), leverpos = Position(32693, 31458, 13)}, -- 6
	{railPos = Position(32696, 31461, 13), leverpos = Position(32696, 31462, 13)}, -- 5
	{railPos = Position(32695, 31464, 13), leverpos = Position(32696, 31465, 13)}, -- 4
	{railPos = Position(32690, 31465, 13), leverpos = Position(32691, 31464, 13)}, -- 3
	{railPos = Position(32684, 31464, 13), leverpos = Position(32685, 31465, 13)}, -- 2
	{railPos = Position(32688, 31469, 13), leverpos = Position(32689, 31470, 13)}, -- 1
	{railPos = Position(32696, 31495, 11), leverpos = Position(32697, 31495, 11)}, -- station 4
	{railPos = Position(32694, 31495, 11), leverpos = Position(32695, 31495, 11)}, -- station 3
	{railPos = Position(32692, 31495, 11), leverpos = Position(32693, 31495, 11)}, -- station 2
	{railPos = Position(32690, 31495, 11), leverpos = Position(32691, 31495, 11)}, -- station 1
}

local theHiddenWagonLevers = Action()
function theHiddenWagonLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #config do
		local table = config[i]
		if fromPosition == table.leverpos and i < 12 then
			local tile = Tile(table.railPos)
			if tile:getItemById(7130) then
				tile:getItemById(7130):transform(7121)
			else
				for j = 7121, 7130 do
					if tile:getItemById(j) then
						tile:getItemById(j):transform(j + 1)
						return item:transform(item.itemid == 8913 and 8914 or 8913)
					end
				end
			end
		elseif fromPosition == table.leverpos then
			local crucible = Tile(Position(32699, 31494, 11)):getItemById(7813)
			if not crucible then
				return true
			end
			if crucible.actionid == 50121 then
				local check = Tile(table.railPos):getItemById(7132)
				if check then
					return true
				end
				local wagon = Game.createItem(7132, 1, table.railPos)
				if wagon then
					wagon:setActionId(40023)
				end
				crucible:transform(7814)
				return item:transform(item.itemid == 9125 and 9126 or 9125)
			end
		end
	end
	return true
end

theHiddenWagonLevers:aid(40024)
theHiddenWagonLevers:register()
