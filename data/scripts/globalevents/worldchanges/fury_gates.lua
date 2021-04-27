local gates = {
	-- Ab'dendriel
	[1] = {
		city = "Ab'dendriel",
		mapName = "abdendriel",
		exitPosition = Position(32680, 31720, 7)
	},
	-- Ankrahmun
	[2] = {
		city = "Ankrahmun",
		mapName = "ankrahmun",
		exitPosition = Position(33269, 32841, 7)
	},
	-- Carlin
	[3] = {
		city = "Carlin",
		mapName = "carlin",
		exitPosition = Position(32263, 31848, 7),
		burntItems = {
			{position = Position(32266, 31842, 7), itemId = 6218},
			{position = Position(32258, 31843, 7), itemId = 6219},
			{position = Position(32264, 31843, 7), itemId = 4181}
		}
	},
	-- Darashia
	[4] = {
		city = "Darashia",
		mapName = "darashia",
		exitPosition = Position(33304, 32371, 7),
		burntItems = {
			{position = Position(33300, 32366, 7), itemId = 6218}
		}
	},
	-- Edron
	[5] = {
		city = "Edron",
		mapName = "edron",
		exitPosition = Position(33221, 31923, 7)
	},
	-- Kazordoon
	[6] = {
		city = "Kazordoon",
		mapName = "kazordoon",
		exitPosition = Position(32575, 31981, 7),
		burntItems = {
			{position = Position(32571, 31976, 7), itemId = 6219},
			{position = Position(32573, 31977, 7), itemId = 6219},
			{position = Position(32569, 31984, 7), itemId = 6218},
			{position = Position(32572, 31984, 7), itemId = 6218},
			{position = Position(32572, 31985, 7), itemId = 6219}
		}
	},
	-- Liberty Bay
	[7] = {
		city = "Liberty Bay",
		mapName = "libertybay",
		exitPosition = Position(32348, 32693, 7)
	},
	-- Port Hope
	[8] = {
		city = "Port Hope",
		mapName = "porthope",
		exitPosition = Position(32530, 32712, 7),
		burntItems = {
			{position = Position(32532, 32719, 7), itemId = 2782}
		}
	},
	-- Thais
	[9] = {
		city = "Thais",
		mapName = "thais",
		exitPosition = Position(32265, 32164, 7),
		burntItems = {
			{position = Position(32269, 32157, 7), itemId = 6219},
			{position = Position(32274, 32165, 7), itemId = 6219}
		}
	},
	-- Venore
	[10] = {
		city = "Venore",
		mapName = "venore",
		exitPosition = Position(32834, 32082, 7),
		burntItems = {
			{position = Position(32836, 32079, 7), itemId = 6218},
			{position = Position(32835, 32080, 7), itemId = 2779},
			{position = Position(32837, 32080, 7), itemId = 6219},
			{position = Position(32828, 32081, 7), itemId = 6217},
			{position = Position(32836, 32081, 7), itemId = 2772},
			{position = Position(32837, 32081, 7), itemId = 6218},
			{position = Position(32827, 32082, 7), itemId = 6219},
			{position = Position(32836, 32082, 7), itemId = 6219},
			{position = Position(32834, 32084, 7), itemId = 2779},
			{position = Position(32830, 32086, 7), itemId = 2780},
			{position = Position(32836, 32086, 7), itemId = 2769},
			{position = Position(32836, 32087, 7), itemId = 2772},
			{position = Position(32838, 32087, 7), itemId = 2782},
			{position = Position(32835, 32089, 7), itemId = 6218},
			{position = Position(32836, 32091, 7), itemId = 2775}
		}
	}
}


-- FURY GATES MAP LOAD

local furygates = GlobalEvent("furygates")

function furygates.onStartup(interval)
	local gateId = math.random(1, 10)

	-- Remove burnt items
	if gates[gateId].burntItems then
		local item
		for i = 1, #gates[gateId].burntItems do
			item = Tile(gates[gateId].burntItems[i].position):getItemById(gates[gateId].burntItems[i].itemId)
			if item then
				item:remove()
			end
		end
	end

	Game.loadMap('data/world/furygates/' .. gates[gateId].mapName .. '.otbm')

	setGlobalStorageValue(GlobalStorage.FuryGates, gateId)

	Spdlog.info(string.format("Fury Gate will be active in %s today",
		gates[gateId].city))

	return true
end

furygates:register()


-- FURY GATE TELEPORTS

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local gateId = Game.getStorageValue(GlobalStorage.FuryGates)

	if not gates[gateId] then
		return true
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)

	-- Enter gates
	if item.actionid == 9710 then
		-- Check requirements
		if not player:isPremium() or not player:isPromoted() or player:getLevel() < 60 then
			player:say("Only Premium promoted players of level 60 or higher are able to enter this portal.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
			player:teleportTo(fromPosition)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		local destination = Position(33290, 31786, 13)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	-- Exit gate
	elseif item.actionid == 9715 then
		player:teleportTo(gates[gateId].exitPosition)
		gates[gateId].exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

teleport:type("stepin")
teleport:aid(9710, 9715)

teleport:register()
