math.randomseed(os.time())

dofile(DATA_DIRECTORY .. "/lib/lib.lua")
local startupFile = io.open(DATA_DIRECTORY .. "/startup/startup.lua", "r")
if startupFile ~= nil then
	io.close(startupFile)
	dofile(DATA_DIRECTORY .. "/startup/startup.lua")
end

function IsRunningGlobalDatapack()
	if DATA_DIRECTORY == "data-otservbr-global" then
		return true
	else
		return false
	end
end

function IsRetroPVP()
	return configManager.getBoolean(configKeys.TOGGLE_SERVER_IS_RETRO)
end

function IsTravelFree()
	return configManager.getBoolean(configKeys.TOGGLE_TRAVELS_FREE)
end

-- NOTE: 0 is disabled.
PARTY_PROTECTION = (IsRetroPVP() and 0) or 1
ADVANCED_SECURE_MODE = (IsRetroPVP() and 0) or 1

NORTH = DIRECTION_NORTH
EAST = DIRECTION_EAST
SOUTH = DIRECTION_SOUTH
WEST = DIRECTION_WEST
SOUTHWEST = DIRECTION_SOUTHWEST
SOUTHEAST = DIRECTION_SOUTHEAST
NORTHWEST = DIRECTION_NORTHWEST
NORTHEAST = DIRECTION_NORTHEAST

DIRECTIONS_TABLE = {
	DIRECTION_NORTH,
	DIRECTION_EAST,
	DIRECTION_SOUTH,
	DIRECTION_WEST,
	DIRECTION_SOUTHWEST,
	DIRECTION_SOUTHEAST,
	DIRECTION_NORTHWEST,
	DIRECTION_NORTHEAST,
}

SERVER_NAME = configManager.getString(configKeys.SERVER_NAME)
SERVER_MOTD = configManager.getString(configKeys.SERVER_MOTD)

AUTH_TYPE = configManager.getString(configKeys.AUTH_TYPE)

-- Event Schedule
SCHEDULE_LOOT_RATE = 100
SCHEDULE_EXP_RATE = 100
SCHEDULE_BOSS_LOOT_RATE = 100
SCHEDULE_SKILL_RATE = 100
SCHEDULE_SPAWN_RATE = 100

-- MARRY
PROPOSED_STATUS = 1
MARRIED_STATUS = 2
PROPACCEPT_STATUS = 3
LOOK_MARRIAGE_DESCR = true
ITEM_WEDDING_RING = 3004
ITEM_ENGRAVED_WEDDING_RING = 9585

-- Scarlett Etzel
SCARLETT_MAY_TRANSFORM = 0
SCARLETT_MAY_DIE = 0

ropeSpots = { 386, 421, 386, 7762, 12202, 12936, 14238, 17238, 23363, 21965, 21966, 21967, 21968 }
specialRopeSpots = { 12935 }
swimmingTiles = { 629, 630, 631, 632, 633, 634, 4809, 4810, 4811, 4812, 4813, 4814 }

-- Global tables for systems
if not _G.GlobalBosses then
	_G.GlobalBosses = {}
end

if not _G.OnExerciseTraining then
	_G.OnExerciseTraining = {}
end

-- Stamina
if not _G.NextUseStaminaTime then
	_G.NextUseStaminaTime = {}
end

if not _G.NextUseXpStamina then
	_G.NextUseXpStamina = {}
end

if not _G.NextUseConcoctionTime then
	_G.NextUseConcoctionTime = {}
end

table.contains = function(array, value)
	for _, targetColumn in pairs(array) do
		if targetColumn == value then
			return true
		end
	end
	return false
end

-- for use of: data\scripts\globalevents\customs\save_interval.lua
SAVE_INTERVAL_TYPE = configManager.getString(configKeys.SAVE_INTERVAL_TYPE)
SAVE_INTERVAL_CONFIG_TIME = configManager.getNumber(configKeys.SAVE_INTERVAL_TIME)
SAVE_INTERVAL_TIME = 0
if SAVE_INTERVAL_TYPE == "second" then
	SAVE_INTERVAL_TIME = 1000
elseif SAVE_INTERVAL_TYPE == "minute" then
	SAVE_INTERVAL_TIME = 60 * 1000
elseif SAVE_INTERVAL_TYPE == "hour" then
	SAVE_INTERVAL_TIME = 60 * 60 * 1000
end

-- Increase Stamina when Attacking Trainer
staminaBonus = {
	target = "Training Machine",
	period = configManager.getNumber(configKeys.STAMINA_TRAINER_DELAY) * 60 * 1000, -- time on miliseconds trainers
	bonus = configManager.getNumber(configKeys.STAMINA_TRAINER_GAIN), -- gain stamina trainers
	eventsTrainer = {}, -- stamina in trainers
	eventsPz = {}, -- stamina in Pz
}

FAMILIARSNAME = {
	"sorcerer familiar",
	"knight familiar",
	"druid familiar",
	"paladin familiar",
}

function addStamina(playerId, ...)
	-- Creature:onTargetCombat
	if playerId then
		local player = Player(playerId)
		if configManager.getBoolean(configKeys.STAMINA_TRAINER) then
			if not player then
				staminaBonus.eventsTrainer[playerId] = nil
			else
				local target = player:getTarget()
				if not target or target:getName() ~= staminaBonus.target then
					staminaBonus.eventsTrainer[playerId] = nil
				else
					player:setStamina(player:getStamina() + staminaBonus.bonus)
					player:sendTextMessage(MESSAGE_FAILURE, string.format("%i of stamina has been refilled.", configManager.getNumber(configKeys.STAMINA_TRAINER_GAIN)))
					staminaBonus.eventsTrainer[playerId] = addEvent(addStamina, staminaBonus.period, playerId)
				end
			end
		end
		return not configManager.getBoolean(configKeys.STAMINA_TRAINER)
	end

	-- Player:onChangeZone
	local localPlayerId, delay = ...

	if localPlayerId and delay then
		if not staminaBonus.eventsPz[localPlayerId] then
			return false
		end
		stopEvent(staminaBonus.eventsPz[localPlayerId])

		local player = Player(localPlayerId)
		if not player then
			staminaBonus.eventsPz[localPlayerId] = nil
			return false
		end

		local actualStamina = player:getStamina()

		if actualStamina > 2340 and actualStamina < 2520 then
			delay = configManager.getNumber(configKeys.STAMINA_GREEN_DELAY) * 60 * 1000 -- Stamina Green 12 min.
		elseif actualStamina == 2520 then
			player:sendTextMessage(
				MESSAGE_STATUS,
				"You are no longer refilling stamina, \z
                                                         because your stamina is already full."
			)
			staminaBonus.eventsPz[localPlayerId] = nil
			return false
		end

		local regen = configManager.getNumber(configKeys.STAMINA_PZ_GAIN)
		player:setStamina(player:getStamina() + regen)
		player:sendTextMessage(MESSAGE_FAILURE, string.format("%i minute%s of stamina has been refilled.", regen, regen == 1 and "" or "s"))
		staminaBonus.eventsPz[localPlayerId] = addEvent(addStamina, delay, nil, localPlayerId, delay)
		return true
	end
	return false
end
