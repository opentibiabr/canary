local itemsToTransform = {}

-- Automatically transforms items with the ids received into @itemsIds in a cyclical way,
-- present in the Tile at position @position, every @intervalSeconds,
-- with a delay of @creatureOnTopDelaySecs.
-- When transforming and if defined, the onTransform function is called with the transformed tile and item.
function autoTransformItems(itemIds, position, intervalSeconds, creatureOnTopDelaySecs, onTransform)
	local tile = Tile(position)
	if not tile then
		logger.warn("[autoTransformItems]: cannot find tile at Position{}", position:toString())
		return
	end
	local fromItem = nil
	local index = 1
	-- Iterating over this since we are looking for first item id present on the tile in question.
	-- If a tile has item id 2147, but itemsIds {2148, 2147} is passed, it starts counting at 2147
	for i, id in ipairs(itemIds) do
		fromItem = tile:getItemById(id)
		if fromItem then
			index = i
			break
		end
	end
	if not fromItem then
		logger.warn("[autoTransformItems]: cannot find item by any id at Position{}", position:toString())
		return
	end
	if not intervalSeconds then
		intervalSeconds = ItemType(fromItem:getId()):getDecayTime()
	end
	intervalSeconds = math.floor(intervalSeconds)
	if intervalSeconds <= 0 then
		logger.warn("[autoTransformItems]: invalid interval for item with id {} at Position{}", fromItem:getId(), position:toString())
		return
	end
	if not creatureOnTopDelaySecs then
		creatureOnTopDelaySecs = 0
	end
	itemsToTransform[#itemsToTransform+1] = {
		ids = itemIds,
		position = position,
		defaultIntervalMs = intervalSeconds * 1000,
		creatureOnTopDelayMs = creatureOnTopDelaySecs * 1000,
		index = index,
		interval = 0,
		creatureOnTopInterval = 0,
		onTransform = onTransform
	}
end

local autoTransformItemsEvent = GlobalEvent("autoTransformItems.onThink")

function autoTransformItemsEvent.onThink(interval, lastExecution)
	for _, items in ipairs(itemsToTransform) do
		local tile = Tile(items.position)
		if tile then
      -- If a creature above creates a transform delay, the indices must be updated so that the items
			-- remain synchronized with the time of other items on the map that have the same interval.
			-- This does not imply that he will be transformed now.
			local prevId = items.ids[items.index]
			items.interval = items.interval + interval
			if items.interval == items.defaultIntervalMs then
				items.interval = 0
				local nextIndex = items.index + 1
				if nextIndex > #items.ids then
					items.index = 1
				else
					items.index = nextIndex
				end
			end
			local nextId = items.ids[items.index]
			local creatureCount = tile:getCreatureCount()
			if items.creatureOnTopDelayMs > 0 and creatureCount > 0 then
				items.creatureOnTopInterval = items.creatureOnTopInterval + items.creatureOnTopDelayMs
			elseif items.creatureOnTopInterval > 0 then
				items.creatureOnTopInterval = items.creatureOnTopInterval - interval
			elseif prevId ~= nextId then
				local targetItem = tile:getItemById(prevId)
				if targetItem then
					targetItem:transform(nextId)
					-- some items have default decay, but in this case we deactivate it because we are controlling the item's transformations
					targetItem:setAttribute(ITEM_ATTRIBUTE_DECAYSTATE, 0)
					if items.onTransform then
						items.onTransform(tile, targetItem)
					end
				end
			end
		end
	end
	return true
end

autoTransformItemsEvent:interval(1000)
autoTransformItemsEvent:register()
