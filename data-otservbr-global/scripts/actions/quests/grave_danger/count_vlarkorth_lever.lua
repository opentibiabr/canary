local config = {
	bossName = "Count Vlarkorth",
	requiredLevel = 250,
	timeToFightAgain = 20, -- In hour
	timeToDefeatBoss = 20, -- In minutes
	playerPositions = {
		{pos = Position(33455, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33456, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33457, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33458, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33459, 31413, 13), teleport = Position(33454, 31445, 13), effect = CONST_ME_TELEPORT}
	},
	bossPosition = Position(33456, 31434, 13),
	specPos = {
		from = Position(33448, 31428, 13),
		to = Position(33464, 31446, 13)
	},
	exit = Position(33195, 31690, 8),
	storage = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorthTimer
}

local countVlarkorthLever = Action()
function countVlarkorthLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if config.playerPositions[1].pos ~= player:getPosition() then
		return false
	end
	local spec = Spectators()
	spec:setOnlyPlayer(false)
	spec:setRemoveDestination(config.exit)
	spec:setCheckPosition(config.specPos)
	spec:check()
	if spec:getPlayers() > 0 then
		player:say("There's someone fighting with " .. config.bossName .. ".", TALKTYPE_MONSTER_SAY)
		return true
	end
	local lever = Lever()
	lever:setPositions(config.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end
		if creature:getLevel() < config.requiredLevel then
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. config.requiredLevel .. " or higher.")
			return false
		end
		if creature:getStorageValue(config.storage) > os.time() then
			local info = lever:getInfoPositions()
			for _, v in pairs(info) do
				local newPlayer = v.creature
				if newPlayer then
					newPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait " .. config.timeToFightAgain .. " hours to face ".. config.bossName .. " again!")
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

countVlarkorthLever:position({x = 33454, y = 31413, z = 13})
countVlarkorthLever:register()