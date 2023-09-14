local config = {
	bossName = "Lady Tenebris",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 15, -- In minutes
	playerPositions = {
		{ pos = Position(32902, 31623, 14), teleport = Position(32911, 31603, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32902, 31624, 14), teleport = Position(32911, 31603, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32902, 31625, 14), teleport = Position(32911, 31603, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32902, 31626, 14), teleport = Position(32911, 31603, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32902, 31627, 14), teleport = Position(32911, 31603, 14), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(32912, 31599, 14),
	specPos = {
		from = Position(32895, 31585, 14),
		to = Position(32830, 32855, 14)
	},
	exit = Position(32902, 31629, 14),
	storage = Storage.ForgottenKnowledge.LadyTenebrisTimer
}

local forgottenKnowledgeTenebris = Action()
function forgottenKnowledgeTenebris.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
		for d = 1, 6 do
			Game.createMonster('shadow tentacle', Position(math.random(32909, 32914), math.random(31596, 31601), 14), true, true)
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

forgottenKnowledgeTenebris:position(Position(32902, 31622, 14))
forgottenKnowledgeTenebris:register()
