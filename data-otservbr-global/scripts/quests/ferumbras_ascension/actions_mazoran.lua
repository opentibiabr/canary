local config = {
	boss = {
		name = "Mazoran",
		position = Position(33584, 32689, 14),
	},
	timeToDefeat = 17 * 60, -- 17 minutes in seconds
	playerPositions = {
		{ pos = Position(33593, 32644, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32645, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32646, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32647, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33593, 32648, 14), teleport = Position(33585, 32693, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33570, 32677, 14),
		to = Position(33597, 32700, 14),
	},
	exit = Position(33319, 32318, 13),
}

local leverMazoran = Action()

function leverMazoran.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spectators = Game.getSpectators(config.specPos.from, false, false, 0, 0, 0, 0, config.specPos.to)
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

	local players = {}
	for i = 1, #config.playerPositions do
		local pos = config.playerPositions[i].pos
		local creature = Tile(pos):getTopCreature()
		if not creature or not creature:isPlayer() then
			player:sendCancelMessage("You need " .. #config.playerPositions .. " players to challenge " .. config.boss.name .. ".")
			return true
		end
		table.insert(players, creature)
	end

	for i = 1, #players do
		local playerToTeleport = players[i]
		local teleportPos = config.playerPositions[i].teleport
		local effect = config.playerPositions[i].effect
		playerToTeleport:teleportTo(teleportPos)
		teleportPos:sendMagicEffect(effect)
	end

	local boss = Game.createMonster(config.boss.name, config.boss.position)
	if boss then
		boss:setReward(true)
	end

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

leverMazoran:uid(1025)
leverMazoran:register()
