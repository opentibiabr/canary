local eggPos = Position(32269, 31084, 14)
local config = {
	boss = {
		name = "Melting Frozen Horror",
		createFunction = function()
			Game.createMonster("dragon egg", eggPos, true, true)

			local eggCreature = Tile(eggPos):getTopCreature()
			if eggCreature then
				eggCreature:setHealth(1)
			else
				print("Error: No dragon egg found at eggPos.")
			end

			return Game.createMonster("solid frozen horror", Position(32269, 31091, 14), true, true)
		end,
	},
	requiredLevel = 250,
	timeToDefeat = 15 * 60,
	playerPositions = {
		{ pos = Position(32302, 31088, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31089, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31090, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31091, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32302, 31092, 14), teleport = Position(32271, 31097, 14), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "icicle", pos = Position(32266, 31084, 14) },
		{ name = "icicle", pos = Position(32272, 31084, 14) },
		{ name = "melting frozen horror", pos = Position(32267, 31071, 14) },
	},
	specPos = {
		from = Position(32257, 31080, 14),
		to = Position(32280, 31102, 14),
	},
	exit = Position(32271, 31097, 14),
}

local leverMeltingFrozenHorror = Action()

function leverMeltingFrozenHorror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local players = {}
	local spectators = Game.getSpectators(config.specPos.from, false, false, 0, 0, 0, 0, config.specPos.to)

	for i = 1, #config.playerPositions do
		local pos = config.playerPositions[i].pos
		local creature = Tile(pos):getTopCreature()

		if not creature or not creature:isPlayer() then
			player:sendCancelMessage("You need " .. #config.playerPositions .. " players to challenge " .. config.boss.name .. ".")
			return true
		end

		local cooldownTime = creature:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.HorrorKilled)
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

	if config.boss.createFunction then
		config.boss.createFunction()
	else
		Game.createMonster(config.boss.name, config.boss.position)
	end

	for _, monster in pairs(config.monsters) do
		Game.createMonster(monster.name, monster.pos)
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

leverMeltingFrozenHorror:position(Position(32302, 31087, 14))
leverMeltingFrozenHorror:register()
