-- Unused function
function PushValues(buffer, sep, ...)
	local argv = {...}
	local argc = #argv
	for k, v in ipairs(argv) do
		table.insert(buffer, v)
		if k < argc and sep then
			table.insert(buffer, sep)
		end
	end
end

function PushSeparated(buffer, sep, ...)
	local argv = {...}
	local argc = #argv
	for k, v in ipairs(argv) do
		table.insert(buffer, v)
		if k < argc and sep then
			table.insert(buffer, sep)
		end
	end
end

function InsertItems(buffer, info, parent, items)
	local start = info.running
	for _, item in ipairs(items) do
		if item ~= nil then
			if item:getId() == ITEM_REWARD_CONTAINER then
				table.insert(buffer, "(")
				PushSeparated(buffer, ",", info.playerGuid, 0, parent, item:getId(), item:getSubType(), db.escapeString(item:serializeAttributes()))
				table.insert(buffer, "),")
			else
				info.running = info.running + 1
				table.insert(buffer, "(")
				PushSeparated(buffer, ",", info.playerGuid, parent, info.running, item:getId(), item:getSubType(), db.escapeString(item:serializeAttributes()))
				table.insert(buffer, "),")
			end

			if item:isContainer() then
				local size = item:getSize()
				if size > 0 then
					local subItems = {}
					for i = 1, size do
						table.insert(subItems, item:getItem(i - 1))
					end

					InsertItems(buffer, info, info.running, subItems)
				end
			end
		end
	end
	return info.running - start
end

function InsertRewardItems(playerGuid, timestamp, itemList)
	local maxSidQueryResult = db.query('select max(`sid`) as max_sid from `player_rewards` where player_id = '..playerGuid..';')
	local bagSid = (Result.getDataInt(maxSidQueryResult, 'max_sid') or 0) + 1;
	local nextSid = bagSid + 1;
	local buffer = {'INSERT INTO `player_rewards` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES'}
	local info = {
		playerGuid = playerGuid,
		running = nextSid
	}
	local bag = Game.createItem(ITEM_REWARD_CONTAINER)
	bag:setAttribute(ITEM_ATTRIBUTE_DATE, timestamp)
	if itemList then
		for _, p in ipairs(itemList) do
			bag:addItem(p[1], p[2])
		end
	end
	local total = InsertItems(buffer, info, bagSid, {bag})

	if total ~= 0 then
		local insertItemsQuery = table.concat(buffer):sub(1, -2)..";";
		db.query(insertItemsQuery)
	end
end

function GetPlayerStats(bossId, playerGuid, autocreate)
	local ret = GlobalBosses[bossId][playerGuid]
	if not ret and autocreate then
		ret = {
			bossId = bossId,
			damageIn = 0, -- damage taken from the boss
			healing = 0, -- healing (other players) done
		}
		GlobalBosses[bossId][playerGuid] = ret
		return ret
	end
	return ret
end

function ResetAndSetTargetList(creature)
	if not creature then
		return
	end

	local bossId = creature:getId()
	local info = GlobalBosses[bossId]
	-- Reset all players' status
	for _, player in pairs(info) do
		player.active = false
	end
	-- Set all players in boss' target list as active in the fight
	local targets = creature:getTargetList()
	for _, target in ipairs(targets) do
		if target:isPlayer() then
			local stats = GetPlayerStats(bossId, target:getGuid(), true)
			stats.playerId = target:getId() -- Update player id
			stats.active = true
		end
	end
end
