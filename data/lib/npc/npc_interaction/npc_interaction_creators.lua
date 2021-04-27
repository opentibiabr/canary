function NpcInteraction:createGreetInteraction(message, keywords)
    return NpcInteraction:new(
        keywords or {"hi", "hello"},
        {reply = message or "Hello, %s, what you need?"},
        {previous = -1}
    )
end

function NpcInteraction:createFarewellInteraction(message, keywords)
    return NpcInteraction:new(
        keywords or {"bye", "farewell"},
        {reply = message or "Goodbye, %s."},
        {current = -1}
    )
end

function NpcInteraction:createReplyInteraction(keywords, message, topic)
    return NpcInteraction:new(
        keywords,
        {reply = message},
        topic
    )
end

function NpcInteraction:createConfirmationInteraction(keywords, messages, childTopic)
    return NpcInteraction:new(
            keywords,
            messages,
            {current = childTopic, previous = 0}
    ):addSubInteraction(
            NpcInteraction:createReplyInteraction( {"yes"}, nil, {current = 0, previous = childTopic})
    ):addSubInteraction(
            NpcInteraction:createReplyInteraction( {"no"},nil, {current = 0, previous = childTopic}),
            InteractionRelationType.RELATION_CANCELLATION
    )
end

function NpcInteraction:createTravelInteraction(player, travelConfigs, baseMessages, travelTopic)
    local cost = player and player:calculateTravelPrice(travelConfigs.baseCost, travelConfigs.discounts or {}) or travelConfigs.baseCost

    -- its nice to keep validators separated, we can later on add failure message per validator when it fails
    local travelValidators = travelConfigs.completionValidations or {}
    travelValidators[#travelValidators + 1] = PlayerProcessingConfigs:new():addAmount(cost)
    travelValidators[#travelValidators + 1] = PlayerProcessingConfigs:new():addStorage(Storage.NpcExhaust, os.time(), ConfigsTypes.CONFIG_LTE)
    --:addPremium(travelConfig.premium or true)
    --:addLevel(travelConfig.level)
    --:addProtectionZone(true)
    --:addProtectionZone(true)

    local travelUpdaters = travelConfigs.completionUpdaters or {}
    travelUpdaters[#travelUpdaters + 1] = PlayerProcessingConfigs:new()
                                           :addPosition(travelConfigs.position)
                                           :removeAmount(cost)
                                           :addStorage(Storage.NpcExhaust, 3 + os.time())
                                           :addCallback(
                                            function(player)
                                                   player:getPosition():sendMagicEffect(travelConfigs.effect or CONST_ME_TELEPORT)
                                                   addEvent(function () travelConfigs.position:sendMagicEffect(travelConfigs.effect or CONST_ME_TELEPORT) end, 100)
                                               end
                                           )

    -- this is some quest weirdness, probably can be encapsulated somewhere else later
    travelUpdaters[#travelUpdaters + 1] = PlayerProcessingConfigs:new()
                                             :addCallback(
                                            function(player)
                                                    if travelConfigs.town == "kazordoon" and player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer) > os.time() then
                                                        player:setStorageValue(Storage.WhatAFoolish.PieBoxTimer, 1)
                                                    end
                                                end
                                            )

    return NpcInteraction:createConfirmationInteraction(
            {travelConfigs.town},
            {
                reply = buildTravelMessage(baseMessages.reply, travelConfigs.town, cost),
                confirmation = baseMessages.confirmation,
                cancellation = baseMessages.cancellation,
                cannotExecute = baseMessages.cannotExecute,
            },
            travelTopic
    ):addCompletionValidationProcessors(travelValidators)
    :addCompletionUpdateProcessors(travelUpdaters)
end