local internalNpcName = "Walter, The Guard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 19,
	lookBody = 19,
	lookLegs = 38,
	lookFeet = 38,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "trouble") and player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.WalterGuard) < 1 and player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01) ~= -1 then
		npcHandler:say("I think there is a pickpocket in town.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "authorities") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Well, sooner or later we will get hold of that delinquent. That's for sure.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "avoided") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("You can't tell by a person's appearance who is a pickpocket and who isn't. You simply can't close the city gates for everyone.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "gods would allow") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("If the gods had created the world a paradise, no one had to steal at all.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			if player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.WalterGuard) < 1 then
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.WalterGuard, 1)
				player:setStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01, player:getStorageValue(Storage.Quest.U8_2.TheInquisitionQuest.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
				player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE THE KING!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "battlegroups" }, StdModule.say, { npcHandler = npcHandler, text = "Ask higher officials about that, please." })
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "He was slain long ago." })
keywordHandler:addKeyword({ "silver guard" }, StdModule.say, { npcHandler = npcHandler, text = "Only the best of the best serve as silver guards." })
keywordHandler:addKeyword({ "provisioner" }, StdModule.say, { npcHandler = npcHandler, text = "Gorn is our provisioner. You'll find him north of the main crossroads. His shop is to the right." })
keywordHandler:addKeyword({ "dogs of war" }, StdModule.say, { npcHandler = npcHandler, text = "Brave warriors, indeed." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I am healthy and vigilant." })
keywordHandler:addKeyword({ "bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "The royal general. A warrior worth Banor's blessings." })
keywordHandler:addKeyword({ "sorcerers" }, StdModule.say, { npcHandler = npcHandler, text = "Muriel is the head of the local sorcerers' guild. You'll find it in the south-west of the city." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Tibianus III is our beloved king! He resides in the castle in the north west of the city." })
keywordHandler:addKeyword({ "paladins" }, StdModule.say, { npcHandler = npcHandler, text = "Elane is responsible for the local paladins' guild. It's in the west of the town, directly south of the post office." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I like that old man. He often passes my gate, but he never remembers my name." })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "Benjamin was a brave fighter. He runs the post office in the west of the city." })
keywordHandler:addKeyword({ "kingsday" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, today is Kingsday. Us guards have to keep an extra eye open." })
keywordHandler:addKeyword({ "knights" }, StdModule.say, { npcHandler = npcHandler, text = "The high knight of the knights' guild. It is in north-east of the town." })
keywordHandler:addKeyword({ "lunatic" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "The royal general. A warrior worth Banor's blessings." })
keywordHandler:addKeyword({ "leader" }, StdModule.say, { npcHandler = npcHandler, text = "Tibianus III is our beloved king! He resides in the castle in the north west of the city." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "Sam is our blacksmith. You'll find him north of the main crossroads. His shop is to the left." })
keywordHandler:addKeyword({ "tavern" }, StdModule.say, { npcHandler = npcHandler, text = "Frodo runs the local tavern. You'll find it at the main crossroads to the north-west." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "The high knight of the knights' guild. It is in north-east of the town." })
keywordHandler:addKeyword({ "druids" }, StdModule.say, { npcHandler = npcHandler, text = "Marvik is the great druid of the local guild. You'll find him by climbing up the citywalls at the east." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "Muriel is the head of the local sorcerers' guild. You'll find it in the south-west of the city." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Marvik is the great druid of the local guild. You'll find him by climbing up the citywalls at the east." })
keywordHandler:addKeyword({ "stupid" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "tyrant" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "He is a role model for us." })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "The castle is at the west of the city." })
keywordHandler:addKeyword({ "harsky" }, StdModule.say, { npcHandler = npcHandler, text = "He is a soldier in the silver guard." })
keywordHandler:addKeyword({ "stutch" }, StdModule.say, { npcHandler = npcHandler, text = "He is a soldier in the silver guard." })
keywordHandler:addKeyword({ "guild" }, StdModule.say, { npcHandler = npcHandler, text = "In the city you will find the guildhouses of the knights, paladins, druids, and sorcerers." })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "Sam is our blacksmith. You'll find him north of the main crossroads. His shop is to the left." })
keywordHandler:addKeyword({ "smith" }, StdModule.say, { npcHandler = npcHandler, text = "Sam is our blacksmith. You'll find him north of the main crossroads. His shop is to the left." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "Frodo runs the local tavern. You'll find it at the main crossroads to the north-west." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Elane is responsible for the local paladins' guild. It's in the west of the town, directly south of the post office." })
keywordHandler:addKeyword({ "guard" }, StdModule.say, { npcHandler = npcHandler, text = "I am a guard and proud of it." })
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "Marvik is the great druid of the local guild. You'll find him by climbing up the citywalls at the east." })
keywordHandler:addKeyword({ "idiot" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "banor" }, StdModule.say, { npcHandler = npcHandler, text = "Praise Banor! May the great warrior be with us!" })
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "The depot is at the post office in the west of the city." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Tibianus III is our beloved king! He resides in the castle in the north west of the city." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "Behave while in the city or we get you! Do you want to know where to find a shop or a guild?" })
keywordHandler:addKeyword({ "shop" }, StdModule.say, { npcHandler = npcHandler, text = "There's a smith, a provisioner, and a tavern." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "Gorn is our provisioner. You'll find him north of the main crossroads. His shop is to the right." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "Of course we guards are members of the army." })
keywordHandler:addKeyword({ "post" }, StdModule.say, { npcHandler = npcHandler, text = "Benjamin was a brave fighter. He runs the post office in the west of the city." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "The royal jester." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "I am busy. Please ask the citizens for news." })
keywordHandler:addKeyword({ "scum" }, StdModule.say, { npcHandler = npcHandler, text = "We will get rid of all scum." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "Sam is our blacksmith. You'll find him north of the main crossroads. His shop is to the left." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "It's my duty to protect the city." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
