local config = {
	bossName = "Brain Head",
	requiredLevel = 250,
	timeToFightAgain = 10, -- In hour
	destination = Position(31963, 32324, 10),
	exitPosition = Position(31971, 32325, 10),
}

local entrancesTiles = {
	{ x = 31937, y = 32324, z = 10 },
	{ x = 31937, y = 32325, z = 10 },
	{ x = 31937, y = 32326, z = 10 },
	{ x = 31951, y = 32310, z = 10 },
	{ x = 31952, y = 32309, z = 10 },
	{ x = 31952, y = 32310, z = 10 },
	{ x = 31953, y = 32309, z = 10 },
	{ x = 31953, y = 32310, z = 10 },
	{ x = 31954, y = 32310, z = 10 },
	{ x = 31954, y = 32311, z = 10 },
	{ x = 31955, y = 32311, z = 10 },
	{ x = 31956, y = 32309, z = 10 },
	{ x = 31956, y = 32310, z = 10 },
	{ x = 31956, y = 32311, z = 10 },
	{ x = 31957, y = 32308, z = 10 },
	{ x = 31957, y = 32309, z = 10 },
	{ x = 31957, y = 32310, z = 10 },
	{ x = 31951, y = 32339, z = 10 },
	{ x = 31952, y = 32339, z = 10 },
	{ x = 31953, y = 32339, z = 10 },
	{ x = 31953, y = 32340, z = 10 },
	{ x = 31954, y = 32340, z = 10 },
	{ x = 31955, y = 32340, z = 10 },
	{ x = 31955, y = 32341, z = 10 },
	{ x = 31969, y = 32323, z = 10 },
	{ x = 31969, y = 32324, z = 10 },
	{ x = 31969, y = 32325, z = 10 },
	{ x = 31969, y = 32326, z = 10 },
	{ x = 31969, y = 32327, z = 10 },
	{ x = 31970, y = 32323, z = 10 },
	{ x = 31970, y = 32324, z = 10 },
	{ x = 31970, y = 32326, z = 10 },
}

local zone = Zone("boss." .. toKey(config.bossName))
local encounter = Encounter("Brain Head", {
	zone = zone,
	timeToSpawnMonsters = "50ms",
})

zone:blockFamiliars()
zone:setRemoveDestination(config.exitPosition)

local locked = false

function encounter:onReset()
	locked = false
	encounter:removeMonsters()
end

encounter:addRemoveMonsters():autoAdvance()
encounter:addBroadcast("You've entered the Brain Head's lair."):autoAdvance()
encounter
	:addSpawnMonsters({
		{
			name = "Brain Head",
			positions = {
				Position(31954, 32325, 10),
			},
		},
		{
			name = "Cerebellum",
			positions = {
				Position(31953, 32324, 10),
				Position(31955, 32324, 10),
				Position(31953, 32326, 10),
				Position(31955, 32326, 10),
				Position(31960, 32320, 10),
				Position(31960, 32330, 10),
				Position(31947, 32320, 10),
				Position(31947, 32330, 10),
			},
		},
	})
	:autoAdvance("30s")

encounter
	:addStage({
		start = function()
			locked = true
		end,
	})
	:autoAdvance("270s")

encounter:addRemovePlayers():autoAdvance()

encounter:startOnEnter()
encounter:register()

local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isPlayer() then
		return false
	end
	local player = creature
	if player:getLevel() < config.requiredLevel then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be level " .. config.requiredLevel .. " or higher.")
		return true
	end
	if locked then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's already someone fighting with " .. config.bossName .. ".")
		return false
	end
	if zone:countPlayers(IgnoredByMonsters) >= 5 then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The boss room is full.")
		return false
	end
	local timeLeft = player:getBossCooldown(config.bossName) - os.time()
	if timeLeft > 0 then
		player:teleportTo(config.exitPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. Game.getTimeInWords(timeLeft) .. " to face " .. config.bossName .. " again!")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	player:teleportTo(config.destination)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:setBossCooldown(config.bossName, os.time() + config.timeToFightAgain * 3600)
	player:sendBosstiaryCooldownTimer()
end

for _, registerPosition in ipairs(entrancesTiles) do
	teleportBoss:position(registerPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()

SimpleTeleport(Position(31946, 32334, 10), config.exitPosition)
