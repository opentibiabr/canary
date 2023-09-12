-- NOTE: Using this script might cause unwanted changes.
-- This script forces a reload in the entire server, this means
-- that everything that is stored in memory might stop to work
-- properly and/or completely.
--
-- This script should be used in test environments only.

function Player.reloadTalkaction(self, words, param)
	local reloadTypes = {
		["all"] = RELOAD_TYPE_ALL,

		["chat"] = RELOAD_TYPE_CHAT,
		["channel"] = RELOAD_TYPE_CHAT,
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

		["scripts"] = RELOAD_TYPE_SCRIPTS,
		["script"] = RELOAD_TYPE_SCRIPTS,

		["rate"] = RELOAD_TYPE_CORE,
		["rates"] = RELOAD_TYPE_CORE,
		["stage"] = RELOAD_TYPE_CORE,
		["stages"] = RELOAD_TYPE_CORE,
		["global"] = RELOAD_TYPE_CORE,
		["core"] = RELOAD_TYPE_CORE,
		["lib"] = RELOAD_TYPE_CORE,
		["libs"] = RELOAD_TYPE_CORE,

		["imbuements"] = RELOAD_TYPE_IMBUEMENTS,

		["group"] = RELOAD_TYPE_GROUPS,
		["groups"] = RELOAD_TYPE_GROUPS,
	}

	if not configManager.getBoolean(configKeys.ALLOW_RELOAD) then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reload command is disabled.")
		return true
	end

	if param == "" then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Command param required.")
		return true
	end

	-- create log
	logCommand(self, "/reload", param)

	local reloadType = reloadTypes[param:lower()]
	if reloadType then
		-- Force save server before reload
		saveServer()
		SaveHirelings()
		logger.info("Saved Hirelings")
		self:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is saved.. Now will reload configs!")

		Game.reload(reloadType)
		self:sendTextMessage(MESSAGE_LOOK, string.format("Reloaded %s.", param:lower()))
		logger.info("Reloaded {}", param:lower())
	elseif not reloadType then
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reload type not found.")
		logger.warn("[reload.onSay] - Reload type '{}' not found", param)
	end
	return true
end

local reload = TalkAction("/reload")

function reload.onSay(player, words, param)
	return player:reloadTalkaction(words, param)
end

reload:separator(" ")
reload:groupType("god")
reload:register()
