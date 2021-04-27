local npcType = Game.createNpcType("A Beggar")
local npcConfig = {} 

npcConfig.description = "A Beggar"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 153,
    lookHead = 39,
    lookBody = 39,
    lookLegs = 39,
    lookFeet = 76,
    lookAddons = 0
}

npcConfig.flags = {
    hostile = false,
    floorchange = false
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

local interactions = {
    NpcInteraction:createGreetInteraction("Hi %s! What is it, what d'ye {want}?")
        :addInitValidationProcessor(
            PlayerProcessingConfigs:new()
               :addStorage(Storage.DarkTrails.Mission01, 1)
        ),
    NpcInteraction:createGreetInteraction()
        :addInitValidationProcessor(
            PlayerProcessingConfigs:new()
               :addStorage(Storage.DarkTrails.Mission01, 2)
        ),
    NpcInteraction:new(
            {"want"},
            {
                reply = "The guys from the magistrate sent you here, didn't they?",
                confirmation = {
                    "Thought so. You'll have to talk to the king though. The beggar king that is. The king does not grant an audience to just everyone. You know how those kings are, don't you? ... ",
                    "However, to get an audience with the king, you'll have to help his subjects a bit. ... ",
                    "His subjects that would be us, the poor, you know? ... ",
                    "So why don't you show your dedication to the poor? Go and help Chavis at the poor house. He's collecting food for people like us. ... ",
                    "If you brought enough of the stuff you'll see that the king will grant you entrance in his {palace}."
                },
            },
            {current = 1, previous = 0}
    ):addSubInteraction(
            NpcInteraction:createReplyInteraction(
                {"yes"},
                nil,
                    {current = 0, previous = 1}
            ):addCompletionUpdateProcessor(
                    PlayerProcessingConfigs:new()
                        :addStorage(Storage.DarkTrails.Mission01, 2)
                        :addStorage(Storage.DarkTrails.Mission02, 1)
            )
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.DarkTrails.Mission01, 1)
    ),
    NpcInteraction:createFarewellInteraction(),
}

npcType.onSay = function(npc, creature, type, message)
    return npc:processOnSay(message, creature, interactions)
end

npcType:register(npcConfig)
