local config = {
	[1945] = {position = {Position(32623, 32188, 9), Position(32623, 32189, 9)}},
	[1946] = {position = {Position(32623, 32189, 9), Position(32623, 32188, 9)}}
}

local theOutlawOven = Action()
function theOutlawOven.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end


	local oven = Tile(useItem.position[1]):getTopTopItem()
	if oven and isInArray({1786, 1787}, oven.itemid) then
		oven:moveTo(useItem.position[2])
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

theOutlawOven:uid(3400)
theOutlawOven:register()