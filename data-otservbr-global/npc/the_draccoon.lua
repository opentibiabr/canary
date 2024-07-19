local internalNpcName = "The Draccoon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1703,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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
	local questline = player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end
	if MsgContains(message, "name") or MsgContains(message, "draccoon") then
		npcHandler:say("I'm just known as 'The Draccoon'! Like some famous artists, you know. I am one of a kind anyway!", npc, creature)
	elseif MsgContains(message, "job") then
		npcHandler:say("Besides being awesome? I make {plans}.", npc, creature)
	elseif MsgContains(message, "venore") then
		npcHandler:say("The city has changed so much, since I left! I hardly recognized it!", npc, creature)
	elseif MsgContains(message, "plans") then
		npcHandler:say("I love it, when a plan comes together.", npc, creature)
	elseif MsgContains(message, "glad") then
		npcHandler:say("I need your assistance in a {quest} of mine!?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "quest") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Due to treachery and malice the evil dragon Nimmersatt managed to catch me in a trap and held me {captive} for 20 years!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "captive") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("As he is greedy and always hungry, he made me one of his cooks! I had to serve him the finest meals for 20 years, to his constant {complaints}!", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "complaints") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("He was never satisfied and always found something to criticise and his complaints never stopped! ...", npc, creature)
			npcHandler:say("Gladly over the years, he let his guard down and I managed to {escape}!", npc, creature, 2000)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "escape") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Now that I am free again, I am plotting my revenge... and this is where you enter the {picture}!", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "picture") then
		if npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Even in captivity, I heard about all your exploits and deeds and decided you are just the person I need to bring my plans to fruition! ...", npc, creature)
			npcHandler:say("I hope you are ready for that {mission}!", npc, creature, 2000)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "mission") then
		local mission = player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine)
		if npcHandler:getTopic(playerId) <= 5 and mission == 1 then
			npcHandler:say("Well, the dragon Nimmersatt managed to catch me off guard and entrapped me with the intention to devour me. ...", npc, creature)
			npcHandler:say("Knowing his insatiable appetite, I managed to talk him into accepting me as one of his cooks! Indeed, my cooking skills aren't garbage, so to say, and I managed to prolong my life for one year after the other. ...", npc, creature, 2000)
			npcHandler:say("Over the years, even Nimmersatt himself let his guard down, and I learned many of his secrets. After 20 years, I finally managed to trick myself out of his clutches and managed to {escape}! ...", npc, creature, 2000)
			npcHandler:say("Now the time of the revenge of the {Draccoon} has come! Nimmersatt will pay dearly for what he did to me! But not only that! ...", npc, creature, 2000)
			npcHandler:say("There are also old friends to be contacted, debts to be called in, and some other culprits to be punished for their role in my capture and imprisonment! ...", npc, creature, 2000)
			npcHandler:say("I'd like you to assist me in that {mission}.", npc, creature, 2000)
			npcHandler:setTopic(playerId, 6)
		elseif mission == 1 then
			npcHandler:say("My dearest human friend must yet be informed of my return. I am sure he will join us in our campaign! ...", npc, creature)
			npcHandler:say("He lives in an apartment in Kazordoon, as I understand he had some trouble in most other cities. I'm pretty sure you'll still find him there. ...", npc, creature, 2000)
			npcHandler:say("Just pay him a visit and tell him, his good old pal, the Draccoon is back!", npc, creature, 2000)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 2)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.TheRestOfRathaDoor, 1)
		elseif mission == 3 then
			npcHandler:say("<sigh> Ratha's demise is most unfortunate, indeed! ...", npc, creature)
			npcHandler:say("But well, as he is still around... to some capacity at least, I am sure we are able to communicate with him. Just travel to his apartment again, I'll send one of my buddies to your assistance. ...", npc, creature, 2000)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 4)
		elseif mission == 5 then
			npcHandler:say("Execellent, the vial with Ratha's essence arrived just minutes ago via our friends from the postman guild...", npc, creature)
			npcHandler:say("Even better, I managed to get my paws on a potion of spirit talking, it's just over there in the potion rack. Sadly it only allows humans to talk with human spirits...", npc, creature, 2000)
			npcHandler:say("But luckily for us, you ARE a human after all! So grab that potion and just drink it! Then we will start to have a conversation with Ratha!", npc, creature, 2000)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 6)
		elseif mission == 7 then
			npcHandler:say("Well I hope you and Ratha get along well. Fret net! I will find a way to extract Ratha From you... sooner or later that is! ...", npc, creature)
			npcHandler:say("Now we have other things to care for, though! The master cook of Nimmersatt and cruel taskmaster for all to us cooks in Nimmersatt's service was a cyclops of immense power and immensely bad taste. ...", npc, creature, 2000)
			npcHandler:say("His answer to anything cooking related was 'fry it!'. So he became known only as ...", npc, creature, 2000)
			npcHandler:say("THE FRYCLOPS! ...", npc, creature, 2000)
			npcHandler:say("His skin became nearly impenetrable by constantly being burnt by frying oil. I learned he got a special reward for his service to Nimmersatt. ...", npc, creature, 2000)
			npcHandler:say("A strange machine that is able to retrieve items from places anywhere in the world! We will conquer this item and also punish the evil fryclops! ...", npc, creature, 2000)
			npcHandler:say("According to my pal and guild mate in the fools guild, Bozo, the despicable Fryclops now resides on a small island north of Carlin where he tries to sink ships at his leisure. ...", npc, creature, 2000)
			npcHandler:say("I arranged for you a secret passage to his isle from the Ghostlands! Look there for an innocent looking trash can <winks>. A friend of mine will be waiting there with further directions.", npc, creature, 2000)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 8)
		elseif mission == 9 then
			npcHandler:say("We got hand on the machine in his cellar. ...", npc, creature)
			npcHandler:say("My mates are stil trying to figure it out, yet one thing is clear, the stupid Fryclops used up all available charges and we need to refuel that thing! ...", npc, creature, 2000)
			npcHandler:say("And I happen to know how to refuel this machine with ease! All we need is some infernal power crystals! ...", npc, creature, 2000)
			npcHandler:say("I'm sure its just a name, don't worry! My informants told me where to find some of those! ...", npc, creature, 2000)
			npcHandler:say("All we have to do is to steal them from some unsuspecting demons, a piece of cake for you, I am sure! ...", npc, creature, 2000)
			npcHandler:say("To make things even easier Cheaty will assist you with her magic and provid you with a disguise! So absolutely nothing could possibly go wrong! ...", npc, creature, 2000)
			npcHandler:say("You will find the entrance at an abandoned tower in Edron, it's close to a stone circle.", npc, creature, 2000)
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 10)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME|! I am {glad} to see you!")

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, my friend!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
