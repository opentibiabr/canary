Migration = {
	registry = {},
}

setmetatable(Migration, {
	---@param self Migration
	__call = function(self, name)
		return setmetatable({
			name = name,
			executed = KV.scoped("migrations"):get(name) or false,
		}, { __index = Migration })
	end,
})

function Migration:forEachPlayer(callback, main)
	local rows = db.storeQuery("SELECT `id` FROM `players`")
	if rows then
		repeat
			local playerId = Result.getNumber(rows, "id")
			local player = Game.getOfflinePlayer(playerId)
			if player then
				callback(player)
				player:save()
			end
		until not Result.next(rows)
		Result.free(rows)
	end
end

function Migration:execute()
	if self.executed then
		return
	end

	if self.onExecute then
		self:onExecute()
	end

	self.executed = true
	KV.scoped("migrations"):set(self.name, true)
end

function Migration:register()
	if self.executed then
		return
	end
	if not self:_validateName() then
		logger.error("Invalid migration name: " .. self.name .. ". Migration names must be in the format: <timestamp>_<description>. Example: 20231128213149_add_new_monsters")
	end

	table.insert(Migration.registry, self)
end

function Migration:_validateName()
	local timestampString = string.match(self.name, "^(%d+)_")

	if not timestampString or #timestampString ~= 14 then
		return false
	end

	local year, month, day, hour, min, sec = timestampString:match("(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)")
	local timestamp = os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec) })

	local minTimestamp = os.time({ year = 2023, month = 11, day = 28, hour = 0, min = 0, sec = 0 })

	if timestamp < minTimestamp then
		return false
	end

	return true
end

local serverstartup = GlobalEvent("GameMigrations")
function serverstartup.onStartup()
	if #Migration.registry > 0 then
		table.sort(Migration.registry, function(a, b)
			return a.name < b.name
		end)
		logger.info("[migration] === Executing game migrations ===")
		local start = os.time()
		for _, migration in ipairs(Migration.registry) do
			logger.info("[migration] Executing game migration {}", migration.name)
			migration:execute()
		end
		logger.info("[migration] === Game migrations executed in {}s ===", os.time() - start)
	else
	end
end

serverstartup:register()
