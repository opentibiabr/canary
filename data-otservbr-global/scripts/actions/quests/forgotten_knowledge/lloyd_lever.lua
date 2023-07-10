local config = {
	bossName = "Lloyd",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 10, -- In minutes
	playerPositions = {
		{ pos = Position(32759, 32868, 14), teleport = Position(32800, 32831, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32759, 32869, 14), teleport = Position(32800, 32831, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32759, 32870, 14), teleport = Position(32800, 32831, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32759, 32871, 14), teleport = Position(32800, 32831, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32759, 32872, 14), teleport = Position(32800, 32831, 14), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(32799, 32827, 14),
	monsters = {
		{ cosmic = 'cosmic energy prism a invu', pos = Position(32801, 32827, 14) },
		{ cosmic = 'cosmic energy prism b invu', pos = Position(32798, 32827, 14) },
		{ cosmic = 'cosmic energy prism c invu', pos = Position(32803, 32826, 14) },
		{ cosmic = 'cosmic energy prism d invu', pos = Position(32796, 32826, 14)}
	},
	specPos = {
		from = Position(32785, 32813, 14),
		to = Position(32812, 32838, 14)
	},
	exit = Position(32815, 32873, 13),
	storage = Storage.ForgottenKnowledge.LloydTimer
}

local forgottenKnowledgeLever = Action()
function forgottenKnowledgeLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if config.playerPositions[1].pos ~= player:getPosition() then
		return false
	end

	local spec = Spectators()
	spec:setOnlyPlayer(false)
	spec:setRemoveDestination(config.exit)
	spec:setCheckPosition(config.specPos)
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
		for n = 1, #config.monsters do
			Game.createMonster(config.monsters[n].cosmic, config.monsters[n].pos, true, true)
		end
		local monster = Game.createMonster(config.bossName, config.bossPosition, true, true)
		if not monster then
			return true
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

forgottenKnowledgeLever:position(Position(32759, 32867, 14))
forgottenKnowledgeLever:register()
