local internalNpcName = "Cerdras"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 144,
	lookHead = 20,
	lookBody = 96,
	lookLegs = 41,
	lookFeet = 22,
	lookAddons = 2,
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

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm merely a humble druid like so many others here. I may not be the most talented of healers, but I am gifted with a special atunement to the elements." })
keywordHandler:addKeyword({ "nature" }, StdModule.say, { npcHandler = npcHandler, text = "For me, nature is the harmony of the elements. This harmony can be disturbed by certain events, but nature always finds its way back to harmony in the end." })

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "elements") then
		npcHandler:say({
			"How can I explain my connection to the elements so that you can understand it? Hmmm, it is like a faint melody, a song, that is always there. ...",
			"I hear that melody shifting in time with the shifts in the elements. With so many years of listening, I have learned to interpret these shifts and so come to a deeper understanding of the elements. ...",
			"It was a natural step for me to become responsible for researching elemental lore. I try to learn as much as I can and share it with my fellow druids. ...",
			"Unfortunately, much of my understanding is instinctive, and our language just doesn't contain the right words for me to express the things I feel adequately.",
		}, npc, creature)
	elseif MsgContains(message, "song") then
		npcHandler:say({
			"It is hard to explain. Of course, it's not a real song as you would understand it. I don't hear it with my ears, but rather, I feel it deep inside of me. ...",
			"Calling it a song or melody is the best I can do to describe it to those who don't share this kind of perception. ...",
			"It also helps me to express and understand something for which our language has no appropriate expression. ...",
			"You know, we are so dependent on words that we can't think about concepts when we don't have words for them. ...",
			"I sometimes think words have become just as much of a hindrance as a help. ...",
			"Perhaps we would fare better if only we forgot words and dealt purely in feelings. Then perhaps all of us could hear the wonderful melody of nature.",
		}, npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Greetings my friend!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May Crunor bless and guide you, |PLAYERNAME|.")
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "<sigh> Druids are supposed to be healers and preservers of nature. And what have most of us become? Hunters and killers who are only interested in furthering their own cause." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Cerdras of the Carlinian Druid Guild." })
keywordHandler:addKeyword(
	{ "earth" },
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The song of earth is always with me. As is the song of air. Both are often in some kind of harmony and sometimes it is hard to separate the one from the other. ... If I concentrate hard enough I can distinguish the many individual songs that make the melody. ... Each boulder, each stone, each grain of sand has its own voice in the symphony of the great melody.",
	}
)
keywordHandler:addKeyword({ "yalahari" }, StdModule.say, { npcHandler = npcHandler, text = "I have heard little of the Yalahari. And the little that I know does not tempt me to learn more." })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "The city sounds like a urban nightmare to me." })
keywordHandler:addKeyword({ "hunt" }, StdModule.say, { npcHandler = npcHandler, text = "The hunt can be part of the cycle of life and death. Nowadays that cycle has been broken. People take more than they give and greed dictates their actions." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "Crunor has not forsaken us despite our failings. Crunor's love for life is truly great." })
keywordHandler:addKeyword({ "greed" }, StdModule.say, { npcHandler = npcHandler, text = "Crunor has not forsaken us despite our failings. Crunor's love for life is truly great." })
keywordHandler:addKeyword({ "golem" }, StdModule.say, { npcHandler = npcHandler, text = "I have indeed gathered some knowledge in the field of elemental golems. Particularly the secrets of the Earth element, which is involved in the process of their creation." })
keywordHandler:addKeyword({ "telas" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, yes, dear Telas. It is a pity that he has closed his eyes to nature's beauty, but I can't reproach him for that." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
