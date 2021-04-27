PlayerConfig = {}

ConfigsTypes = {
    CONFIG_EQ = 1,
    CONFIG_NEQ = 2,
    CONFIG_GTE = 3,
    CONFIG_LTE = 4,
}

function PlayerConfig:new(value, type)
    obj = {
        value = value or 0,
        type = type or ConfigsTypes.CONFIG_EQ,
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function PlayerConfig:getValue(player)
    return type(self.value) == "function" and self.value(player) or self.value
end

function PlayerConfig:checkValue(value, player)
    local currentValue = self:getValue(player)

    if type(currentValue) == "number" then
        if self.type == ConfigsTypes.CONFIG_GTE then
            return value >= currentValue
        end

        if self.type == ConfigsTypes.CONFIG_LTE then
            return value <= currentValue
        end
    end

    if self.type == ConfigsTypes.CONFIG_NEQ then
        if type(currentValue) == table and #currentValue > 0 then
            for _, v in ipairs(currentValue) do
                if v == value then return false end
            end
            return true
        end
        return currentValue ~= value
    end

    if type(currentValue) == table and #currentValue > 0 then
        for _, v in ipairs(currentValue) do
            if v ~= value then return false end
        end
        return true
    end

    return currentValue == value
end

function PlayerConfig:setValue(value)
    self.value = value
end

function PlayerConfig:appendValue(value)
    self.value = self.value + value
end
