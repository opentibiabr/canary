local config = {
	-- Position of the first position (line 1 column 1)
	firstRoomPosition = Position(1018, 1112, 7),
	-- X distance between each room (on the same line)
	distancePositionX = 12,
	-- Y distance between each room (on the same line)
	distancePositionY = 12,
	-- Number of columns
	columns = 7,
	-- Number of lines
	lines = 54,
	-- Teleports in cities
	entrances = {
		Position(32364, 32232, 7), --thais
		Position(32362, 31785, 7), --carlin
		Position(33221, 31818, 8), --edron
		Position(32961, 32074, 7), --venore
		Position(33210, 32453, 1), --darashia
		Position(33196, 32849, 8), --ankrahmun
		Position(32319, 32818, 7), --liberty bay
		Position(32785, 31249, 5), --yalahar
		Position(33521, 32358, 7), --roshamuul
	},
}

local function isBusyable(position)
	local creature = Tile(position):getTopCreature()
	if creature then
		if creature:isPlayer() or creature:getMaster() then
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
		line = line < (config.lines - 1) and line + 1 or false
	end

	if line then
		local room_pos = { x = position.x + (column * config.distancePositionX), y = position.y + (line * config.distancePositionY), z = position.z }
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

local function teleportToLastPosition(creature)
	if creature:isPlayer() then
		local lastPos, position = creature:kv():scoped("trainer"):get("last-position") or "", creature:getTown():getTemplePosition()
		if lastPos ~= "" then
			local pos = lastPos:split(",")
			position = Position(pos[1], pos[2], pos[3])
		end
		creature:teleportTo(position)
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
end

---------------------- Entrance ----------------------
local trainerEntrance = MoveEvent()
function trainerEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	creature:kv():scoped("trainer"):set("last-position", string.format("%s,%s,%s", fromPosition.x, fromPosition.y, fromPosition.z))
	calculatingRoom(creature.uid, config.firstRoomPosition, 0, 0)
	Game.createMonster("Training Machine", creature:getPosition(), true, false)
	Game.createMonster("Training Machine", creature:getPosition(), true, false)
	return true
end

for index, position in pairs(config.entrances) do
	trainerEntrance:position(position)
end
trainerEntrance:register()

---------------------- Exit ----------------------
local trainerExit = MoveEvent()
function trainerExit.onStepIn(creature, item, position, fromPosition)
	teleportToLastPosition(creature)
	return true
end

trainerExit:aid(40015)
trainerExit:register()
