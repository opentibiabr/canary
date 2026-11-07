-- Import legacy Cyclopedia SQL into the existing protobuf KV store. Source
-- tables remain untouched for rollback; no gameplay code writes them afterward.
local function checked(query)
	if not db.query(query) then
		error("Cyclopedia KV migration query failed")
	end
end

local function uint(row, field, maximum)
	-- Result.getString preserves BIGINT precision beyond Lua's exact integer range.
	local value = Result.getString(row, field)
	if not value or not value:match("^%d+$") then
		error("Invalid legacy Cyclopedia field: " .. field)
	end
	value = value:gsub("^0+", "")
	value = value == "" and "0" or value
	maximum = maximum or "9223372036854775807"
	if #value > #maximum or (#value == #maximum and value > maximum) then
		error("Legacy Cyclopedia value exceeds supported range: " .. field)
	end
	return value
end

local function count(query)
	local row = db.storeQuery(query)
	if not row then
		error("Could not count legacy Cyclopedia rows")
	end
	local value = tonumber(uint(row, "count", "1000000"))
	Result.free(row)
	return value
end

local function rows(tableName, query, callback)
	if not db.tableExists(tableName) then
		return
	end
	if count("SELECT COUNT(*) AS `count` FROM `" .. tableName .. "` WHERE `world_id` <> 0") ~= 0 then
		error("This upstream migration supports world 0 only. Keep the multiworld database on its matching server.")
	end
	if count("SELECT COUNT(*) AS `count` FROM `" .. tableName .. "`") == 0 then
		return
	end
	local result = db.storeQuery(query)
	if not result then
		error("Could not read legacy Cyclopedia table: " .. tableName)
	end
	repeat
		callback(result)
	until not Result.next(result)
	Result.free(result)
end

