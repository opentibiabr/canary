local ipBanDays = 0

local ipBan = TalkAction("/ipban")

function ipBan.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Verificar si el parámetro está vacío
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	-- Escapar el parámetro del jugador y consultar la base de datos
	local resultId = db.storeQuery("SELECT `name`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if not resultId then
		player:sendCancelMessage("Player not found.")
		return true
	end

	-- Obtener el nombre y la IP del jugador
	local targetName = Result.getString(resultId, "name")
	local targetIp = Result.getNumber(resultId, "lastip")
	Result.free(resultId)

	-- Si el jugador está en línea, obtener su IP en tiempo real
	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		targetPlayer:remove()  -- Desconectar al jugador
	end

	-- Verificar si se obtuvo la IP
	if targetIp == 0 then
		player:sendCancelMessage("Failed to retrieve IP address.")
		return true
	end

	-- Verificar si la IP ya está baneada
	resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. targetIp)
	if resultId then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, targetName .. " is already IP banned.")
		Result.free(resultId)
		return true
	end

	-- Insertar el baneo en la tabla `ip_bans`
	local timeNow = os.time()
	local query = string.format(
		"INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (%d, '', %d, %d, %d)",
		targetIp, timeNow, timeNow + (ipBanDays * 86400), player:getGuid()
	)

	db.query(query)
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, targetName .. " has been IP banned.")
	return true
end

ipBan:separator(" ")
ipBan:groupType("god")
ipBan:register()
