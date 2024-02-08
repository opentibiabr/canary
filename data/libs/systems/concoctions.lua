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
	KooldownAid = Concoction_KooldownAid,
	StaminaExtension = Concoction_StaminaExtension,
	StrikeEnhancement = Concoction_StrikeEnhancement,
	CharmUpgrade = Concoction_CharmUpgrade,
	WealthDuplex = Concoction_WealthDuplex,
	BestiaryBetterment = Concoction_BestiaryBetterment,
	FireResilience = Concoction_FireResilience,
	IceResilience = Concoction_IceResilience,
	EarthResilience = Concoction_EarthResilience,
	EnergyResilience = Concoction_EnergyResilience,
	HolyResilience = Concoction_HolyResilience,
	DeathResilience = Concoction_DeathResilience,
	PhysicalResilience = Concoction_PhysicalResilience,
	FireAmplification = Concoction_FireAmplification,
	IceAmplification = Concoction_IceAmplification,
	EarthAmplification = Concoction_EarthAmplification,
	EnergyAmplification = Concoction_EnergyAmplification,
	HolyAmplification = Concoction_HolyAmplification,
	DeathAmplification = Concoction_DeathAmplification,
	PhysicalAmplification = Concoction_PhysicalAmplification,
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
	if self.config.condition then
		self.condition = Condition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT)
		self.condition:setParameter(CONDITION_PARAM_SUBID, self.id)
		self.condition:setParameter(CONDITION_PARAM_TICKS, -1)
		self.condition:setParameter(self.config.condition[1], self.config.condition[2])
	end
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
	if self.timeLeftStorage == nil then
		return 0
	end

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

local function tick(concoctionId, playerId, timeDeduction)
	local player = Player(playerId)
	if not player then
		return
	end
	local concoction = Concoction.find(concoctionId)
	if not concoction then
		return
	end
	concoction:tick(player, timeDeduction)
end

function Concoction:tick(player, timeDeduction)
	local timeLeft = self:timeLeft(player)
	if timeLeft <= 0 then
		return
	end
	timeLeft = timeLeft - timeDeduction
	self:timeLeft(player, timeLeft > 0 and timeLeft or 0)
	self:update(player)
	if timeLeft > 0 then
		if self:tickType() == ConcoctionTickType.Online then
			addEvent(tick, timeDeduction * 1000, self.id, player:getId(), timeDeduction)
		end
	else
		self:removeCondition(player)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your concoction " .. self.name .. " has worn off.")
	end
end

function Concoction:init(player, sendMessage)
	if self:timeLeft(player) <= 0 then
		return true
	end

	self:update(player)
	self:addCondition(player)
	if self:tickType() == ConcoctionTickType.Online then
		addEvent(tick, updateInterval * 1000, self.id, player:getId(), updateInterval)
	end
	if sendMessage then
		addEvent(function(playerId, name, duration)
			local eventPlayer = Player(playerId)
			if not eventPlayer then
				return
			end
			eventPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your concoction " .. name .. " is still active for another " .. duration .. ".")
		end, 500, player:getId(), self.name, getTimeInWords(self:timeLeft(player)))
	end
end

function Concoction:addCondition(player)
	if not self.condition then
		return
	end
	player:addCondition(self.condition)
end

function Concoction:removeCondition(player)
	if not self.condition then
		return
	end
	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_DEFAULT, self.id)
end

function Concoction:activate(player, item)
	local cooldown = self:cooldown()
	if self:lastActivatedAt(player) + cooldown > os.time() then
		local cooldownLeft = self:lastActivatedAt(player) + cooldown - os.time()
		player:sendTextMessage(MESSAGE_FAILURE, "You must wait " .. getTimeInWords(cooldownLeft) .. " before using " .. item:getName() .. " again.")
		return true
	end
	self:timeLeft(player, self:totalDuration())
	self:lastActivatedAt(player, os.time())
	self:update(player)
	local consumptionString = self:tickType() == ConcoctionTickType.Online and " while you are online" or " as you gain experience"
	if self.config.callback then
		self.config.callback(player, self.config)
	else
		self:addCondition(player)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have activated " .. item:getName() .. ". It will last for " .. getTimeInWords(self:totalDuration()) .. consumptionString .. ".")
		if self:tickType() == ConcoctionTickType.Online then
			addEvent(tick, updateInterval * 1000, self.id, player:getId(), updateInterval)
		end
	end
	item:remove(1)
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
