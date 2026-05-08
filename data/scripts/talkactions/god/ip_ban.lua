local ipBanDays = 7

local ipBan = TalkAction("/ipban")

local function getLegacyIpAddressExpression(columnName)
	return "CONCAT((`" .. columnName .. "` & 255), '.', ((`" .. columnName .. "` >> 8) & 255), '.', ((`" .. columnName .. "` >> 16) & 255), '.', ((`" .. columnName .. "` >> 24) & 255))"
end

local function getIpFamily(ipAddress)
	return ipAddress:find(":", 1, true) and 6 or 4
end

function ipBan.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local query = "SELECT `name`, `lastip`, CASE WHEN `lastip_address` != '' THEN `lastip_address` WHEN `lastip` != 0 THEN " .. getLegacyIpAddressExpression("lastip") .. " ELSE '' END AS `lastip_address` FROM `players` WHERE `name` = " .. db.escapeString(param)
	local resultId = db.storeQuery(query)
	if resultId == false then
		return true
	end

	local targetName = Result.getString(resultId, "name")
	local targetIp = Result.getNumber(resultId, "lastip")
	local targetIpAddress = Result.getString(resultId, "lastip_address")
	Result.free(resultId)

	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		targetIpAddress = targetPlayer:getIpAddress() or targetPlayer:getIpString()
		targetPlayer:remove()
	end

	if targetIpAddress == nil or targetIpAddress == "" then
		return true
	end

	local targetIpFamily = getIpFamily(targetIpAddress)
	resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip_family` = " .. targetIpFamily .. " AND `ip_address` = " .. db.escapeString(targetIpAddress))
	if resultId ~= false then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, targetName .. " is already IP banned.")
		Result.free(resultId)
		return true
	end

	local timeNow = os.time()
	db.query("INSERT INTO `ip_bans` (`ip`, `ip_address`, `ip_family`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. targetIp .. ", " .. db.escapeString(targetIpAddress) .. ", " .. targetIpFamily .. ", '', " .. timeNow .. ", " .. timeNow + (ipBanDays * 86400) .. ", " .. player:getGuid() .. ")")
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, targetName .. " has been IP banned.")
	return true
end

ipBan:separator(" ")
ipBan:groupType("god")
ipBan:register()
