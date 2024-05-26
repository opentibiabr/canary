local internalNpcName = "Guide"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 38,
	lookBody = 8,
	lookLegs = 13,
	lookFeet = 58,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I can inform you about the status of this world, if you're interested." },
	{ text = "Hello, is this your first visit to Orario? I can show you around a little." },
	{ text = "Talk to me if you need directions." },
	{ text = "Need some help finding your way through Orario? Let me assist you." },
	{ text = "Free escort to the depot for newcomers!" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local configMarks = {
	-- Tiendas
	{ mark = "magicShop", position = Position(10026, 10027, 7), markId = MAPMARK_BAG, description = "Potions and Runes" },
	{ mark = "distanceShop", position = Position(10056, 10050, 7), markId = MAPMARK_BAG, description = "Distance Weapons and Ammunition" },
	{ mark = "amuletShop", position = Position(10020, 10044, 7), markId = MAPMARK_BAG, description = "Amulets and Rings" },
	{ mark = "gearShop", position = Position(9994, 10030, 7), markId = MAPMARK_SWORD, description = "Armors and Weapons Bazar" },
	{ mark = "exerciseShop", position = Position(9972, 9955, 7), markId = MAPMARK_STAR, description = "Training Area" },
	{ mark = "toolShop", position = Position(9979, 10014, 7), markId = MAPMARK_SHOVEL, description = "Backpacks and Tools" },
	{ mark = "jewelryShop", position = Position(10024, 10068, 7), markId = MAPMARK_BAG, description = "Jewelry Shop" },
	{ mark = "exoticPotionShop", position = Position(9941, 10019, 7), markId = MAPMARK_BAG, description = "Exotic Potions Shop" },
	{ mark = "cupcakeShop", position = Position(10042, 10022, 7), markId = MAPMARK_BAG, description = "Cupcake Shop" },
	-- Lugares Importantes
	{ mark = "temple", position = Position(10000, 10000, 7), markId = MAPMARK_TEMPLE, description = "Temple" },
	{ mark = "depot", position = Position(9956, 10008, 7), markId = MAPMARK_LOCK, description = "Depot" },
	{ mark = "castle", position = Position(9984, 9982, 7), markId = MAPMARK_GREENNORTH, description = "Promotion (King Castle)" },
	{ mark = "onlineTraining", position = Position(9937, 9985, 7), markId = MAPMARK_SWORD, description = "Online Training" },
	{ mark = "bank", position = Position(10017, 10066, 7), markId = MAPMARK_DOLLAR, description = "Bank" },
	-- Gates
	--{mark = "eastGate", position = Position(1159, 1000, 7), markId = MAPMARK_REDEAST, description = "East Gate"},
	--{mark = "southGate", position = Position(1000, 1159, 7), markId = MAPMARK_REDSOUTH, description = "South Gate"},
	--{mark = "westGate", position = Position(842, 1000, 7), markId = MAPMARK_REDWEST, description = "West Gate"},
	--{mark = "northGate", position = Position(1000, 842, 7), markId = MAPMARK_REDNORTH, description = "North Gate"}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if table.contains({ "map", "marks" }, message) then
		npcHandler:say("Would you like me to mark locations like - for example - the depot, bank and shops on your map?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Here you go.", npc, creature)
		local mark
		for i = 1, #configMarks do
			mark = configMarks[i]
			player:addMapMark(mark.position, mark.markId, mark.description)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) >= 1 then
		npcHandler:say("Well, nothing wrong about exploring the town on your own. Let me know if you need something!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "Currently, I can tell you all about the town, its temple, the bank, shops - well, warehouses - spell trainers and the depot, as well as about the adventurer's guild, hunting grounds, quests and the world status." })
keywordHandler:addKeyword({ "temple" }, StdModule.say, { npcHandler = npcHandler, text = "The temple is pretty much in the middle of Orario. If you go south from this harbour, you can't miss it." })
keywordHandler:addKeyword({ "bank" }, StdModule.say, { npcHandler = npcHandler, text = "The bank as well as jewel stores can be found in the House of Wealth, in the north-eastern part of Orario. I can mark it on your map if you want." })
keywordHandler:addKeyword({ "shops" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy almost everything here! Visit one of our warehouses for weapons, armors, magical equipment, spells, gems, tools, furniture and everything else you can imagine." })
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "The depot is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I will help you find your way in the buzzing city of Orario. I can mark important locations on your map and give you some information about the town and the world status." })
keywordHandler:addKeyword({ "town" }, StdModule.say, { npcHandler = npcHandler, text = "This trading city has been built directly over a swamp and basically stands on stone pillars. We have many large warehouses here. To speak of 'shops' would be an understatement." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm Elena, sweetheart. I love your name, |PLAYERNAME|." })
-- Customs
keywordHandler:addKeyword({ "discord" }, StdModule.say, { npcHandler = npcHandler, text = "Make sure to join our discord. Invitation Link: {https://discord.com/invite/DyTuuf7zua}" })
keywordHandler:addKeyword({ "social" }, StdModule.say, { npcHandler = npcHandler, text = "All our social media are storaged at {https://allmylinks.com/aerwix}" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Orario, |PLAYERNAME| Would you like some information and a {map} guide? Also you can ask for {discord} or our {social} media")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Orario, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
