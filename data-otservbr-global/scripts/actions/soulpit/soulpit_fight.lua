local config = {
	soulCores = Game.getSoulCoreItems(),
	requiredLevel = 8,
	playerPositions = {
		{ pos = Position(32371, 31155, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31156, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31157, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31158, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31159, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
	},
	waves = {
		[1] = {
			stacks = {
				[1] = 7,
			}
		},
		[2] = {
			stacks = {
				[1] = 4,
				[5] = 3,
			}
		},
		[3] = {
			stacks = {
				[1] = 5,
				[15] = 2,
			}
		},
		[4] = {
			stacks = {
				[1] = 3,
				[5] = 3,
				[40] = 1,
			}
		},
	},
	effects = {
		[1] = CONST_ME_TELEPORT,
		[5] = CONST_ME_ORANGETELEPORT,
		[15] = CONST_ME_REDTELEPORT,
		[40] = CONST_ME_PURPLETELEPORT,
	},
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	bossPosition = Position(32372, 31135, 8),
	exit = Position(33659, 32897, 14),
	zone = Zone("soulpit"),
}

config.zone:addArea(Position(32365, 31134, 8), Position(32382, 31152, 8))

local soulPitAction = Action()
function soulPitAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or target:getId() ~= 49174 then
		return false
	end

	local isParticipant = false
	for _, v in ipairs(config.playerPositions) do
		if Position(v.pos) == player:getPosition() then
			isParticipant = true
		end
	end

	if not isParticipant then
		return false
	end

	local lever = Lever()
	lever:setPositions(config.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end

		local isAccountNormal = creature:getAccountType() < ACCOUNT_TYPE_GAMEMASTER
		if isAccountNormal and creature:getLevel() < config.requiredLevel then
			local message = "All players need to be level " .. config.requiredLevel .. " or higher."
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return false
		end

		local infoPositions = lever:getInfoPositions()
		return true
	end)
	lever:checkPositions()
	if lever:checkConditions() then
		lever:teleportPlayers()
	end

	local monsterName = string.gsub(item:getName(), " soul core", "")

	logger.warn("monster name: " .. monsterName)

	config.zone:removeMonsters()

	local encounter = Encounter("Soulpit", {
		zone = config.zone,
	})

	local function waveStart()
		for stack, amount in pairs(config.waves[encounter.currentStage].stacks) do
			logger.warn("stack: " .. stack)
			logger.warn("amount: " .. amount)
			for i = 1, amount do
				local position = stack ~= 40 and config.zone:randomPosition() or config.bossPosition
				for i = 1, config.timeToSpawnMonsters / 1000 do
					encounter:addEvent(function(position)
						position:sendMagicEffect(config.effects[stack])
					end, i * 1000, position)
				end

				encounter:addEvent(function(name, stack, position)
					local monster = Game.createMonster(name, position)
					if not monster then
						return false
					end
					monster:setForgeStack(stack)
					local icon = stack <= 15 and CreatureIconModifications_ReducedHealth or CreatureIconModifications_ReducedHealthExclamation
					monster:removeIcon("forge")
					monster:setIcon("soulpit", CreatureIconCategory_Modifications, icon, stack <= 15 and stack or 0)
					monster:setDropLoot(false)
				end, config.timeToSpawnMonsters, monsterName, stack, position)
			end
		end
	end

	for i = 1, #config.waves do
		encounter:addStage({
		start = waveStart,
		}):autoAdvance({ delay = config.checkMonstersDelay, monstersKilled = true })
	end

	encounter:start()
	encounter:register()

	return true
end

for _, itemType in pairs(config.soulCores) do
	soulPitAction:id(itemType:getId())
end
soulPitAction:register()
