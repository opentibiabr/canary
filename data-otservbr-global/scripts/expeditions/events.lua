local loginEvent = CreatureEvent("ExpeditionLogin")

function loginEvent.onLogin(player)
	local ok, err = pcall(function()
		ExpeditionManager.onLogin(player)
	end)
	if not ok then
		logger.error("[Expedition] onLogin failed for {}: {}", player:getName(), err)
	end
	return true
end

loginEvent:register()

local opcodeEvent = CreatureEvent("ExpeditionExtendedOpcode")

function opcodeEvent.onExtendedOpcode(player, opcode, buffer)
	if not ExpeditionConfig or opcode ~= ExpeditionConfig.OPCODE then
		return
	end
	local ok, err = pcall(function()
		ExpeditionProtocol.handle(player, buffer)
	end)
	if not ok then
		logger.error("[Expedition] opcode handler failed: {}", err)
	end
end

opcodeEvent:register()

local deathEvent = CreatureEvent("ExpeditionPlayerDeath")

function deathEvent.onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	pcall(function()
		ExpeditionManager.onDeath(player)
	end)
	return true
end

deathEvent:register()

local monsterDeath = CreatureEvent("ExpeditionMonsterDeath")

function monsterDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	pcall(function()
		ExpeditionWaves.onMonsterDeath(creature)
	end)
	return true
end

monsterDeath:register()

local thinkCallback = EventCallback("ExpeditionPlayerOnThink")

function thinkCallback.playerOnThink(player, interval)
	if ExpeditionAI and ExpeditionAI.onPlayerThink then
		pcall(ExpeditionAI.onPlayerThink, player)
	end
end

thinkCallback:register()

local startup = GlobalEvent("ExpeditionStartup")

function startup.onStartup()
	if ExpeditionManager and ExpeditionManager.onStartup then
		ExpeditionManager.onStartup()
	end
	return true
end

startup:register()
