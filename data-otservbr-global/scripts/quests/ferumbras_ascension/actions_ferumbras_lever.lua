local config = {
	boss = {
		name = "Ferumbras Mortal Shell",
		position = Position(33392, 31473, 14),
	},
	playerPositions = {
		{ pos = Position(33269, 31477, 14), teleport = Position(33390, 31483, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33374, 31458, 14),
		to = Position(33414, 31498, 14),
	},
	exit = Position(33319, 32318, 13),
	centerRoom = Position(33392, 31473, 14),
	summonName = "Rift Fragment",
	maxSummon = 3,
}

local leverFerumbras = Action()

function leverFerumbras.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

	Game.createMonster(config.boss.name, config.boss.position, true, true)
	for b = 1, config.maxSummon do
		local xrand = math.random(-5, 5)
		local yrand = math.random(-5, 5)
		local position = Position(config.boss.position.x + xrand, config.boss.position.y + yrand, config.boss.position.z)
		Game.createMonster(config.summonName, position)
	end

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

leverFerumbras:uid(1021)
leverFerumbras:register()
