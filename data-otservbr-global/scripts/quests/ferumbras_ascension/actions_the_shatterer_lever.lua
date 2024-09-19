local config = {
	boss = {
		name = "The Shatterer",
		position = Position(33406, 32418, 14),
	},
	timeToDefeat = 17 * 60, -- 17 minutes in seconds
	playerPositions = {
		{ pos = Position(33403, 32465, 13), teleport = Position(33398, 32414, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33404, 32465, 13), teleport = Position(33398, 32414, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33405, 32465, 13), teleport = Position(33398, 32414, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33406, 32465, 13), teleport = Position(33398, 32414, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33407, 32465, 13), teleport = Position(33398, 32414, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33377, 32390, 14),
		to = Position(33446, 32447, 14),
	},
	exit = Position(33319, 32318, 13),
	centerRoom = Position(33406, 32418, 14),
	storage = {
		lever = Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever,
		timer = Storage.Quest.U10_90.FerumbrasAscension.TheShattererTimer,
	},
}

local ferumbrasAscendantTheShattererLever = Action()

function ferumbrasAscendantTheShattererLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spectators = Game.getSpectators(config.centerRoom, false, false, 30, 30, 30, 30)
	for _, spec in pairs(spectators) do
		if spec:isPlayer() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting with The Shatterer.")
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

	for _, participant in pairs(players) do
		participant:setStorageValue(config.storage.lever, 0)
		participant:setStorageValue(config.storage.timer, 1)
	end

	addEvent(clearBossRoom, config.timeToDefeat * 1000, config.specPos.from, config.specPos.to, config.exit, config.storage.timer)

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
	local bossRemoved = false
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for z = fromPos.z, toPos.z do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isMonster() and creature:getName() == bossName then
						creature:remove()
						bossRemoved = true
					end
				end
			end
		end
	end
	return bossRemoved
end

ferumbrasAscendantTheShattererLever:uid(1029)
ferumbrasAscendantTheShattererLever:register()
