function test_PlayerValidator_InvalidNilConstructorThrows()
    lu.assertErrorMsgContains(
        'PlayerValidator needs a valid player to run',
        function () PlayerValidator(self, nil) end
    )
end

function test_PlayerValidator_InvalidNonPlayerConstructorThrows()
    lu.assertErrorMsgContains(
        'attempt to call method \'isPlayer\' (a nil value)',
        function () PlayerValidator(self, {}) end
    )
end

function test_PlayerUpdater_EmptyValidatorReturnsTrue()
    lu.assertIsTrue(
        PlayerValidator(PlayerProcessingConfigs:new(), FakePlayer:new())
    )
end

function test_PlayerUpdater_ValidateMoney()
    local player = FakePlayer:new({totalMoney = 12})
    local processor = PlayerProcessingConfigs:new()

    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addAmount(11)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addAmount(1)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addAmount(1)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor:addAmount(120)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor:removeAmount(1305)
    lu.assertIsTrue(PlayerValidator(processor, player))
end

function test_PlayerUpdater_ValidatePosition()
    local player = FakePlayer:new({position = 123})
    local processor = PlayerProcessingConfigs:new():addPosition(123)

    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addPosition(321)
    lu.assertIsFalse(PlayerValidator(processor, player))
end

function test_PlayerUpdater_ValidateItems()
    local player = FakePlayer:new({itemCount = { [2173] = 1, [1732] = 9, [1515] = 0}})
    local processor = PlayerProcessingConfigs:new()
                         :addItem(2173, 1)
                         :addItem(1732, 9)

    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addItem(1515, 0)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addItem(1732, 90)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor:addItem(1732, -99)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addItem(2173, 3)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor:addItem(2173, -3):addItem(1515, 1)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor:addItem(1515, -1)
    lu.assertIsTrue(PlayerValidator(processor, player))
end

function test_PlayerUpdater_ValidateStorages()
    local player = FakePlayer:new({storageValue = { [2173] = 1, [1732] = 9, [1515] = 0}})
    local processor = PlayerProcessingConfigs:new()
                         :addStorage(2173, 1)
                         :addStorage(1732, 9)
                         :addStorage(1515, 0)

    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new():addStorage(2173, 1)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new():addStorage(1732, 9)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new():addStorage(1515, 0)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 1)
                   :addStorage(1732, 9)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(1732, 9)
                   :addStorage(1515, 0)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 1)
                   :addStorage(1515, 0)
    lu.assertIsTrue(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 1)
                   :addStorage(1732, 9)
                   :addStorage(1515, 0)
                   :addStorage(1516, 1)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 0)
                   :addStorage(1732, 9)
                   :addStorage(1515, 0)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 1)
                   :addStorage(1732, 0)
                   :addStorage(1515, 0)
    lu.assertIsFalse(PlayerValidator(processor, player))

    processor = PlayerProcessingConfigs:new()
                   :addStorage(2173, 1)
                   :addStorage(1732, 9)
                   :addStorage(1515, 1)
    lu.assertIsFalse(PlayerValidator(processor, player))
end

function test_PlayerUpdater_ValidateCallbacks()
    local player = FakePlayer:new({storageValue = { [2173] = 1, [1732] = 9, [1515] = 0}})
    local processor = PlayerProcessingConfigs:new()
                        :addCallback(function () return true end)
                        :addCallback(function () return true end)

    lu.assertIsTrue(PlayerValidator(processor, player))

    processor:addCallback(function () return false end)
    lu.assertIsFalse(PlayerValidator(processor, player))
end