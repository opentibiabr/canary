local npcType = Game.createNpcType("Captain Bluebear")
local npcConfig = {}

npcConfig.description = "Captain Bluebear"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 0

npcConfig.outfit = {
    lookType = 129,
    lookHead = 19,
    lookBody = 69,
    lookLegs = 125,
    lookFeet = 50,
    lookAddons = 0
}

npcConfig.voices = {
    interval = 2000,
    chance = 20,
    { text = 'Passages to Carlin, Ab\'Dendriel, Edron, Venore, Port Hope, Liberty Bay, Yalahar, Roshamuul, Krailos, Oramond and Svargrond.' }
}

npcConfig.flags = {
    floorchange = false
}

local travelMessages = {
    reply = "Do you seek a passage to %s for %s?",
    confirmation = "Set the sails!",
    cancellation = "We would like to serve you some time.",
    cannotExecute = "I'm sorry but I don't sail there."
}

local replyInteractions = {
    NpcInteraction:createGreetInteraction("Welcome on board %s, Where can I {sail} you today?"),
    NpcInteraction:createReplyInteraction({"name"}, "My name is Captain Bluebear from the Royal Tibia Line."),
    NpcInteraction:createReplyInteraction({"job", "captain"}, "I am the captain of this sailing-ship."),
    NpcInteraction:createReplyInteraction({"ship", "line", "company", "tibia"}, "The Royal Tibia Line connects all seaside towns of Tibia."),
    NpcInteraction:createReplyInteraction({"good"}, "We can transport everything you want."),
    NpcInteraction:createReplyInteraction({"passenger"}, ""),
    NpcInteraction:createReplyInteraction({"trip", "route", "passage", "town", "destination", "sail", "go"}, "Where do you want to go? To {Carlin}, {Ab\'Dendriel}, {Venore}, {Port Hope}, {Liberty Bay}, {Svargrond}, {Yalahar}, {Roshamuul}, {Oramond} or {Edron}?"),
    NpcInteraction:createReplyInteraction({"ice", "senja", "folda", "vega"}, "I\'m sorry, but we don\'t serve the routes to the Ice Islands."),
    NpcInteraction:createReplyInteraction({"darashia", "darama"}, "I\'m not sailing there. This route is afflicted by a ghostship! However I\'ve heard that Captain Fearless from Venore sails there."),
    NpcInteraction:createReplyInteraction({"ghost"}, "Many people who sailed to Darashia never returned because they were attacked by a ghostship! I\'ll never sail there!"),
    NpcInteraction:createReplyInteraction({"thais"}, "This is Thais. Where do you want to go?"),
    NpcInteraction:createFarewellInteraction("Good bye %s. Recommend us if you were satisfied with our service."),
}

local destinations = {
    -- TODO: Create TravelConfig class
    { town = "carlin", baseCost = 110, position = Position(32387, 31820, 6), discounts = 'postman',
        completionUpdaters = {
            PlayerProcessingConfigs:new()
                :addCallback(
                  function(player)
                      --[[
                            we can simplify this by adding "validations" attribute
                            to the player processing that will make the processor only execute
                            if they run successfully. This is useful since we use this kind of
                            conditional updates everywhere.

                            e.g.
                            completionUpdaters = {
                                PlayerProcessingConfigs:new():addValidation(
                                    PlayerProcessingConfigs:new():addStorage(Storage.Postman.Mission01, 1)
                                ):addStorage(Storage.Postman.Mission01, 2)
                            }
                      ]]--
                      if player:getStorageValue(Storage.Postman.Mission01) == 1 then
                          player:setStorageValue(Storage.Postman.Mission01, 2)
                      end
                end
                )
    }},
    { town = "ab'dendriel", baseCost = 130, position = Position(32734, 31668, 6), discounts = 'postman' },
    { town = "edron", baseCost = 160, position = Position(33175, 31764, 6), discounts = 'postman' },
    { town = "venore", baseCost = 170, position = Position(32954, 32022, 6), discounts = 'postman' },
    { town = "port hope", baseCost = 160, position = Position(32527, 32784, 6), discounts = 'postman' },
    { town = "roshamuul", baseCost = 210, position = Position(33494, 32567, 7), discounts = 'postman' },
    { town = "svargrond", baseCost = 180, position = Position(32341, 31108, 6), discounts = 'postman' },
    { town = "liberty bay", baseCost = 180, position = Position(32285, 32892, 6), discounts = 'postman' },
    { town = "oramond", baseCost = 150, position = Position(33479, 31985, 7), discounts = 'postman' },
    { town = "krailos", baseCost = 230, position = Position(33492, 31712, 6), discounts = 'postman' },
    { town = "yalahar", baseCost = 200, position = Position(32816, 31272, 6), discounts = 'postman',
        completionValidations = {
            PlayerProcessingConfigs:new()
                :addStorage(Storage.SearoutesAroundYalahar.Thais, 1, ConfigsTypes.CONFIG_NEQ)
                :addStorage(Storage.SearoutesAroundYalahar.TownsCounter, 4, ConfigsTypes.CONFIG_LTE)
        }
    },
}

local getTravelInteractions = function (player, destinations, baseMessages)
    local travelInteractions = {}

    for index, travelConfigs in pairs(destinations) do
        travelInteractions[#travelInteractions + 1] = NpcInteraction:createTravelInteraction(player, travelConfigs, baseMessages, index)
    end

    return travelInteractions
end

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    local npcInteractions = table.concat(replyInteractions, getTravelInteractions(creature, destinations, travelMessages))
    return npc:processOnSay(message, creature, npcInteractions)
end

npcType:register(npcConfig)
