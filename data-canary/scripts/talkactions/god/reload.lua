-- NOTE: Using this script might cause unwanted changes.
-- This script forces a reload in the entire server, this means
-- that everything that is stored in memory might stop to work
-- properly and/or completely.
--
-- This script should be used in test environments only.

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

	["rate"] = RELOAD_TYPE_GLOBAL,
	["rates"] = RELOAD_TYPE_GLOBAL,
	["stage"] = RELOAD_TYPE_GLOBAL,
	["stages"] = RELOAD_TYPE_GLOBAL,
	["global"] = RELOAD_TYPE_GLOBAL,
	["core"] = RELOAD_TYPE_GLOBAL,
	["libs"] = RELOAD_TYPE_GLOBAL,

	["imbuements"] = RELOAD_TYPE_IMBUEMENTS
}

local reload = TalkAction("/reload")

function reload.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if not configManager.getBoolean(configKeys.ALLOW_RELOAD) then
		player:sendCancelMessage("Reload command is disabled.")
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
		player:sendTextMessage(MESSAGE_LOOK, string.format("Reloaded %s.", param:lower()))
		Spdlog.info("Reloaded " .. param:lower() .. "")
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
