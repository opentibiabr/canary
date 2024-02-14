local function furyWebhook(message)
	Webhook.sendMessage(":fire: " .. message, announcementChannels["serverAnnouncements"])
end

local gates = {
	{ city = "Ab'dendriel", mapName = "abdendriel", exitPosition = Position(32680, 31720, 7) },
	{ city = "Ankrahmun", mapName = "ankrahmun", exitPosition = Position(33269, 32841, 7) },
	{ city = "Carlin", mapName = "carlin", exitPosition = Position(32263, 31848, 7) },
	{ city = "Darashia", mapName = "darashia", exitPosition = Position(33304, 32371, 7) },
	{ city = "Edron", mapName = "edron", exitPosition = Position(33221, 31923, 7) },
	{ city = "Kazordoon", mapName = "kazordoon", exitPosition = Position(32575, 31981, 7) },
	{ city = "Liberty Bay", mapName = "libertybay", exitPosition = Position(32348, 32693, 7) },
	{ city = "Port Hope", mapName = "porthope", exitPosition = Position(32530, 32712, 7) },
	{ city = "Thais", mapName = "thais", exitPosition = Position(32265, 32164, 7) },
	{ city = "Venore", mapName = "venore", exitPosition = Position(32834, 32082, 7) },
}

local furyGates = GlobalEvent("Load Fury Gates")

function furyGates.onStartup(interval)
	local totalGates = #gates
	if totalGates == 0 then
		return true
	end

	local gateId = math.random(1, totalGates)
	local selectedGate = gates[gateId]
	Game.loadMap(DATA_DIRECTORY .. "/world/world_changes/fury_gates/" .. selectedGate.mapName .. ".otbm")
	Game.setStorageValue(GlobalStorage.FuryGates, gateId)

	logger.info("[World Change] Fury Gate has arrived in {}!", selectedGate.city)
	addEvent(furyWebhook, 60000, (string.format("Fury Gate will be active in %s today", selectedGate.city)))
	return true
end

furyGates:register()

local furyGatesTeleports = MoveEvent()

function furyGatesTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local gateId = Game.getStorageValue(GlobalStorage.FuryGates)
	if not gates[gateId] then
		return true
	end

	if item.actionid == 9710 then
		if not player:isPremium() or not player:isPromoted() or player:getLevel() < 60 then
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:say("Only Premium promoted players of level 60 or higher are able to enter this portal.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
			return true
		end

		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(Position(33290, 31786, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif item.actionid == 9715 then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(gates[gateId].exitPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

furyGatesTeleports:type("stepin")
furyGatesTeleports:aid(9710, 9715)
furyGatesTeleports:register()
