local reloadTypes = {
	["all"] = RELOAD_TYPE_ALL,
	["channel"] = RELOAD_TYPE_CHAT,
	["chat"] = RELOAD_TYPE_CHAT,
	["chatchannels"] = RELOAD_TYPE_CHAT,
	["config"] = RELOAD_TYPE_CONFIG,
	["configuration"] = RELOAD_TYPE_CONFIG,
	["core"] = RELOAD_TYPE_CORE,
	["events"] = RELOAD_TYPE_EVENTS,
	["global"] = RELOAD_TYPE_CORE,
	["group"] = RELOAD_TYPE_GROUPS,
	["groups"] = RELOAD_TYPE_GROUPS,
	["imbuements"] = RELOAD_TYPE_IMBUEMENTS,
	["items"] = RELOAD_TYPE_ITEMS,
	["lib"] = RELOAD_TYPE_CORE,
	["libs"] = RELOAD_TYPE_CORE,
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
	["rate"] = RELOAD_TYPE_CORE,
	["rates"] = RELOAD_TYPE_CORE,
	["script"] = RELOAD_TYPE_SCRIPTS,
	["scripts"] = RELOAD_TYPE_SCRIPTS,
	["stage"] = RELOAD_TYPE_CORE,
	["stages"] = RELOAD_TYPE_CORE,
}

local reload = TalkAction("/reload")

function reload.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.ALLOW_RELOAD) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reload command is disabled.")
		return true
	end

	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Command param required.")
		return true
	end

	-- create log
	logCommand(player, "/reload", param)

	local reloadType = reloadTypes[param:lower()]
	if reloadType then
		saveServer()
		SaveHirelings()

		Game.reload(reloadType)
		logger.info("Reloaded {}", param:lower())

		player:sendTextMessage(MESSAGE_LOOK, string.format("Reloaded %s.", param:lower()))
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is saved. Now will reload configs!")
	elseif not reloadType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reload type not found.")
		logger.warn("[reload.onSay] - Reload type '{}' not found", param)
	end
	return true
end

reload:separator(" ")
reload:groupType("god")
reload:register()
