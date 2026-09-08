local internalNpcName = "Robson"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "<mumbles>" },
	{ text = "Just great. Getting stranded on a remote underground isle was not that bad but now I'm becoming a tourist attraction!" },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "parcel") then
		npcHandler:say("Do you want to buy a parcel for 15 gold?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "label") then
		npcHandler:say("Do you want to buy a label for 1 gold?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") then
		local player = Player(creature)
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeMoneyBank(15) then
				npcHandler:say("Sorry, that's only dust in your purse.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:addItem(3503, 1)
			npcHandler:say("Fine.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeMoneyBank(1) then
				npcHandler:say("Sorry, that's only dust in your purse.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:addItem(3507, 1)
			npcHandler:say("Fine.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if table.contains({ 1, 2 }, npcHandler:getTopic(playerId)) then
			npcHandler:say("I knew I would be stuck with that stuff.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hrmpf, I'd say welcome if I felt like lying.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you next time!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "No patience at all!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "steamboat" }, StdModule.say, { npcHandler = npcHandler, text = "What an irony. I was stranded here for years and now my isle becomes part of an regular shipping route. But so I have the best of both worlds. My solitude and provisions. That's enough for me." })
keywordHandler:addKeyword({ "goblin" }, StdModule.say, { npcHandler = npcHandler, text = "You mean the little guy over there? I call him Lunch. He is my ... uhm friend ... I guess." })
keywordHandler:addKeyword({ "lunch" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You won't believe it, but I found him in a giant fish that I captured. When I cut the beast in pieces, I saw a little goblin cowering inside. ... He did not seem to be a threat and I kind of adopted him. Since I captured the fish for lunch and it was lunchtime I named him Lunch. ... He learnt our language quite fast. Well at least the basics. He never bothered to improve his grammar but I'm no teacher anyway.",
})
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm Robson Stonespitter, Son of Earth of the Dragoneater fellowship." })
keywordHandler:addKeyword({ "isle" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "It seems there was once a building in the centre of the isle. The ruins are still there. Some of the pillars outside remind me of what I've seen in a bonelord hideout that we've raided when I was younger. ... The rest of the ruins here, though, does not fit into that. Either the isle has been populated by different inhabitants, or by some race that I don't know at all. ... Be it as it may, there has to be something about this isle that attracted inhabitants before me and I wonder what that might be. ... I could not figure it out in all those years though. So I doubt anyone can do that during my lifetime.",
})
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I was once a trader but after some years stranded on this remote isle, I felt that I liked that kind of life better and just stayed here even after steamships found that isle." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
