local timiraFightConfig = {
	chestEquipmentChance = 200, -- with modifier x4 and lootRate x3 it gives 3,6% for equipment
	getLootRandomModifier = 4, -- for more info check getLootRandom function in functions.lua
	bucketsRequiredPerPlayerInFight = 2,
	corruptedWaterUsePerPlayerInFight = 2,
	secondsDelayForUseCorruptedWater = 8,
	chestPossibleValuables = {
		"crystal coin",
		"amber",
		"giant sapphire",
		"giant amethyst",
		"Raw Watermelon Tourmaline",
		"Watermelon Tourmaline",
	},
	chestPossibleEquipment = {
		"dawnfire sherwani",
		"dawnfire pantaloons",
		"frostflower boots",
		"feverbloom boots",
		"midnight tunic",
		"midnight sarong",
		"naga sword",
		"naga axe",
		"naga club",
		"naga wand",
		"naga rod",
		"naga crossbow",
		"naga quiver",
	},
}

local fightZone = Zone("fight.timira.encounterZone")
local firstStageZone = Zone("fight.timira.encounterZone.firstStage")
local secondStageZone = Zone("fight.timira.encounterZone.secondStage")
local bossZone = Zone("fight.timira.encounterZone.bossStage")

firstStageZone:addArea({ x = 33787, y = 32684, z = 10 }, { x = 33793, y = 32694, z = 10 }) -- smaller than first stage area, its spawn area
secondStageZone:addArea({ x = 33793, y = 32704, z = 9 }, { x = 33802, y = 32709, z = 9 }) -- smaller than first stage area, its spawn area
bossZone:addArea({ x = 33803, y = 32690, z = 9 }, { x = 33828, y = 32715, z = 9 }) -- whole boss area

fightZone:addArea({ x = 33777, y = 32673, z = 10 }, { x = 33801, y = 32700, z = 10 }) -- whole first stage area
fightZone:addArea({ x = 33784, y = 32701, z = 9 }, { x = 33805, y = 32711, z = 9 }) -- whole second stage area
fightZone:addArea({ x = 33803, y = 32690, z = 9 }, { x = 33828, y = 32715, z = 9 }) -- whole boss stage area

local monstersToKeepSpawning = {
	{ name = "Rogue Naga", amount = 3 },
	{ name = "Corrupt Naga", amount = 3 },
}

local stages = {
	FIRST = 1,
	SECOND = 2,
	THIRD = 3,
}

local firstStageConfig = {
	sparklingBucketId = 39244,
	badWaterBucketId = 39243,
	emptyBucketId = 39242,
	shatteredWaterId = 39269,
	fixedShatteredWaterId = 39268,
	shatteredWaterPosition = Position(33798, 32689, 10),
	sparklesIds = { 1722, 1723 },
	shallowWaterPositions = {
		Position(33793, 32679, 10),
		Position(33794, 32679, 10),
		Position(33793, 32680, 10),
		Position(33794, 32680, 10),
		Position(33795, 32680, 10),
		Position(33793, 32681, 10),
		Position(33794, 32681, 10),
		Position(33795, 32681, 10),
		Position(33796, 32681, 10),
		Position(33794, 32682, 10),
		Position(33795, 32682, 10),
		Position(33796, 32682, 10),
		Position(33794, 32683, 10),
		Position(33795, 32683, 10),
		Position(33796, 32683, 10),
	},
	bucketsPostions = {
		Position(33796, 32685, 10),
		Position(33797, 32691, 10),
		Position(33787, 32687, 10),
		Position(33785, 32676, 10),
	},
	shallowWaterBorderIds = {
		1722,
		1723,
		38125,
		38134,
		38130,
		38126,
		38136,
	},
	isWaterSparkling = false,
	skipedSparklingIterations = 0,
	sparklingIterationsToSkip = 3,
	nextStageTeleportPosition = Position(33787, 32699, 10),
	rewardChestPosition = Position(33789, 32699, 10),
	playersTookReward = {},
}

local secondStageConfig = {
	nextStageTeleportPosition = Position(33804, 32704, 9),
	rewardChestPosition = Position(33802, 32703, 9),
	playersTookReward = {},
}

local activeTeleportId = 35500
local inactiveTeleportId = 39238
local chestId = 39390
local activeStage = stages.FIRST
local firstStagePoints = 0
local secondStagePoints = 0

local function restartShatteredWater()
	local pos = firstStageConfig.shatteredWaterPosition
	if pos:hasItem(firstStageConfig.fixedShatteredWaterId) then
		Tile(pos):getItemById(firstStageConfig.fixedShatteredWaterId):remove(1)
		Game.createItem(firstStageConfig.shatteredWaterId, 1, pos)
	end
end

local function restartBuckets()
	for _, pos in ipairs(firstStageConfig.bucketsPostions) do
		if not pos:hasItem(firstStageConfig.emptyBucketId) then
			Game.createItem(firstStageConfig.emptyBucketId, 1, pos)
		end
	end
