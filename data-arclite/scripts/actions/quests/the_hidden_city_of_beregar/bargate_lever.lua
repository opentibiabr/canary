local config = {
	{gatePosX = Position(32569, 31421, 9), gatePosY = Position(32569, 31422, 9), tileIdX = 501, tileIdY = 502},
	{gatePosX = Position(32600, 31421, 9), gatePosY = Position(32600, 31422, 9), tileIdX = 502, tileIdY = 501}
}

local function wall(i)
	if Tile(config[i].gatePosX):getItemById(1613) then
		Tile(config[i].gatePosX):getItemById(1613):remove(1613)
		Tile(config[i].gatePosX):getItemById(1608):remove(1608)
		Tile(config[i].gatePosY):getItemById(1613):remove(1613)
		Tile(config[i].gatePosY):getItemById(1608):remove(1608)
	else
		Game.createItem(1613, 1, config[i].gatePosX)
		Game.createItem(1608, 1, config[i].gatePosX)
		Game.createItem(1613, 1, config[i].gatePosY)
		Game.createItem(1608, 1, config[i].gatePosY)
	end
end

local theHiddenBeregar = Action()
function theHiddenBeregar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray({32568, 32570}, item:getPosition().x) and player:getPosition().x ~= 32569 then
		wall(1)
	elseif isInArray({32599, 32601}, item:getPosition().x) and player:getPosition().x ~= 32600 then
		wall(2)
	end
	return item:transform(item.itemid == 2772 and 2773 or 2772)
end

theHiddenBeregar:aid(30005)
theHiddenBeregar:register()
