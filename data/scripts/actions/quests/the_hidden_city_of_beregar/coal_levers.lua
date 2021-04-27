local config = {
	[50108] = {actionId = 50122, wagonPos = Position(32696, 31495, 11)},
	[50109] = {actionId = 50123, wagonPos = Position(32694, 31495, 11)},
	[50110] = {actionId = 50124, wagonPos = Position(32692, 31495, 11)},
	[50111] = {actionId = 50125, wagonPos = Position(32690, 31495, 11)}
}

local theHiddenCoalLevers = Action()
function theHiddenCoalLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	local crucible = Tile(Position(32699, 31494, 11)):getItemById(8641)
	if crucible.actionid == 50121 then
		local wagon = Game.createItem(7132, 1, useItem.wagonPos)
		if wagon then
			wagon:setActionId(useItem.actionId)
		end

		crucible:transform(8642)
	end

	item:transform(item.itemid == 10044 and 10045 or 10044)
	return true
end

theHiddenCoalLevers:uid(50108,50109,50110,50111)
theHiddenCoalLevers:register()