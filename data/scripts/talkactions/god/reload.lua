local reloadTypes = {
	["all"] = RELOAD_TYPE_ALL,

	["channel"] = RELOAD_TYPE_CHAT,
	["chat"] = RELOAD_TYPE_CHAT,
	["chatchannels"] = RELOAD_TYPE_CHAT,

	["config"] = RELOAD_TYPE_CONFIG,
	["configuration"] = RELOAD_TYPE_CONFIG,

	["events"] = RELOAD_TYPE_EVENTS,

	["items"] = RELOAD_TYPE_ITEMS,

	["module"] = RELOAD_TYPE_MODULES,
	["modules"] = RELOAD_TYPE_MODULES,

	["monster"] = RELOAD_TYPE_MONSTERS,
	["monsters"] = RELOAD_TYPE_MONSTERS,

	["mount"] = RELOAD_TYPE_MOUNTS,
	["mounts"] = RELOAD_TYPE_MOUNTS,

	["npc"] = RELOAD_TYPE_NPCS,
	["npcs"] = RELOAD_TYPE_NPCS,

	["raid"] = RELOAD_TYPE_RAIDS,
	["raids"] = RELOAD_TYPE_RAIDS,

	["rate"] = RELOAD_TYPE_STAGES,
	["rates"] = RELOAD_TYPE_STAGES,

	["scripts"] = RELOAD_TYPE_SCRIPTS,

	["spell"] = RELOAD_TYPE_SPELLS,
	["spells"] =  RELOAD_TYPE_SPELLS,

	["stage"] = RELOAD_TYPE_STAGES,
	["stages"] = RELOAD_TYPE_STAGES,

	["global"] = RELOAD_TYPE_GLOBAL,
	["libs"] = RELOAD_TYPE_GLOBAL
}

local reload = TalkAction("/reload")

function reload.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	logCommand(player, words, param)

	local reloadType = reloadTypes[param:lower()]
	if reloadType then
		Game.reload(reloadType)
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, string.format("Reloaded %s.", param:lower()))
		Spdlog.info("Reloaded " .. param:lower())
		return true
	elseif not reloadType then
		player:sendCancelMessage("Reload type not found.")
		Spdlog.warn("[reload.onSay] - Reload type '".. param.. "' not found")
		return false
	end
	return false
end

reload:separator(" ")
reload:register()
