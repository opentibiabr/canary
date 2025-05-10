local deathListEnabled = true

local function getKillerInfo(killer)
	local byPlayer = 0
	local killerName

	if killer then
		if killer:isPlayer() then
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killer = master
				byPlayer = 1
			end
		end

		killerName = killer:isMonster() and killer:getType():getNameDescription() or killer:getName()
	else
		killerName = "field item"
	end

	return killerName, byPlayer
end

local function getMostDamageInfo(mostDamageKiller)
	local byPlayerMostDamage = 0
	local mostDamageKillerName

	if mostDamageKiller then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end

		mostDamageKillerName = mostDamageKiller:isMonster() and mostDamageKiller:getType():getNameDescription() or mostDamageKiller:getName()
	else
		mostDamageKillerName = "field item"
	end

	return mostDamageKillerName, byPlayerMostDamage
end

local function serializeParticipants(participants)
	if not participants or #participants == 0 then
		return ""
	end

	local result = {}
	for _, participant in ipairs(participants) do
		local entry = string.format("Name: %s\nType: %s", participant.name, participant.type)
		result[#result + 1] = entry
	end
	return table.concat(result, "\n\n")
end

local function saveDeathRecord(playerGuid, player, killerName, byPlayer, mostDamageName, byPlayerMostDamage, unjustified, mostDamageUnjustified, participants)
	local participantsString = serializeParticipants(participants)
	local query = string.format(
		"INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`, `participants`) " .. "VALUES (%d, %d, %d, %s, %d, %s, %d, %d, %d, %s)",
		playerGuid,
		os.time(),
		player:getLevel(),
		db.escapeString(killerName),
		byPlayer,
		db.escapeString(mostDamageName),
		byPlayerMostDamage,
		unjustified and 1 or 0,
		mostDamageUnjustified and 1 or 0,
		db.escapeString(participantsString)
	)
	db.query(query)
end

local function getDeathRecords(playerGuid)
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)
	local deathRecords = 0
	while resultId do
		resultId = Result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId then
		Result.free(resultId)
	end

	return deathRecords
end

local function handleGuildWar(player, killer, mostDamageKiller, killerName, mostDamageName)
	if not player or not killer or not killer:isPlayer() or not player:getGuild() or not killer:getGuild() then
		return
	end

	local playerGuildId = player:getGuild():getId()
	local killerGuildId = killer:getGuild():getId()

	if playerGuildId == killerGuildId then
		return
	end

	if getDeathRecords(player:getGuid()) > 0 then
		local warId = checkForGuildWar(playerGuildId, killerGuildId)
		if warId then
			recordGuildWarKill(killer, player, killerGuildId, playerGuildId, warId)
			checkAndUpdateGuildWarScore(warId, playerGuildId, killerGuildId, player:getName(), killerName, mostDamageName)
		end
	end
end

local function checkForGuildWar(targetGuildId, killerGuildId)
	local resultId = db.storeQuery(string.format("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND ((`guild1` = %d AND `guild2` = %d) OR (`guild1` = %d AND `guild2` = %d))", killerGuildId, targetGuildId, targetGuildId, killerGuildId))

	local warId = false
	if resultId then
		warId = Result.getNumber(resultId, "id")
		Result.free(resultId)
	end

	return warId
end

local function recordGuildWarKill(killer, player, killerGuildId, targetGuildId, warId)
	local playerName = player:getName()
	db.asyncQuery(string.format("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) VALUES ('%s', '%s', %d, %d, %d, %d)", db.escapeString(killer:getName()), db.escapeString(playerName), killerGuildId, targetGuildId, os.time(), warId))
end

