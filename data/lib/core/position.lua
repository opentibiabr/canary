-- Functions from The Forgotten Server
Position.directionOffset = {
	[DIRECTION_NORTH] = {x = 0, y = -1},
	[DIRECTION_EAST] = {x = 1, y = 0},
	[DIRECTION_SOUTH] = {x = 0, y = 1},
	[DIRECTION_WEST] = {x = -1, y = 0},
	[DIRECTION_SOUTHWEST] = {x = -1, y = 1},
	[DIRECTION_SOUTHEAST] = {x = 1, y = 1},
	[DIRECTION_NORTHWEST] = {x = -1, y = -1},
	[DIRECTION_NORTHEAST] = {x = 1, y = -1}
}

function Position:getNextPosition(direction, steps)
	local offset = Position.directionOffset[direction]
	if offset then
		steps = steps or 1
		self.x = self.x + offset.x * steps
		self.y = self.y + offset.y * steps
	end
end

function Position:moveUpstairs()
	local swap = function (lhs, rhs)
		lhs.x, rhs.x = rhs.x, lhs.x
		lhs.y, rhs.y = rhs.y, lhs.y
		lhs.z, rhs.z = rhs.z, lhs.z
	end

	self.z = self.z - 1

	local defaultPosition = self + Position.directionOffset[DIRECTION_SOUTH]
	local toTile = Tile(defaultPosition)
	if not toTile or not toTile:isWalkable(false, false, false, false, true) then
		for direction = DIRECTION_NORTH, DIRECTION_NORTHEAST do
			if direction == DIRECTION_SOUTH then
				direction = DIRECTION_WEST
			end

			local position = self + Position.directionOffset[direction]
			toTile = Tile(position)
			if toTile and toTile:isWalkable(false, false, false, false, true) then
				swap(self, position)
				return self
			end
		end
	end
	swap(self, defaultPosition)
	return self
end

-- Functions from OTServBR-Global
function Position:isInRange(from, to)
	-- No matter what corner from and to is, we want to make
	-- life easier by calculating north-west and south-east
	local zone = {
		nW = {
			x = (from.x < to.x and from.x or to.x),
			y = (from.y < to.y and from.y or to.y),
			z = (from.z < to.z and from.z or to.z)
		},
		sE = {
			x = (to.x > from.x and to.x or from.x),
			y = (to.y > from.y and to.y or from.y),
			z = (to.z > from.z and to.z or from.z)
		}
	}

	if  self.x >= zone.nW.x and self.x <= zone.sE.x
	and self.y >= zone.nW.y and self.y <= zone.sE.y
	and self.z >= zone.nW.z and self.z <= zone.sE.z then
		return true
	end
	return false
end

function Position:moveDownstairs()
	local swap = function (lhs, rhs)
		lhs.x, rhs.x = rhs.x, lhs.x
		lhs.y, rhs.y = rhs.y, lhs.y
		lhs.z, rhs.z = rhs.z, lhs.z
	end

	self.z = self.z + 1

	local defaultPosition = self + Position.directionOffset[DIRECTION_SOUTH]
	local tile = Tile(defaultPosition)
	if not tile then return false end

	if not tile:isWalkable(false, false, false, false, true) then
		for direction = DIRECTION_NORTH, DIRECTION_NORTHEAST do
			if direction == DIRECTION_SOUTH then
				direction = DIRECTION_WEST
			end

			local position = self + Position.directionOffset[direction]
			local newTile = Tile(position)
			if not newTile then return false end

			if newTile:isWalkable(false, false, false, false, true) then
				swap(self, position)
				return self
			end
		end
	end
	swap(self, defaultPosition)
	return self
end

function Position.getTile(self)
	return Tile(self)
end

function Position:getDistanceBetween(position)
	local xDif = math.abs(self.x - position.x)
	local yDif = math.abs(self.y - position.y)
	local posDif = math.max(xDif, yDif)
	if self.z ~= position.z then
		posDif = posDif + 15
	end
	return posDif
end

function Position:compare(position)
	return self.x == position.x and self.y == position.y and self.z == position.z
end

