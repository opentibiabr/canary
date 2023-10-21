function Tile.isCreature(self)
	return false
end

function Tile.isItem(self)
	return false
end

function Tile.isTile(self)
	return true
end

function Tile.isContainer(self)
	return false
end

function Tile.relocateTo(self, toPosition)
	if self:getPosition() == toPosition or not Tile(toPosition) then
		return false
	end

	for i = self:getThingCount() - 1, 0, -1 do
		local thing = self:getThing(i)
		if thing then
			if thing:isItem() then
				if thing:getFluidType() ~= 0 then
					thing:remove()
				elseif ItemType(thing:getId()):isMovable() then
					thing:moveTo(toPosition)
				end
			elseif thing:isCreature() then
				thing:teleportTo(toPosition)
			end
		end
	end
	return true
end

function Tile:isWalkable(pz, creature, floorchange, block, proj)
	if not self then
		return false
	end
	if not self:getGround() then
		return false
	end
	if self:hasProperty(CONST_PROP_BLOCKSOLID) or self:hasProperty(CONST_PROP_BLOCKPROJECTILE) then
		return false
	end
	if self:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
		return false
	end
	if pz and (self:hasFlag(TILESTATE_HOUSE) or self:hasFlag(TILESTATE_PROTECTIONZONE)) then
		return false
	end
	if creature and self:getTopCreature() ~= nil then
		return false
	end
	if floorchange and self:hasFlag(TILESTATE_FLOORCHANGE) then
		return false
	end
	if block then
		if self:hasProperty(CONST_PROP_BLOCKPATH) or self:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) or self:hasProperty(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH) or self:hasProperty(CONST_PROP_NOFIELDBLOCKPATH) then
			return false
		end
		local topStackItem = self:getTopTopItem()
		if topStackItem and topStackItem:hasProperty(CONST_PROP_BLOCKPATH) then
			return false
		end
	end
	if proj then
		local items = self:getItems()
		if #items > 0 then
			for i = 1, #items do
				local itemType = ItemType(items[i])
				local blockSolid = items[i]:hasProperty(CONST_PROP_BLOCKSOLID)
				local blockProjectile = items[i]:hasProperty(CONST_PROP_BLOCKPROJECTILE)
				if itemType:getType() ~= ITEM_TYPE_MAGICFIELD and not itemType:isMovable() and (blockSolid or blockProjectile) then
					return false
				end
			end
		end
	end
	return true
end

-- Functions from OTServbr-Global
function Tile.isHouse(self)
	local house = self:getHouse()
	return house and true or false
end

function Tile.isPz(self)
	return self:hasFlag(TILESTATE_PROTECTIONZONE)
end

function Tile:isRopeSpot()
	if not self then
		return false
	end

	if not self:getGround() then
		return false
	end

	if table.contains(ropeSpots, self:getGround():getId()) then
		return true
	end

	for i = 1, self:getTopItemCount() do
		local thing = self:getThing(i)
		if thing and table.contains(specialRopeSpots, thing:getId()) then
			return true
		end
	end

	return false
end
