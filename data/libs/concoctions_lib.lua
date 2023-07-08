local updateInterval = 60

-- Concoctions registry
local concoctions = {}

ConcoctionTickType = {
	Online = "online",
	Experience = "experience",
}

-- Concoction class
Concoction = {}
Concoction.__index = Concoction
Concoction.Ids = {
	KooldownAid = 36723,
	StaminaExtension = 36725,
	StrikeEnhancement = 36724,
	CharmUpgrade = 36726,
	WealthDuplex = 36727,
	BestiaryBetterment = 36728,
	EarthResilience = 36729,
	FireResilience = 36730,
	IceResilience = 36731,
	EarthAmplification = 36732,
	EnergyResilience = 36733,
	DeathResilience = 36734,
	HolyResilience = 36735,
	PhysicalResilience = 36736,
	FireAmplification = 36737,
	IceAmplification = 36738,
}

function Concoction.find(identifier)
	for _, concoction in ipairs(concoctions) do
		if concoction.id == identifier or concoction.name == identifier then
			return concoction
		end
	end
	return nil
end

function Concoction.new(data)
    local self = setmetatable({}, Concoction)
		self.id = data.id
		self.name = data.name or ItemType(data.id):getName()
		self.timeLeftStorage = data.timeLeftStorage
		self.lastActivatedAtStorage = data.lastActivatedAtStorage
		self.config = data.config or {}
    return self
end

function Concoction.initAll(player, sendMessage)
	for _, concoction in ipairs(concoctions) do
		concoction:init(player, sendMessage)
	end
end

function Concoction.experienceTick(player, timeDeduction)
	for _, concoction in ipairs(concoctions) do
		if concoction:tickType() == ConcoctionTickType.Experience then
			concoction:tick(player, timeDeduction)
		end
	end
end

function Concoction:cooldown()
	return self.config.cooldownOverride or configManager.getNumber(configKeys.TIBIADROME_CONCOCTION_COOLDOWN)
end

function Concoction:totalDuration()
	return self.config.durationOverride or configManager.getNumber(configKeys.TIBIADROME_CONCOCTION_DURATION)
end

function Concoction:tickType()
	return self.config.tickTypeOverride or configManager.getString(configKeys.TIBIADROME_CONCOCTION_TICK_TYPE)
end

function Concoction:lastActivatedAt(player, value)
	if value == nil then
		return player:getStorageValue(self.lastActivatedAtStorage)
	end
	player:setStorageValue(self.lastActivatedAtStorage, value)
end

function Concoction:timeLeft(player, value)
	if self.timeLeftStorage == nil then return 0 end

	if value == nil then
		return player:getStorageValue(self.timeLeftStorage)
	end
	player:setStorageValue(self.timeLeftStorage, value)
end

function Concoction:active(player)
	return self:timeLeft(player) > 0
end

function Concoction:update(player)
	player:updateConcoction(self.id, self:timeLeft(player))
end

function Concoction:tick(player, timeDeduction)
	local timeLeft = self:timeLeft(player) - timeDeduction
	self:timeLeft(player, timeLeft > 0 and timeLeft or 0)
	self:update(player)
	if timeLeft > 0 then
		if self:tickType() == ConcoctionTickType.Online then
			addEvent(function() self:tick(player, timeDeduction) end, timeDeduction * 1000)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your concoction " .. self.name .. " has worn off.")
	end
end

function Concoction:init(player, sendMessage)
	if self:timeLeft(player) <= 0 then return true end

	self:update(player)
	if self:tickType() == ConcoctionTickType.Online then
		addEvent(function() self:tick(player, updateInterval) end, updateInterval * 1000)
	end
	if sendMessage then
		addEvent(function()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your concoction " .. self.name .. " is still active for another " .. durationString(self:timeLeft(player)) .. ".")
		end, 500)
	end
end

function Concoction:activate(player, item)
	local cooldown = self:cooldown()
	if self:lastActivatedAt(player) + cooldown > os.time() then
		local cooldownLeft = self:lastActivatedAt(player) + cooldown - os.time()
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You must wait " .. durationString(cooldownLeft) .. " before using " .. item:getName() .. " again.")
		return true
	end
	self:timeLeft(player, self:totalDuration())
	self:lastActivatedAt(player, os.time())
	self:update(player)
	local consumptionString = self:tickType() == ConcoctionTickType.Online and " while you are online" or " as you gain experience"
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have activated " .. item:getName() .. ". It will last for " .. durationString(self:totalDuration()) .. consumptionString .. ".")
	item:remove(1)
	if self:tickType() == ConcoctionTickType.Online then
		addEvent(function() self:tick(player, updateInterval) end, updateInterval * 1000)
	end
end

function Concoction:register()
	local action = Action()

	function action.onUse(player, item)
		self:activate(player, item)
		return true
	end

	action:id(self.id)
	action:register()

	-- add to Concoctions registry
	table.insert(concoctions, self)
end
