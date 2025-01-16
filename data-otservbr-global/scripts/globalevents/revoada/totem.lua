local config = {
	bossName = "Taberna Totem",
	timeToEvokeAgain = 5, -- hours
	timeToSpawn = 5, -- minutes
	positions = {
		Position(32364, 32164, 7), --thais
		Position(32345, 31734, 7), --carlin
		Position(33193, 32700, 7), --ankrahmun
		Position(33108, 32421, 7), --darashia
		Position(32707, 32702, 7), --port hope
		Position(32802, 31233, 7), --yalahar
		Position(33250, 31797, 7), --edron
		Position(33560, 32013, 7), --oramond
	},
	cities = {
		"Thais", --1
		"Carlin", --2
		"Ankrahmun", --3
		"Darashia", --4
		"Port Hope", --5
		"yalahar", --6
		"Edron", --7
		"Oramond", --8
	},
}

function evokeRevoadaTotem()
	local message = "A wild totem has coming to our world. The " .. config.bossName .. " will spawn in " .. config.timeToSpawn .. " minutes. RUN AND FIND HIM!!"
	Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
	Webhook.sendMessage("Taberna Totem", message, WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	addEvent(createRevoadaTotem, config.timeToSpawn * 60 * 1000)
end

function createRevoadaTotem()
	local cityIndex = math.random(#config.positions)
	local positionToBorn = config.positions[cityIndex]
	logger.info("[{}] in city: {} ({})", config.bossName, config.cities[cityIndex], cityIndex)
	Game.setStorageValue(GlobalStorage.RevoadaTotemCityIndex, cityIndex)
	Game.createMonster(config.bossName, positionToBorn, false, true)
	Game.broadcastMessage("A wild totem was born in one of these cities: Thais, Carlin, Ankrahmun, Darashia, Yalahar, Edron, Oramond or Port Hope! Go check and call your friends..", MESSAGE_EVENT_ADVANCE)
end

------------------------------- Startup ----------------------------------
local revoadaTotemRespawnStart = GlobalEvent("RevoadaTotemRespawnStartup")
function revoadaTotemRespawnStart.onStartup()
	logger.info("[{}] Event Started", config.bossName)
	evokeRevoadaTotem()
end
revoadaTotemRespawnStart:register()

--------------------------- On Death ------------------------------------
local revoadaTotemDeath = CreatureEvent("RevoadaTotemDeath")
function revoadaTotemDeath.onDeath(creature)
	if not creature:getName():lower() == "Taberna Totem" then
		return false
	end

	logger.info("[{}] Defeated. Reborn in {} hours", config.bossName, config.timeToEvokeAgain)
	Game.setStorageValue(GlobalStorage.RevoadaTotemCityIndex, 0)
	Game.broadcastMessage(config.bossName .. " was defeated and will reborn again in " .. config.timeToEvokeAgain .. " hours.", MESSAGE_EVENT_ADVANCE)
	addEvent(evokeRevoadaTotem, config.timeToEvokeAgain * 3600 * 1000)
	--local spectators, spectator = Game.getSpectators(Position({ x = 33063, y = 31034, z = 3 }), false, true, 10, 10, 10, 10)
	--for i = 1, #spectators do
	--	spectator = spectators[i]
	--	spectator:teleportTo(exitPosition[1])
	--	exitPosition[1]:sendMagicEffect(CONST_ME_TELEPORT)
	--	spectator:say("You have won! As new champion take the ancient armor as reward before you leave.", TALKTYPE_MONSTER_SAY)
	--end
	return true
end

revoadaTotemDeath:register()
