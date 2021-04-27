FakePlayer = {}
function FakePlayer:new(obj)
    obj = obj or {}

    obj.itemCount = obj.itemCount or {}
    obj.storageValue = obj.storageValue or {}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function FakePlayer:isPlayer()
    return true
end

function FakePlayer:getTotalMoney()
    return self.totalMoney
end

function FakePlayer:getPosition()
    return self.position
end

function FakePlayer:getItemCount(itemId)
    return self.itemCount[itemId]
end

function FakePlayer:getStorageValue(storage)
    return self.storageValue[storage]
end

function FakePlayer:removeMoneyIncludingBalance(money)
    self.totalMoney = (self.totalMoney or 0) - money
end

function FakePlayer:addMoney(money)
    self.totalMoney = (self.totalMoney or 0) + money
end

function FakePlayer:teleportTo(pos)
    self.position = pos
end

function FakePlayer:addItem(itemId, count)
    self.itemCount[itemId] = (self.itemCount[itemId] or 0) + count
end

function FakePlayer:removeItem(itemId, count)
    self.itemCount[itemId] = (self.itemCount[itemId] or 0) - count
end

function FakePlayer:setStorageValue(storage, value)
    self.storageValue[storage] = value
end