end

local function restartTeleports()
	local teleports = { firstStageConfig.nextStageTeleportPosition, secondStageConfig.nextStageTeleportPosition }
	for _, pos in ipairs(teleports) do
		if pos:hasItem(activeTeleportId) then
			Tile(pos):getItemById(activeTeleportId):remove(1)
			Game.createItem(inactiveTeleportId, 1, pos)
		end
	end
end

local function removeRewardChests()
	local chests = { firstStageConfig.rewardChestPosition, secondStageConfig.rewardChestPosition }
	firstStageConfig.playersTookReward = {}
	secondStageConfig.playersTookReward = {}
	for _, pos in ipairs(chests) do
		if pos:hasItem(chestId) then
			Tile(pos):getItemById(chestId):remove(1)
		end
	end
end

local function restart()
	activeStage = stages.FIRST
	firstStagePoints = 0
	secondStagePoints = 0
	firstStageConfig.isWaterSparkling = false
	firstStageConfig.previousIterSkipedSparkling = false
	restartShatteredWater()
	restartBuckets()
	restartTeleports()
	removeRewardChests()
end

local function activeZone()
	local stageZones = {
		[stages.FIRST] = firstStageZone,
		[stages.SECOND] = secondStageZone,
		[stages.THIRD] = {},
	}
	return stageZones[activeStage]
end

local encounter = Encounter("Timira the Many-Headed", {
	zone = fightZone,
	timeToSpawnMonsters = "10ms",
})

encounter
	:addStage({
		start = function()
			restart()
		end,
	})
	:autoAdvance()
encounter:addRemoveMonsters():autoAdvance()
encounter:addStage({ start = function() end }) -- FIRST stage, Action timiraBucket.onUse activates next stage

encounter:addRemoveMonsters():autoAdvance()
encounter:addStage({ start = function() end }) -- SECOND stage, Action corruptedWater.onUse activates next stage

encounter:addRemoveMonsters():autoAdvance()
encounter:addSpawnMonsters({ -- THIRD stage, boss fight
	{
		name = "Timira the Many-Headed",
		positions = { Position(33815, 32703, 9) },
	},
})

encounter:register()

local function startSecondStage()
	if activeStage == stages.FIRST then
		local pos = firstStageConfig.shatteredWaterPosition
		if pos:hasItem(firstStageConfig.shatteredWaterId) then
			Tile(pos):getItemById(firstStageConfig.shatteredWaterId):remove(1)
			Game.createItem(firstStageConfig.fixedShatteredWaterId, 1, pos)
		end
		local tpPos = firstStageConfig.nextStageTeleportPosition
		if tpPos:hasItem(inactiveTeleportId) then
			Tile(tpPos):getItemById(inactiveTeleportId):remove(1)
			Game.createItem(activeTeleportId, 1, tpPos)
		end
		Game.createItem(chestId, 1, firstStageConfig.rewardChestPosition)
		activeStage = stages.SECOND
		encounter:nextStage()
	end
end

local function startThirdStage()
	if activeStage == stages.SECOND then
		local tpPos = secondStageConfig.nextStageTeleportPosition
		if tpPos:hasItem(inactiveTeleportId) then
			Tile(tpPos):getItemById(inactiveTeleportId):remove(1)
			Game.createItem(activeTeleportId, 1, tpPos)
		end
		Game.createItem(chestId, 1, secondStageConfig.rewardChestPosition)
		activeStage = stages.THIRD
		encounter:nextStage()
	end
end

function encounter:onReset(position)
	encounter:removeMonsters()
	fightZone:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Timira the Many-Headed has been defeated. You have %i seconds to leave the room.", 60))
	self:addEvent(function(zn)
		zn:refresh()
		zn:removePlayers()
	end, 60 * 1000, fightZone)
end

local nagaSpawner = GlobalEvent("self.timira.spawner.onThink")
function nagaSpawner.onThink(interval, lastExecution)
	if next(fightZone:getPlayers()) == nil then
		return true
	end

	if activeStage < 3 then
		for _, mob in ipairs(monstersToKeepSpawning) do
			if fightZone:countMonsters(mob.name) < mob.amount then
				encounter:spawnMonsters({ name = mob.name, positions = { activeZone():randomPosition() } })
			end
		end
	end

	return true
end
nagaSpawner:interval(1000)
nagaSpawner:register()

