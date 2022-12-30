local function notAccountTypeGod(player)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end
end

function Player.reloadTalkaction(self, param)
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

		["rate"] = RELOAD_TYPE_CORE,
		["rates"] = RELOAD_TYPE_CORE,
		["stage"] = RELOAD_TYPE_CORE,
		["stages"] = RELOAD_TYPE_CORE,
		["global"] = RELOAD_TYPE_CORE,
		["core"] = RELOAD_TYPE_CORE,
		["lib"] = RELOAD_TYPE_CORE,
		["libs"] = RELOAD_TYPE_CORE,

		["imbuements"] = RELOAD_TYPE_IMBUEMENTS,

		["talkaction"] = RELOAD_TYPE_TALKACTION,
		["talkactions"] = RELOAD_TYPE_TALKACTION,
		["talk"] = RELOAD_TYPE_TALKACTION,
		["commands"] = RELOAD_TYPE_TALKACTION
	}

	if notAccountTypeGod(self) then
		return true
	end

	if not configManager.getBoolean(configKeys.ALLOW_RELOAD) then
		self:sendCancelMessage("Reload command is disabled.")
		return true
	end

	if param == "" then
		self:sendCancelMessage("Command param required.")
		return false
	end

	logCommand(self, words, param)

	local reloadType = reloadTypes[param:lower()]
	if reloadType then
		Game.reload(reloadType)
		self:sendTextMessage(MESSAGE_LOOK, string.format("Reloaded %s.", param:lower()))
		Spdlog.info("Reloaded " .. param:lower() .. "")
		return true
	elseif not reloadType then
		self:sendCancelMessage("Reload type not found.")
		Spdlog.warn("[reload.onSay] - Reload type '".. param.. "' not found")
		return false
	end
	return false
end
