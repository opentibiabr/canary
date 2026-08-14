local internalNpcName = "Guide Alexena"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 115,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Free escort to the depot for newcomers!" },
	{ text = "Hello, is this your first visit to Carlin? I can show you around a little." },
	{ text = "I can tell you all about the status this world is in." },
	{ text = "Talk to me if you need directions." },
	{ text = "Need some help finding your way through Carlin?" },
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
	{ mark = "shops", position = Position(32335, 31803, 7), markId = MAPMARK_BAG, description = "Shops" },
	{ mark = "depot", position = Position(32331, 31782, 7), markId = MAPMARK_LOCK, description = "Depot" },
	{ mark = "temple", position = Position(32360, 31782, 7), markId = MAPMARK_TEMPLE, description = "Temple" },
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

keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "Currently, I can tell you all about the town, its temple, the bank, shops, spell trainers and the depot, as well as about the world status." })
keywordHandler:addKeyword({ "temple" }, StdModule.say, { npcHandler = npcHandler, text = "The temple can be found in one of the uptown districts. Look for stairs up from the lower city, you'll find the temple in the northwest of the upper city." })
keywordHandler:addKeyword({ "bank" }, StdModule.say, { npcHandler = npcHandler, text = "The bank is on the left side of the depot. Eva will be at your service there." })
keywordHandler:addKeyword({ "shops" }, StdModule.say, { npcHandler = npcHandler, text = "You can buy weapons, armor, tools, gems, magical equipment, furniture, spells and food here." })
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "The depot is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'll help you find your way through Carlin, the amazon town. I can mark important locations on your map and give you some information about the town and the world status." })
keywordHandler:addKeyword({ "town" }, StdModule.say, { npcHandler = npcHandler, text = "This city is ruled by Queen Eloise with the help of her female brigade. We have a lot of shops here as well as the usual facilities like depot, temple and so on." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm Alexena, at your service!" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Carlin, |PLAYERNAME| Would you like some information and a map guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Carlin, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "queen eloise" }, StdModule.say, { npcHandler = npcHandler, text = "Queen Eloise rules this city and can also promote your vocation once you have reached level 20. Her castle is in the north-western part of town." })
keywordHandler:addKeyword({ "weapons" }, StdModule.say, { npcHandler = npcHandler, text = "Rowenna's smithy is just south west of the depot. Distance weapons and ammunition can be bought at Perac's shop west of the depot." })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "Cornelia's armor shop is just south of the depot, on the Central Plaza." })
keywordHandler:addKeyword({ "tools" }, StdModule.say, { npcHandler = npcHandler, text = "General goods like ropes and shovels can be bought in Sarina's shop south of the depot, on the Central Plaza." })
keywordHandler:addKeyword({ "gems" }, StdModule.say, { npcHandler = npcHandler, text = "No, you can't buy gems here. I guess the amazons are not like other women in that respect." })
keywordHandler:addKeyword({ "magical" }, StdModule.say, { npcHandler = npcHandler, text = "Magical equipment like runes and potions can be bought at Rachel's. Her shop is in the very southern part of town." })
keywordHandler:addKeyword({ "furniture" }, StdModule.say, { npcHandler = npcHandler, text = "Nydala sells furniture in the southern part of town, just to the left of Rachel's magical store." })
keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, text = "You can learn new knight spells from Trisha in the northern part of town." })
keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, text = "Imalas sells all sorts of fruits and vegetables south of the depot. Lector sells meat south east of the depot." })
keywordHandler:addKeyword({ "spell trainers" }, StdModule.say, { npcHandler = npcHandler, text = "You can learn new knight spells from Trisha in the northern part of town." })
keywordHandler:addKeyword({ "escort" }, StdModule.say, { npcHandler = npcHandler, text = "This service is only for newcomers below level 10. I think you can manage the way on your own! If you need marks on your map, let me know." })
keywordHandler:addKeyword({ "world status" }, StdModule.say, { npcHandler = npcHandler, text = "If you'd like to know the status of this world just say the keyword for a world change." })
keywordHandler:addKeyword({ "change" }, StdModule.say, { npcHandler = npcHandler, text = "Valid keywords are: Horestis, Mage Tower, Master's Voice, Swamp Fever, Thornfire, Twisted Waters, Awash, Steamship, Horses, Overhunting, Demon War, Sea Serpent, Deepling or Hive." })
keywordHandler:addKeyword({ "keyword" }, StdModule.say, { npcHandler = npcHandler, text = "Valid keywords are: Horestis, Mage Tower, Master's Voice, Swamp Fever, Thornfire, Twisted Waters, Awash, Steamship, Horses, Overhunting, Demon War, Sea Serpent, Deepling or Hive." })
keywordHandler:addKeyword({ "harbour" }, StdModule.say, { npcHandler = npcHandler, text = "That's where we are standing right now. You can travel between the Tibian settlements using this ship if you have a premium account, that is." })
keywordHandler:addKeyword({ "post" }, StdModule.say, { npcHandler = npcHandler, text = "The post office is at the entrance of the depot. Very convenient! Liane will be glad to help you." })
keywordHandler:addKeyword({ "blessings" }, StdModule.say, { npcHandler = npcHandler, text = "Blessings reduce the death penalty, meaning that if you should die, you will lose less experience, fewer skill points and fewer to no items, if you have all five blessings." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
