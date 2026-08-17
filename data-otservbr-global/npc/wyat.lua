local internalNpcName = "Wyat"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 98,
	lookBody = 96,
	lookLegs = 95,
	lookFeet = 116,
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

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "secret police" }, StdModule.say, { npcHandler = npcHandler, text = "All i can tell you is, that it's known as the TBI." })
keywordHandler:addKeyword({ "inhabitants" }, StdModule.say, { npcHandler = npcHandler, text = "Be more specific! If you want to talk about someone I'll need a name!" })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I am fine, thanks." })
keywordHandler:addKeyword({ "rebellion" }, StdModule.say, { npcHandler = npcHandler, text = "Luckily that's nothing I have to care about." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "He attacked our town at several occasions but was repelled each time." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "If you have any news about the whereabouts of that blade, report it to me." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "An old magician that lives south of here. I sometimes see strange smoke coming from his house." })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "The poor fool lost his mind some years ago. It's a good thing they gave him a job in the post office." })
keywordHandler:addKeyword({ "criminal" }, StdModule.say, { npcHandler = npcHandler, text = "Our enemies are numerous and not all are obvious." })
keywordHandler:addKeyword({ "zathroth" }, StdModule.say, { npcHandler = npcHandler, text = "Don't mention this name!" })
keywordHandler:addKeyword({ "murderer" }, StdModule.say, { npcHandler = npcHandler, text = "Our enemies are numerous and not all are obvious." })
keywordHandler:addKeyword({ "sheriff" }, StdModule.say, { npcHandler = npcHandler, text = "I uphold law and order. I protect Thais inhabitants ... and keep an eye on them." })
keywordHandler:addKeyword({ "chester" }, StdModule.say, { npcHandler = npcHandler, text = "His bureau is at the northgate." })
keywordHandler:addKeyword({ "problem" }, StdModule.say, { npcHandler = npcHandler, text = "We will handle each problem with care." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "Old Bloodblade does a fine job." })
keywordHandler:addKeyword({ "lunatic" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "Thais should be relatively safe from direct assaults of monsters." })
keywordHandler:addKeyword({ "subject" }, StdModule.say, { npcHandler = npcHandler, text = "There are certain criminal objects in the population of our town." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "Sam, the Thaian smith, is a man of great diligence. Whenever in need of weapons or armor, just ask him." })
keywordHandler:addKeyword({ "harsky" }, StdModule.say, { npcHandler = npcHandler, text = "A fine warrior, indeed. He is one of the king's bodyguards." })
keywordHandler:addKeyword({ "stutch" }, StdModule.say, { npcHandler = npcHandler, text = "A fine warrior, indeed. He is one of the king's bodyguards." })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "The castle should be relatively safe from criminal transgressions." })
keywordHandler:addKeyword({ "leader" }, StdModule.say, { npcHandler = npcHandler, text = "HAIL TO KING TIBIANUS!" })
keywordHandler:addKeyword({ "tyrant" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "Sam, the Thaian smith, is a man of great diligence. Whenever in need of weapons or armor, just ask him." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "A woman of great skill and courage. No one deserves the title of a Grandmaster of the Paladins more then her." })
keywordHandler:addKeyword({ "guard" }, StdModule.say, { npcHandler = npcHandler, text = "I usually work with the townguards only." })
keywordHandler:addKeyword({ "banor" }, StdModule.say, { npcHandler = npcHandler, text = "He is the patron of justice and bravery." })
keywordHandler:addKeyword({ "idiot" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "enemy" }, StdModule.say, { npcHandler = npcHandler, text = "Our enemies are numerous and not all are obvious." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "I uphold law and order. I protect Thais inhabitants ... and keep an eye on them." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "I have no news for the public." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He's so funny, I could listen to his jokes for hours." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He was a rowdy in his youth, but now he's a fine citizen as far as I can tell." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "I usually work with the townguards only." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "The city is not as bad as some people might claim, but we certainly have our problems here." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "HAIL TO KING TIBIANUS!" })
keywordHandler:addKeyword({ "brog" }, StdModule.say, { npcHandler = npcHandler, text = "The more primitive races such as orcs often worship the raging one." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "Sam, the Thaian smith, is a man of great diligence. Whenever in need of weapons or armor, just ask him." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "I am follower of Banor." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the sheriff of the Thaian territory." })
keywordHandler:addKeyword({ "tbi" }, StdModule.say, { npcHandler = npcHandler, text = "The Tibian Bureau of Investigation. If you want to know more, ask Chester Kahs about it, but I doubt you'll get any vital information." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
