config = {
	enable = true,
	startChance = 10,
	wydaPosition = Position(32719, 31983, 7),
	spawnRadius = 10,
	spawnAmount = 3,
	spawnmaxAttempts = 10,
	spawnMonsterName = "Giant Spider Wyda",
	monsterDeathEvent = "GiantSpiderWyda",
	kv = KV.scoped("worldchanges"):scoped("bored"),
	isActive = function()
		return config.kv:get("active")
	end,
	setActive = function(value)
		config.kv:set("active", value)
	end,
}

local function getRandomSpawnPosition(centerPosition, radius)
	local offsetX = math.random(-radius, radius)
	local offsetY = math.random(-radius, radius)
	return Position(centerPosition.x + offsetX, centerPosition.y + offsetY, centerPosition.z)
end

local function canSpawnAt(position)
	local tile = Tile(position)
	if not tile or tile:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end

	return true
end

local function spawnFakeGiantSpider(position)
	local monster = Game.createMonster(config.spawnMonsterName, position, true, true)
	if not monster then
		logger.error("[MiniWorldChange] Failed to spawn {} at {}", config.spawnMonsterName, position)
		return false
	end

	monster:registerEvent(config.monsterDeathEvent)
	monster:setSpawnPosition()
	monster:remove()
	return true
end

local function spawnBoredMiniWorldChange()
	if not config.isActive() then
		return true
	end

	local spawnedCount = 0
	local attemptedCount = 0
	local Attempts = config.spawnAmount * config.spawnmaxAttempts

	while spawnedCount < config.spawnAmount and attemptedCount < Attempts do
		attemptedCount = attemptedCount + 1
		local spawnPosition = getRandomSpawnPosition(config.wydaPosition, config.spawnRadius)
		if canSpawnAt(spawnPosition) then
			if spawnFakeGiantSpider(spawnPosition) then
				spawnedCount = spawnedCount + 1
			end
		end
	end
	return true
end

local boredMiniWorldChangeStartUp = GlobalEvent("BoredMiniWorldChangeStartUp")

function boredMiniWorldChangeStartUp.onStartup()
	if not config.enable then
		logger.info("[MiniWorldChange] Bored Mini World Change is disabled in config - data-otservbr-global/scripts/world_changes/bored_mini_world_change.lua")
		return true
	end

	if not config.isActive() then
		local rolledActive = math.random(100) <= config.startChance
		if not rolledActive then
			return true
		end
	end

	config.setActive(true)
	logger.info("[MiniWorldChange] Bored Mini World Change active")
	return spawnBoredMiniWorldChange()
end

boredMiniWorldChangeStartUp:register()

local boredMiniWorldChangeGlobalServerSave = GlobalEvent("boredMiniWorldChangeGlobalServerSave")

function boredMiniWorldChangeGlobalServerSave.onGlobalServerSave()
	config.setActive(false)
	return true
end

boredMiniWorldChangeGlobalServerSave:register()
