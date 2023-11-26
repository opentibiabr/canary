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

-- Bestiary charm
GLOBAL_CHARM_GUT = 120 -- 20% more chance to get creature products from looting
GLOBAL_CHARM_SCAVENGE = 125 -- 25% more chance to get creature products from skinning

--WEATHER
weatherConfig = {
	groundEffect = CONST_ME_LOSEENERGY,
	fallEffect = CONST_ANI_SMALLICE,
	thunderEffect = configManager.getBoolean(configKeys.WEATHER_THUNDER),
	minDMG = 1,
	maxDMG = 5,
}

-- Event Schedule
SCHEDULE_LOOT_RATE = 100
SCHEDULE_EXP_RATE = 100
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

if not _G._G.NextUseConcoctionTime then
	_G._G.NextUseConcoctionTime = {}
end

-- Delay potion
if not _G.PlayerDelayPotion then
	_G.PlayerDelayPotion = {}
end

-- Increase Stamina when Attacking Trainer
staminaBonus = {
	target = "Training Machine",
	period = configManager.getNumber(configKeys.STAMINA_TRAINER_DELAY) * 60 * 1000, -- time on miliseconds trainers
	bonus = configManager.getNumber(configKeys.STAMINA_TRAINER_GAIN), -- gain stamina trainers
	eventsTrainer = {}, -- stamina in trainers
	eventsPz = {}, -- stamina in Pz
}
