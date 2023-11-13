local config = {
	bossName = {
		["Monday"] = "Plagueroot",
		["Tuesday"] = "Malofur Mangrinder",
		["Wednesday"] = "Maxxenius",
		["Thursday"] = "Alptramun",
		["Friday"] = "Izcandar The Banished",
		["Saturday"] = "Maxxenius",
		["Sunday"] = "Alptramun",
	},
	requiredLevel = 250,
	timeToFightAgain = 10, -- In hour
	timeToDefeat = 30, -- In minutes
	playerPositions = {
		{ pos = Position(32208, 32021, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32022, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32023, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32024, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32208, 32025, 13), teleport = Position(32207, 32041, 14), effect = CONST_ME_TELEPORT },
	},
	bossPosition = Position(32207, 32051, 14),
	specPos = {
		from = Position(32199, 32039, 14),
		to = Position(32229, 32055, 14),
	},
	exit = Position(32210, 32035, 13),
}
local bossToday = config.bossName[os.date("%A")]

local dreamCourtsLever = Action()
function dreamCourtsLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if config.playerPositions[1].pos ~= player:getPosition() then
		return false
	end
	local spec = Spectators()
	spec:setOnlyPlayer(false)
	spec:setRemoveDestination(config.exit)
	spec:setCheckPosition(config.specPos)
	spec:check()
	if spec:getPlayers() > 0 then
		player:say("There's someone fighting with " .. bossToday .. ".", TALKTYPE_MONSTER_SAY)
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
		if not lever:canUseLever(player, bossToday, config.timeToFightAgain) then
			return false
		end
		return true
	end)
	lever:checkPositions()
	if lever:checkConditions() then
		spec:removeMonsters()
		local monster = Game.createMonster(bossToday, config.bossPosition, true, true)
		if not monster then
			return true
		end
		lever:teleportPlayers()
		lever:setCooldownAllPlayers(bossToday, os.time() + config.timeToFightAgain * 3600)
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
		end, config.timeToDefeat * 60 * 1000)
	end
end

dreamCourtsLever:position({ x = 32208, y = 32020, z = 13 })
dreamCourtsLever:register()
