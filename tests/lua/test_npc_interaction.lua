function test_NpcInteraction_EmptyConstructor()
    local interaction = NpcInteraction:new()
    lu.assertEquals(interaction.parent, nil)
    lu.assertEquals(interaction.children, {})
    lu.assertEquals(interaction.keywords, {})

    lu.assertIsTrue(getmetatable(interaction.messages) == NpcMessages)
    lu.assertIsTrue(getmetatable(interaction.topic) == NpcTopic)

    lu.assertNotIsNil(interaction.onInitPlayerProcessors)
    lu.assertEquals(interaction.onInitPlayerProcessors.validators, {})
    lu.assertEquals(interaction.onInitPlayerProcessors.updaters, {})

    lu.assertNotIsNil(interaction.onCompletePlayerProcessors)
    lu.assertEquals(interaction.onCompletePlayerProcessors.validators, {})
    lu.assertEquals(interaction.onCompletePlayerProcessors.updaters, {})

    lu.assertIsTrue(getmetatable(interaction) == NpcInteraction)
end

function test_NpcInteraction_ConstructorParameters()
    local keywords = {"hi", "hello"}

    local messages = {
        reply = "Fuck you man!",
        confirmation = "Hmm, you were wise in confirm!",
        cancellation = "You Bastard..",
        cannotExecute = "You're joking, ehn?",
    }

    local topic = {
        current = 123,
        previous = 255,
    }

    local interaction = NpcInteraction:new(keywords, messages, topic)

    lu.assertEquals(interaction.keywords, keywords)
    lu.assertMessages(interaction.messages, messages)
    lu.assertTopic(interaction.topic, topic)

    lu.assertIsTrue(getmetatable(interaction.messages) == NpcMessages)
    lu.assertIsTrue(getmetatable(interaction.topic) == NpcTopic)
end