function Position.hasPlayer(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

function Position.removeMonster(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	local spectators,
	spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end
end

function Position.getFreePosition(from, to)
	local result, tries = Position(from.x, from.y, from.z), 0
	repeat
		local x, y, z = math.random(from.x, to.x), math.random(from.y, to.y), math.random(from.z, to.z)
		result = Position(x, y, z)
		tries = tries + 1
		if tries >= 20 then
			return result
		end

		local tile = Tile(result)

	until tile and tile:isWalkable(false, false, false, false, true)
	return result
end

function Position.getFreeSand()
	local from, to = ghost_detector_area.from, ghost_detector_area.to
	local result, tries = Position(from.x, from.y, from.z), 0
	repeat
		local x, y, z = math.random(from.x, to.x), math.random(from.y, to.y), math.random(from.z, to.z)
		result = Position(x, y, z)
		tries = tries + 1
		if tries >= 50 then
			return result
		end

		local tile = Tile(result)

	until tile and tile:isWalkable(false, false, false, false, true) and tile:getGround():getName() == "grey sand"
	return result
end

function Position.getDirectionTo(pos1, pos2)
	local dir = DIRECTION_NORTH
	if (pos1.x > pos2.x) then
		dir = DIRECTION_WEST
		if(pos1.y > pos2.y) then
			dir = DIRECTION_NORTHWEST
		elseif(pos1.y < pos2.y) then
			dir = DIRECTION_SOUTHWEST
		end
	elseif (pos1.x < pos2.x) then
		dir = DIRECTION_EAST
		if(pos1.y > pos2.y) then
			dir = DIRECTION_NORTHEAST
		elseif(pos1.y < pos2.y) then
			dir = DIRECTION_SOUTHEAST
		end
	else
		if (pos1.y > pos2.y) then
			dir = DIRECTION_NORTH
		elseif(pos1.y < pos2.y) then
			dir = DIRECTION_SOUTH
		end
	end
	return dir
end

-- Checks if there is a creature in a certain position (self)
-- If so, teleports to another position (teleportTo)
function Position:hasCreature(teleportTo)
	local creature = Tile(self):getTopCreature()
	if creature then
		creature:teleportTo(teleportTo, true)
	end
end

--[[
Checks whether there is an item in a position table
Use the index to check which positions the script should check

-- Position table
local position = {
	{x = 1000, y = 1000, z = 7},
	{x = 1001, y = 1000, z = 7}
}

-- Checks position 1
if Position(position[1]):hasItem(1498) then
	return true
end

-- Checks position 2
if Position(position[2]):hasItem(1499) then
	return true
end

-- Check two positions
if Position(position[1]):hasItem(1498) and Position(position[2]):hasItem(1499) then
	return true
end
]]
function Position:hasItem(itemId)
	local tile = Tile(self)
	if tile then
		local item = tile:getItemById(itemId)
		if item then
			return true
		end
	end
end

--[[
position.hasCreatureInArea({x = positionx, y = positiony, z = positionz}, {x = positionx, y = positiony, z = positionz}, true or false, true or false, {x = positionx, y = positiony, z = positionz})

fromPosition: is the upper left corner
toPosition: is the lower right corner,
removeCreatures[true or false]: is to say whether or not to remove the monster
removePlayer[true or false]  is to say whether or not to remove the player
teleportTo: is where you will teleport the player (it is only necessary to put this position in the function, if the previous value is true)
]]

function Position.hasCreatureInArea(fromPosition, toPosition, removeCreatures, removePlayer, teleportTo)
	for positionX = fromPosition.x, toPosition.x do
		for positionY = fromPosition.y, toPosition.y do
        	for positionZ = fromPosition.z, toPosition.z do
		        local room = {x = positionX, y = positionY, z= positionZ}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, creature in pairs(creatures) do
							if removeCreatures == true then
								if removePlayer == true then
									if isPlayer(creature) then
										creature:teleportTo(teleportTo)
									end
								end
								if isMonster(creature) then
									creature:remove()
								end
							end
						end
					end
				end
			end
		end
	end
end

--[[
If the script have one lever and item to revert uses:
Position.revertItem(createItemPosition, createItemId, tilePosition, itemTransform, itemId, effect)

If not have lever, use only the first two variables
Revert item: Position.revertItem(createItemPosition, createItemId)
"effect" variable is optional
]]
function Position.revertItem(positionCreateItem, itemIdCreate, positionTransform, itemId, itemTransform, effect)
	local tile = Tile(positionTransform)
	if tile then
		local lever = tile:getItemById(itemId)
		if lever then
			lever:transform(itemTransform)
		end
	end

	local getItemTile = Tile(positionCreateItem)
	if getItemTile then
		local getItemId = getItemTile:getItemById(itemIdCreate)
		if not getItemId then
			Game.createItem(itemIdCreate, 1, positionCreateItem)
			Position(positionCreateItem):sendMagicEffect(effect)
		end
	end
end

-- Position.transformItem(itemPosition, itemId, itemTransform, effect)
-- Variable "effect" is optional
function Position:transformItem(itemId, itemTransform, effect)
	local thing = Tile(self):getItemById(itemId)
	if thing then
		thing:transform(itemTransform)
		Position(self):sendMagicEffect(effect)
	end
end

-- Position.createItem(tilePosition, itemId, effect)
-- Variable "effect" is optional
function Position:createItem(itemId, effect)
	local tile = Tile(self)
	if not tile then
		return true
	end

	local thing = tile:getItemById(itemId)
	if not thing then
		Game.createItem(itemId, 1, self)
		Position(self):sendMagicEffect(effect)
	end
end

-- Position.removeItem(position, itemId, effect)
-- Variable "effect" is optional
function Position:removeItem(itemId, effect)
	local tile = Tile(self)
	if not tile then
		return true
	end

	local thing = tile:getItemById(itemId)
	if thing then
		thing:remove(1)
		Position(self):sendMagicEffect(effect)
	end
end
