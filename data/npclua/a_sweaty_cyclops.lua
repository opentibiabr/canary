local npcType = Game.createNpcType("A Sweaty Cyclops")
local npcConfig = {}

npcConfig.description = "A Sweaty Cyclops"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 0

npcConfig.outfit = { lookType = 22 }

npcConfig.voices = {
    interval = 2000,
    chance = 20,
    { text = 'Hum hum, huhum' },
    { text = 'Silly lil\' human' },
}

npcConfig.flags = {
    floorchange = false
}

local craftConfigs = {
    ["uth'kean"] = { item = 2487, metal = 5887, message = "Very noble. Shiny. Me like. But breaks so fast. Me can make from shiny armour. Lil' one want to trade?" },
    ["uth'lokr"] = { item = 2516, metal = 5889, message = "Firy steel it is. Need green ones' breath to melt. Or red even better. Me can make from shield. Lil' one want to trade?" },
    ["uth'prta"] = { item = 2393, metal = 5892, message = "Good iron is. Me friends use it much for fight. Me can make from weapon. Lil' one want to trade?" },
    ["za'ralator"] = { item = 2462, metal = 5888, message = "Hellsteel is. Cursed and evil. Dangerous to work with. Me can make from evil helmet. Lil' one want to trade?" },
    ["soul orb"] = { item = 5944, metal = 6529, message = "Uh. Me can make some nasty lil' bolt from soul orbs. Lil' one want to trade all?" },
}

local getCraftInteractions = function (craftConfigs)
    local craftInteractions = {}
    local topic = 4

    for index, craftConfig in pairs(craftConfigs) do
        craftInteractions[#craftInteractions + 1] = NpcInteraction:createReplyInteraction(
            {index}, craftConfig.message, {current = 1, previous = 0}
        ):addInitValidationProcessor(
            PlayerProcessingConfigs:new():addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 0, ConfigsTypes.CONFIG_LTE)
        )

        if index ~= "soul orb" then
            craftInteractions[#craftInteractions + 1] = NpcInteraction:createConfirmationInteraction(
                {index},
                {
                    reply = craftConfig.message,
                    confirmation = "Cling clang!",
                },
                topic
            ):addInitValidationProcessor(
                PlayerProcessingConfigs:new()
                   :addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 2)
            ):addCompletionValidationProcessor(
                PlayerProcessingConfigs:new():addItem(craftConfig.item, 1)
            ):addCompletionUpdateProcessor(
                PlayerProcessingConfigs:new():addItem(craftConfig.item, -1):addItem(craftConfig.metal, 1)
            )

            topic = topic + 1
        end
    end

    return craftInteractions
end

