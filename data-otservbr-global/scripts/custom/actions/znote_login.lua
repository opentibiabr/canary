-- Znote LoginWebService (version 1) for protocol 11, 12+
-- Move file to this location: data/scripts/znote_login.lua
-- And restart OT server, it should auto load script.
-- Requires updated version of Znote AAC. (18. June 2020)
-- This script will help Znote AAC connect players to this game server.

local znote_loginWebService = GlobalEvent("znote_loginWebService")
function znote_loginWebService.onStartup()
	print("=============================")
	print("= Server Login Service =")
	print("=============================")
    local configLua = {
        ["SERVER_NAME"] = configManager.getString(configKeys.SERVER_NAME),
        ["IP"] = configManager.getString(configKeys.IP),
        ["GAME_PORT"] = configManager.getNumber(configKeys.GAME_PORT)
    }
    local configSQL = {
        ["SERVER_NAME"] = false,
        ["IP"] = false,
        ["GAME_PORT"] = false
    }
    local webStorage = db.storeQuery([[
		SELECT
			`key`,
            `value`
		FROM `znote_global_storage`
		WHERE `key` IN('SERVER_NAME', 'IP', 'GAME_PORT')
	]])
	if webStorage ~= false then
		repeat
			local key = result.getString(webStorage, 'key')
			local value = result.getString(webStorage, 'value')
            configSQL[key] = value
		until not result.next(webStorage)
		result.free(webStorage)
    end
    local inserts = {}
    if configSQL.SERVER_NAME == false then
        table.insert(inserts, "('SERVER_NAME',".. db.escapeString(configLua.SERVER_NAME) ..")")
    elseif configSQL.SERVER_NAME ~= configLua.SERVER_NAME then
        db.query("UPDATE `znote_global_storage` SET `value`=".. db.escapeString(configLua.SERVER_NAME) .." WHERE `key`='SERVER_NAME';")
        print("= Updated [SERVER_NAME] FROM [" .. configSQL.SERVER_NAME .. "] to [" .. configLua.SERVER_NAME .. "]")
    end
    if configSQL.IP == false then
        table.insert(inserts, "('IP',".. db.escapeString(configLua.IP) ..")")
    elseif configSQL.IP ~= configLua.IP then
        db.query("UPDATE `znote_global_storage` SET `value`=".. db.escapeString(configLua.IP) .." WHERE `key`='IP';")
        print("= Updated [IP] FROM [" .. configSQL.IP .. "] to [" .. configLua.IP .. "]")
    end
    if configSQL.GAME_PORT == false then
        table.insert(inserts, "('GAME_PORT',".. db.escapeString(configLua.GAME_PORT) ..")")
    elseif configSQL.GAME_PORT ~= tostring(configLua.GAME_PORT) then
        db.query("UPDATE `znote_global_storage` SET `value`=".. db.escapeString(configLua.GAME_PORT) .." WHERE `key`='GAME_PORT';")
        print("= Updated [GAME_PORT] FROM [" .. configSQL.GAME_PORT .. "] to [" .. configLua.GAME_PORT .. "]")
    end
    if #inserts > 0 then
        db.query("INSERT INTO `znote_global_storage` (`key`,`value`) VALUES "..table.concat(inserts,',')..";")
        print("= Fixed " .. #inserts .. " missing configurations.")
    end
    print("= SERVER_NAME: " .. configLua.SERVER_NAME)
    print("= IP: " .. configLua.IP)
    print("= GAME_PORT: " .. configLua.GAME_PORT)
    print("=============================")
end
znote_loginWebService:register()
