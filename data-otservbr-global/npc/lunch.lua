local internalNpcName = "Lunch"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 297,
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
keywordHandler:addKeyword({ "robson" }, StdModule.say, { npcHandler = npcHandler, text = "He good dwarf. Not kill me but gave me food and bandages. Me and Robson very great friends!" })
keywordHandler:addKeyword({ "goblin" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Other goblins always mean to me. Took me to human castle to steal stuff in their cellar. But we got alarm and metal men came after us. Me was cornered and fled through toilet. ... Me squeezed long way through stonecracks until me fell into water. ... Me thought me drown but nonono! Biggest fish ever came and swallowed me! Many long days in fish! Or even hours! But later suddenly fish was jumping much, then suddenly light! ... And me kind of: 'Oh! Goblin heaven!' but it was Robson who caught big fish! Imagine! He freed me and friends ever since! True story!",
})
keywordHandler:addKeyword({ "dwarf" }, StdModule.say, { npcHandler = npcHandler, text = "Dwarf are dangerous fighters. Me first very great fear of Robson because dwarf he is. But Robson good dwarf is. Not killing poor little goblin. ... Uh, of course mayhaps that making him bad dwarf, me not sure." })
keywordHandler:addKeyword({ "ferry" }, StdModule.say, { npcHandler = npcHandler, text = "Ferry so noisy but good stink! Me always thought ferry would be little and have funny wings. Me know so little of big world!" })
keywordHandler:addKeyword({ "steam" }, StdModule.say, { npcHandler = npcHandler, text = "Ferry so noisy but good stink! Me always thought ferry would be little and have funny wings. Me know so little of big world!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Me new name is Lunch." })
keywordHandler:addKeyword({ "isle" }, StdModule.say, { npcHandler = npcHandler, text = "Isle so scary. Evil monsters everywhere. Robson sometimes gone exploring. Me begging him not to go but he so brave. Gladly he always back for Lunch." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am many, many things. Me bodyguard for Robson. Watching over him when sleeping. Me good fisherman. Me fish soo many fish that sometime no fish is left. ... Aaaand me many, many other things. All so more much fun with Robson. At home at goblin camp me only was punching ball for bigger goblins." })
keywordHandler:addKeyword({ "new" }, StdModule.say, { npcHandler = npcHandler, text = "Me old name no word was. Hard to make noises for Robson. Robson named me Lunch because we met at lunchtime." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
