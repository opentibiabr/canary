function test_PlayerProcessingConfigs_EmptyConstructor()
    local processor = PlayerProcessingConfigs:new()
    lu.assertIsNil(processor.position)
    lu.assertEquals(processor.moneyAmount, nil)
    lu.assertEquals(processor.storages, {})
    lu.assertEquals(processor.items, {})
    lu.assertEquals(processor.callbacks, {})
    lu.assertIsTrue(getmetatable(processor) == PlayerProcessingConfigs)
end

function test_PlayerProcessingConfigs_AddStorage()
    local processor = PlayerProcessingConfigs:new({}):addStorage(5055, 2)
    lu.assertEquals(processor.storages[5055], {type = ConfigsTypes.CONFIG_EQ, value = 2})

    processor:addStorage(5054, 23, ConfigsTypes.CONFIG_NEQ)
    lu.assertEquals(processor.storages[5054], {type = ConfigsTypes.CONFIG_NEQ, value = 23})

    processor:addStorage(5053, 300, ConfigsTypes.CONFIG_LTE)
    lu.assertEquals(processor.storages[5053], {type = ConfigsTypes.CONFIG_LTE, value = 300})

    processor:addStorage(5055, -1, ConfigsTypes.CONFIG_GTE)
    lu.assertEquals(processor.storages[5055], {type = ConfigsTypes.CONFIG_GTE, value = -1})
end

function test_PlayerProcessingConfigs_AddAmount()
    local processor = PlayerProcessingConfigs:new({}):addAmount(123)
    lu.assertEquals(processor.moneyAmount, {type = ConfigsTypes.CONFIG_GTE, value = 123})

    processor:addAmount(123)
    lu.assertEquals(processor.moneyAmount, {type = ConfigsTypes.CONFIG_GTE, value = 246})

    processor:removeAmount(246)
    lu.assertEquals(processor.moneyAmount, {type = ConfigsTypes.CONFIG_GTE, value = 0})

    processor:addAmount(0)
    lu.assertEquals(processor.moneyAmount, {type = ConfigsTypes.CONFIG_GTE, value = 0})

    processor = PlayerProcessingConfigs:new({}):addAmount(123, ConfigsTypes.CONFIG_EQ)
    lu.assertEquals(processor.moneyAmount, {type = ConfigsTypes.CONFIG_EQ, value = 123})
end

function test_PlayerProcessingConfigs_AddItem()
    local processor = PlayerProcessingConfigs:new({}):addItem(2172, 11)
    lu.assertEquals(processor.items[2172], {type = ConfigsTypes.CONFIG_GTE, value = 11})

    processor:addItem(2172, -5)
    lu.assertEquals(processor.items[2172], {type = ConfigsTypes.CONFIG_GTE, value = 6})

    processor:addItem(2132, 1)
    lu.assertEquals(processor.items[2132], {type = ConfigsTypes.CONFIG_GTE, value = 1})

    processor:addItem(2132, 2)
    lu.assertEquals(processor.items[2132], {type = ConfigsTypes.CONFIG_GTE, value = 3})
end

function test_PlayerProcessingConfigs_AddPosition()
    local processor = PlayerProcessingConfigs:new({}):addPosition({x = 1, y = 2, z = 3})
    lu.assertEquals(processor.position, {type = ConfigsTypes.CONFIG_EQ, value = {x = 1, y = 2, z = 3}})

    processor:addPosition({x = 3, y = 2, z = 3})
    lu.assertEquals(processor.position, {type = ConfigsTypes.CONFIG_EQ, value = {x = 3, y = 2, z = 3}})

    processor:addPosition({x = 3, y = 2, z = 3}, ConfigsTypes.CONFIG_NEQ)
    lu.assertEquals(processor.position, {type = ConfigsTypes.CONFIG_NEQ, value = {x = 3, y = 2, z = 3}})
end

function test_PlayerProcessingConfigs_AddCallback()
    local cb = function () return "test" end
    local processor = PlayerProcessingConfigs:new({}):addCallback(cb)
    lu.assertEquals(processor.callbacks[1], cb)

    cb = function () return "test_2" end
    processor:addCallback(cb)
    lu.assertEquals(processor.callbacks[2], cb)

    lu.assertEquals(processor.callbacks[1](), "test")
    lu.assertEquals(processor.callbacks[2](), "test_2")
end

function test_PlayerProcessingConfigs_ProcessingValidation()
    local processor = PlayerProcessingConfigs:new()
                         :addAmount(10)
                         :addPosition(123)
                         :addStorage(2173, 1)
                         :addItem(2173, 1)
                         :addCallback(function () return true end)

    local validPlayer = FakePlayer:new({
        storageValue = { [2173] = 1 },
        itemCount = { [2173] = 1 },
        position = 123,
        totalMoney = 11
    })

    lu.assertIsTrue(processor:validate(validPlayer))

    local invalidPlayer = FakePlayer:new({
        storageValue = { [2173] = 0 },
        itemCount = { [2173] = 0 },
        position = 125,
        totalMoney = 10
    })
    lu.assertIsFalse(processor:validate(invalidPlayer))
end