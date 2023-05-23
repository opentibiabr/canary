local internalNpcName = "Mr Morris"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 289,
	lookHead = 115,
	lookBody = 114,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "I have a quest that needs doing. Interested?"},
	{text = "Hmmm. Interesting. If only someone could help investigate this."},
	{text = "There's a task for an intrepid adventurer open! Any volunteers?"},
	{text = "Hey, you. Yes, you. I could use your help."},
	{text = "<sigh> The Adventurers' Guild really should have equipped me with more man power. \z
		Who's to keep all those monsters in check?" },
	{text = "So much to investigate, so little time..."},
	{text = "Buying all sorts of creature products!"},
	{text = "You're looking thoughtful. Maybe I can help you?"}
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

	if MsgContains(message, "amulet") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet) < 1 then
			npcHandler:say(
				{
					"One of our ...less fortunate members lost an ancient amulet somewhere on the island, \z
					along with his life. If you could retrieve the amulet at least, there's a little reward. \z
					Would you go on that errand?"
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet) == 2 and player:getItemCount(21379) == 1 then
			npcHandler:say(
				{
					"Ah, you found the amulet! Ah. Really? Poor Dormovo. \z
					Always a bit hasty. Forgot his rope, or food, or potions - \z
					it was to be expected he would meet an early end. Oh, well. ..."
				},
			npc, creature, 0)
			player:removeItem(21379, 1)
			player:addItem(3031, 50)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet, 3)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "log book") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TornLogBook) < 1 then
			npcHandler:say("The first log book from the first foray group has been stolen by trolls. \z
				One wonders what for, as they can hardly read! Anyway, we need it back. \z
				Would you go looking for it?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.TornLogBook) == 1
		and player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheStolenLogBook) == 1
		and player:getItemCount(21378) == 1 then
			npcHandler:say("Ah, yes, that's it! Torn and gnawed, but, ah well, the information is still retrievable. \z
				Thank you. Here's your reward.", npc, creature)
			player:removeItem(21378, 1)
			player:addItem(3031, 50)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheStolenLogBook, 2)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "herbs") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheRareHerb) < 1 then
			npcHandler:say("One of our ...less fortunate members lost an ancient amulet somewhere on the island, \z
				along with his life. If you could retrieve the amulet at least, there's a little reward. \z
				Would you go on that errand?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheRareHerb) == 2 then
			npcHandler:say("Ah, wonderful. Freshly cut and full of potent... whatever it is it does. \z
				Thanks. Here's your reward.", npc, creature)
			player:addItem(3031, 50)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheRareHerb, 3)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "key") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) < 1 then
			npcHandler:say("his is an undercover thing - the key to the dormitory has disappeared. \z
				No one wants to own up who has lost it, at least not to me. Maybe they'll talk to you. \z
				I'll reward you if you find it. You in?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 4 then
			npcHandler:say("Ah, you're here to report about the key - any progress?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Wonderful. I don't believe you will find Dormovo alive, though. \z
				He would not have stayed abroad that long without refilling his inkpot for his research notes. \z
				But at least the amulet should be retrieved.", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Good. The logbook or whatever is left of it is very valuable to my research. \z
				If you return its contents to me, I will reward you accordingly.", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheStolenLogBook, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say(
				{
					"Splendid. Those Dawnfire buds are just the thing against nasty troll bites, you know? \z
						But they're quite rare.",
					"Look for a bush with yellow glowing flower buds. It grows only on a special, \z
						light grey-brown sand, and is usually surrounded by fireflies. \z
						Use the herb to pluck off the fresh flower buds, and return to me."
				},
			npc, creature, 10)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheRareHerb, 1)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.HerbFlower, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Good. Just chat with the guys. Someone is bound to remember *something* about that key.", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("The key to the dormitory! Finally! You're a real sleuth. Here's your reward.", npc, creature)
			player:removeItem(21392, 1)
			player:addItem(3031, 50)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 5)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Good. Killing 20 will teach them a lesson, without provoking desperate retaliation. \z
				Still, take care!", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll, 1)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount, 0)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Good. Killing 20 will teach them a lesson, without provoking desperate retaliation. \z
				Still, take care!", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin, 1)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount, 0)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say("Good. Killing 20 will teach them a lesson, without provoking desperate retaliation. \z
				Still, take care!", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos, 1)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount, 0)
			npcHandler:setTopic(playerId, 0)
		end
		--End mission
		--Start Task
	elseif MsgContains(message, "trolls") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll) < 1 then
			npcHandler:say(
				{
					"Mountain trolls are worse than magpies, stealing everything that's not nailed down. \z
						Lately, they have raided our ship and made off with most of the Captain's rum stock!",
					"I will reward you if you kill 20 mountain trolls. Would you do that?"
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 6)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll) == 1 then
			if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount) >= 20 then
				npcHandler:say("Ah, very good job. That should put a crimp in their activities. Here's your reward.", npc, creature)
				player:setStorageValue(14898, 1)
				player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll, 2)
				player:addItem(3031, 50)
			else
				npcHandler:say("Come back when you have slain {20 mountain trolls!}", npc, creature)
			end
		end
	elseif MsgContains(message, "goblins") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin) < 1 then
			npcHandler:say(
				{
					"Footmen of the muglex clan are worse than magpies, stealing everything that's not nailed down. \z
						Lately, they have raided our ship and made off with most of the Captain's rum stock!",
					"I will reward you if you kill 20 muglex clan footmen. Would you do that?"
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin) == 1 then
			if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount) >= 20 then
				npcHandler:say("Ah, very good job. That should put a crimp in their activities. Here's your reward.", npc, creature)
				player:setStorageValue(14899, 1)
				player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin, 2)
				player:addItem(3031, 50)
			else
				npcHandler:say("Come back when you have slain {20 muglex clan footman!}", npc, creature)
			end
		end
	elseif MsgContains(message, "minotaur") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos) < 1 then
			npcHandler:say(
				{
					"Minotaur bruisers are worse than magpies, stealing everything that's not nailed down. \z
						Lately, they have raided our ship and made off with most of the Captain's rum stock!",
					"I will reward you if you kill 20 minotaur bruisers. Would you do that?"
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 8)
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos) == 1 then
			if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount) >= 20 then
				npcHandler:say("Ah, very good job. That should put a crimp in their activities. Here's your reward.", npc, creature)
				player:setStorageValue(14900, 1)
				player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos, 2)
				player:addItem(3031, 50)
			else
				npcHandler:say("Come back when you have slain {20 minotaur bruisers!}", npc, creature)
			end
		elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos) == 2 then
			npcHandler:say("You already done this task.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addKeyword({"quest"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hm. Well, you look like you want to take a look at the unknown yourself. \z
			I might have a job for you. Choose what you would like to do - {fetch} some things, or {kill} some monsters."
	}
)
keywordHandler:addKeyword({"mission"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hm. Well, you look like you want to take a look at the unknown yourself. \z
			I might have a job for you. Choose what you would like to do - {fetch} some things, or {kill} some monsters."
	}
)
keywordHandler:addKeyword({"fetch"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "There's three things that need to be found. You can look for an {amulet}, \z
			a {log book} or pick some rare {herbs}. Take your pick."
	}
)
keywordHandler:addKeyword({"kill"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Well, those monsters have grown very uppity lately. There's a choice of three - mountain {trolls}, \z
			muglex clan {goblins} or, if you are up to it or together with some friends, \z
			there's a need to weed out some risky {minotaur} bruisers. Choose your target."
	}
)
keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Mr Morris will do."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "There's always someone who needs to be at the front, to take the first step into the unknown. \z
			My whole life has been full of such steps."
	}
)
keywordHandler:addKeyword({"dawnport"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, that old story of how it was named? I spread it around. \z
			Can't remember really what its origins are. Interesting archeological findings here, though."
	}
)
keywordHandler:addKeyword({"secrets of dawnport"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah yes. Well, the magic that led us here seems to be most potent at a certain time, close before sunrise. \z
			Perhaps like a giant pulse, or beacon. Maybe the gods set it here, or a mad sorcerer, \z
			we don't know for sure yet... The portal deep down in the caves, resonating with magical energy where you came \z
			through, can maybe bring something else into this world as well. \z
			So it must be carefully guarded while we investigate the island for more clues... \z
			There are some very interesting archeological findings here on the island throughout. \z
			Seems the island has drawn some cults here, but why they are gone now, no one knows."
	}
)
keywordHandler:addKeyword({"archeological"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "It seems that throughout its history, this island was inhabited by very different species. \z
			I like to study their remains."
	}
)
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Yeah. Long time I haven't been to that place. How's old Vascalir? Still hanging around in the academy? \z
			And Kraknaknork? Hah, I remember our brawl after that last card game. Fun times."
	}
)
keywordHandler:addKeyword({"coltrayne"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "What about him? Is he in one of his dark moods again? That's his normal mood, I mean. \z
			Just buy your armor, weaponry and ammunition there and don't worry."
	}
)
keywordHandler:addKeyword({"garamond"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Tired of the academy, maybe, but not of teaching. If you need druid or sorcerer spells, go to him."
	}
)
keywordHandler:addKeyword({"hamish"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, good old Hamish. A real wizard with potions. \z
			Will supply you with very useful magic equipment for hunting."
	}
)
keywordHandler:addKeyword({"mr morris"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Exactly. Has a nice ring to it."
	}
)
keywordHandler:addKeyword({"oressa"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She's a good listener if you should still hesitate as to the choice of your definite vocation."
	}
)
keywordHandler:addKeyword({"plunderpurse"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Well, for him it's always been just a question of ''Your gold or your life'' - gold it is nowadays. \z
			You can stash your loose change at ol' Abram, but make sure to withdraw it once you leave Dawnport!"
	}
)
keywordHandler:addKeyword({"inigo"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ran across Inigo a few times on some remote islands, years and years ago. \z
			Talked him into coming along here, and he seems to enjoy helping newcomers find their way. \z
			Passing his knowledge on to the next generation."
	}
)
keywordHandler:addKeyword({"richard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We found him here half-dead and fixed him up, now he fixes us dinner and roof beams. \z
			Definitely someone you should check out for food, a rope and a shovel."
	}
)
keywordHandler:addKeyword({"ser tybald"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Been together through many a desperate situation. A romantic underneath it all. \z
			Found the time to specialise on spells for paladins and knights somewhere along the way."
	}
)
keywordHandler:addKeyword({"wentworth"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Be careful that he doesn't bore you to death with accountants of, well, your bank account history."
	}
)
keywordHandler:addKeyword({"woblin"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, the goblin who sneaks around here now and then? Lives in a cave to the west, somewhere."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Welcome, young adventurer. \z
If you seek to help me with some things, I might have a little {quest} or {mission} for you.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
