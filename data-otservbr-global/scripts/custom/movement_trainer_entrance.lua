local config = {
	-- Position of the first position (line 1 column 1)
	firstRoomPosition = {x = 1018, y = 1112, z = 7},
	-- X distance between each room (on the same line)
	distancePositionX= 12,
	-- Y distance between each room (on the same line)
	distancePositionY= 12,
	-- Number of columns
	columns= 7,
	-- Number of lines
	lines= 54
}

local function isBusyable(position)
	local player = Tile(position):getTopCreature()
	if player then
		if player:isPlayer() then
			return false
		end
	end

	local tile = Tile(position)
	if not tile then
		return false
	end

	local ground = tile:getGround()
	if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) then
		return false
	end

	local items = tile:getItems()
	for i = 1, tile:getItemCount() do
		local item = items[i]
		local itemType = item:getType()
		if itemType:getType() ~= ITEM_TYPE_MAGICFIELD and not itemType:isMovable() and item:hasProperty(CONST_PROP_BLOCKSOLID) then
			return false
		end
	end
	return true
end

local function calculatingRoom(uid, position, column, line)
	local player = Player(uid)
	if column >= config.columns then
		column = 0
		line = line < (config.lines -1) and line + 1 or false
	end

	if line then
		local room_pos = {x = position.x + (column * config.distancePositionX), y = position.y + (line * config.distancePositionY), z = position.z}
		if isBusyable(room_pos) then
			player:teleportTo(room_pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			calculatingRoom(uid, position, column + 1, line)
		end
	else
		player:sendCancelMessage("Couldn't find any position for you right now.")
	end
end

local trainerEntrance = MoveEvent()
function trainerEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	calculatingRoom(creature.uid, config.firstRoomPosition, 0, 0)
	Game.createMonster("training machine", creature:getPosition(), true, false)
	Game.createMonster("training machine", creature:getPosition(), true, false)
	return true
end

trainerEntrance:position({x = 1116, y = 1092, z = 7})
trainerEntrance:register()
