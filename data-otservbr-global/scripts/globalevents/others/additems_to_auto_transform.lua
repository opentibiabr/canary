-- Automated transform items are sent through this callback as soon as they transform, just like your Tile
function onTransformIntoBlades(tile, item)
	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and item:getId() == 2146 then
		for _, creature in ipairs(tile:getCreatures()) do
			doTargetCombatHealth(0, creature, COMBAT_PHYSICALDAMAGE, -50, -100, CONST_ME_NONE)
		end
	end
end

local slitsBlades = {
  ids = {2145, 2146},
  params = {
		-- poi end
		-- some slits from poi is not here since these are traps exclusively
		-- triggered by the player's walking, not by autoTransformItems
		{ position = Position(32839, 32251, 10), intervalSeconds = 1, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoBlades },
		{ position = Position(32839, 32253, 10), intervalSeconds = 1, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoBlades },
		--
  },
}

-- Automated transform items are sent through this callback as soon as they transform, just like your Tile
function onTransformIntoSpikes(tile, item)
	if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and item:getId() == 2148 then
		for _, creature in ipairs(tile:getCreatures()) do
			doTargetCombatHealth(0, creature, COMBAT_PHYSICALDAMAGE, -15, -30, CONST_ME_NONE)
		end
	end
end

local holesSpikes = {
	ids = {2147, 2148},
	params = {
		-- poi end
		{ position = Position(32833, 32250, 10), intervalSeconds = 6, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32251, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32252, 10), intervalSeconds = 4, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32253, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32833, 32254, 10), intervalSeconds = 6, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32250, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32251, 10), intervalSeconds = 4, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32252, 10), intervalSeconds = 6, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32253, 10), intervalSeconds = 4, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32835, 32254, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32250, 10), intervalSeconds = 1, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32251, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32252, 10), intervalSeconds = 1, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32253, 10), intervalSeconds = 2, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		{ position = Position(32838, 32254, 10), intervalSeconds = 1, creatureOnTopDelaySecs = 0, onTransform = onTransformIntoSpikes },
		--
	}
}

local function addItemsToAutoTransform(data)
	for _, param in ipairs(data.params) do
		autoTransformItems(data.ids, param.position, param.intervalSeconds, param.creatureOnTopDelaySecs, param.onTransform)
	end
end

local addItemsToAutoTransformEvent = GlobalEvent("addItemsToAutoTransform.onStartup")
function addItemsToAutoTransformEvent.onStartup()
	addItemsToAutoTransform(slitsBlades)
	addItemsToAutoTransform(holesSpikes)
end
addItemsToAutoTransformEvent:register()
