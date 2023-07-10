local config = {
	bossName = "Dragonking Zyrtarch",
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 15, -- In minutes
	playerPositions = {
		{ pos = Position(33391, 31178, 10), teleport = Position(33359, 31186, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(33391, 31179, 10), teleport = Position(33359, 31186, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(33391, 31180, 10), teleport = Position(33359, 31186, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(33391, 31181, 10), teleport = Position(33359, 31186, 10), effect = CONST_ME_TELEPORT },
		{ pos = Position(33391, 31182, 10), teleport = Position(33359, 31186, 10), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(33357, 31182, 10),
	monsters = {
		{ name = 'soulcatcher', pos = Position(33352, 31187, 10) },
		{ name = 'soulcatcher', pos = Position(33363, 31187, 10) },
		{ name = 'soulcatcher', pos = Position(33353, 31176, 10) },
		{ name = 'soulcatcher', pos = Position(33363, 31176, 10) },
		{ name = 'soul of dragonking zyrtarch', pos = Position(33359, 31182, 12)}
	},
	specPos = {
		from = Position(33348, 31172, 10),
		to = Position(33368, 31190, 12)
	},
	exit = Position(33407, 31172, 10),
	storage = Storage.ForgottenKnowledge.DragonkingTimer
}


local forgottenKnowledgeDragonking = Action()
function forgottenKnowledgeDragonking.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
		for n = 1, #config.monsters do
			Game.createMonster(config.monsters[n].name, config.monsters[n].pos, true, true)
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

forgottenKnowledgeDragonking:position(Position(33391, 31177, 10))
forgottenKnowledgeDragonking:register()
