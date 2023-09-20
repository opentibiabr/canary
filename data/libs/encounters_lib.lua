---@class EncounterStage
---@field encounter Encounter
---@field start function
---@field tick function
---@field finish function
EncounterStage = {}

local unstarted = 0

setmetatable(EncounterStage, {
	---@param self EncounterStage
	---@param config table
	__call = function(self, config)
		return setmetatable({
			encounter = config.encounter,
			start = config.start,
			tick = config.tick,
			finish = config.finish,
		}, { __index = EncounterStage })
	end,
})

---@class Encounter
---@field name string
---@field private zone Zone
---@field private spawnZone Zone
---@field private stages EncounterStage[]
---@field private currentStage number
---@field private events table
---@field private registered boolean
---@field private timeToSpawnMonsters number
---@field beforeEach function
Encounter = {
	registry = {},
}

setmetatable(Encounter, {
	---@param self Encounter
	---@param name string
	---@param config table
	__call = function(self, name, config)
		if not name then
			error("Encounter: name is required")
		end
		local encounter
		if Encounter.registry[name] then
			encounter = Encounter.registry[name]
		else
			encounter = setmetatable({
				name = name,
			}, { __index = Encounter })
		end
		if config then
			encounter:resetConfig(config)
		end
		return encounter
	end,
})

---Resets the encounter configuration
---@param config table The new configuration
function Encounter:resetConfig(config)
	self.zone = config.zone
	self.spawnZone = config.spawnZone or config.zone
	self.stages = {}
	self.currentStage = unstarted
	self.beforeEach = config.beforeEach
	self.registered = false
	self.global = config.global or false
	self.timeToSpawnMonsters = config.timeToSpawnMonsters or 3
	self.events = {}
end

---@param callable function The callable function for the event
---@param delay number The delay time for the event
function Encounter:addEvent(callable, delay, ...)
	local index = #self.events + 1
	local event = addEvent(function(callable, ...)
		pcall(callable, ...)
		table.remove(self.events, index)
	end, delay, callable, ...)
	table.insert(self.events, index, event)
end

---Cancels all the events associated with the encounter
function Encounter:cancelEvents()
	for _, event in ipairs(self.events) do
		stopEvent(event)
	end
	self.events = {}
end

---Returns the stage of the encounter by the given stage number
---@param stageNumber number? The number of the stage. Optional.
---@return EncounterStage The stage of the encounter
function Encounter:getStage(stageNumber)
	return self.stages[stageNumber or self.currentStage]
end

---Enters a new stage in the encounter
---@param stageNumber number The number of the stage to enter
---@param abort boolean? A flag to determine whether to abort the current stage without calling the finish function. Optional.
---@return boolean True if the stage is entered successfully, false otherwise
function Encounter:enterStage(stageNumber, abort)
	if not abort then
		local currentStage = self:getStage(self.currentStage)
		if currentStage and currentStage.finish then
			currentStage:finish()
		end
	end

	self:cancelEvents()
	if self.beforeEach then
		self:beforeEach()
	end

	if stageNumber == unstarted then
		self.currentStage = unstarted
		return true
	end

	local stage = self:getStage(stageNumber)
	if not stage then
		logger.error("Encounter:enterStage - stage {} not found", stageNumber)
		return false
	end

	self.currentStage = stageNumber
	if stage.start then
		stage:start()
	end

	return true
end

---Spawns monsters based on the given configuration
---@param config {name: string, amount: number, event: string?, timeLimit: number?, position: Position|table?, positions: Position|table[]?, spawn: function?} The configuration for spawning monsters
function Encounter:spawnMonsters(config)
	local positions = config.positions
	local amount = config.amount
	if positions and config.position then
		error("You can't use both 'position' and 'positions' in the same config.")
	end
	if positions and amount then
		error("You can't use both 'amount' and 'positions' in the same config.")
	end
	if amount and amount > 0 then
		positions = {}
		for _ = 1, amount do
			if config.position then
				table.insert(positions, config.position)
			else
				table.insert(positions, self.spawnZone:randomPosition())
			end
		end
	end
	for _, position in ipairs(positions) do
		for i = 1, self.timeToSpawnMonsters do
			self:addEvent(function(position)
				position:sendMagicEffect(CONST_ME_TELEPORT)
			end, i * 1000, position)
		end
		self:addEvent(function(name, position, event, spawn, timeLimit)
			local monster = Game.createMonster(name, position)
			if not monster then
				return false
			end
			if spawn then
				spawn(monster)
			end
			if event then
				monster:registerEvent(event)
			end
			if timeLimit then
				self:addEvent(function(monsterId)
					local monster = Monster(monsterId)
					if not monster then
						return
					end
					monster:remove()
				end, config.timeLimit, monster:getID())
			end
		end, self.timeToSpawnMonsters * 1000, config.name, position, config.event, config.spawn, config.timeLimit)
	end
