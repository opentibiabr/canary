---@alias Weekday 'Monday'|'Tuesday'|'Wednesday'|'Thursday'|'Friday'|'Saturday'|'Sunday

---@class Raid : Encounter
---@field allowedDays Weekday|Weekday[] The days of the week the raid is allowed to start
---@field minActivePlayers number The minimum number of players required to start the raid
---@field initialChance number|nil The initial chance to start the raid
---@field targetChancePerDay number The chance per enabled day to start the raid
---@field maxChancePerCheck number The maximum chance to start the raid in a single check (1m)
---@field minGapBetween string|number The minimum gap between raids of this type in seconds
---@field maxChecksPerDay number The maximum number of checks per day
---@field kv KV
Raid = {
	registry = {},
	checkInterval = "1m",
	idleTime = "5m",
}

-- Set the metatable so that Raid inherits from Encounter
setmetatable(Raid, {
	__index = Encounter,
	---@param config { name: string, global: boolean, allowedDays: Weekday|Weekday[], minActivePlayers: number, targetChancePerDay: number, maxChancePerCheck: number, minGapBetween: string|number, initialChance: number, maxChecksPerDay: number }
	__call = function(self, name, config)
		config.global = true
		local raid = setmetatable(Encounter(name, config), { __index = Raid })
		raid.allowedDays = config.allowedDays
		raid.minActivePlayers = config.minActivePlayers
		raid.targetChancePerDay = config.targetChancePerDay
		raid.maxChancePerCheck = config.maxChancePerCheck
		raid.minGapBetween = ParseDuration(config.minGapBetween)
		raid.initialChance = config.initialChance
		raid.maxChecksPerDay = config.maxChecksPerDay
		raid.kv = kv.scoped("raids"):scoped(name)
		return raid
	end,
})

---Registers the raid
---@param self Raid The raid to register
---@return boolean True if the raid is registered successfully, false otherwise
function Raid:register()
	Encounter.register(self)
	Raid.registry[self.name] = self
	self.registered = true
	return true
end

---Starts the raid if it can be started
---@param self Raid The raid to try to start
---@return boolean True if the raid was started, false otherwise
function Raid:tryStart(force)
	if not force and not self:canStart() then
		return false
	end
	logger.info("Starting raid {}", self.name)
	self.kv:set("last-occurrence", os.time())
	self:start()
	return true
end

---Checks if the raid can be started
---@param self Raid The raid to check
---@return boolean True if the raid can be started, false otherwise
function Raid:canStart()
	if self.currentStage ~= Encounter.unstarted then
		logger.debug("Raid {} is already running", self.name)
		return false
	end
	local forceTrigger = self.kv:get("trigger-when-possible")
	if not forceTrigger then
		local lastOccurrence = (self.kv:get("last-occurrence") or 0) * 1000
		local currentTime = os.time() * 1000
		if self.minGapBetween and lastOccurrence and currentTime - lastOccurrence < self.minGapBetween then
			logger.debug("Raid {} occurred too recently (last: {} ago, min: {})", self.name, FormatDuration(currentTime - lastOccurrence), FormatDuration(self.minGapBetween))
			return false
		end

		if not self.targetChancePerDay or not self.maxChancePerCheck then
			logger.debug("Raid {} does not have a chance configured (targetChancePerDay: {}, maxChancePerCheck: {})", self.name, self.targetChancePerDay, self.maxChancePerCheck)
			return false
		end

		-- Check if we need to reset daily counters
		local checksToday
		local lastCheckDate = self.kv:get("last-check-date")
		local currentDate = os.date("%Y%m%d")
		if lastCheckDate ~= currentDate then
			self.kv:set("checks-today", 0)
			self.kv:set("last-check-date", currentDate)
			checksToday = 0
		else
			checksToday = math.max(0, tonumber(self.kv:get("checks-today")) or 0)
		end
		if self.maxChecksPerDay and checksToday >= self.maxChecksPerDay then
			logger.debug("Raid {} has already checked today (checks today: {}, max: {})", self.name, checksToday, self.maxChecksPerDay)
			return false
		end
		self.kv:set("checks-today", checksToday + 1)

		local failedAttempts = math.max(0, tonumber(self.kv:get("failed-attempts")) or 0)
		local checksPerDay = ParseDuration("23h") / ParseDuration(Raid.checkInterval)
		local initialChance = self.initialChance or (self.targetChancePerDay / checksPerDay)
		local chanceIncrease = math.max((self.targetChancePerDay - initialChance) / checksPerDay, 0)
		local chance = initialChance + (chanceIncrease * failedAttempts)
		if chance > self.maxChancePerCheck then
			chance = self.maxChancePerCheck
		end
		chance = chance * 1000

		-- offset the chance by 1000 to allow for fractional chances
		local roll = math.random(100 * 1000)
		if roll > chance then
			logger.debug("Raid {} failed to start (roll: {}, chance: {}, failed attempts: {})", self.name, roll, chance, failedAttempts)
			self.kv:set("failed-attempts", failedAttempts + 1)
			return false
		end
	end

	if self.allowedDays and not self:isAllowedDay() then
		logger.debug("Raid {} is not allowed today ({})", self.name, os.date("%A"))
		self.kv:set("trigger-when-possible", true)
		return false
	end
	if self.minActivePlayers and self:getActivePlayerCount() < self.minActivePlayers then
		logger.debug("Raid {} does not have enough players (active: {}, min: {})", self.name, self:getActivePlayerCount(), self.minActivePlayers)
		self.kv:set("trigger-when-possible", true)
		return false
	end

	self.kv:set("trigger-when-possible", false)
	self.kv:set("failed-attempts", 0)
	return true
end

---Checks if the raid is allowed to start today
---@param self Raid The raid to check
---@return boolean True if the raid is allowed to start today, false otherwise
function Raid:isAllowedDay()
	local day = os.date("%A")
	if self.allowedDays == day then
		return true
	end
	if type(self.allowedDays) == "table" then
		for _, allowedDay in pairs(self.allowedDays) do
			if allowedDay == day then
				return true
			end
		end
	end
	return false
end

---Gets the number of players in the game
---@param self Raid The raid to check
---@return number The number of players in the game
function Raid:getActivePlayerCount()
	local count = 0
	for _, player in pairs(Game.getPlayers()) do
		if player:getIdleTime() < ParseDuration(Raid.idleTime) then
			count = count + 1
		end
	end
	return count
end

--Overrides Encounter:addBroadcast
--Adds a stage that broadcasts raid information globally
--@param message string The message to send
--@return boolean True if the message stage is added successfully, false otherwise
function Raid:addBroadcast(message, type)
	type = type or MESSAGE_EVENT_ADVANCE
	return self:addStage({
		start = function()
			self:broadcast(type, message)
			Webhook.sendMessage(":space_invader: " .. message, announcementChannels["raids"])
		end,
	})
end
