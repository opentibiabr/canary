STORAGEVALUE_DODGE = 48900
STORAGEVALUE_CRITICAL = 48901

DODGE = {
	LEVEL_MAX = 100, -- máximo de level que o dodge será
	PERCENT = 0.2 -- porcentagem que irá defender o ataque
}

CRITICAL = {
	LEVEL_MAX = 100, -- máximo de level que o critical será
	PERCENT = 1.0 -- porcentagem que irá aumentar o ataque 
}

function Player.getDodgeLevel(self)
	return self:getStorageValue(STORAGEVALUE_DODGE)
end

function Player.setDodgeLevel(self, value)
	return self:setStorageValue(STORAGEVALUE_DODGE, value)
end

function Player.getCriticalLevel(self)
	return self:getStorageValue(STORAGEVALUE_CRITICAL)
end

function Player.setCriticalLevel(self, value)
	return self:setStorageValue(STORAGEVALUE_CRITICAL, value)
end