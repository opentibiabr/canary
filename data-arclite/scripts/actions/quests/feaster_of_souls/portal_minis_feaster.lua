local config = {
	[1] = {
		teleportPosition = {x = 33491, y = 31398, z = 8},
		bossName = "Irgix the Flimsy",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33467, 31405, 8),
		bossPosition = Position(33467, 31399, 8),
		specPos = {
			from = Position(33460, 31393, 8),
			to = Position(33474, 31408, 8)
		},
		exitPosition = Position(33493, 31400, 8),
		storage = Storage.Quest.U12_30.FeasterOfSouls.IrgixTimer
	},
	[2] = {
		teleportPosition = {x = 33566, y = 31475, z = 8},
		bossName = "Unaz the Mean",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33576, 31494, 8),
		bossPosition = Position(33565, 31496, 8),
		specPos = {
			from = Position(33558, 31487, 8),
			to = Position(33582, 31499, 8)
		},
		exitPosition = Position(33563, 31477, 8),
		storage = Storage.Quest.U12_30.FeasterOfSouls.UnazTimer
	},
	[3] = {
		teleportPosition = {x = 33509, y = 31450, z = 9},
		bossName = "Vok The Freakish",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33508, 31494, 9),
		bossPosition = Position(33508, 31486, 9),
		specPos = {
			from = Position(33501, 31483, 9),
			to = Position(33515, 31496, 9)
		},
		exitPosition = Position(33509, 31451, 9),
		storage = Storage.Quest.U12_30.FeasterOfSouls.VokTimer
	},
	[4] = {
		teleportPosition = {x = 33467, y = 31396, z = 8},
		exitPosition = Position(33493, 31400, 8)
		},
	[5] = {
		teleportPosition = {x = 33562, y = 31492, z = 8},
		exitPosition = Position(33563, 31477, 8)
		},
	[6] = {
		teleportPosition = {x = 33505, y = 31485, z = 9},
		exitPosition = Position(33509, 31451, 9)
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
			if creature:getStorageValue(value.storage) > os.time() then
				creature:teleportTo(fromPosition, true)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait " .. value.timeToFightAgain .. " hours to face ".. value.bossName .. " again!")
				return true
			end
			spec:removeMonsters()
			local monster = Game.createMonster(value.bossName, value.bossPosition, true, true)
			if not monster then
				return true
			end
			creature:teleportTo(value.destination)
			creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			creature:setStorageValue(value.storage, os.time() + value.timeToFightAgain * 3600)
			addEvent(function()
				spec:clearCreaturesCache()
				spec:setOnlyPlayer(true)
				spec:check()
				spec:removePlayers()
			end, value.timeToDefeatBoss * 60 * 1000)
		end
	end
end
for index, value in pairs(config) do
	teleportBoss:position(value.teleportPosition)
end

teleportBoss:type("stepin")
teleportBoss:register()
