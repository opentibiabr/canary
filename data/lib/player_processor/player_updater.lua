PlayerUpdater = {}
setmetatable(PlayerUpdater, {
    __call =
    function(self, configs, player, actor)
        if not player or not player:isPlayer() then
            error("PlayerUpdater needs a valid player to run")
        end

        for i,parse in pairs(self) do
            parse(configs, player, actor)
        end
    end
})

PlayerUpdater.updateMoney = function (configs, player)
    if not configs.moneyAmount then return end

    local amount = configs.moneyAmount:getValue(player)
    if amount < 0 then
        player:removeMoneyIncludingBalance(math.abs(amount))
    elseif amount > 0 then
        player:addMoney(amount)
    end
end

PlayerUpdater.updatePosition = function (configs, player)
    if not configs.position then return end
    player:teleportTo(configs.position:getValue(player))
end

PlayerUpdater.updateItems = function (configs, player)
    for itemId, itemConfig in pairs(configs.items) do
        if itemConfig.value < 0 then
            player:removeItem(itemId, math.abs(itemConfig:getValue(player)))
        elseif itemConfig.value > 0 then
            player:addItem(itemId, itemConfig:getValue(player))
        end
    end
end

PlayerUpdater.updateStorages = function (configs, player)
    for storage, storageConfig in pairs(configs.storages) do
        player:setStorageValue(storage, storageConfig:getValue(player))
    end
end

PlayerUpdater.runUpdateCallbacks = function (configs, player, actor)
    for _, callback in pairs(configs.callbacks) do
        callback(player, actor)
    end
end