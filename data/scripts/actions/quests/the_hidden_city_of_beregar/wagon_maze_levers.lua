local levers = {
	{uniqueId = 50113, railPos = Position(32696, 31453, 13)},
	{uniqueId = 50114, railPos = Position(32692, 31453, 13)},
	{uniqueId = 50115, railPos = Position(32687, 31452, 13)},
	{uniqueId = 50116, railPos = Position(32682, 31455, 13)},
	{uniqueId = 50117, railPos = Position(32688, 31456, 13)},
	{uniqueId = 50118, railPos = Position(32692, 31459, 13)},
	{uniqueId = 50119, railPos = Position(32696, 31461, 13)},
	{uniqueId = 50120, railPos = Position(32695, 31464, 13)},
	{uniqueId = 50121, railPos = Position(32690, 31465, 13)},
	{uniqueId = 50122, railPos = Position(32684, 31464, 13)},
	{uniqueId = 50123, railPos = Position(32688, 31469, 13)}
}

local theHiddenWagonLevers = Action()
function theHiddenWagonLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	for i = 1, #config do
		local table = config[i]
		if item.uid == table.uniqueId then
			local tile = Tile(railPos)
			if tile:getItemById(7130) then
				tile:getItemById(7130):transform(7121)
			else
				tile:getItemById():transform(item.itemid + 1)
			end
		end
	end
	item:transform(item.itemid == 10044 and 10045 or 10044)
	return true
end

for value = 50113, 50123 do
	theHiddenWagonLevers:uid(value)
end
theHiddenWagonLevers:register()