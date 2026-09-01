local internalNpcName = "Pig"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 60,
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

npcHandler:setMessage(MESSAGE_GREET, "Oink.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "kiss") then
		npcHandler:say("Do you want to try to release me with a kiss?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Mhm Uhhh. Not bad, not bad at all! But you can still improve your skill a LOT.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Oh well. I am cursed to live in this unworthy shape but I still hope that the curse will be lifted one day." })
keywordHandler:addKeyword({ "best kisser" }, StdModule.say, { npcHandler = npcHandler, text = "You probably have the potential. If your kiss does not lift the curse, travel the world to learn more about kissing." })
keywordHandler:addKeyword({ "princess" }, StdModule.say, { npcHandler = npcHandler, text = "An evil witch has cursed me to live as a pig until the best kisser in the world gives me a kiss." })
keywordHandler:addKeyword({ "kissing" }, StdModule.say, { npcHandler = npcHandler, text = "Learn as much about kissing as you can. I'm sure you can learn the basics in the major cities. To refine your skill you might need to travel to the countryside, explore sparsely populated areas and even face some dangers." })
keywordHandler:addKeyword({ "curse" }, StdModule.say, { npcHandler = npcHandler, text = "An evil witch has cursed me to live as a pig until the best kisser in the world gives me a kiss." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Shantalla." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you think I'd wear a watch?" })
keywordHandler:addKeyword({ "lift" }, StdModule.say, { npcHandler = npcHandler, text = "Only a kiss of the king of all kissers will break the curse." })
keywordHandler:addKeyword({ "oink" }, StdModule.say, { npcHandler = npcHandler, text = "Don't kill me! I taste bad!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Once I was a beautiful princess but now I'm only an ordinary pig without much dignity!" })
keywordHandler:addKeyword({ "pig" }, StdModule.say, { npcHandler = npcHandler, text = "It's just the appearance. Inside I am still the beautiful princess I used to be." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