local interactions = {
    NpcInteraction:createGreetInteraction("Hum Humm! Welcume lil' %s"),
    NpcInteraction:createReplyInteraction({'job'}, "I am smith."),
    NpcInteraction:createReplyInteraction({'smith'}, "Working steel is my profession."),
    NpcInteraction:createReplyInteraction({'steel'}, "Manny kinds of. Like {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Morc}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, and {Zatragil}."),
    NpcInteraction:createReplyInteraction({'zatragil'}, "Most ancients use dream silver for different stuff. Now ancients most gone. Most not know about."),
    NpcInteraction:createReplyInteraction({'uth\'doon'}, "It's high steel called. Only lil' lil' ones know how make."),
    NpcInteraction:createReplyInteraction({'za\'kalortith'}, "It's evil. Demon iron is. No good cyclops goes where you can find and need evil flame to melt."),
    NpcInteraction:createReplyInteraction({'mesh kaha rogh'}, "Steel that is singing when forged. No one knows where find today."),
    NpcInteraction:createReplyInteraction({'uth\'byth'}, "Not good to make stuff off. Bad steel it is. But eating magic, so useful is."),
    NpcInteraction:createReplyInteraction({'uth\'maer'}, "Brightsteel is. Much art made with it. Sorcerers too lazy and afraid to enchant much."),
    NpcInteraction:createReplyInteraction({'uth\'amon'}, "Heartiron from heart of big old mountain, found very deep. Lil' lil ones fiercely defend. Not wanting to have it used for stuff but holy stuff."),
    NpcInteraction:createReplyInteraction({'ab\'dendriel'}, "Me parents live here before town was. Me not care about lil' ones."),
    NpcInteraction:createReplyInteraction({'lil\' lil\''}, "Lil' lil' ones are so fun. We often chat."),
    NpcInteraction:createReplyInteraction({'tibia'}, "One day I'll go and look."),
    NpcInteraction:createReplyInteraction({'teshial'}, "Is one of elven family or such thing. Me not understand lil' ones and their business."),
    NpcInteraction:createReplyInteraction({'cenath'}, "Is one of elven family or such thing. Me not understand lil' ones and their business."),
    NpcInteraction:createReplyInteraction({'name'}, "I called Bencthyclthrtrprr by me people. Lil' ones me call Big Ben."),
    NpcInteraction:createReplyInteraction({'god'}, "You shut up. Me not want to hear."),
    NpcInteraction:createReplyInteraction({'fire sword'}, "Do lil' one want to trade a fire sword?"),
    NpcInteraction:createReplyInteraction({'dragon shield'}, "Do lil' one want to trade a dragon shield?"),
    NpcInteraction:createReplyInteraction({'sword of valor'}, "Do lil' one want to trade a sword of valor?"),
    NpcInteraction:createReplyInteraction({'warlord sword'}, "Do lil' one want to trade a warlord sword?"),
    NpcInteraction:createReplyInteraction({'minotaurs'}, "They were friend with me parents. Long before elves here, they often made visit. No longer come here."),
    NpcInteraction:createReplyInteraction({'elves'}, "Me not fight them, they not fight me."),
    NpcInteraction:createReplyInteraction({'excalibug'}, "Me wish I could make weapon like it."),
    NpcInteraction:createReplyInteraction({'cyclops'}, "Me people not live here much. Most are far away."),
    NpcInteraction:createFarewellInteraction("Good bye lil' one"),
    NpcInteraction:createReplyInteraction(
        {'yes'},
        "Wait. Me work no cheap is. Do favour for me first, yes?",
        {current = 2, previous = 1}
    ),
    NpcInteraction:createReplyInteraction(
        {'yes'},
        "Me need gift for woman. We dance, so me want to give her bast skirt. But she big is. So I need many to make big one. Bring three okay? Me wait.",
        {current = 0, previous = 2}
    ):addInitUpdateProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.FriendsandTraders.DefaultStart, 1)
           :addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 1)
    ),
    NpcInteraction:createConfirmationInteraction(
        {"bast skirt", "uth'kean", "uth'prta", "uth'lokr", "za'ralator", "soul orb"},
        {
            reply = "Lil' one bring three bast skirts?",
            confirmation = "Good good! Woman happy will be. Now me happy too and help you.",
            cannotExecute = "Lil' one does not have three bast skirts.",
        },
        3
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 1)
    ):addCompletionValidationProcessor(
        PlayerProcessingConfigs:new():addItem(3983, 3)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new():addItem(3983, -3)
           :addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 2)
    ),
    NpcInteraction:createConfirmationInteraction(
        {"soul orb"},
        {
            reply = craftConfigs["soul orb"].message,
            confirmation = "Cling clang!",
            cannotExecute = "Lil' one does not have soul orbs!",
        },
        8
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.FriendsandTraders.TheSweatyCyclops, 2)
    ):addCompletionValidationProcessor(
        PlayerProcessingConfigs:new():addItem(5944, 1, ConfigsTypes.CONFIG_GTE)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new():addCallback(
            function (player)
                local total = player:getItemCount(5944)
                for i = 1, total do
                    player:addItem(6529, 3 * math.random(1,2))
                    player:removeItem(5944, 1)
                end
            end
        )
    ),
    NpcInteraction:createConfirmationInteraction(
        {"melt"},
        {
            reply = "Me can do unbroken but Big Ben want gold 5000 and Big Ben need a lil' time to make it unbroken. Yes or no??",
            confirmation = "whoooosh There!",
            cannotExecute = "There is no gold ingot with you.",
        },
        9
    ):addCompletionValidationProcessor(
        PlayerProcessingConfigs:new():addItem(9971, 1)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new():addItem(9971, -1):addItem(13941, 1)
    ),
    NpcInteraction:createConfirmationInteraction(
        {"amulet"},
        {
            reply = "Can melt gold ingot for lil' one. You want?",
            confirmation = "Well, well, I do that! Big Ben makes lil' amulet unbroken with big hammer in big hands! No worry! Come back after sun hits the horizon 24 times and ask me for amulet.",
        },
        10
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
            :addStorage(Storage.SweetyCyclops.AmuletStatus, 0, ConfigsTypes.CONFIG_LTE)
    ):addCompletionValidationProcessor(
        PlayerProcessingConfigs:new()
            :addItem(8262, 1)
            :addItem(8263, 1)
            :addItem(8264, 1)
            :addItem(8265, 1)
            :addAmount(5000)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new()
            :addItem(8262, -1)
            :addItem(8263, -1)
            :addItem(8264, -1)
            :addItem(8265, -1)
            :removeAmount(5000)
            :addStorage(Storage.SweetyCyclops.AmuletStatus, 1)
            :addStorage(Storage.SweetyCyclops.AmuletTimer, os.time() + 24 * 60 * 60)
    ),
    NpcInteraction:createReplyInteraction(
        {"amulet"},
        "Ahh, lil' one wants amulet. Here! Have it! Mighty, mighty amulet lil' one has. Don't know what but mighty, mighty it is!!!"
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
            :addStorage(Storage.SweetyCyclops.AmuletStatus, 1)
            :addStorage(Storage.SweetyCyclops.AmuletTimer, os.time(), ConfigsTypes.CONFIG_LTE)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new()
            :addStorage(Storage.SweetyCyclops.AmuletStatus, 2)
            :addItem(8266, 1)
    ),
    NpcInteraction:createConfirmationInteraction(
            {"gear wheel"},
            {
                reply = "Uh. Me can make some gear wheel from iron ores. Lil' one want to trade?",
                confirmation = "Cling clang!",
                cannotExecute = "Lil' one does not have any iron ores.",
            },
            11
    ):addInitValidationProcessor(
        PlayerProcessingConfigs:new()
           :addStorage(Storage.HiddenCityOfBeregar.GoingDown, 1, ConfigsTypes.CONFIG_GTE)
           :addStorage(Storage.HiddenCityOfBeregar.GearWheel, 2, ConfigsTypes.CONFIG_LTE)
    ):addCompletionValidationProcessor(
            PlayerProcessingConfigs:new():addItem(5880, 1)
    ):addCompletionUpdateProcessor(
        PlayerProcessingConfigs:new()
            -- Needs to do in way that we can increase storage
            :addStorage(Storage.HiddenCityOfBeregar.GearWheel, 3)
            :addItem(5880, -1)
            :addItem(9690, 1)
    ),
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    return npc:processOnSay(message, creature, table.concat(interactions, getCraftInteractions(craftConfigs)))
end

npcType:register(npcConfig)
