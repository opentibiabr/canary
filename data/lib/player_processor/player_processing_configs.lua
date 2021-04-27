PlayerProcessingConfigs = {}

function PlayerProcessingConfigs:new()
    obj = {
        moneyAmount = nil,
        position = nil,
        storages = {},
        items = {},
        callbacks = {},
        premium = nil,
        promotion = nil,
        level = nil,
        protectionZone = nil,
        vocation = nil,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function PlayerProcessingConfigs:validate(player, actor)
    return PlayerValidator(self, player, actor)
end

function PlayerProcessingConfigs:update(player, actor)
    return PlayerUpdater(self, player, actor)
end

function PlayerProcessingConfigs:addStorage(key, value, configType)
    self.storages[key] = PlayerConfig:new(value, configType)
    return self
end

function PlayerProcessingConfigs:addAmount(amount, configType)
    if not self.moneyAmount then
        self.moneyAmount = PlayerConfig:new(amount, configType or ConfigsTypes.CONFIG_GTE)
    else
        self.moneyAmount:appendValue(amount)
    end
    return self
end

function PlayerProcessingConfigs:removeAmount(amount, configType)
    self:addAmount(-amount, configType)
    return self
end

function PlayerProcessingConfigs:addItem(itemId, count, configType)
    if not self.items[itemId] then
        self.items[itemId] = PlayerConfig:new(count, configType or ConfigsTypes.CONFIG_GTE)
    else
        self.items[itemId]:appendValue(count)
    end
    return self
end

function PlayerProcessingConfigs:addPosition(position, configType)
    self.position = PlayerConfig:new(position, configType)
    return self
end

function PlayerProcessingConfigs:addCallback(callback)
    self.callbacks[#self.callbacks + 1] = callback
    return self
end

function PlayerProcessingConfigs:addLevel(level, configType)
    self.level = PlayerConfig:new(level, configType)
    return self
end

function PlayerProcessingConfigs:addVocation(vocation, configType)
    self.vocation = PlayerConfig:new(vocation, configType)
    return self
end

function PlayerProcessingConfigs:addPromotion(promotion)
    self.promotion = promotion
    return self
end

function PlayerProcessingConfigs:addPremium(premium)
    self.premium = premium
    return self
end

function PlayerProcessingConfigs:addProtectionZone(protectionZone)
    self.protectionZone = protectionZone
    return self
end