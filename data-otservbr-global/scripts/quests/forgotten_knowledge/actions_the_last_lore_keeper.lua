local config = {
	boss = {
		name = "The Last Lore Keeper",
		position = Position(31987, 32839, 14),
	},
	requiredLevel = 250,
	timeToDefeat = 17 * 60,
	playerPositions = {
		{ pos = Position(32018, 32844, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32019, 32844, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32020, 32844, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32018, 32845, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32019, 32845, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32020, 32845, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32018, 32846, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32019, 32846, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32020, 32846, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32018, 32847, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32019, 32847, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32020, 32847, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32018, 32848, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32019, 32848, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32020, 32848, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT },
	},
	monsters = {
		{ name = "bound astral power", pos = Position(31973, 32840, 15) },
		{ name = "bound astral power", pos = Position(31973, 32856, 15) },
		{ name = "bound astral power", pos = Position(31989, 32856, 15) },
		{ name = "bound astral power", pos = Position(31989, 32840, 15) },
		{ name = "a shielded astral glyph", pos = Position(31986, 32840, 14) },
		{ name = "the distorted astral source", pos = Position(31986, 32823, 15) },
		{ name = "an astral glyph", pos = Position(31989, 32823, 15) },
	},
	specPos = {
		from = Position(31968, 32821, 14),
		to = Position(32004, 32865, 15),
	},
	exit = Position(32035, 32859, 14),
}

local leverLoreKeeper = Action()

function leverLoreKeeper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local players = {}
	local spectators = Game.getSpectators(config.specPos.from, false, false, 0, 0, 0, 0, config.specPos.to)

	for i = 1, #config.playerPositions do
		local pos = config.playerPositions[i].pos
		local creature = Tile(pos):getTopCreature()

		if not creature or not creature:isPlayer() then
			player:sendCancelMessage("You need " .. #config.playerPositions .. " players to challenge " .. config.boss.name .. ".")
			return true
		end

		local cooldownTime = creature:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.LastLoreKilled)
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

leverLoreKeeper:position(Position(32019, 32843, 14))
leverLoreKeeper:register()
