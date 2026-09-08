local internalNpcName = "Eclesius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 91,
	lookLegs = 12,
	lookFeet = 95,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I'm looking for a new assistant!" },
	{ text = "Err, what was it again that I wanted...?" },
	{ text = "Do come in! Mind the step of the magical door, though." },
	{ text = "I'm so sorry... I promise it won't happen again. Problem is, I can't remember where I made the error..." },
	{ text = "Actually, I STILL prefer inexperienced assistants. They're easier to keep an eye on and don't tend to backstab you." },
	{ text = "So much to do, so much to do... uh... where should I start?" },
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

npcHandler:setMessage(MESSAGE_GREET, "Who are you? What do you want? You seem too experienced to become my assistant. Please leave.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "He was bested in combat, but the hero who killed him, was that humble that he never claimed the fame." })
keywordHandler:addKeyword({ "assistant" }, StdModule.say, { npcHandler = npcHandler, text = "As my assistant you can carry out daily tasks and solve missions for me." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Yes?" })
keywordHandler:addKeyword({ "prevent" }, StdModule.say, { npcHandler = npcHandler, text = "What's wrong? Are you afraid to go down there? There's absolutely no reason for that. Me? Erm... my knees, you know. Stairs are such a trial for me. Go on! Secure the cage and calm the demon!" })
keywordHandler:addKeyword({ "turian" }, StdModule.say, { npcHandler = npcHandler, text = "Oh dear. It's all my fault that he is the way he is now. That much I can remember. <sniff>" })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "It's to the far east of here. You can either reach it by ship or walk there, but it's QUITE a walk. I think." })
keywordHandler:addKeyword({ "player" }, StdModule.say, { npcHandler = npcHandler, text = "Was that your name...? |PLAYERNAME|? Really? <scratches head> Fine then... hello |PLAYERNAME|!" })
keywordHandler:addKeyword({ "sorry" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, you SHOULD be sorry!" })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I moved away from there for a reason. I just can't remember what the reason was." })
keywordHandler:addKeyword({ "thank" }, StdModule.say, { npcHandler = npcHandler, text = "What are you thanking me for? <scratches head>" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Eclesius. And I'm quite happy that my memory works almost all of the time." })
keywordHandler:addKeyword({ "frog" }, StdModule.say, { npcHandler = npcHandler, text = "Oh dear. It's all my fault that he is the way he is now. That much I can remember. <sniff>" })
keywordHandler:addKeyword({ "hint" }, StdModule.say, { npcHandler = npcHandler, text = "Hint? What kind of hint?" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I have a lot of work to do. I'm a very wise sorcerer, you see. So I'm busy creating magic fields, inventing new spells, reading books, summoning creatures... all very complex. That's why I need assistants for the easy work." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "Where did I put that key, erm... I think it's somewhere in my lab. But then again my memory is not the best." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
