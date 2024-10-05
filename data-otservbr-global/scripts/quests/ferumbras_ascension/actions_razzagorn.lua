local config = {
	boss = {
		name = "Razzagorn",
		position = Position(33422, 32467, 14),
	},
	timeToDefeat = 17 * 60, -- 17 minutes in seconds
	playerPositions = {
		{ pos = Position(33386, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33387, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33388, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33389, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33390, 32455, 14), teleport = Position(33419, 32467, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33407, 32453, 14),
		to = Position(33439, 32481, 14),
	},
	exit = Position(33319, 32318, 13),
}

local leverRazzagorn = Action()

function leverRazzagorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local players = {}
	local spectators = Game.getSpectators(config.specPos.from, false, false, 0, 0, 0, 0, config.specPos.to)

	for i = 1, #config.playerPositions do
		local pos = config.playerPositions[i].pos
		local creature = Tile(pos):getTopCreature()

		if not creature or not creature:isPlayer() then
			player:sendCancelMessage("You need " .. #config.playerPositions .. " players to challenge " .. config.boss.name .. ".")
			return true
		end

		local cooldownTime = creature:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.RazzagornTime)
		if cooldownTime > os.time() then
			local remainingTime = cooldownTime - os.time()
			local hours = math.floor(remainingTime / 3600)
			local minutes = math.floor((remainingTime % 3600) / 60)
			player:sendCancelMessage(creature:getName() .. " must wait " .. hours .. " hours and " .. minutes .. " minutes to challenge again.")
			return true
		end

		if creature:getLevel() < config.requiredLevel then
			player:sendCancelMessage(creature:getName() .. " needs to be at least level " .. config.requiredLevel .. " to challenge " .. config.boss.name .. ".")
			return true
		end

		table.insert(players, creature)
	end

	for _, spec in pairs(spectators) do
		if spec:isPlayer() then
			player:say("Someone is already inside the room.", TALKTYPE_MONSTER_SAY)
			return true
		end
	end

	if isBossInRoom(config.specPos.from, config.specPos.to, config.boss.name) then
		player:say("The room is being cleared. Please wait a moment.", TALKTYPE_MONSTER_SAY)
		return true
	end

	for i = 1, #players do
		local playerToTeleport = players[i]
		local teleportPos = config.playerPositions[i].teleport
		local effect = config.playerPositions[i].effect
		playerToTeleport:teleportTo(teleportPos)
		teleportPos:sendMagicEffect(effect)
	end

	Game.createMonster(config.boss.name, config.boss.position)

	addEvent(clearBossRoom, config.timeToDefeat * 1000, config.specPos.from, config.specPos.to, config.exit)

	if item.itemid == 8911 then
		item:transform(8912)
	else
		item:transform(8911)
	end

	return true
end

function clearBossRoom(fromPos, toPos, exitPos)
	local spectators = Game.getSpectators(fromPos, false, false, 0, 0, 0, 0, toPos)
	for _, spec in pairs(spectators) do
		if spec:isPlayer() then
			spec:teleportTo(exitPos)
			exitPos:sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You took too long, the battle has ended.")
		else
			spec:remove()
		end
	end
end

function isBossInRoom(fromPos, toPos, bossName)
	local monstersRemoved = false
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for z = fromPos.z, toPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isMonster() then
						creature:remove()
						monstersRemoved = true
					end
				end
			end
		end
	end
	return monstersRemoved
end

leverRazzagorn:uid(1024)
leverRazzagorn:register()
