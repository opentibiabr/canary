local config = {
	[1] = {
		teleportPosition = { x = 33886, y = 31477, z = 6 },
		bossName = "Neferi The Spy",
		requiredLevel = 250,
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(33871, 31547, 8),
		bossPosition = Position(33871, 31552, 8),
		specPos = {
			from = Position(33866, 31545, 8),
			to = Position(33876, 31555, 8),
		},
		exitPosition = Position(33886, 31478, 6),
	},
	[2] = {
		teleportPosition = { x = 33883, y = 31467, z = 9 },
		bossName = "Sister Hetai",
		requiredLevel = 250,
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(33833, 31490, 9),
		bossPosition = Position(33833, 31496, 9),
		specPos = {
			from = Position(33827, 31488, 9),
			to = Position(33837, 31501, 9),
		},
		exitPosition = Position(33883, 31468, 9),
	},
	[3] = {
		teleportPosition = { x = 33819, y = 31773, z = 10 },
		bossName = "Amenef the Burning",
		requiredLevel = 250,
		timeToFightAgain = 10, -- In hour
		timeToDefeat = 10, -- In minutes
		destination = Position(33849, 31782, 10),
		bossPosition = Position(33849, 31787, 10),
		specPos = {
			from = Position(33842, 31779, 10),
			to = Position(33855, 31791, 10),
		},
		exitPosition = Position(33819, 31774, 10),
	},
	[4] = {
		teleportPosition = { x = 33871, y = 31546, z = 8 },
		exitPosition = Position(33886, 31478, 6),
	},
	[5] = {
		teleportPosition = { x = 33833, y = 31489, z = 9 },
		exitPosition = Position(33883, 31468, 9),
	},
	[6] = {
		teleportPosition = { x = 33849, y = 31781, z = 10 },
		exitPosition = Position(33819, 31774, 10),
	},
}

local teleportBoss = MoveEvent()
function teleportBoss.onStepIn(creature, item, position, fromPosition)
	if not creature or not creature:isPlayer() then
		return false
	end
	for index, value in pairs(config) do
		if Tile(position) == Tile(value.teleportPosition) then
			if not value.specPos then
				creature:teleportTo(value.exitPosition)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
			local spec = Spectators()
			spec:setOnlyPlayer(false)
			spec:setRemoveDestination(value.exitPosition)
			spec:setCheckPosition(value.specPos)
			spec:check()
			if spec:getPlayers() > 0 then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:say("There's someone fighting with " .. value.bossName .. ".", TALKTYPE_MONSTER_SAY)
				return true
			end
			if creature:getLevel() < value.requiredLevel then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. value.requiredLevel .. " or higher.")
				return true
			end
			if not creature:canFightBoss(value.bossName) then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. value.timeToFightAgain .. " hours to face " .. value.bossName .. " again!")
				return true
			end
			spec:removeMonsters()
			local monster = Game.createMonster(value.bossName, value.bossPosition, true, true)
			if not monster then
				return true
			end
			creature:teleportTo(value.destination)
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			creature:setBossCooldown(value.bossName, os.time() + value.timeToFightAgain * 3600)
			addEvent(function()
				spec:clearCreaturesCache()
				spec:setOnlyPlayer(true)
				spec:check()
				spec:removePlayers()
			end, value.timeToDefeat * 60 * 1000)
		end
	end
end

for index, value in pairs(config) do
	teleportBoss:position(value.teleportPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()
