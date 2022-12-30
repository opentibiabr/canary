local internalNpcName = "Zumtah"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 51
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

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 348})
condition:setTicks(-1)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "exit") then
		if player:getStorageValue(Storage.WrathoftheEmperor.ZumtahStatus) ~= 1 then
			if npcHandler:getTopic(playerId) < 1 then
				npcHandler:say("You are searching for the way out? Do you want to go home? Are you homesick, nostalgic, allergic? I am sorry. You will stay. Muhahahaha. Haha. Are you giving up then?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif npcHandler:getTopic(playerId) == 3 then
				npcHandler:say("A what? I don't even know what you're talking about, human. If you aren't just giving up - will you kindly change the topic please?", npc, creature)
				npcHandler:setTopic(playerId, 4)
			elseif npcHandler:getTopic(playerId) == 6 then
				npcHandler:say("I'm not sure, there is an entry, though. Muhahaha. And isn't that enough after all?", npc, creature)
				npcHandler:setTopic(playerId, 7)
			elseif npcHandler:getTopic(playerId) == 10 then
				npcHandler:say("Oh, you mean - if I have ever been out of here in those 278 years? Well, I - I can't remember. No, I can't remember. Sorry.", npc, creature)
				npcHandler:setTopic(playerId, 11)
			elseif npcHandler:getTopic(playerId) == 11 then
				npcHandler:say("No, I really can't remember. I enjoyed my stay here so much that I forgot how it looks outside of this hole. Outside. The air, the sky, the light. Oh well... well.", npc, creature)
				npcHandler:setTopic(playerId, 12)
			elseif npcHandler:getTopic(playerId) == 12 then
				npcHandler:say({"Oh yes, yes. I... I never really thought about how you creatures feel in here I guess. I... just watched all these beings die here. ...",
				"I... enjoyed this torture so much that I forgot time and everything around me. ...",
				"I feel - sorry. Yes, sorry."}, npc, creature)
				npcHandler:setTopic(playerId, 13)
			elseif npcHandler:getTopic(playerId) == 13 then
				npcHandler:say({"Oh, excuse me of course, you... wanted to go. Like all... the others. I am sorry, so sorry. You... you can leave. Yes. You can go. You are free. I shall stay here and help every poor soul which ever gets thrown in here from this day onward. ...",
				"Yes, I will redeem myself. Maybe in another 278 years. ...",
				"If you want to go, just ask for an {exit} and I will transform you into a creature small enough to fit through that hole over there."}, npc, creature)
				npcHandler:setTopic(playerId, 14)
			elseif npcHandler:getTopic(playerId) == 14 then
				npcHandler:say({"Alright, as I said you are free now. There will not be an outside for the next three centuries, but you - go. ...",
				"Oh and I recovered the strange crate you where hiding in, it will wait for you at the exit since you can't carry it as... a beetle, muhaha. Yes, you shall now crawl through the passage as a beetle. There you go."}, npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:setStorageValue(Storage.WrathoftheEmperor.ZumtahStatus, 1)
				player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
				player:addCondition(condition)
			end
		else
			npcHandler:say("It's you, why did they throw you in here again? Anyway, I will just transform you once more. I also recovered your crate which will wait for you at the exit. There, feel free to go.", npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
			player:addCondition(condition)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("I've already told you that you can't get out. What's the problem? Do you even see an exit?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("You are starting to get on my nerves. Is this the only topic you know?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("But there is no escape, I said NO. You've already asked several times and my answer will stay the same. What is this? Are you trying to test me?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Muhahaha. Where? I can only see a dark cave with nothing than bones and a djinn in it. You mean that small hole there? Muhahaha.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Pesky, persistent human.", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say("Muhahaha. Then I will give you a test. How many years do you think have I been here? {89}, {164} or {278}?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "278") and npcHandler:getTopic(playerId) == 9 then
		npcHandler:say("Correct human, and that is not nearly how high you would need to count to tell all the lost souls I've seen dying here. I AM PERPETUAL. Muahahaha.", npc, creature)
		npcHandler:setTopic(playerId, 10)
	elseif (MsgContains(message, "164") or MsgContains(message, "89")) and npcHandler:getTopic(playerId) == 9 then
		npcHandler:say("Wrong answer human! Muahahaha.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
--Basic
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I wait. I wait for someone like you to come here. I wait for them to grow disconsolate. I wait for them to despair. And I wait for them to die. Muhahaha."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I am Zumtah, Zumtah the impeccable, Zumtah the marvellous, Zumtah the... the... eternal."})
keywordHandler:addAliasKeyword({"djinn"})
keywordHandler:addAliasKeyword({"zumtah"})
keywordHandler:addKeyword({"zao"}, StdModule.say, {npcHandler = npcHandler, text = "The land you are currently dwelling in, human. Don't you have any sense of your surroundings?"})
keywordHandler:addKeyword({"humans"}, StdModule.say, {npcHandler = npcHandler, text = "I have seen many of them. I have seen many of them die. In here, with me. Perhaps you will be pleased to meet them. Not long and you will join their ranks. Muhaha."})
keywordHandler:addKeyword({"lizard"}, StdModule.say, {npcHandler = npcHandler, text = "Pesky creatures. Many of them have been brought here, many of them died here. Humans, lizards, beasts, they all die the same. Down here, with me. Muhahaha."})
keywordHandler:addKeyword({"zalamon"}, StdModule.say, {npcHandler = npcHandler, text = "What? What do you mean by that?"})
keywordHandler:addKeyword({"emperor"}, StdModule.say, {npcHandler = npcHandler, text = "Hmm, an old one. I don't care much about politics or power, as here, he has none. Here, only I have power. Muhaha."})
keywordHandler:addKeyword({"resistance"}, StdModule.say, {npcHandler = npcHandler, text = "What are you talking about, such things do not matter down here. Down here alone, isolated and broken. Muhaha."})
npcHandler:setMessage(MESSAGE_GREET, "Another visitor to this constricted, cosy, calm realm, perfect except for an {exit}. Muhaha.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Muhahaha.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
