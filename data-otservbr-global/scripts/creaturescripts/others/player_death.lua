local deathListEnabled = true
local maxDeathRecords = false

local playerDeath = CreatureEvent("PlayerDeath")

function playerDeath.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if player:getStorageValue(Storage.SvargrondArena.PitDoor) > 0 then
		player:setStorageValue(Storage.SvargrondArena.PitDoor, 0)
	end

	if not deathListEnabled then
		return
	end

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
		mostDamageName = mostDamageKiller:isMonster() and mostDamageKiller:getType():getNameDescription() or mostDamageKiller:getName()
	else
		mostDamageName = "field item"
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

	-- Start Webhook Player Death
	Webhook.sendMessage(":skull_crossbones: " .. player:getMarkdownLink() .. " has died. Killed at level _" .. player:getLevel() .. "_ by **" .. killerName .. "**.", announcementChannels["player-kills"])
	-- End Webhook Player Death

	if maxDeathRecords then
		local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)

		local deathRecords = 0
		local tmpResultId = resultId
		while tmpResultId do
			tmpResultId = Result.next(resultId)
			deathRecords = deathRecords + 1
		end

		if resultId then
			Result.free(resultId)
		end

		local limit = deathRecords - maxDeathRecords
		if limit > 0 then
			db.asyncQuery("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGuid .. " ORDER BY `time` LIMIT " .. limit)
		end
	end

	if byPlayer == 1 then
		local targetGuild = player:getGuild()
		targetGuild = targetGuild and targetGuild:getId() or 0
		if targetGuild ~= 0 then
			local killerGuild = killer:getGuild()
			killerGuild = killerGuild and killerGuild:getId() or 0
			if killerGuild ~= 0 and targetGuild ~= killerGuild and isInWar(player:getId(), killer:getId()) then
				local warId = false
				local resultId = db.storeQuery("SELECT `id` FROM `guild_wars` WHERE `status` = 1 AND \z
					((`guild1` = " .. killerGuild .. " AND `guild2` = " .. targetGuild .. ") OR \z
					(`guild1` = " .. targetGuild .. " AND `guild2` = " .. killerGuild .. "))")
				if resultId then
					warId = Result.getNumber(resultId, "id")
					Result.free(resultId)
				end

				if warId then
					db.asyncQuery("INSERT INTO `guildwar_kills` (`killer`, `target`, `killerguild`, `targetguild`, `time`, `warid`) \z
						VALUES (" .. db.escapeString(killerName) .. ", " .. db.escapeString(player:getName()) .. ", " .. killerGuild .. ", \z
						" .. targetGuild .. ", " .. os.time() .. ", " .. warId .. ")")
				end
			end
		end
	end
end

playerDeath:register()
