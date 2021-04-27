local npcType = Game.createNpcType("Black Bert")
local npcConfig = {}

npcConfig.description = "Black Bert"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 151,
    lookHead = 0,
    lookBody = 38,
    lookLegs = 19,
    lookFeet = 76,
    lookAddons = 0
}

npcConfig.flags = {
    floorchange = false
}

npcConfig.shop = {
    {clientId = 123, buy = 16000, sell = 16000, count = 1},
    {clientId = 130, buy = 100, count = 1},
    {clientId = 135, buy = 5000, count = 1},
    {clientId = 138, buy = 600, count = 1},
    {clientId = 141, buy = 2000, count = 1},
    {clientId = 142, buy = 6000, count = 1},
    {clientId = 349, buy = 15000, count = 1},
    {clientId = 396, buy = 5000, count = 1},
    {clientId = 406, buy = 15000, count = 1},
    {clientId = 3216, buy = 8000, count = 1},
    {clientId = 3217, buy = 8000, count = 1},
    {clientId = 3232, buy = 3000, count = 1},
    {clientId = 3233, buy = 16000, count = 1},
    {clientId = 3234, buy = 150, count = 1},
    {clientId = 4827, buy = 18000, count = 1},
    {clientId = 4832, buy = 24000, count = 1},
    {clientId = 4834, buy = 1000, count = 1},
    {clientId = 4835, buy = 8000, count = 1},
    {clientId = 4836, buy = 15000, count = 1},
    {clientId = 4841, buy = 3000, count = 1},
    {clientId = 4843, buy = 500, count = 1},
    {clientId = 4846, buy = 4000, count = 1},
    {clientId = 4847, buy = 6000, count = 1},
    {clientId = 5940, buy = 10000, count = 1},
    {clientId = 6124, buy = 40000, count = 1},
    {clientId = 7281, buy = 500, count = 1},
    {clientId = 7924, buy = 10000, count = 1},
    {clientId = 7936, buy = 7000, count = 1},
    {clientId = 8453, buy = 50000, count = 1},
    {clientId = 8746, buy = 50000, count = 1},
    {clientId = 8818, buy = 8000, count = 1},
    {clientId = 8822, buy = 20000, count = 1},
    {clientId = 9107, buy = 600, count = 1},
    {clientId = 9188, buy = 5000, count = 1},
    {clientId = 9191, buy = 5000, count = 1},
    {clientId = 9236, buy = 10000, count = 1},
    {clientId = 9237, buy = 12500, count = 1},
    {clientId = 9238, buy = 17000, count = 1},
    {clientId = 9239, buy = 12500, count = 1},
    {clientId = 9240, buy = 13000, count = 1},
    {clientId = 9241, buy = 10000, count = 1},
    {clientId = 9247, buy = 13500, count = 1},
    {clientId = 9248, buy = 12500, count = 1},
    {clientId = 9249, buy = 13000, count = 1},
    {clientId = 9251, buy = 8000, count = 1},
    {clientId = 9252, buy = 13000, count = 1},
    {clientId = 9255, buy = 25000, count = 1},
    {clientId = 9308, buy = 5250, count = 1},
    {clientId = 9390, buy = 8500, count = 1},
    {clientId = 9391, buy = 10000, count = 1},
    {clientId = 9537, buy = 350, count = 1},
    {clientId = 9696, buy = 1000, count = 1},
    {clientId = 9698, buy = 1000, count = 1},
    {clientId = 9699, buy = 1000, count = 1},
    {clientId = 10009, buy = 700, count = 1},
    {clientId = 10011, buy = 650, count = 1},
    {clientId = 10025, buy = 600, count = 1},
    {clientId = 10028, buy = 666, count = 1},
    {clientId = 10183, buy = 1000, count = 1},
    {clientId = 10187, buy = 1000, count = 1},
    {clientId = 10189, buy = 1000, count = 1},
    {clientId = 11329, buy = 1000, count = 1},
    {clientId = 11339, buy = 550, count = 1},
    {clientId = 11341, buy = 1000, count = 1},
    {clientId = 11544, buy = 600, count = 1},
    {clientId = 11545, buy = 4000, count = 1},
    {clientId = 11546, buy = 4000, count = 1},
    {clientId = 11547, buy = 4000, count = 1},
    {clientId = 11548, buy = 4000, count = 1},
    {clientId = 11549, buy = 4000, count = 1},
    {clientId = 11550, buy = 4000, count = 1},
    {clientId = 11551, buy = 4000, count = 1},
    {clientId = 11552, buy = 4000, count = 1},
    {clientId = 13974, buy = 5000, count = 1},
    {clientId = 31414, buy = 50000, count = 1},
    {clientId = 31447, buy = 5000, count = 1}
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onPlayerBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
    npc:doSellItem(player, itemId, amount, subType, true, inBackpacks, 1988)
    npc:talk(player, string.format("You've bought %i %s for %i", amount, name, totalCost))
end

npcType.onPlayerSellItem = function(npc, player, amount, name, totalCost, clientId)
    npc:talk(player, string.format("You've sold %i %s for %i", amount, name, totalCost))
end

npcType.onPlayerCheckItem = function(npc, player, itemId)
end

local interactions = {
    NpcInteraction:createGreetInteraction("Hi there, %s! You look like you are eager to {trade}!"),
    NpcInteraction:new(
            {"trade"},
            {
                cannotExecute = "I don't know you and I don't have any dealings with people whom I don't trust."
            }
    ):addCompletionValidationProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.ThievesGuild.Mission08, 3)
        )
    :addCompletionUpdateProcessor(
    PlayerProcessingConfigs:new()
       :addCallback(function (player, npc) npc:openShopWindow(player, 0) end)
    ),
    NpcInteraction:createFarewellInteraction()
        :addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new()
           :addCallback(function (player, npc) npc:closeShopWindow(player, 0) end)
    ),
}

npcType.onSay = function(npc, creature, type, message)
    return npc:processOnSay(message, creature, interactions)
end

npcType:register(npcConfig)