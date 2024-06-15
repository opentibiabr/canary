-- Automated transform items are sent through this callback as soon as they transform, just like your Tile
local function onTransformIntoBlades(tile, item)
	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and item:getId() == 2146 then
		for _, creature in ipairs(tile:getCreatures()) do
			doTargetCombatHealth(0, creature, COMBAT_PHYSICALDAMAGE, -50, -100, CONST_ME_NONE)
		end
	end
end

local slitsBlades = {
	ids = { 2145, 2146 },
	params = {
		-- poi end
		-- some slits from poi is not here since these are traps exclusively
		-- triggered by the player's walking, not by autoTransformItems
		{ position = Position(32839, 32251, 10), intervalSeconds = 1, onTransform = onTransformIntoBlades },
		{ position = Position(32839, 32253, 10), intervalSeconds = 1, onTransform = onTransformIntoBlades },
		--
	},
}

-- Automated transform items are sent through this callback as soon as they transform, just like your Tile
local function onTransformIntoSpikes(tile, item)
	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and item:getId() == 2148 then
		for _, creature in ipairs(tile:getCreatures()) do
			doTargetCombatHealth(0, creature, COMBAT_PHYSICALDAMAGE, -15, -30, CONST_ME_NONE)
		end
	end
end

local holesSpikes = {
	ids = { 2147, 2148 },
	params = {
		-- poi end
		{ position = Position(32833, 32250, 10), intervalSeconds = 6, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32251, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32252, 10), intervalSeconds = 4, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32253, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32254, 10), intervalSeconds = 6, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32250, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32251, 10), intervalSeconds = 4, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32252, 10), intervalSeconds = 6, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32253, 10), intervalSeconds = 4, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32254, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32250, 10), intervalSeconds = 1, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32251, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32252, 10), intervalSeconds = 1, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32253, 10), intervalSeconds = 2, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32254, 10), intervalSeconds = 1, onTransform = onTransformIntoSpikes },
		--
	},
}

local function addItemsToAutoTransform(data)
	for _, param in ipairs(data.params) do
		autoTransformItems(data.ids, param.position, param.intervalSeconds, param.onTransform)
	end
end

local function addSpikesTest()
	local load = 25
	local centerX = 32636
	local centerY = 31996
	local centerZ = 7
	local tiles = {}
	for x = -load, load do
		for y = -load, load do
			local position = Position(centerX + x, centerY + y, centerZ)
			local tile = position:getTile()
			if tile and tile:getGround() then
				tiles[#tiles+1] = tile
			end
		end
	end
	local count = 0
	for _, tile in ipairs(tiles) do
		if tile:addItem(2147) then
			autoTransformItems({ 2147, 2148 }, tile:getPosition(), math.random(3), onTransformIntoSpikes)
			count = count + 1
		end
	end
	logger.info("[addSpikesTest]: added {} items to auto transform", count)
end

local addItemsToAutoTransformEvent = GlobalEvent("addItemsToAutoTransform.onStartup")
function addItemsToAutoTransformEvent.onStartup()
	addItemsToAutoTransform(slitsBlades)
	addItemsToAutoTransform(holesSpikes)
	addSpikesTest()
end

addItemsToAutoTransformEvent:register()