local function checkAndUpdateGuildWarScore(warId, targetGuildId, killerGuildId, playerName, killerName, mostDamageName)
	local resultId = db.storeQuery(
		string.format(
			"SELECT `guild_wars`.`id`, `guild_wars`.`frags_limit`, "
				.. "(SELECT COUNT(1) FROM `guildwar_kills` WHERE `guildwar_kills`.`warid` = `guild_wars`.`id` AND `guildwar_kills`.`killerguild` = `guild_wars`.`guild1`) AS guild1_kills, "
				.. "(SELECT COUNT(1) FROM `guildwar_kills` WHERE `guildwar_kills`.`warid` = `guild_wars`.`id` AND `guildwar_kills`.`killerguild` = `guild_wars`.`guild2`) AS guild2_kills "
				.. "FROM `guild_wars` WHERE (`guild1` = %d OR `guild2` = %d) AND `status` = 1 AND `id` = %d",
			killerGuildId,
			targetGuildId,
			warId
		)
	)

	if resultId then
		local guild1Kills = Result.getNumber(resultId, "guild1_kills")
		local guild2Kills = Result.getNumber(resultId, "guild2_kills")
		local fragsLimit = Result.getNumber(resultId, "frags_limit")
		Result.free(resultId)

		local killerGuild = killer:getGuild()
		local targetGuild = player:getGuild()

		updateGuildWarScore(killerGuild, targetGuild, playerName, killerName, guild1Kills, guild2Kills, fragsLimit)
		endGuildWarIfLimitReached(guild1Kills, guild2Kills, fragsLimit, warId, killerGuild, targetGuild)
	end
end

local function updateGuildWarScore(killerGuild, targetGuild, playerName, killerName, guild1Kills, guild2Kills, fragsLimit)
	local members = killerGuild:getMembersOnline()
	for _, member in ipairs(members) do
		member:sendChannelMessage(member, string.format("%s was killed by %s. The new score is: %s %d:%d %s (frags limit: %d)", playerName, killerName, targetGuild:getName(), guild1Kills, guild2Kills, killerGuild:getName(), fragsLimit), TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
	end

	local enemyMembers = targetGuild:getMembersOnline()
	for _, enemy in ipairs(enemyMembers) do
		enemy:sendChannelMessage(enemy, string.format("%s was killed by %s. The new score is: %s %d:%d %s (frags limit: %d)", playerName, killerName, targetGuild:getName(), guild1Kills, guild2Kills, killerGuild:getName(), fragsLimit), TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
	end
end

local function endGuildWarIfLimitReached(guild1Kills, guild2Kills, fragsLimit, warId, killerGuild, targetGuild)
	if guild1Kills >= fragsLimit or guild2Kills >= fragsLimit then
		db.query(string.format("UPDATE `guild_wars` SET `status` = 4, `ended` = %d WHERE `status` = 1 AND `id` = %d", os.time(), warId))
		Game.broadcastMessage(string.format("%s has just won the war against %s.", killerGuild:getName(), targetGuild:getName()))
	end
end

local playerDeath = CreatureEvent("PlayerDeath")

function playerDeath.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if not deathListEnabled then
		return
	end

	local killers = player:getKillers(false)
	local participants = {}
	for _, entry in ipairs(killers) do
		local name = entry:isMonster() and entry:getType():getNameDescription() or entry:getName()
		local type = entry:isPlayer() and "player" or "monster"
		participants[#participants + 1] = { name = name, type = type }
	end

	local killerName, byPlayer = getKillerInfo(killer)
	local mostDamageName, byPlayerMostDamage = getMostDamageInfo(mostDamageKiller)

	player:takeScreenshot(byPlayer and SCREENSHOT_TYPE_DEATHPVP or SCREENSHOT_TYPE_DEATHPVE)

	if mostDamageKiller and mostDamageKiller:isPlayer() then
		mostDamageKiller:takeScreenshot(SCREENSHOT_TYPE_PLAYERKILL)
	end

	local playerGuid = player:getGuid()
	saveDeathRecord(playerGuid, player, killerName, byPlayer, mostDamageName, byPlayerMostDamage, unjustified, mostDamageUnjustified, participants)

	Webhook.sendMessage(":skull_crossbones: " .. player:getMarkdownLink() .. " has died. Killed at level _" .. player:getLevel() .. "_ by **" .. killerName .. "**.", announcementChannels["player-kills"])
	handleGuildWar(player, killer, mostDamageKiller, killerName, mostDamageName)
end

playerDeath:register()
