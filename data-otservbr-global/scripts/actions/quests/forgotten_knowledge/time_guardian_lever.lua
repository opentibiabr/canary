local config = {
	bossName = "The Time Guardian",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 15, -- In minutes
	playerPositions = {
		{ pos = Position(33010, 31660, 14), teleport = Position(32977, 31667, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33010, 31661, 14), teleport = Position(32977, 31667, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33010, 31662, 14), teleport = Position(32977, 31667, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33010, 31663, 14), teleport = Position(32977, 31667, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33010, 31664, 14), teleport = Position(32977, 31667, 14), effect = CONST_ME_TELEPORT }
	},
	bosses = {
		{bossPosition = Position(32977, 31662, 14), bossName = 'The Time Guardian'},
		{bossPosition = Position(32975, 31664, 13), bossName = 'The Freezing Time Guardian'},
		{bossPosition = Position(32980, 31664, 13), bossName = 'The Blazing Time Guardian'}
	},
	monsters = {
		{ cosmic = 'cosmic energy prism a invu', pos = Position(32801, 32827, 14) },
		{ cosmic = 'cosmic energy prism b invu', pos = Position(32798, 32827, 14) },
		{ cosmic = 'cosmic energy prism c invu', pos = Position(32803, 32826, 14) },
		{ cosmic = 'cosmic energy prism d invu', pos = Position(32796, 32826, 14) }
	},
	specPos = {
		from = Position(32967, 31654, 13),
		to = Position(32989, 31677, 14)
	},
	exit = Position(32870, 32724, 14),
	storage = Storage.ForgottenKnowledge.TimeGuardianTimer
}

local forgottenKnowledgeGuardianLever = Action()
function forgottenKnowledgeGuardianLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if config.playerPositions[1].pos ~= player:getPosition() then
		return false
	end

	local spec = Spectators()
	spec:setOnlyPlayer(false)
	spec:setRemoveDestination(config.exit)
	spec:setCheckPosition(config.specPos)
	spec:setMultiFloor(true)
	spec:check()

	if spec:getPlayers() > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone fighting with " .. config.bossName .. ".")
		return true
	end

	local lever = Lever()
	lever:setPositions(config.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end

		if creature:getStorageValue(config.storage) > os.time() then
			local info = lever:getInfoPositions()
			for _, v in pairs(info) do
				local newPlayer = v.creature
				if newPlayer then
					newPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait " .. config.timeToFightAgain .. " hours to face " .. config.bossName .. " again!")
					if newPlayer:getStorageValue(config.storage) > os.time() then
						newPlayer:getPosition():sendMagicEffect(CONST_ME_POFF)
					end
				end
			end
			return false
		end
		return true
	end)

	lever:checkPositions()
	if lever:checkConditions() then
		spec:removeMonsters()
		for b = 1, #config.bosses do
			local monster = Game.createMonster(config.bosses[b].bossName, config.bosses[b].bossPosition, true, true)
			if not monster then
				return true
			end
		end
		lever:teleportPlayers()
		lever:setStorageAllPlayers(config.storage, os.time() + config.timeToFightAgain * 3600)
		addEvent(function()
			local old_players = lever:getInfoPositions()
			spec:clearCreaturesCache()
			spec:setOnlyPlayer(true)
			spec:check()
			local player_remove = {}
			for i, v in pairs(spec:getCreatureDetect()) do
				for _, v_old in pairs(old_players) do
					if v_old.creature == nil or v_old.creature:isMonster() then
						break
					end
					if v:getName() == v_old.creature:getName() then
						table.insert(player_remove, v_old.creature)
						break
					end
				end
			end
			spec:removePlayers(player_remove)
		end, config.timeToDefeatBoss * 60 * 1000)
	end
end

forgottenKnowledgeGuardianLever:position(Position(33010, 31659, 14))
forgottenKnowledgeGuardianLever:register()