end

---Broadcasts a message to all players
function Encounter:broadcast(...)
	for _, player in ipairs(Game.getPlayers()) do
		player:sendTextMessage(...)
	end
end

---Counts the number of monsters with the given name in the encounter zone
---@param name string The name of the monster to count
---@return number The number of monsters with the given name
function Encounter:countMonsters(name)
	return self.zone:countMonsters(name)
end

---Counts the number of players in the encounter zone
---@return number The number of players in the encounter zone
function Encounter:countPlayers()
	return self.zone:countPlayers(IgnoredByMonsters)
end

---Sends a text message to all creatures in the encounter zone
function Encounter:sendTextMessage(...)
	self.zone:sendTextMessage(...)
end

---Removes all monsters from the encounter zone
function Encounter:removeMonsters()
	self.zone:removeMonsters()
end

---Resets the encounter to its initial state
---@return boolean True if the encounter is reset successfully, false otherwise
function Encounter:reset()
	if self.currentStage == unstarted then
		return true
	end
	return self:enterStage(unstarted)
end

---Checks if a position is inside the encounter zone
---@param position Position The position to check
---@return boolean True if the position is inside the encounter zone, false otherwise
function Encounter:isInZone(position)
	return self.zone:isInZone(position)
end

---Enters the previous stage in the encounter
---@return boolean True if the previous stage is entered successfully, false otherwise
function Encounter:previousStage()
	return self:enterStage(self.currentStage - 1, true)
end

---Enters the next stage in the encounter
---@return boolean True if the next stage is entered successfully, false otherwise
function Encounter:nextStage()
	if self.currentStage == #self.stages then
		return self:reset()
	end
	return self:enterStage(self.currentStage + 1)
end

---Starts the encounter
---@return boolean True if the encounter is started successfully, false otherwise
function Encounter:start()
	Encounter.registerTickEvent()
	if self.currentStage ~= unstarted then
		return false
	end
	return self:enterStage(1)
end

---Adds a new stage to the encounter
---@param stage table The stage to add
---@return boolean True if the stage is added successfully, false otherwise
function Encounter:addStage(stage)
	table.insert(self.stages, EncounterStage(stage))
	return true
end

---Adds an intermission stage to the encounter
---@param interval number The duration of the intermission
---@return boolean True if the intermission stage is added successfully, false otherwise
function Encounter:addIntermission(interval)
	return self:addStage({
		start = function()
			self:addEvent(function()
				self:nextStage()
			end, interval)
		end,
	})
end

---Automatically starts the encounter when players enter the zone
function Encounter:startOnEnter()
	local zoneEvents = ZoneEvent(self.zone)

	function zoneEvents.afterEnter(zone, creature)
		if not self.registered then
			return true
		end
		local player = creature:getPlayer()
		if not player then
			return true
		end
		if player:hasGroupFlag(IgnoredByMonsters) then
			return
		end
		self:start()
	end

	function zoneEvents.afterLeave(zone, creature)
		local player = creature:getPlayer()
		if not player then
			return
		end
		if player:hasGroupFlag(IgnoredByMonsters) then
			return
		end
		-- last player left; reset encounter
		if self:countPlayers() == 1 then
			return
		end
		self:reset()
	end

	zoneEvents:register()
end

---Registers the encounter
--@param self Encounter The encounter to register
---@return boolean True if the encounter is registered successfully, false otherwise
function Encounter:register()
	Encounter.registry[self.name] = self
	self.registered = true
	return true
end

function Encounter.registerTickEvent()
	if Encounter.tick then
		return
	end
	Encounter.tick = GlobalEvent("encounter.ticks.onThink")
	function Encounter.tick.onThink(interval, lastExecution)
		for _, encounter in pairs(Encounter.registry) do
			local stage = encounter:getStage()
			if stage and stage.tick then
				stage.tick(encounter, interval, lastExecution)
			end
		end
		return true
	end

	Encounter.tick:interval(1000)
	Encounter.tick:register()
end
