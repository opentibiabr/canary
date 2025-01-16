local config = {
	days = {
		--[[
		days: Monday-Segunda, Tuesday-Terça, Wednesday-Quarta, Thursday-Quinta, Friday-Sexta, Saturday-Sábado and Sunday-Domingo
		["day"]	   	  = { "Monster"  , "Tp Create Position"	    , "Position To Go"				 , "Position Boss"					 }
		]]
		--
		["Monday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Tuesday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Wednesday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Thursday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Friday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Saturday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
		["Sunday"] = { "Sanguinary", Position(32378, 32240, 7), Position(909, 1065, 6), Position(935, 1065, 7) },
	},
	teleportId = 25053, --25053, --1949
	spawnTime = "14:35",
	timeToSpawn = 5,
	centerPosition = Position(930, 1065, 7),
	exitPosition = Position(32345, 32223, 7),
}

local function removePlayers()
	local spectators = Game.getSpectators(config.centerPosition, true, true, 40, 40, 20, 20)
	for i = 1, #spectators do
		local spectator = spectators[i]
		--spectator:say("You have won this battle! Be prepared for the next!", TALKTYPE_MONSTER_SAY)
		spectator:teleportTo(config.exitPosition)
		spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
end

local function createBoss(bossName, bossPos)
	Game.createMonster(bossName, bossPos, false, true)
	Game.broadcastMessage(string.format("%s: DO PROFUNDO DESPERTAR EU VIM, UMA FOME INSACIAVEL DE SANGUE. SEUS GRITOS SERAO A SINFONIA DA MINHA DIVINA RESSURREICAO!", bossName), MESSAGE_EVENT_ADVANCE)
end

-- Function that is called by the global events when it reaches the time configured
-- interval is the time between the event start and the boss created, it will send a notify message when start
local BossEventRespawn = GlobalEvent("BossEventRespawn")
function BossEventRespawn.onTime(interval)
	local cfg = config.days[os.date("%A")]
	if cfg then
		removeTpAndOrnaments("sanguinary", cfg[2])
		createTpAndOrnaments("sanguinary", config.teleportId, cfg[2], cfg[3])
		local message = "The portal to boss event was opened inside Thais depot. The boss " .. cfg[1] .. " will spawn in " .. config.timeToSpawn .. " minutes. RUN!!"
		Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
		Webhook.sendMessage("Boss Event Respawn", message, WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
		addEvent(createBoss, config.timeToSpawn * 60 * 1000, cfg[1], cfg[4])
	end
	return true
end

BossEventRespawn:time(config.spawnTime)
BossEventRespawn:register()

------------------------------------------------------
local startBoss = TalkAction("/startsanguinary")

function startBoss.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local cfg = config.days[os.date("%A")]
	if cfg then
		removeTpAndOrnaments("sanguinary", cfg[2])
		createTpAndOrnaments("sanguinary", config.teleportId, cfg[2], cfg[3])
		local message = "The portal to boss event was opened inside Thais depot. The boss " .. cfg[1] .. " will spawn in " .. config.timeToSpawn .. " minutes. RUN!!"
		Game.broadcastMessage(message, MESSAGE_EVENT_ADVANCE)
		Webhook.sendMessage("Boss Event Respawn", message, WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
		addEvent(createBoss, config.timeToSpawn * 60 * 1000, cfg[1], cfg[4])
	end
	return true
end

startBoss:separator(" ")
startBoss:groupType("god")
startBoss:register()

--------------------------- On Death ------------------------------------
local SanguinaryDeath = CreatureEvent("SanguinaryDeath")
function SanguinaryDeath.onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if not table.contains({ "sanguinary" }, creature:getName():lower()) then
		return false
	end
	logger.info("[{}] Defeated", creature:getName())
	Game.broadcastMessage(creature:getName() .. ": DESSA VEZ VOCES CONSEGUIRAM ME DETER, NOS ENCONTRAREMOS DE NOVO.. Muahahahaha!", MESSAGE_EVENT_ADVANCE)
	local cfg = config.days[os.date("%A")]
	if cfg then
		removeTpAndOrnaments("sanguinary", cfg[2])
		addEvent(removePlayers, 1 * 60 * 1000)
	end
	return true
end

SanguinaryDeath:register()
