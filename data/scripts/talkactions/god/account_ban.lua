local accountBanDays = 0  -- 0 para bans permanentes

local accountBan = TalkAction("/accban")

function accountBan.onSay(player, words, param)
	-- crear log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	-- Obtener el account_id del jugador usando su nombre
	local resultId = db.storeQuery("SELECT `account_id`, `name` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local targetAccountId = Result.getNumber(resultId, "account_id")
	local targetName = Result.getString(resultId, "name")
	Result.free(resultId)

	-- Comprobar si la cuenta ya está baneada
	resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. targetAccountId)
	if resultId ~= false then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Account of " .. targetName .. " is already banned.")
		Result.free(resultId)
		return true
	end

	-- Obtener la hora actual
	local timeNow = os.time()

	-- Realizar el ban a la cuenta, estableciendo 'expires_at' en 0 para un ban permanente
	db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. targetAccountId .. ", '', " .. timeNow .. ", 0, " .. player:getGuid() .. ")")
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Account of " .. targetName .. " has been banned permanently.")
	return true
end

accountBan:separator(" ")
accountBan:groupType("god")
accountBan:register()
