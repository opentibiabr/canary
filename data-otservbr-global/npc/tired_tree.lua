local internalNpcName = "Tired Tree"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 25405,
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
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "These days my name is fagus sylvatica. It will change as soon as I take over another plant or animal." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Currently I'm a tree." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It's time to sleep." })
keywordHandler:addKeyword({ "tree" }, StdModule.say, { npcHandler = npcHandler, text = "Outside of our secret realm my siblings and I can't keep our true shape. If we want to travel other parts of the world, we must take over the bodies of animals. But we are causing them no harm and we just take control if necessary." })
keywordHandler:addKeyword({ "siblings" }, StdModule.say, { npcHandler = npcHandler, text = "We call ourselves the fae. Some name us nature spirits or peri but we prefer the former term. Most of us are rather reclusive and live peaceful lives in our secret realm. We only leave it in order to protect our home. ... As we tend to be secretive about our true nature I'm afraid I can't tell you more." })
keywordHandler:addKeyword({ "realm" }, StdModule.say, { npcHandler = npcHandler, text = "We call it Feyrist and it is a secret, hidden place. Just few mortals get permission to enter it. A long time ago, we learned how to hide our realm from the outside world. Only if you gain our trust I will tell you how to reach it." })
keywordHandler:addKeyword({ "trust" }, StdModule.say, { npcHandler = npcHandler, text = "You should talk to Alkestios if you want to prove yourself trustworthy." })
keywordHandler:addKeyword({ "alkestios" }, StdModule.say, { npcHandler = npcHandler, text = "He's one of our kind and took over the body of a white deer. You may find him near Ab'Dendriel." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "My sisters and brothers told me that there is a strange evil that threatens this world." })
keywordHandler:addKeyword({ "rumors" }, StdModule.say, { npcHandler = npcHandler, text = "My sisters and brothers told me that there is a strange evil that threatens this world." })
keywordHandler:addKeyword({ "rumours" }, StdModule.say, { npcHandler = npcHandler, text = "My sisters and brothers told me that there is a strange evil that threatens this world." })
keywordHandler:addKeyword({ "evil" }, StdModule.say, { npcHandler = npcHandler, text = "It is some kind of dark energy that threatens nature's balance. I don't know the details. If you are interested you should talk to Alkestios." })
keywordHandler:addKeyword({ "aurita" }, StdModule.say, { npcHandler = npcHandler, text = "She's a beautiful mermaid, dwelling in the warm waters at Feyrist's shores. She stole Taegen's heart." })
keywordHandler:addKeyword({ "taegen" }, StdModule.say, { npcHandler = npcHandler, text = "He's one of my brethren, a faun. He preferred not to leave Feyrist - mainly because of Aurita, I assume." })
keywordHandler:addKeyword({ "benevola" }, StdModule.say, { npcHandler = npcHandler, text = "She's a druid who is living near Ab'Dendriel. Alkestios befriended her, so I guess she is trustworthy." })
keywordHandler:addKeyword({ "tooth fairy" }, StdModule.say, { npcHandler = npcHandler, text = "She's one of our sisters and took over a white seagull. The last time I talked to her she seemed worried." })
keywordHandler:addKeyword({ "ikassis" }, StdModule.say, { npcHandler = npcHandler, text = "She's one of my sisters. I guess she took over the body of a snake." })
keywordHandler:addKeyword({ "maelyrra" }, StdModule.say, { npcHandler = npcHandler, text = "She is one of the fae queens of Feyrist." })
keywordHandler:addKeyword({ "talila" }, StdModule.say, { npcHandler = npcHandler, text = "She is a pixies living in Feyrist." })
keywordHandler:addKeyword({ "valindara" }, StdModule.say, { npcHandler = npcHandler, text = "She is a swan maiden and lives in Feyrist." })
keywordHandler:addKeyword({ "feyrist" }, StdModule.say, { npcHandler = npcHandler, text = "It is a secret, hidden place. Just few mortals get permission to enter it. A long time ago, we learned how to hide our realm from the outside world. Only if you gain our trust I will tell you how to reach it." })
keywordHandler:addKeyword({ "fae" }, StdModule.say, { npcHandler = npcHandler, text = "Some call us nature spirits or peri but we prefer the term fae. Most of us are rather reclusive and live peaceful lives in our secret realm. We only leave it in order to protect our home. ... As we tend to be secretive about our true nature I'm afraid I can't tell you more." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of life and huge trees. The elves who are living there love plants and animals, so I guess it is a good place." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "They are inhabiting Ab'Dendriel and live in close touch with nature." })
keywordHandler:addKeyword({ "kazordoon" }, StdModule.say, { npcHandler = npcHandler, text = "It has something to do with ... dwarves, I guess." })
keywordHandler:addKeyword({ "dwarves" }, StdModule.say, { npcHandler = npcHandler, text = "They are living underneath the earth. I just don't understand why." })
keywordHandler:addKeyword({ "krailos" }, StdModule.say, { npcHandler = npcHandler, text = "I have never heard of this place." })
keywordHandler:addKeyword({ "oramond" }, StdModule.say, { npcHandler = npcHandler, text = "I have never heard of this place." })
keywordHandler:addKeyword({ "rathleton" }, StdModule.say, { npcHandler = npcHandler, text = "I have never heard of this place." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "This is the world we are living in. This place is rather pleasant because the nearby living mortal sometimes sits down here and raises sweet melodies on his flute. He calls himself Humphrey." })
keywordHandler:addKeyword({ "humphrey" }, StdModule.say, { npcHandler = npcHandler, text = "He is living nearby and seems to be some kind of healer." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. Very odd surrounding, if you ask me." })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. Very odd surrounding, if you ask me." })
keywordHandler:addKeyword({ "edron" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. Very odd surrounding, if you ask me." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. Very odd surrounding, if you ask me." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. Very odd surrounding, if you ask me." })
keywordHandler:addKeyword({ "darama" }, StdModule.say, { npcHandler = npcHandler, text = "I have never heard of this place." })
keywordHandler:addKeyword({ "map" }, StdModule.say, { npcHandler = npcHandler, text = "I have a part of a certain map, yes. I would consider giving it to you if you do me a small favour. Would you do that?" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