function test_NpcInteraction_AddSubInteraction()
    local interaction = NpcInteraction:new({"parent"})
    local subInteraction1 = NpcInteraction:new({"sub_interaction_1"})
    local subInteraction2 = NpcInteraction:new({"sub_interaction_2"})

    interaction:addSubInteraction(subInteraction1)
    interaction:addSubInteraction(subInteraction2)
    interaction:addSubInteraction()
    interaction:addSubInteraction({})

    lu.assertEquals(#interaction.children, 2)
    lu.assertEquals(interaction.children[1].keywords, {"sub_interaction_1"})
    lu.assertEquals(interaction.children[2].keywords, {"sub_interaction_2"})

    lu.assertEquals(subInteraction2.parent.interaction.keywords, subInteraction1.parent.interaction.keywords)

    lu.assertEquals(subInteraction1.parent.interaction.keywords, {"parent"})
    lu.assertIsTrue(getmetatable(subInteraction1.parent.interaction) == NpcInteraction)
end

function test_NpcInteraction_AddInitValidationProcessor()
    local interaction = NpcInteraction:new()
    interaction:addInitValidationProcessor(PlayerProcessingConfigs:new():addAmount(25123))
    interaction:addInitValidationProcessor(PlayerProcessingConfigs:new():addAmount(0))
    interaction:addInitValidationProcessor()
    interaction:addInitValidationProcessor({})

    lu.assertEquals(#interaction.onInitPlayerProcessors.validators, 2)
    lu.assertEquals(interaction.onInitPlayerProcessors.validators[1].moneyAmount.value, 25123)
    lu.assertEquals(interaction.onInitPlayerProcessors.validators[2].moneyAmount.value, 0)

end

function test_NpcInteraction_AddInitUpdateProcessor()
    local interaction = NpcInteraction:new()
    interaction:addInitUpdateProcessor(PlayerProcessingConfigs:new():addAmount(25120))
    interaction:addInitUpdateProcessor(PlayerProcessingConfigs:new():addAmount(0))
    interaction:addInitUpdateProcessor()
    interaction:addInitUpdateProcessor({})

    lu.assertEquals(#interaction.onInitPlayerProcessors.updaters, 2)
    lu.assertEquals(interaction.onInitPlayerProcessors.updaters[1].moneyAmount.value, 25120)
    lu.assertEquals(interaction.onInitPlayerProcessors.updaters[2].moneyAmount.value, 0)
end

function test_NpcInteraction_AddCompletionValidationProcessor()
    local interaction = NpcInteraction:new()
    interaction:addCompletionValidationProcessor(PlayerProcessingConfigs:new():addAmount(25121))
    interaction:addCompletionValidationProcessor(PlayerProcessingConfigs:new():addAmount(0))
    interaction:addCompletionValidationProcessor()
    interaction:addCompletionValidationProcessor({})

    lu.assertEquals(#interaction.onCompletePlayerProcessors.validators, 2)
    lu.assertEquals(interaction.onCompletePlayerProcessors.validators[1].moneyAmount.value, 25121)
    lu.assertEquals(interaction.onCompletePlayerProcessors.validators[2].moneyAmount.value, 0)
end

function test_NpcInteraction_AddCompletionUpdateProcessor()
    local interaction = NpcInteraction:new()
    interaction:addCompletionUpdateProcessor(PlayerProcessingConfigs:new():addAmount(25122))
    interaction:addCompletionUpdateProcessor(PlayerProcessingConfigs:new():addAmount(0))
    interaction:addCompletionUpdateProcessor()
    interaction:addCompletionUpdateProcessor({})

    lu.assertEquals(#interaction.onCompletePlayerProcessors.updaters, 2)
    lu.assertEquals(interaction.onCompletePlayerProcessors.updaters[1].moneyAmount.value, 25122)
    lu.assertEquals(interaction.onCompletePlayerProcessors.updaters[2].moneyAmount.value, 0)
end

function test_NpcInteraction_HasMessageValidKeyword()
    local interaction = NpcInteraction:new({"donuts", "somoha", "brazil"})
    lu.assertIsTrue(interaction:hasMessageValidKeyword("I love donuts bro, lets eat it"))
    lu.assertIsTrue(interaction:hasMessageValidKeyword("Don't you dare going to somoha"))
    lu.assertIsTrue(interaction:hasMessageValidKeyword("Waaait! Brazil? Noooo"))

    lu.assertIsFalse(interaction:hasMessageValidKeyword("I love donut bro, lets eat it"))
    lu.assertIsFalse(interaction:hasMessageValidKeyword("Don't you dare going to s omoha"))
    lu.assertIsFalse(interaction:hasMessageValidKeyword("Waaait! Brzil? Noooo"))
    lu.assertIsFalse(interaction:hasMessageValidKeyword(""))

end

function test_NpcInteraction_UpdatePlayerInteraction()
    local player = FakePlayer:new()
    local npc = FakeNpc:new()

    lu.assertIsNil(player.topic)

    local interaction = NpcInteraction:new({}, {}, {current = 5})
    interaction:updatePlayerInteraction(player, npc)
    lu.assertEquals(player.topic, 5)

    local interaction = NpcInteraction:new({}, {}, {current = 3})
    interaction:updatePlayerInteraction(player, npc)
    lu.assertEquals(player.topic, 3)

    local interaction = NpcInteraction:new({}, {}, {current = -1})
    interaction:updatePlayerInteraction(player, npc)
    lu.assertIsNil(player.topic)
end

function test_NpcInteraction_RunOnInitPlayerProcessors()
    local player = FakePlayer:new()
    local interaction = NpcInteraction:new()
    local call = 0

    local updateProcessor = PlayerProcessingConfigs:new()
    local validationProcessor = PlayerProcessingConfigs:new()

    updateProcessor.update = function()
        call = call + 1
    end

    validationProcessor.validate = function()
        call = call + 1
        return true
    end

    interaction:addInitUpdateProcessor(updateProcessor)
    interaction:addInitValidationProcessor(validationProcessor)

    lu.assertIsTrue(interaction:runOnInitPlayerProcessors(player))
    lu.assertEquals(call, 2)
end

function test_NpcInteraction_RunOnInitPlayerProcessorsReturnFalseForFailedValidations()
    local player = FakePlayer:new()
    local interaction = NpcInteraction:new()
    local call = 0

    local updateProcessor = PlayerProcessingConfigs:new()
    local validationProcessor = PlayerProcessingConfigs:new()

    updateProcessor.update = function()
        call = call + 1
    end

    validationProcessor.validate = function()
        call = call + 1
        return false
    end

    interaction:addInitUpdateProcessor(updateProcessor)
    interaction:addInitValidationProcessor(validationProcessor)

    lu.assertIsFalse(interaction:runOnInitPlayerProcessors(player))
    lu.assertEquals(call, 1)
end

function test_NpcInteraction_RunOnCompletePlayerProcessors()
    local player = FakePlayer:new()
    local interaction = NpcInteraction:new()
    local call = 0

    local updateProcessor = PlayerProcessingConfigs:new()
    local validationProcessor = PlayerProcessingConfigs:new()

    updateProcessor.update = function()
        call = call + 1
    end

    validationProcessor.validate = function()
        call = call + 1
        return true
    end

    interaction:addCompletionUpdateProcessor(updateProcessor)
    interaction:addCompletionValidationProcessor(validationProcessor)

    lu.assertIsTrue(interaction:runOnCompletePlayerProcessors(player))
    lu.assertEquals(call, 2)
end

function test_NpcInteraction_RunOnCompletePlayerProcessorsReturnFalseForFailedValidations()
    local player = FakePlayer:new()
    local interaction = NpcInteraction:new()
    local call = 0

    local updateProcessor = PlayerProcessingConfigs:new()
    local validationProcessor = PlayerProcessingConfigs:new()

    updateProcessor.update = function()
        call = call + 1
    end

    validationProcessor.validate = function()
        call = call + 1
        return false
    end

    interaction:addCompletionUpdateProcessor(updateProcessor)
    interaction:addCompletionValidationProcessor(validationProcessor)

    lu.assertIsFalse(interaction:runOnCompletePlayerProcessors(player))
    lu.assertEquals(call, 1)
end

function test_NpcInteraction_GetValidNpcInteractionForMessage()
    local player = FakePlayer:new({topic = 1})
    local npc = FakeNpc:new()

    local interaction = NpcInteraction:new({"parent"}, {}, {current = 1})
    local subInteraction = NpcInteraction:new({"child"}, {}, {current = 2, previous = 1})
    local subInteraction2 = NpcInteraction:new({"another"}, {}, {current = 1, previous = 3})
    local subInteraction3 = NpcInteraction:new({"empty"})

    interaction:addSubInteraction(subInteraction):addSubInteraction(subInteraction2):addSubInteraction(subInteraction3)

    lu.assertEquals(interaction:getValidNpcInteractionForMessage("has parent", npc, player), interaction)
    lu.assertEquals(interaction:getValidNpcInteractionForMessage("has child", npc, player), subInteraction)

    lu.assertEquals(interaction:getValidNpcInteractionForMessage("has another", npc, player), nil)
    lu.assertEquals(interaction:getValidNpcInteractionForMessage("has empty", npc, player), nil)
end

function test_NpcInteraction_IsValidSubInteraction()
    lu.assertIsTrue(NpcInteraction:isValidSubInteraction(NpcInteraction:new()))
    lu.assertIsFalse(NpcInteraction:isValidSubInteraction())
    lu.assertIsFalse(NpcInteraction:isValidSubInteraction({}))
end

function test_NpcInteraction_IsValidProcessor()
    lu.assertIsTrue(NpcInteraction:isValidProcessor(PlayerProcessingConfigs:new()))
    lu.assertIsFalse(NpcInteraction:isValidProcessor())
    lu.assertIsFalse(NpcInteraction:isValidProcessor({}))
end

function test_NpcInteraction_ExecuteWithNoKeywordDoesNotUpdateTopic()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()

    lu.assertEquals(player.topic, 0)
    NpcInteraction:new({"valid"}, {}, {current = 2, previous = 0}):execute("invalid", player, npc)

    lu.assertEquals(player.topic, 0)
end

function test_NpcInteraction_ExecuteWithInvalidTopicDoesNotUpdateTopic()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()

    lu.assertEquals(player.topic, 0)
    NpcInteraction:new({"valid"}, {}, {current = 2, previous = 1}):execute("valid", player, npc)

    lu.assertEquals(player.topic, 0)
end

function test_NpcInteraction_ValidExecuteUpdatesTopic()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()

    lu.assertEquals(player.topic, 0)
    NpcInteraction:new({"valid"}, {}, {current = 2, previous = 0}):execute("valid", player, npc)

    lu.assertEquals(player.topic, 2)
end

function test_NpcInteraction_ValidExecuteRunProcessors()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()
    local call = 0

    function npc:isPlayerInteractingOnTopic(player, topic)
        call = call + 1
        return FakeNpc:isPlayerInteractingOnTopic(player, topic)
    end

    function npc:setPlayerInteraction(player, topic)
        call = call + 1
        FakeNpc:setPlayerInteraction(player, topic)
    end

    local interaction = NpcInteraction:new({"valid"}, {}, {current = 2, previous = 0})

    interaction.runOnCompletePlayerProcessors = function()
        call = call + 1
    end

    interaction.runOnInitPlayerProcessors = function()
        call = call + 1
        return true
    end

    lu.assertEquals(call, 0)
    lu.assertEquals(player.topic, 0)
    interaction:execute("valid", player, npc)

    lu.assertEquals(call, 4)
    lu.assertEquals(player.topic, 2)
end

function test_NpcInteraction_ValidExecuteWithFailedValidationDoesntTriggerUpdates()
    local player = FakePlayer:new({topic = 1})
    local npc = FakeNpc:new()
    local call = 0

    function npc:isPlayerInteractingOnTopic(player, topic)
        call = call + 1
        return FakeNpc:isPlayerInteractingOnTopic(player, topic)
    end

    function npc:setPlayerInteraction(player, topic)
        call = call + 1
        FakeNpc:setPlayerInteraction(player, topic)
    end

    local interaction = NpcInteraction:new({"valid"}, {}, {current = 2, previous = 10})

    interaction.runOnCompletePlayerProcessors = function()
        call = call + 1
    end

    interaction.runOnInitPlayerProcessors = function()
        call = call + 1
        return false
    end

    lu.assertEquals(call, 0)
    lu.assertEquals(player.topic, 1)
    interaction:execute("valid", player, npc)

    lu.assertEquals(call, 1)
    lu.assertEquals(player.topic, 1)
end

function test_NpcInteraction_ValidExecuteWithChildRunOnlyInitProcessors()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()
    local call = 0

    local interaction = NpcInteraction:new({"valid"}, {}, {current = 2, previous = 0})

    interaction.runOnCompletePlayerProcessors = function()
        call = call + 1
    end

    interaction.runOnInitPlayerProcessors = function()
        call = call + 1
        return true
    end

    local child = NpcInteraction:new()
    local callChild = 0
    function child:execute()
        callChild = callChild + 1
    end
    interaction:addSubInteraction(child)

    lu.assertEquals(call, 0)
    lu.assertEquals(callChild, 0)
    lu.assertEquals(player.topic, 0)
    interaction:execute("valid", player, npc)

    lu.assertEquals(call, 1)
    lu.assertEquals(callChild, 0)
    lu.assertEquals(player.topic, 2)
end

function test_NpcInteraction_ValidChildExecuteRunsParentCompleteProcessor()
    local player = FakePlayer:new({topic = 0})
    local npc = FakeNpc:new()
    local call = 0

    local interaction = NpcInteraction:new({"valid"}, {}, {current = 2, previous = 0})

    interaction.runOnCompletePlayerProcessors = function()
        call = call + 1
    end

    interaction.runOnInitPlayerProcessors = function()
        call = call + 1
        return true
    end

    local parent = NpcInteraction:new()
    parent:addSubInteraction(interaction)

    local callParent = 0
    parent.runOnCompletePlayerProcessors = function()
        callParent = callParent + 1
    end

    parent.runOnInitPlayerProcessors = function()
        callParent = callParent + 1
        return true
    end

    lu.assertEquals(call, 0)
    lu.assertEquals(callParent, 0)
    lu.assertEquals(player.topic, 0)
    interaction:execute("valid", player, npc)

    lu.assertEquals(call, 2)
    lu.assertEquals(callParent, 1)
    lu.assertEquals(player.topic, 2)
end