DROME_POTIONS = {
	POTIONS_IDS = {},
	Storage = {
		WealthDuplex = 30100,
		BestiaryBetterment = 30101,
		CharmUpgrade = 30102,
		FireResilience = 30103,
		IceResilience = 30104,
		EarthResilience = 30105,
		EnergyResilience = 30106,
		HolyResilience = 30107,
		DeathResilience = 30108,
		PhyicalResilience = 30109,
		FireAmplification = 30110,
		IceAmplification = 30111,
		EarthAmplification = 30112,
		EnergyAmplification = 30113,
		HolyAmplification = 30114,
		DeathAmplification = 30115,
		PhyicalAmplification = 30116,
	},
}

local DROME_DAMAGE_STORAGE = {
	RESILIENCE = {
		[COMBAT_FIREDAMAGE] = DROME_POTIONS.Storage.FireResilience,
		[COMBAT_ICEDAMAGE] = DROME_POTIONS.Storage.IceResilience,
		[COMBAT_EARTHDAMAGE] = DROME_POTIONS.Storage.EarthResilience,
		[COMBAT_ENERGYDAMAGE] = DROME_POTIONS.Storage.EnergyResilience,
		[COMBAT_HOLYDAMAGE] = DROME_POTIONS.Storage.HolyResilience,
		[COMBAT_DEATHDAMAGE] = DROME_POTIONS.Storage.DeathResilience,
		[COMBAT_PHYSICALDAMAGE] = DROME_POTIONS.Storage.PhyicalResilience,
	},
	AMPLIFICATION = {
		[COMBAT_FIREDAMAGE] = DROME_POTIONS.Storage.FireAmplification,
		[COMBAT_ICEDAMAGE] = DROME_POTIONS.Storage.IceAmplification,
		[COMBAT_EARTHDAMAGE] = DROME_POTIONS.Storage.EarthAmplification,
		[COMBAT_ENERGYDAMAGE] = DROME_POTIONS.Storage.EnergyAmplification,
		[COMBAT_HOLYDAMAGE] = DROME_POTIONS.Storage.HolyAmplification,
		[COMBAT_DEATHDAMAGE] = DROME_POTIONS.Storage.DeathAmplification,
		[COMBAT_PHYSICALDAMAGE] = DROME_POTIONS.Storage.PhyicalAmplification,
	},
}

local DROME_DAMAGE_ITEMS = {
	RESILIENCE = {
		[36729] = COMBAT_FIREDAMAGE,
		[36730] = COMBAT_ICEDAMAGE,
		[36731] = COMBAT_EARTHDAMAGE,
		[36732] = COMBAT_ENERGYDAMAGE,
		[36733] = COMBAT_HOLYDAMAGE,
		[36734] = COMBAT_DEATHDAMAGE,
		[36735] = COMBAT_PHYSICALDAMAGE,
	},
	AMPLIFICATION = {
		[36736] = COMBAT_FIREDAMAGE,
		[36737] = COMBAT_ICEDAMAGE,
		[36738] = COMBAT_EARTHDAMAGE,
		[36739] = COMBAT_ENERGYDAMAGE,
		[36740] = COMBAT_HOLYDAMAGE,
		[36741] = COMBAT_DEATHDAMAGE,
		[36742] = COMBAT_PHYSICALDAMAGE,
	},
}

for i = 36723, 36742 do
	table.insert(DROME_POTIONS.POTIONS_IDS, i)
end

DROME_POTIONS.parseUseAmplificationPotion = function(player, item)
	local combatType = DROME_DAMAGE_ITEMS.AMPLIFICATION[item:getId()]
	if not combatType then return false end
	if player:hasAmplification(combatType) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already have '.. item:getName() ..' bonuses.')
		return false
	end
	player:setAmplification(combatType)
	item:remove(1)
end

function Player.hasAmplification(self, combatType)
	if not self or not combatType then return false end
	local storage = DROME_DAMAGE_STORAGE.AMPLIFICATION[combatType]
	if not storage then return false end
	if self:getStorageValue(storage) > os.time() then
		return true
	end
	return false
end

function Player.setAmplification(self, combatType)
	if not self or not combatType then return false end
	local storage = DROME_DAMAGE_STORAGE.AMPLIFICATION[combatType]
	self:setStorageValue(storage, os.time() + 3600)
	return true
end

DROME_POTIONS.parseUseResiliencePotion = function(player, item)
	local combatType = DROME_DAMAGE_ITEMS.RESILIENCE[item:getId()]
	if not combatType then return false end
	if player:hasResilience(combatType) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already have '.. item:getName() ..' bonuses.')
		return false
	end
	player:setResilience(combatType)
	item:remove(1)
end

function reduceEightPercent(value)
	return (value > 0) and math.floor(value * 0.92) or 0
end

function increaseEightPercent(value)
	return (value > 0) and math.floor(value * 1.08) or 0
end

function Player.setResilience(self, combatType)
	if not self or not combatType then return false end
	local storage = DROME_DAMAGE_STORAGE.RESILIENCE[combatType]
	self:setStorageValue(storage, os.time() + 3600)
	return true
end

function Player.hasResilience(self, combatType)
	if not self or not combatType then return false end
	local storage = DROME_DAMAGE_STORAGE.RESILIENCE[combatType]
	if not storage then return false end
	if self:getStorageValue(storage) > os.time() then
		return true
	end
	return false
end

DROME_POTIONS.BestiaryBetterment = function(player, item)
	if player:hasBestiaryBettermentBonus() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already have Bestiary Betterment bonuses.')
		return false
	end
	player:setStorageValue(DROME_POTIONS.Storage.BestiaryBetterment, os.time() + 3600)
	item:remove(1)
