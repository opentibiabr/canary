local config = {
	bossName = "Frozen Horror",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 15, -- In minutes
	playerPositions = {
		{ pos = Position(32302, 31088, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31089, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31090, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31091, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31092, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(32269, 31091, 14),
	monsters = {
		{ monster = 'icicle', pos = Position(32266, 31084, 14) },
		{ monster = 'icicle', pos = Position(32272, 31084, 14) },
		{ monster = 'dragon egg', pos = Position(32269, 31084, 14) },
		{ monster = 'melting frozen horror', pos = Position(32267, 31071, 14) }
	},
	specPos = {
		from = Position(32257, 31080, 14),
		to = Position(32280, 31102, 14)
	},
	exit = Position(32271, 31097, 14),
	storage = Storage.ForgottenKnowledge.HorrorTimer
}

local forgottenKnowledgeHorror = Action()
function forgottenKnowledgeHorror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
			Game.createMonster(config.monsters[n].monster, config.monsters[n].pos, true, true)
		end
		Tile(config.monsters[3].pos):getTopCreature():setHealth(1)
		local monster = Game.createMonster("solid frozen horror", config.bossPosition, true, true)
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

forgottenKnowledgeHorror:position(Position(32302, 31087, 14))
forgottenKnowledgeHorror:register()
