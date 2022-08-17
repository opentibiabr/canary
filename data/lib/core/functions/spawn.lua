---@author @Glatharth
---@version 1.0
---@since 1.0
MonsterStorage = {
	Spawn = {
		info = 550000,
		monster_spawn_object = 550001,
	}
}
Spawn = {}
SpawnMetatables = {}
setmetatable(Spawn, {
	__call = function(self)
		local spawn_data = {
			storage = {
				info = MonsterStorage.Spawn.info,
				object = MonsterStorage.Spawn.monster_spawn_object,
			},
			monsters = {},
			positions = {},
			functions = {
				["onSpawn"] = {
					["MonsterDeath"] = function(s, monster)
						monster:setStorageValue(s.storage.object, s)
						monster:registerEvent('monsterDeath')
					end
				},
				["onDeath"] = {
					["Respawn"] = function(s, monster)
						if monster:getStorageValue(s.storage.info) > 0 then
							s:spawnMonsterIndex(monster:getStorageValue(s.storage.info))
						end
					end
				}
			}
		}
		local mt = setmetatable(spawn_data, { __index = Spawn })
		table.insert(SpawnMetatables, mt)
		return mt
	end
})

-- positions - {monster = "Rat" ,pos = Position(x, y, z), spawntime = 60, status = true}
function Spawn.getPositions(self)
	return self.positions
end

function Spawn.setPositions(self, pos)
	if type(pos) ~= "table" then
		pos = { pos }
	end
	self.positions = pos
end

function Spawn.getMonsters(self)
	return self.monsters
end

function Spawn.getMonster(self, uid)
	for i, v in pairs(self:getMonsters()) do
		if v == uid then
			return i
		end
	end
	return 0
end

function Spawn.deleteMonster(self, uid)
	local get_monster = self:getMonster(uid)
	table.remove(self:getMonsters(), get_monster)
	return true
end

function Spawn.removeMonsters(self)
	for i, v in pairs(self:getMonsters()) do
		if v then
			v:remove()
		end
	end
end

function Spawn.addMonster(self, monster)
	if monster:getId() then
		table.insert(self:getMonsters(), monster)
		return true
	end
	return false
end

function Spawn.addFunction(self, table, func, functionName)
	if type(func) ~= "function" then
		error("Param is not a function")
		return false
	end
	local pos = functionName or #table + 1
	if type(table) == "table" then
		table[pos] = func
	else
		error("TableName is not a table")
		return false
	end
	return true
end

function Spawn.executeFunction(self, table, ...)
	if type(table) == "table" then
		for _, f in pairs(table) do
			f(self, ...)
		end
		return true
	end
	return false
end

function Spawn.getFunctionMonster(self, tableName)
	return self.functions[tableName]
end

function Spawn.addFunctionMonster(self, tableName, func, functionName)
	return self:addFunction(self:getFunctionMonster(tableName), func, functionName)
end

function Spawn.executeFunctionMonster(self, tableName, ...)
	return self:executeFunction(self:getFunctionMonster(tableName), ...)
end

function Spawn.spawnMonsterTimer(self, config, func)
	-- 	config = {
	-- 		spawntime = int,
	-- 		monster = string,
	-- 		pos = Position()
	-- 	}
	local time_tp = 3
	config.spawntime = config.spawntime <= time_tp and (time_tp + 1) or (config.spawntime - time_tp)
	addEvent(function()
		for i = 1, time_tp do
			addEvent(function()
				config.pos:sendMagicEffect(CONST_ME_TELEPORT)
			end, i * 1000)
		end
		addEvent(function()
			local monster = Game.createMonster(config.monster, config.pos, false, false)
			if not monster then
				Spdlog.error("[Spawn] Error on spawn monster: " .. config.monster)
				return false
			end

			if func ~= nil and func ~= false then
				func(monster)
			end
			self:executeFunctionMonster("onSpawn", monster)
		end, time_tp * 1000)
	end, config.spawntime * 1000)
end

function Spawn.spawnMonsterIndex(self, index)
	local table = self:getPositions()
	table = table[index]
	if table ~= nil and table.status == true then
		local config = {
			spawntime = table.spawntime,
			monster = table.monster,
			pos = table.pos
		}
		local func = function(s, monster)
			monster:setStorageValue(s.storage.info, index)
			s:addMonster(monster)
		end
		self:addFunctionMonster("onSpawn", func, "MonsterIndex")
		self:spawnMonsterTimer(config)
	else
		Spdlog.error("[Spawn.spawnMonsterIndex] - Table is nil")
	end
end

function Spawn.executeSpawn(self)
	local pos = self:getPositions()
	if not pos then
		error('Not set pos')
		return false
	end
	for i, v in pairs(pos) do
		self:spawnMonsterIndex(i)
	end
end

function Spawn.removeSpawn(self)
	local pos = self:getPositions()
	if not pos then
		error('Not set pos')
		return false
	end
	for i, v in pairs(pos) do
		v.status = false
	end
end

function Spawn.checkMonstersUID(self)
	local monsters = self:getMonsters()
	local statistics = {
		active = 0,
		inactive = 0
	}
	for i, v in pairs(monsters) do
		if v ~= nil and v:isMonster() then
			statistics.active = statistics.active + 1
		else
			self:deleteMonster(v)
			statistics.inactive = statistics.inactive + 1
		end
	end
	return statistics
end
