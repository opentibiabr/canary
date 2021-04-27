--[[
TODO
- Include PITS and ARENA table in SvargrondArena -> SvargrondArena.arenas / SvargrondArena.PitDoors
- Restructure PITS and ARENA table (reward.storage does not seem to be used)
]]

SvargrondArena = {
	-- kick time in seconds (10 minutes)
	kickTime = 600,
	kickPosition = Position({x = 32251, y = 31098, z = 6}),
	rewardPosition = Position({x = 32222, y = 31080, z = 6}),

	-- used to store event ids
	kickEvents = {},
	timerEvents = {},
	effectPositionCache = {},

	-- item ids used by the script
	itemTimer = 10288,
	itemPillar = 1354,
	itemTeleport = 5023,
	itemsNotErasable = {10288, 1354, 1543, 1544, 1545},
}

-- Script automatically derives other pit positions from this one
local firstPit = {
	fromPos = {x = 32205, y = 31094, z = 7},
	toPos = {x = 32214, y = 31103, z = 7},
	center = {x = 32210, y = 31098, z = 7},
	pillar = {x = 32204, y = 31098, z = 7},
	tp = {x = 32204, y = 31098, z = 7},
	summon = {x = 32210, y = 31100, z = 7}
}

PITS = {
	[1] = {
		fromPos = firstPit.fromPos,
		toPos = firstPit.toPos,
		center = firstPit.center,
		pillar = firstPit.pillar,
		tp = firstPit.tp,
		summon = firstPit.summon
	},
	[2] = {
		fromPos = {x = firstPit.fromPos.x - 14, y = firstPit.fromPos.y, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 14, y = firstPit.toPos.y, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 14, y = firstPit.center.y, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 14, y = firstPit.pillar.y, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 14, y = firstPit.tp.y, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 14, y = firstPit.summon.y, z = firstPit.summon.z}
	},
	[3] = {
		fromPos = {x = firstPit.fromPos.x - 28, y = firstPit.fromPos.y, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 28, y = firstPit.toPos.y, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 28, y = firstPit.center.y, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 28, y = firstPit.pillar.y, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 28, y = firstPit.tp.y, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 28, y = firstPit.summon.y, z = firstPit.summon.z}
	},
	[4] = {
		fromPos = {x = firstPit.fromPos.x - 42, y = firstPit.fromPos.y, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 42, y = firstPit.toPos.y, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 42, y = firstPit.center.y, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 42, y = firstPit.pillar.y, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 42, y = firstPit.tp.y, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 42, y = firstPit.summon.y, z = firstPit.summon.z}
	},
	[5] = {
		fromPos = {x = firstPit.fromPos.x - 35, y = firstPit.fromPos.y - 14, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 35, y = firstPit.toPos.y - 14, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 35, y = firstPit.center.y - 14, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 35, y = firstPit.pillar.y - 14, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 35, y = firstPit.tp.y - 14, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 35, y = firstPit.summon.y - 14, z = firstPit.summon.z}
	},
	[6] = {
		fromPos = {x = firstPit.fromPos.x - 21, y = firstPit.fromPos.y - 14, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 21, y = firstPit.toPos.y - 14, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 21, y = firstPit.center.y - 14, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 21, y = firstPit.pillar.y - 14, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 21, y = firstPit.tp.y - 14, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 21, y = firstPit.summon.y - 14, z = firstPit.summon.z}
	},
	[7] = {
		fromPos = {x = firstPit.fromPos.x - 7, y = firstPit.fromPos.y - 14, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 7, y = firstPit.toPos.y - 14, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 7, y = firstPit.center.y - 14, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 7, y = firstPit.pillar.y - 14, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 7, y = firstPit.tp.y - 14, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 7, y = firstPit.summon.y - 14, z = firstPit.summon.z}
	},
	[8] = {
		fromPos = {x = firstPit.fromPos.x - 14, y = firstPit.fromPos.y - 28, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 14, y = firstPit.toPos.y - 28, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 14, y = firstPit.center.y - 28, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 14, y = firstPit.pillar.y - 28, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 14, y = firstPit.tp.y - 28, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 14, y = firstPit.summon.y - 28, z = firstPit.summon.z}
	},
	[9] = {
		fromPos = {x = firstPit.fromPos.x - 28, y = firstPit.fromPos.y - 28, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 28, y = firstPit.toPos.y - 28, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 28, y = firstPit.center.y - 28, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 28, y = firstPit.pillar.y - 28, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 28, y = firstPit.tp.y - 28, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 28, y = firstPit.summon.y - 28, z = firstPit.summon.z}
	},
	[10] = {
		fromPos = {x = firstPit.fromPos.x - 21, y = firstPit.fromPos.y - 42, z = firstPit.fromPos.z},
		toPos = {x = firstPit.toPos.x - 21, y = firstPit.toPos.y - 42, z = firstPit.toPos.z},
		center = {x = firstPit.center.x - 21, y = firstPit.center.y - 41, z = firstPit.center.z},
		pillar = {x = firstPit.pillar.x - 21, y = firstPit.pillar.y - 41, z = firstPit.pillar.z},
		tp = {x = firstPit.tp.x - 21, y = firstPit.tp.y - 41, z = firstPit.tp.z},
		summon = {x = firstPit.summon.x - 21, y = firstPit.summon.y - 41, z = firstPit.summon.z}
	}
}