end

DROME_POTIONS.WealthDuplex = function(player, item)
	if player:hasWealthDuplexBonus() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already have Wealth Duplex bonuses.')
		return false
	end
	player:setStorageValue(DROME_POTIONS.Storage.WealthDuplex, os.time() + 3600)
	item:remove(1)
	return true
end

DROME_POTIONS.CharmUpgrade = function(player, item)
	if player:hasCharmUpgradeBonus() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already have Charm Upgrade bonuses.')
		return false
	end
	player:setStorageValue(DROME_POTIONS.Storage.CharmUpgrade, os.time() + 3600)
	item:remove(1)
	addEvent(checkDromeCharmUpgradeBonus, 3600000, player:getId())
	return true
end

DROME_POTIONS.StaminaExtension = function(player, item)
	if player:getStamina() < 2520 then
		local newStamina = ((player:getStamina() + 60) > 2520) and 2520 or player:getStamina() + 60
		player:setStamina(newStamina)
		item:remove(1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have a full stamina.')
	end
	return true
end

local lastUsedTime = 0
local cooldownDuration = 24 * 60 * 60 -- 24 horas en segundos

DROME_POTIONS.KooldownAid = function(player, item)
  local currentTime = os.time()

  if currentTime - lastUsedTime >= cooldownDuration then
    lastUsedTime = currentTime

    player:resetSpellsCooldown()
    item:remove(1)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Your cooldowns have been reseted.")
    return true
  else
    local timeLeft = cooldownDuration - (currentTime - lastUsedTime)
    local hoursLeft = math.floor(timeLeft / 3600)
    local minutesLeft = math.floor((timeLeft % 3600) / 60)
    local secondsLeft = math.floor((timeLeft % 3600) % 60)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot use this at this moment. You need wait " .. hoursLeft .. " hours, " .. minutesLeft .. " minutes and " .. secondsLeft .. " seconds.")
    return false
  end
end

local lastUsedTime = 0
local cooldownDuration = 24 * 60 * 60 -- 24 horas en segundos

DROME_POTIONS.StrikeEnhancement = function(player, item)
  local currentTime = os.time()

  if currentTime - lastUsedTime >= cooldownDuration then
    lastUsedTime = currentTime

    local strikeEnhancement = Condition(CONDITION_ATTRIBUTES)
    strikeEnhancement:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
    strikeEnhancement:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 5)
    player:addCondition(strikeEnhancement)
    item:remove(1)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Tu ataque ha sido mejorado! Ahora tienes un aumento del 5% de probabilidad de golpe critico durante 1 hora.")

    return true
  else
    local timeLeft = cooldownDuration - (currentTime - lastUsedTime)
    local hoursLeft = math.floor(timeLeft / 3600)
    local minutesLeft = math.floor((timeLeft % 3600) / 60)
    local secondsLeft = math.floor((timeLeft % 3600) % 60)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "No puedes usar el item en este momento. Debes esperar " .. hoursLeft .. " horas, " .. minutesLeft .. " minutos y " .. secondsLeft .. " segundos.")

    return false
  end
end

DROME_POTIONS.parseUseAction = function(player, item)
	if item:getId() == 36723 then return DROME_POTIONS.KooldownAid(player, item) end
	if item:getId() == 36724 then return DROME_POTIONS.StrikeEnhancement(player, item) end
	if item:getId() == 36725 then return DROME_POTIONS.StaminaExtension(player, item) end
	if item:getId() == 36726 then return DROME_POTIONS.CharmUpgrade(player, item) end
	if item:getId() == 36727 then return DROME_POTIONS.WealthDuplex(player, item) end
	if item:getId() == 36728 then return DROME_POTIONS.BestiaryBetterment(player, item) end
	if item:getId() >= 36729 and item:getId() <= 36735 then
		DROME_POTIONS.parseUseResiliencePotion(player, item)
	end
	if item:getId() >= 36736 and item:getId() <= 36742 then
		DROME_POTIONS.parseUseAmplificationPotion(player, item)
	end
end

function Player.hasWealthDuplexBonus(self)
	if not self then return false end
	if self:getStorageValue(DROME_POTIONS.Storage.WealthDuplex) > os.time() then
		return true
	end
	return false
end

function Player.hasBestiaryBettermentBonus(self)
	if not self then return false end
	if self:getStorageValue(DROME_POTIONS.Storage.BestiaryBetterment) > os.time() then
		return true
	end
	return false
end

function Player.hasCharmUpgradeBonus(self)
	if not self then return false end
	if self:getStorageValue(DROME_POTIONS.Storage.CharmUpgrade) > os.time() then
		return true
	end
	return false
end

function Player.getCharmUpgradeBonusTimeLeft(self)
	if not self then return false end
	local timeStamp = self:getStorageValue(DROME_POTIONS.Storage.CharmUpgrade)
	if timeStamp <= os.time() then
		return 0
	end
	return timeStamp - os.time()
end

function checkDromeCharmUpgradeBonus(playerId)
	local player = Player(playerId)
	if not player then
		return
	end
	if not player:hasCharmUpgradeBonus() then
		player:setDromeCharmUpgrade(false)
		return
	end
	if player:hasCharmUpgradeBonus() then
		player:setDromeCharmUpgrade(true)
	end
	local secondsLeft = player:getCharmUpgradeBonusTimeLeft()
	addEvent(checkDromeCharmUpgradeBonus, secondsLeft * 1000, playerId)
end