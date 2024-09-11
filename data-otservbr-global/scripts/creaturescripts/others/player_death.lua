local deathListEnabled = true

local playerDeath = CreatureEvent("PlayerDeath")
function playerDeath.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if player:getStorageValue(Storage.Quest.U8_0.BarbarianArena.PitDoor) > 0 then
		player:setStorageValue(Storage.Quest.U8_0.BarbarianArena.PitDoor, 0)
	end

	if not deathListEnabled then
		return
	end

	local byPlayer = 0
	local killerName
	if killer ~= nil then
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

	local byPlayerMostDamage = 0
	local mostDamageKillerName
	if mostDamageKiller ~= nil then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamageKiller:isMonster() and mostDamageKiller:getType():getNameDescription() or mostDamageKiller:getName()
	else
		mostDamageName = "field item"
	end

	player:takeScreenshot(byPlayer and SCREENSHOT_TYPE_DEATHPVP or SCREENSHOT_TYPE_DEATHPVE)

	if mostDamageKiller and mostDamageKiller:isPlayer() then
		mostDamageKiller:takeScreenshot(SCREENSHOT_TYPE_PLAYERKILL)
	end

	local playerGuid = player:getGuid()
	db.query(
		"INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES ("
			.. playerGuid
			.. ", "
			.. os.time()
			.. ", "
			.. player:getLevel()
			.. ", "
			.. db.escapeString(killerName)
			.. ", "
			.. byPlayer
			.. ", "
			.. db.escapeString(mostDamageName)
			.. ", "
			.. byPlayerMostDamage
			.. ", "
			.. (unjustified and 1 or 0)
			.. ", "
			.. (mostDamageUnjustified and 1 or 0)
			.. ")"
	)
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)
	-- Start Webhook Player Death
	Webhook.sendMessage(":skull_crossbones: " .. player:getMarkdownLink() .. " has died. Killed at level _" .. player:getLevel() .. "_ by **" .. killerName .. "**.", announcementChannels["player-kills"])
	-- End Webhook Player Death

	local deathRecords = 0
	local tmpResultId = resultId
	while tmpResultId ~= false do
		tmpResultId = Result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then
		Result.free(resultId)
	end

	if byPlayer == 1 then
		killer:takeScreenshot(SCREENSHOT_TYPE_PLAYERKILL)
		local targetGuild = player:getGuild()
		local targetGuildId = targetGuild and targetGuild:getId() or 0
		if targetGuildId ~= 0 then
			local killerGuild = killer:getGuild()
			local killerGuildId = killerGuild and killerGuild:getId() or 0
			if killerGuildId ~= 0 and targetGuildId ~= killerGuildId and isInWar(player:getId(), killer:getId()) then
				local warId = false
				resultId = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND \z
					((`guild1` = " .. killerGuildId .. " AND `guild2` = " .. targetGuildId .. ") OR \z
					(`guild1` = " .. targetGuildId .. " AND `guild2` = " .. killerGuildId .. "))")
				if resultId then
					warId = Result.getNumber(resultId, "id")
					Result.free(resultId)
				end

				if warId then
					local playerName = player:getName()
					db.asyncQuery("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) \z
						VALUES (" .. db.escapeString(killerName) .. ", " .. db.escapeString(playerName) .. ", " .. killerGuildId .. ", \z
						" .. targetGuildId .. ", " .. os.time() .. ", " .. warId .. ")")

					resultId = db.storeQuery("SELECT `guild_wars`.`id`, `guild_wars`.`frags_limit`, (SELECT COUNT(1) FROM `guildwar_kills` \z
						WHERE `guildwar_kills`.`warid` = `guild_wars`.`id` AND `guildwar_kills`.`killerguild` = `guild_wars`.`guild1`) AS guild1_kills, \z
						(SELECT COUNT(1) FROM `guildwar_kills` WHERE `guildwar_kills`.`warid` = `guild_wars`.`id` AND `guildwar_kills`.`killerguild` = `guild_wars`.`guild2`) AS guild2_kills \z
						FROM `guild_wars` WHERE (`guild1` = " .. killerGuildId .. " OR `guild2` = " .. killerGuildId .. ") AND `status` = 1 AND `id` = " .. warId)

					if resultId then
						local guild1_kills = Result.getNumber(resultId, "guild1_kills")
						local guild2_kills = Result.getNumber(resultId, "guild2_kills")
						local frags_limit = Result.getNumber(resultId, "frags_limit")
						Result.free(resultId)

						local members = killerGuild:getMembersOnline()
						for i = 1, #members do
							members[i]:sendChannelMessage(members[i], string.format("%s was killed by %s. The new score is: %s %d:%d %s (frags limit: %d)", playerName, killerName, targetGuild:getName(), guild1_kills, guild2_kills, killerGuild:getName(), frags_limit), TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
						end

						local enemyMembers = targetGuild:getMembersOnline()
						for i = 1, #enemyMembers do
							enemyMembers[i]:sendChannelMessage(enemyMembers[i], string.format("%s was killed by %s. The new score is: %s %d:%d %s (frags limit: %d)", playerName, killerName, targetGuild:getName(), guild1_kills, guild2_kills, killerGuild:getName(), frags_limit), TALKTYPE_CHANNEL_R1, CHANNEL_GUILD)
						end

						if guild1_kills >= frags_limit or guild2_kills >= frags_limit then
							db.query("UPDATE `guild_wars` SET `status` = 4, `ended` = " .. os.time() .. " WHERE `status` = 1 AND `id` = " .. warId)
							Game.broadcastMessage(string.format("%s has just won the war against %s.", killerGuild:getName(), targetGuild:getName()))
						end
					end
				end
			end
		end
	end
end

playerDeath:register()
