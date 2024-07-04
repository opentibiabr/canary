local reloadTypes = {
	["all"] = RELOAD_TYPE_ALL,
	["channel"] = RELOAD_TYPE_CHAT,
	["chat"] = RELOAD_TYPE_CHAT,
	["chatchannels"] = RELOAD_TYPE_CHAT,
	["config"] = RELOAD_TYPE_CONFIG,
	["configuration"] = RELOAD_TYPE_CONFIG,
	["core"] = RELOAD_TYPE_CORE,
	["events"] = RELOAD_TYPE_EVENTS,
	["familiar"] = RELOAD_TYPE_FAMILIARS,
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
	["outfit"] = RELOAD_TYPE_OUTFITS,
	["outfits"] = RELOAD_TYPE_OUTFITS,
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
	["vocations"] = RELOAD_TYPE_VOCATIONS,
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
	if not reloadType then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reload type not found.")
		return true
	end

	saveServer()
	SaveHirelings()

	Game.reload(reloadType)

	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("The server has been reloaded, %s and configurations are now being reloaded.", param:lower()))
	return true
end

reload:separator(" ")
reload:groupType("god")
reload:register()
