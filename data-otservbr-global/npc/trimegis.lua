local internalNpcName = "Trimegis"
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
	lookHead = 57,
	lookBody = 109,
	lookLegs = 94,
	lookFeet = 0,
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
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "The king listens to the advice of this swordsman far too often." })
keywordHandler:addKeyword({ "stone of insight" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Ah well. This matter was taken out of our hands for now. The inquisition insisted to control the collection of these stones and by royal decree they were granted the exclusive right to do so. ... As a simple scientist I'm not in a position to question such decision, as hard as it might hit my researches. For now I can not trade any of the stones. You will have to wait for another opportunity.",
})
keywordHandler:addKeyword({ "pits of inferno" }, StdModule.say, { npcHandler = npcHandler, text = "Some dumb holes for adventurers seeking trouble." })
keywordHandler:addKeyword({ "nightmare pits" }, StdModule.say, { npcHandler = npcHandler, text = "Some dumb holes for adventurers seeking trouble." })
keywordHandler:addKeyword({ "courtmage" }, StdModule.say, { npcHandler = npcHandler, text = "The last courtmage was killed by Ferumbras in one of his attacks." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "He failed in his quest for power since he ultimately forfeited greater powers for a quick but limited powerboost by enslaving himself to some dark entities." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "The only weapon I need is my magic." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Our king frequently relies on my divinations and spells of protection." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "That old fool wanted to become courtmage too. But he just doesn't cut the mustard." })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "Many call themselves a sorcerer, but only a few truly understand what that means." })
keywordHandler:addKeyword({ "lungelen" }, StdModule.say, { npcHandler = npcHandler, text = "She has the 'know how', but sadly does not really know how to use it efficiently." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "Mixing up magic with religion can't do any good." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "The king listens to the advice of this swordsman far too often." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Limited in his vision as all knights are." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Since intelligence can't be substituted by passion, all druids are nothing but hedgemages." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "He's quite good in magical theories, but lacks practice in the field." })
keywordHandler:addKeyword({ "wisdom" }, StdModule.say, { npcHandler = npcHandler, text = "Wisdom is only an excuse for the lack of consequence." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "Brawns but no brain." })
keywordHandler:addKeyword({ "donald" }, StdModule.say, { npcHandler = npcHandler, text = "I have certainly no business with such persons." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "A truly disgusting fellow." })
keywordHandler:addKeyword({ "sherry" }, StdModule.say, { npcHandler = npcHandler, text = "I have certainly no business with such persons." })
keywordHandler:addKeyword({ "kings" }, StdModule.say, { npcHandler = npcHandler, text = "Our king frequently relies on my divinations and spells of protection." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "Power comes to those who have the intelligence to claim it." })
keywordHandler:addKeyword({ "spell" }, StdModule.say, { npcHandler = npcHandler, text = "My spells are my personal secret." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "A bar is fine to distract the mundanes from doing something foolish." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Paladins are another example that diversing one's resources between goods, mundane weapons, and magic does not make a good mixture." })
keywordHandler:addKeyword({ "xodet" }, StdModule.say, { npcHandler = npcHandler, text = "He made the best he could of his limited abilities." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "Another bogeyman. Who's afraid of someone who is that 'powerful' that he hides in some dirthole?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am commonly known as Trimegis." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time does not matter in the end." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "In the long run, it would pay off to focus all resources on a magicians corps, but the king is not convinced of that. Not yet. At least one mundane who knows his proper place." })
keywordHandler:addKeyword({ "rune" }, StdModule.say, { npcHandler = npcHandler, text = "I have no need for runes anymore. Runes are tools for beginners." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "I don't care about mundane gossip." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the kings new courtmage and advisor in arcane matters." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "A man as mundane as a rock." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