local function store(key, value)
	if #key > 191 or #value > 262144 then
		error("Cyclopedia KV import exceeds snapshot bounds")
	end
	-- kv.proto ValueWrapper.str_value: tag 1, wire type 2, varint byte length.
	local length, size = #value, {}
	repeat
		local byte = length % 128
		length = math.floor(length / 128)
		size[#size + 1] = string.char(byte + (length > 0 and 128 or 0))
	until length == 0
	local protobuf = string.char(10) .. table.concat(size) .. value
	-- Existing snapshots win on retries. The final marker makes completion
	-- idempotent without replacing any live KV progress after the first import.
	checked("INSERT IGNORE INTO `kv_store` (`key_name`,`timestamp`,`value`) VALUES (" .. db.escapeString(key) .. ",UNIX_TIMESTAMP()*1000," .. db.escapeBlob(protobuf, #protobuf) .. ")")
	local verified = db.storeQuery("SELECT `key_name` FROM `kv_store` WHERE `key_name`=" .. db.escapeString(key) .. " AND `value`=" .. db.escapeBlob(protobuf, #protobuf))
	if not verified then
		error("Conflicting or unreadable existing Cyclopedia KV snapshot: " .. key)
	end
	Result.free(verified)
end

local function pointArray(points)
	local compact = points:gsub("%s", "")
	local rebuilt, seen = {}, {}
	for x, y, z, state in compact:gmatch("%[(%d+),(%d+),(%d+),(%d+)%]") do
		if #x > 5 or #y > 5 or #z > 2 or #state ~= 1 or tonumber(x) > 65535 or tonumber(y) > 65535 or tonumber(z) > 15 or tonumber(state) > 2 then
			error("Invalid legacy discovery point")
		end
		local position = x .. "," .. y .. "," .. z
		if seen[position] then
			error("Duplicate legacy discovery point")
		end
		seen[position] = true
		rebuilt[#rebuilt + 1] = "[" .. position .. "," .. state .. "]"
	end
	if #rebuilt ~= 5 or "[" .. table.concat(rebuilt, ",") .. "]" ~= compact then
		error("Legacy discovery must contain exactly five valid points")
	end
	return compact
end

function onUpdateDatabase()
	if not db.tableExists("kv_store") then
		error("Existing kv_store table is required for the Cyclopedia migration")
	end
	local completed = db.storeQuery("SELECT `value` FROM `kv_store` WHERE `key_name`='cyclopedia.atomic.migration-v1'")
	if completed then
		local version = Result.getString(completed, "value")
		Result.free(completed)
		if version ~= string.char(10, 1) .. "1" then
			error("Invalid Cyclopedia KV migration marker")
		end
		return true
	end
	checked("START TRANSACTION")
	local ok, message = pcall(function()
		local areas, seenDonationAreas, cycle = {}, {}, "0"
		rows("cyclopedia_donations", "SELECT `area_id`,`amount`,`active` FROM `cyclopedia_donations` WHERE `world_id`=0 ORDER BY `area_id`", function(row)
			local id = uint(row, "area_id", "65535")
			if id == "0" or seenDonationAreas[id] then
				error("Invalid or duplicate legacy donation area")
			end
			seenDonationAreas[id] = true
			local amount = uint(row, "amount")
			local active = uint(row, "active", "1") == "1" and "true" or "false"
			areas[#areas + 1] = '"' .. id .. '":{"amount":' .. amount .. ',"active":' .. active .. "}"
			if #areas > 255 then
				error("Too many legacy donation areas")
			end
		end)
		rows("cyclopedia_donation_cycles", "SELECT `last_day` FROM `cyclopedia_donation_cycles` WHERE `world_id`=0", function(row)
			cycle = uint(row, "last_day")
		end)
		store("cyclopedia.atomic.donations", '{"version":1,"last_day":' .. cycle .. ',"areas":{' .. table.concat(areas, ",") .. "}}")
		rows("cyclopedia_donation_log", "SELECT `id`,`player_id`,`area_id`,`amount`,UNIX_TIMESTAMP(`created_at`) AS `created_at` FROM `cyclopedia_donation_log` WHERE `world_id`=0 ORDER BY `id`", function(row)
			store("cyclopedia.atomic.audit.legacy." .. uint(row, "id"), '{"player_id":' .. uint(row, "player_id", "4294967295") .. ',"area_id":' .. uint(row, "area_id", "65535") .. ',"amount":' .. uint(row, "amount", "4294967295") .. ',"created_at":' .. uint(row, "created_at") .. "}")
		end)
		local player, active, discovered, seenAreas, total = nil, "0", {}, {}, 0
		local function flush()
			if player then
				store("cyclopedia.atomic.discovery." .. player, '{"version":1,"active":' .. active .. ',"areas":{' .. table.concat(discovered, ",") .. "}}")
			end
		end
		rows("cyclopedia_discovery", "SELECT `player_id`,`area_id`,`active`,`points` FROM `cyclopedia_discovery` WHERE `world_id`=0 ORDER BY `player_id`,`area_id`", function(row)
			local id = uint(row, "player_id", "4294967295")
			if id ~= player then
				flush()
				player, active, discovered, seenAreas, total = id, "0", {}, {}, 0
			end
			local area = uint(row, "area_id", "65535")
			if id == "0" or area == "0" or seenAreas[area] then
				error("Invalid or duplicate legacy discovery area/character")
			end
			seenAreas[area] = true
			if uint(row, "active", "1") == "1" then
				if active ~= "0" or area == "0" then
					error("Invalid active legacy discovery area")
				end
				active = area
			end
			total = total + 1
			if total > 512 then
				error("Too many legacy discovery areas for a character")
			end
			discovered[#discovered + 1] = '"' .. area .. '":' .. pointArray(Result.getString(row, "points"))
		end)
		flush()
		store("cyclopedia.atomic.migration-v1", "1")
		checked("COMMIT")
	end)
	if not ok then
		db.query("ROLLBACK")
		error(message)
	end
	logger.info("Cyclopedia legacy SQL imported into protobuf KV; source tables preserved")
	return true
end