local sparklingWater = GlobalEvent("self.timira.water.onThink")
function sparklingWater.onThink(interval, lastExecution)
	if firstStageConfig.isWaterSparkling then --Sparkling 2s passed, turn it off
		for _, pos in ipairs(firstStageConfig.shallowWaterPositions) do
			for _, spark in ipairs(firstStageConfig.sparklesIds) do
				if pos:hasItem(spark) then
					Tile(pos):getItemById(spark):remove(1)
				end
			end
		end
		firstStageConfig.isWaterSparkling = false
		firstStageConfig.skipedSparklingIterations = 0
		return true
	end

	if next(fightZone:getPlayers()) == nil then
		return true
	end

	if activeStage == stages.FIRST then
		if not firstStageConfig.isWaterSparkling and firstStageConfig.skipedSparklingIterations >= firstStageConfig.sparklingIterationsToSkip then
			for _, pos in ipairs(firstStageConfig.shallowWaterPositions) do
				local spark = firstStageConfig.sparklesIds[math.random(1, #firstStageConfig.sparklesIds)]
				Game.createItem(spark, 1, pos)
			end
			firstStageConfig.isWaterSparkling = true
		else
			firstStageConfig.skipedSparklingIterations = firstStageConfig.skipedSparklingIterations + 1
		end
	end

	return true
end
sparklingWater:interval(2000)
sparklingWater:register()

local timiraBucket = Action()
function timiraBucket.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == firstStageConfig.sparklingBucketId and target and target.itemid == firstStageConfig.shatteredWaterId then
		if player:removeItem(firstStageConfig.sparklingBucketId, 1) then
			player:addItem(firstStageConfig.emptyBucketId, 1)
			toPosition:sendMagicEffect(CONST_ME_WATER_DROP)
			firstStagePoints = firstStagePoints + 1

			if activeStage == stages.FIRST and firstStagePoints >= fightZone:countPlayers() * timiraFightConfig.bucketsRequiredPerPlayerInFight then
				player:say("The water has formed into a shape!", TALKTYPE_MONSTER_SAY, false, 0, firstStageConfig.shatteredWaterPosition)
				startSecondStage()
				return true
			end
			player:say("The pieces are shining!", TALKTYPE_MONSTER_SAY, false, 0, firstStageConfig.shatteredWaterPosition)
		end
		return true
	end
	if item.itemid == firstStageConfig.badWaterBucketId and target and target.itemid ~= firstStageConfig.shatteredWaterId then
		if player:removeItem(firstStageConfig.badWaterBucketId, 1) then
			player:addItem(firstStageConfig.emptyBucketId, 1)
			local splash = Game.createItem(2886, 0, toPosition)
			splash:decay()
		end
		return true
	end
	if item.itemid == firstStageConfig.emptyBucketId and target and table.contains(firstStageConfig.shallowWaterBorderIds, target.itemid) then
		if player:removeItem(firstStageConfig.emptyBucketId, 1) then
			if firstStageConfig.isWaterSparkling then
				player:addItem(firstStageConfig.sparklingBucketId, 1)
			else
				player:addItem(firstStageConfig.badWaterBucketId, 1)
			end
		end
		return true
	end
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end
timiraBucket:id(firstStageConfig.sparklingBucketId, firstStageConfig.emptyBucketId, firstStageConfig.badWaterBucketId)
timiraBucket:allowFarUse(true)
timiraBucket:register()

local corruptedWater = Action()
function corruptedWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not activeStage == stages.SECOND then
		return false
	end
	local currentIcon = player:getIcon("timira-secondStage")
	if not currentIcon or currentIcon.category ~= CreatureIconCategory_Quests or currentIcon.icon ~= CreatureIconQuests_RedShield then
		secondStagePoints = secondStagePoints + 1
		if secondStagePoints >= fightZone:countPlayers() * timiraFightConfig.corruptedWaterUsePerPlayerInFight then
			startThirdStage()
			return true
		end
		player:setIcon("timira-secondStage", CreatureIconCategory_Quests, CreatureIconQuests_RedShield, 1)
		addEvent(function(playerUid)
			local player = Player(playerUid)
			if player then
				player:removeIcon("timira-secondStage")
			end
			return true
		end, timiraFightConfig.secondsDelayForUseCorruptedWater * 1000, player:getGuid())
		return true
	end
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
end
corruptedWater:id(39267)
corruptedWater:register()

local timiraChest = Action()
function timiraChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewards = {
		[firstStageConfig.rewardChestPosition.z] = firstStageConfig.playersTookReward,
		[secondStageConfig.rewardChestPosition.z] = secondStageConfig.playersTookReward,
	}

	if table.contains(rewards[toPosition.z], player:getGuid()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	table.insert(rewards[toPosition.z], player:getGuid())
	local randValue = getLootRandom(timiraFightConfig.getLootRandomModifier)
	local itemName = timiraFightConfig.chestPossibleValuables[math.random(1, #timiraFightConfig.chestPossibleValuables)]
	if randValue <= timiraFightConfig.chestEquipmentChance then
		itemName = timiraFightConfig.chestPossibleEquipment[math.random(1, #timiraFightConfig.chestPossibleEquipment)]
	end

	local rewardItem = ItemType(itemName)
	player:addItem(rewardItem:getId(), 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. itemName .. ".")
	return true
end
timiraChest:id(chestId)
timiraChest:register()
