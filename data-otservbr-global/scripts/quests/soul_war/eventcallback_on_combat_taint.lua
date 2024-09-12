local taintCooldown = {}

local function createTeleportEffect(position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local function scheduleMonsterCreation(player, monster, monsterName, spawnPosition)
	addEvent(createTeleportEffect, 1000, spawnPosition)
	addEvent(createTeleportEffect, 2000, spawnPosition)
	addEvent(createTeleportEffect, 3000, spawnPosition)

	addEvent(function(playerId, monsterId)
		local eventPlayer = Player(playerId)
		if not eventPlayer then
			return
		end

		local eventMonster = Monster(monsterId)
		if not eventMonster or eventMonster:isDead() then
			return
		end

		-- Only create if the player not have cooldown
		if not taintCooldown[playerId] or os.time() > taintCooldown[playerId] then
			taintCooldown[playerId] = os.time() + 30
			local monster = Game.createMonster(monsterName, spawnPosition, true, true)
			if monster then
				spawnPosition:sendMagicEffect(CONST_ME_TELEPORT)
				logger.debug("Spamming monster with name {} to player {}", monsterName, eventPlayer:getName())
			end
		end
	end, 4000, player:getId(), monster:getId())
end

local function onPlayerAttackMonster(player, target)
	local monster = target:getMonster()
	if not monster then
		return
	end

	-- It will only execute if the player has the second taint
	if player:getTaintNameByNumber(2) ~= nil then
		local chance = math.random(1, 200)
		local spawnPosition = player:getPosition()
		if chance == 1 then -- 0.5% chance
			local foundMonsterName = player:getSoulWarZoneMonster()
			if foundMonsterName ~= nil then
				scheduleMonsterCreation(player, monster, foundMonsterName, spawnPosition)
			end
		end
	end
end

local function onMonsterAttackPlayer(target, primaryValue, secondaryValue)
	local targetPlayer = target:getPlayer()
	if not targetPlayer then
		return primaryValue, secondaryValue
	end

	if targetPlayer:getTaintNameByNumber(3) ~= nil then
		local monsterZone = targetPlayer:getSoulWarZoneMonster()
		if monsterZone ~= nil then
			logger.debug("Player {} have third taint, primary value {}, secondary {}", targetPlayer:getName(), primaryValue, secondaryValue)
			primaryValue = primaryValue + math.ceil(primaryValue * 0.15)
			secondaryValue = secondaryValue + math.ceil(secondaryValue * 0.15)
			logger.debug("Primary value after {}, secondary {}", primaryValue, secondaryValue)
		end
	end

	return primaryValue, secondaryValue
end

local callback = EventCallback("CreatureOnCombatTaint")

function callback.creatureOnCombat(caster, target, primaryValue, primaryType, secondaryValue, secondaryType, origin)
	if not caster or not target then
		return primaryValue, primaryType, secondaryValue, secondaryType
	end

	-- Second taint
	local attackerPlayer = caster:getPlayer()
	if attackerPlayer and target:isMonster() then
		onPlayerAttackMonster(attackerPlayer, target)
	end

	-- Third taint
	if caster:getMonster() then
		primaryValue, secondaryValue = onMonsterAttackPlayer(target, primaryValue, secondaryValue)
	end

	return primaryValue, primaryType, secondaryValue, secondaryType
end

callback:register()

callback = EventCallback("PlayerOnThinkTaint")

local accumulatedTime = {}

function callback.playerOnThink(player, interval)
	if not player then
		return
	end

	local playerId = player:getId()
	if not accumulatedTime[playerId] then
		accumulatedTime[playerId] = 0
	end

	accumulatedTime[playerId] = accumulatedTime[playerId] + interval

	if accumulatedTime[playerId] >= 10000 then
		local soulWarQuest = player:soulWarQuestKV()
		if player:getSoulWarZoneMonster() ~= nil and player:getTaintNameByNumber(5) ~= nil then
			local hpLoss = math.ceil(player:getHealth() * 0.1)
			local manaLoss = math.ceil(player:getMana() * 0.1)
			player:addHealth(-hpLoss)
			player:addMana(-manaLoss)
			logger.debug("Fifth taint removing '{}' mana and '{}' health from player {}", manaLoss, hpLoss, player:getName())
		end

		accumulatedTime[playerId] = 0
	end
end

callback:register()
