local config = {
	bossName = "Thorn Knight",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 15, -- In minutes
	playerPositions = {
		{ pos = Position(32657, 32877, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32878, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32879, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32880, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32881, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(32624, 32880, 14),
	specPos = {
		from = Position(32613, 32869, 14),
		to = Position(32636, 32892, 14)
	},
	exit = Position(32678, 32888, 14),
	storage = Storage.ForgottenKnowledge.ThornKnightTimer
}

local forgottenKnowledgeThorn = Action()
function forgottenKnowledgeThorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
			Game.createMonster('possessed tree', Position(math.random(32619, 32629), math.random(32877, 32884), 14), true, true)
		end
		local monster = Game.createMonster("mounted thorn knight", config.bossPosition, true, true)
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

forgottenKnowledgeThorn:position(Position(32657, 32876, 14))
forgottenKnowledgeThorn:register()
