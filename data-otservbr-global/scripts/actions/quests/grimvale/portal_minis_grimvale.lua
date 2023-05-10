local config = {
	[1] = {
		teleportPosition = {x = 33167, y = 31977, z = 8},
		bossName = "Bloodback",
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33180, 32012, 8),
		bossPosition = Position(33184, 32016, 8),
		specPos = {
			from = Position(33174, 32007, 8),
			to = Position(33191, 32020, 8)
		},
		exitPosition = Position(33167, 31978, 8),
		storage = Storage.Quest.U10_80.Grimvale.BloodbackTimer
	},
	[2] = {
		teleportPosition = {x = 33055, y = 31910, z = 9},
		bossName = "Darkfang",
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33055, 31889, 9),
		bossPosition = Position(33565, 31496, 8),
		specPos = {
			from = Position(33050, 31883, 9),
			to = Position(33066, 31896, 9)
		},
		exitPosition = Position(33055, 31911, 9),
		storage = Storage.Quest.U10_80.Grimvale.DarkfangTimer
	},
	[3] = {
		teleportPosition = {x = 33128, y = 31971, z = 9},
		bossName = "Sharpclaw",
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33120, 31997, 9),
		bossPosition = Position(33120, 32002, 9),
		specPos = {
			from = Position(33113, 31994, 9),
			to = Position(33126, 32007, 9)
		},
		exitPosition = Position(33128, 31972, 9),
		storage = Storage.Quest.U10_80.Grimvale.SharpclawTimer
	},
	[4] = {
		teleportPosition = {x = 33402, y = 32097, z = 9},
		bossName = "Shadowpelt",
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33395, 32112, 9),
		bossPosition = Position(33384, 32114, 9),
		specPos = {
			from = Position(33376, 32107, 9),
			to = Position(33396, 32119, 9)
		},
		exitPosition = Position(33403, 32097, 9),
		storage = Storage.Quest.U10_80.Grimvale.ShadowpeltTimer
	},
	[5] = {
		teleportPosition = {x = 33442, y = 32051, z = 9},
		bossName = "Black Vixen",
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33447, 32040, 9),
		bossPosition = Position(33450, 32034, 9),
		specPos = {
			from = Position(33442, 32027, 9),
			to = Position(33456, 32041, 9)
		},
		exitPosition = Position(33442, 32052, 9),
		storage = Storage.Quest.U10_80.Grimvale.BlackVixenTimer
	},
	[6] = {
		teleportPosition = {x = 33180, y = 32011, z = 8},
		exitPosition = Position(33167, 31978, 8)
	},
	[7] = {
		teleportPosition = {x = 33055, y = 31888, z = 9},
		exitPosition = Position(33055, 31911, 9)
	},
	[8] = {
		teleportPosition = {x = 33120, y = 31996, z = 9},
		exitPosition = Position(33128, 31972, 9)
	},
	[9] = {
		teleportPosition = {x = 33395, y = 32111, z = 9},
		exitPosition = Position(33403, 32097, 9)
	},
	[10] = {
		teleportPosition = {x = 33446, y = 32040, z = 9},
		exitPosition = Position(33442, 32052, 9)
	}
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
