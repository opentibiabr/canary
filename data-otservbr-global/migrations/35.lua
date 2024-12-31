function onUpdateDatabase()
	logger.info("Updating database to version 35 (fix account premdays and lastday)")

	local resultQuery = db.storeQuery("SELECT `id`, `premdays`, `lastday` FROM `accounts` WHERE (`premdays` > 0 OR `lastday` > 0) AND `lastday` <= " .. os.time())
	if resultQuery ~= false then
		repeat
			local id = Result.getNumber(resultQuery, "id")
			local premDays = Result.getNumber(resultQuery, "premdays")
			local lastDay = Result.getNumber(resultQuery, "lastday")
			local result = getNewValue(premDays, lastDay)
			db.query("UPDATE `accounts` SET `premdays` = " .. result.premDays .. ", `lastday` = " .. result.lastDay .. " WHERE `id` = " .. id)
		until not Result.next(resultQuery)
		Result.free(resultQuery)
	end
end

function getNewValue(premDays, lastDay)
	local now = os.time()
	local data = {}
	data.premDays = 0
	data.lastDay = 0

	if lastDay <= now and premDays > 0 then
		local timeLeft = lastDay + (premDays * 86400)
		if timeLeft > now then
			data.premDays = math.floor((now - lastDay) / 86400)
			data.lastDay = lastDay + (premDays * 86400)
		end
	end

	return data
end