ARENA = {
	[1] = {
		name = 'Greenhorn',
		price = 1000,
		questLog = Storage.SvargrondArena.QuestLogGreenhorn,
		achievement = 'Greenhorn',
		creatures = {
			[1] = 'frostfur',
			[2] = 'bloodpaw',
			[3] = 'bovinus',
			[4] = 'achad',
			[5] = 'colerian the barbarian',
			[6] = 'the hairy one',
			[7] = 'axeitus headbanger',
			[8] = 'rocky',
			[9] = 'cursed gladiator',
			[10] = 'orcus the cruel'
		}
	},
	[2] = {
		name = 'Scrapper',
		price = 5000,
		questLog = Storage.SvargrondArena.QuestLogScrapper,
		achievement = 'Scrapper',
		creatures = {
			[1] = 'avalanche',
			[2] = 'kreebosh the exile',
			[3] = 'the dark dancer',
			[4] = 'the hag',
			[5] = 'slim',
			[6] = 'grimgor guteater',
			[7] = 'drasilla',
			[8] = 'spirit of earth',
			[9] = 'spirit of water',
			[10] = 'spirit of fire'
		}
	},
	[3] = {
		name = 'Warlord',
		price = 10000,
		questLog = Storage.SvargrondArena.QuestLogWarlord,
		achievement = 'Warlord of Svargrond',
		creatures = {
			[1] = 'webster',
			[2] = 'darakan the executioner',
			[3] = 'norgle glacierbeard',
			[4] = 'the pit lord',
			[5] = 'svoren the mad',
			[6] = 'the masked marauder',
			[7] = 'gnorre chyllson',
			[8] = 'fallen mooh\'tah master ghar',
			[9] = 'deathbringer',
			[10] = 'the obliverator'
		}
	}
}

ARENA_TROPHY = {
	[3264] = {
		trophy = 5807,
		trophyStorage = Storage.SvargrondArena.TrophyGreenhorn,
		desc = 'It is given to the courageous victor of the barbarian arena in greenhorn difficulty. Awarded to %s',
	},
	[3265] = {
		trophy = 5806,
		trophyStorage = Storage.SvargrondArena.TrophyScrapper,
		desc = 'It is given to the courageous victor of the barbarian arena in scrapper difficulty. Awarded to %s.',
	},
	[3266] = {
		trophy = 5805,
		trophyStorage = Storage.SvargrondArena.TrophyWarlord,
		desc = 'It is given to the courageous victor of the barbarian arena in warlord difficulty. Awarded to %s.',
	}
}

