local internalNpcName = "Dalbrect"
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
	lookHead = 76,
	lookBody = 97,
	lookLegs = 67,
	lookFeet = 76,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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


	if MsgContains(message, "brooch") then
		if player:getStorageValue(Storage.WhiteRavenMonastery.Passage) == 1 then
			npcHandler:say("You have recovered my brooch! I shall forever be in your debt, my friend!", npc, creature)
			return true
		end

		npcHandler:say("What? You want me to examine a brooch?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getItemCount(3205) == 0 then
				npcHandler:say("What are you talking about? I am too poor to be interested in jewelry.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			npcHandler:say("Can it be? I recognise my family's arms! You have found a treasure indeed! \z
					I am poor and all I can offer you is my friendship, but ... please ... give that brooch to me?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:setTopic(playerId, 0)
			if not player:removeItem(3205, 1) then
				npcHandler:say("I should have known better than to ask for an act of kindness in this cruel, selfish, world!", npc, creature)
				return true
			end

			npcHandler:say("Thank you! I shall consider you my friend from now on! \z
					Just let me know if you {need} something!", npc, creature)
			player:setStorageValue(Storage.WhiteRavenMonastery.QuestLog, 1) -- Quest log
			player:setStorageValue(Storage.WhiteRavenMonastery.Passage, 1)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Then stop being a fool. I am poor and I have to work the whole day through!", npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I should have known better than to ask for an act of kindness in this cruel, selfish, world!", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({"passage"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have only sailed to the isle of the kings once or twice. \z
				I dare not anger the monks by bringing travelers there without their permission."
	},
	
function(player)
	return player:getStorageValue(Storage.WhiteRavenMonastery.Passage) ~= 1
end)

local travelNode = keywordHandler:addKeyword({"passage"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Do you seek a passage to the isle of the kings for 10 gold coins?"
	}
)
	travelNode:addChildKeyword({"yes"}, StdModule.travel,
		{
			npcHandler = npcHandler,
			premium = false,
			text = "Have a nice trip!",
			cost = 10,
			destination = Position(32190, 31957, 6)
		}
	)
	travelNode:addChildKeyword({"no"}, StdModule.say,
		{
			npcHandler = npcHandler, reset = true,
			text = "Well, I'll be here if you change your mind."
		}
	)

keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My name is Dalbrect Windtrouser, of the once proud Windtrouser family."
	}
)
keywordHandler:addKeyword({"hut"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I am merely a humble fisher now that nothing is left of my noble {legacy}."
	}
)
keywordHandler:addKeyword({"legacy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Once my family was once noble and wealthy, but {fate} turned against us and threw us into poverty."
	
	}
)
keywordHandler:addKeyword({"poverty"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "When Carlin tried to colonize the region now known as the ghostlands, \z
				my ancestors put their fortune in that {project}."
	}
)
keywordHandler:addKeyword({"fate"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "When Carlin tried to colonize the region now known as the ghostlands, \z
				my ancestors put their fortune in that {project}."
	}
)
keywordHandler:addKeyword({"ghostlands"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our family fortune was lost when the colonization of those cursed lands failed. \z
				Now nothing is left of our fame or our fortune. \z
				If I only had something as a reminder of those better times. <sigh>"
	}
)
keywordHandler:addKeyword({"project"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our family fortune was lost when the colonization of those cursed lands failed. \z
				Now nothing is left of our fame or our fortune. \z
				If I only had something as a reminder of those better times. <sigh>"
	}
)
keywordHandler:addKeyword({"carlin"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "To think my family used to belong to the local nobility! And now those arrogant women are in charge!"
	}
)
keywordHandler:addKeyword({"need"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "There is little I can offer you but a trip with my boat. \z
				Are you looking for a {passage} to the isle of kings perhaps?"
	}
)
keywordHandler:addKeyword({"ship"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My ship is my only pride and joy."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, traveller |PLAYERNAME|. Welcome to my {hut}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. You are welcome.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
