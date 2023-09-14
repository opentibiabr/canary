local config = {
	bossName = "The Last Lore Keeper",
	timeToFightAgain = 14 * 24, -- In hour
	timeToDefeatBoss = 17, -- In minutes
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
		{ pos = Position(32020, 32848, 14), teleport = Position(31984, 32851, 14), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(31987, 32839, 14),
	monsters = {
		{pos = Position(31973, 32840, 15), monster = 'bound astral power'},
		{pos = Position(31973, 32856, 15), monster = 'bound astral power'},
		{pos = Position(31989, 32856, 15), monster = 'bound astral power'},
		{pos = Position(31989, 32840, 15), monster = 'bound astral power'},
		{pos = Position(31986, 32840, 14), monster = 'a shielded astral glyph'},
		{pos = Position(31986, 32823, 15), monster = 'the distorted astral source'},
		{pos = Position(31989, 32823, 15), monster = 'an astral glyph'}
	},
	specPos = {
		from = Position(31968, 32821, 14),
		to = Position(32004, 32865, 15)
	},
	exit = Position(32035, 32859, 14),
	storage = Storage.ForgottenKnowledge.LastLoreTimer
}

local forgottenKnowledgeLastLore = Action()
function forgottenKnowledgeLastLore.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if config.playerPositions[2].pos ~= player:getPosition() then
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
					newPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You or a member in your team have to wait " .. config.timeToFightAgain/24 .. " days to face " .. config.bossName .. " again!")
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
		local monster = Game.createMonster('the astral source', config.bossPosition, true, true)
		if not monster then
			return true
		end
		lever:teleportPlayers()
		lever:setStorageAllPlayers(config.storage, os.time() + config.timeToFightAgain * 3600)
		Game.setStorageValue(GlobalStorage.ForgottenKnowledge.AstralPowerCounter, 1)
		Game.setStorageValue(GlobalStorage.ForgottenKnowledge.AstralGlyph, 0)
		player:say('The Astral Glyph begins to draw upon bound astral power to expel you from the room!', TALKTYPE_MONSTER_SAY)
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

forgottenKnowledgeLastLore:position(Position(32019, 32843, 14))
forgottenKnowledgeLastLore:register()