function SvargrondArena.getPitCreatures(pitId)
	if not PITS[pitId] then
		return {}
	end

	local ret = {}
	local specs = Game.getSpectators(PITS[pitId].center, false, false, 5, 5, 5, 5)
	for i = 1, #specs do
		ret[#ret+1] = specs[i]
	end

	return ret
end

function SvargrondArena.resetPit(pitId)
	if not PITS[pitId] then
		return
	end

	for x = PITS[pitId].fromPos.x, PITS[pitId].toPos.x do
		for y = PITS[pitId].fromPos.y, PITS[pitId].toPos.y do
			for z = PITS[pitId].fromPos.z, PITS[pitId].toPos.z do
				local tile = Tile({x=x, y=y, z=z})
				if tile then
					local movableItem = tile:getThing(255)
					if movableItem and movableItem:isItem() then
						local itemType = ItemType(movableItem:getId())
						if itemType and itemType:isMovable() and not isInArray(SvargrondArena.itemsNotErasable, movableItem:getId()) then
							moveableItem:remove()
						end
					end

					local creature = tile:getTopCreature()
					if creature and creature:isMonster() then
						creature:remove()
					end
				end
			end
		end
	end

	local pillarTile = Tile(PITS[pitId].pillar)
	if pillarTile then
		local teleportItem = pillarTile:getItemById(SvargrondArena.itemTeleport)
		if teleportItem then
			teleportItem:remove()
		end

		local pillarItem = pillarTile:getItemById(SvargrondArena.itemPillar)
		if not pillarItem then
			Game.createItem(SvargrondArena.itemPillar, 1, PITS[pitId].pillar)
		end
	end
end

function SvargrondArena.getPitOccupant(pitId, ignorePlayer)
	local creatures = SvargrondArena.getPitCreatures(pitId)
	for i = 1, #creatures do
		if creatures[i]:isPlayer() and creatures[i]:getId() ~= ignorePlayer:getId() then
			return creatures[i]
		end
	end

	return nil
end

function SvargrondArena.kickPlayer(cid, hideMessage)
	SvargrondArena.cancelEvents(cid)
	local player = Player(cid)
	if not player then
		return
	end

	if player:getStorageValue(Storage.SvargrondArena.PitDoor) > 0 then
		player:teleportTo(SvargrondArena.kickPosition)
		SvargrondArena.kickPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.SvargrondArena.PitDoor, 0)
		if not hideMessage then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your time ran out!')
		end
	end
end

function SvargrondArena.cancelEvents(cid)
	local kickEvent = SvargrondArena.kickEvents[cid]
	if kickEvent then
		SvargrondArena.removeTimer(kickEvent.pitId)
		stopEvent(kickEvent.eventId)
	end
	SvargrondArena.kickEvents[cid] = nil
end

function SvargrondArena.scheduleKickPlayer(cid, pitId)
	SvargrondArena.cancelEvents(cid)
	SvargrondArena.startTimer(pitId)
	local eventId = addEvent(SvargrondArena.kickPlayer, SvargrondArena.kickTime * 1000, cid)
	SvargrondArena.kickEvents[cid] = {eventId = eventId, pitId = pitId}
end

function SvargrondArena.startTimer(pitId)
	local tile = Tile(PITS[pitId].fromPos)
	if not tile then
		return
	end

	local timerItem = tile:getItemById(SvargrondArena.itemTimer)
	if timerItem then
		timerItem:remove()
	end

	timerItem = Game.createItem(SvargrondArena.itemTimer, 1, PITS[pitId].fromPos)
	if timerItem then
		timerItem:decay()
	end

	if SvargrondArena.timerEvents[pitId] then
		stopEvent(SvargrondArena.timerEvents[pitId])
	end
	SvargrondArena.timerEvents[pitId] = addEvent(SvargrondArena.removeTimer, SvargrondArena.kickTime * 1000, pitId)
end

function SvargrondArena.removeTimer(pitId)
	local tile = Tile(PITS[pitId].fromPos)
	if not tile then
		return
	end

	local timerItem = tile:getItemById(SvargrondArena.itemTimer)
	if timerItem then
		timerItem:remove()
	end
	SvargrondArena.timerEvents[pitId] = nil
end

function SvargrondArena.sendPillarEffect(pitId)
	local positions = SvargrondArena.effectPositionCache[pitId]
	if not positions then
		local position = PITS[pitId].pillar
		local effectPositions = {
			Position(position.x - 1, position.y, position.z),
			Position(position.x + 1, position.y, position.z),
			Position(position.x + 1, position.y - 1, position.z),
			Position(position.x + 1, position.y + 1, position.z),
			Position(position.x, position.y, position.z)
		}
		SvargrondArena.effectPositionCache[pitId] = effectPositions
		positions = effectPositions
	end

	for i = 1, #positions do
		positions[i]:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
end
