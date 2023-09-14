local config = {
	[1] = {
		teleportPosition = {x = 33123, y = 32239, z = 12},
		bossName = "Yirkas Blue Scales",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33154, 32246, 12),
		bossPosition = Position(33154, 32252, 12),
		specPos = {
			from = Position(33150, 32242, 12),
			to = Position(33164, 32260, 12)
		},
		exitPosition = Position(33123, 32240, 12),
		storage = Storage.Quest.U10_80.Grimvale.YirkasTimer
	},
	[2] = {
		teleportPosition = {x = 33131, y = 32252, z = 12},
		bossName = "Srezz Yellow Eyes",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33120, 32278, 12),
		bossPosition = Position(33122, 32285, 12),
		specPos = {
			from = Position(33115, 32275, 12),
			to = Position(33127, 32290, 12)
		},
		exitPosition = Position(33130, 32252, 12),
		storage = Storage.Quest.U10_80.Grimvale.SrezzTimer
	},
	[3] = {
		teleportPosition = {x = 33123, y = 32265, z = 12},
		bossName = "Utua Stone Sting",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33087, 32240, 12),
		bossPosition = Position(33087, 32245, 12),
		specPos = {
			from = Position(33082, 32237, 12),
			to = Position(33091, 32252, 12)
		},
		exitPosition = Position(33123, 32264, 12),
		storage = Storage.Quest.U10_80.Grimvale.UtuaTimer
	},
	[4] = {
		teleportPosition = {x = 33114, y = 32252, z = 12},
		bossName = "Katex Blood Tongue",
		requiredLevel = 250,
		timeToFightAgain = 20, -- In hour
		timeToDefeatBoss = 10, -- In minutes
		destination = Position(33149, 32283, 12),
		bossPosition = Position(33152, 32289, 12),
		specPos = {
			from = Position(33145, 32279, 12),
			to = Position(33159, 32293, 12)
		},
		exitPosition = Position(33115, 32252, 12),
		storage = Storage.Quest.U10_80.Grimvale.KatexTimer
	},
	[5] = {
		teleportPosition = {x = 33154, y = 32245, z = 12},
		exitPosition = Position(33123, 32240, 12)
	},
	[6] = {
		teleportPosition = {x = 33119, y = 32278, z = 12},
		exitPosition = Position(33130, 32252, 12)
	},
	[7] = {
		teleportPosition = {x = 33087, y = 32239, z = 12},
		exitPosition = Position(33123, 32264, 12)
	},
	[8] = {
		teleportPosition = {x = 33148, y = 32283, z = 12},
		exitPosition = Position(33115, 32252, 12)
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
