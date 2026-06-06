local internalNpcName = "Tooth Fairy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 223,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I have to ... No, I don't dare ..." },
	{ text = "This is a very strange part of the world." },
	{ text = "The children are waiting for their presents." },
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

	if MsgContains(message, "mission") then
		if player:getLevel() < 30 then
			npcHandler:say("Oh! You need to be a little more grown in order I can seek your help.", npc, creature)
			return true
		end
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy) < 1 then
			npcHandler:say({
				"You've got me, I really have a little problem here. What gave it away? My sorrowful expression? Yes, I thought so. This is what troubles me: I'm the tooth fairy. Well, this wouldn't be a problem at all under normal circumstances. ...",
				"I love gathering children's milk teeth and bringing presents for them. Until now, I did so by using a spell. This spell teleported me into the children's bedrooms and - after carrying out my duty - back to my secret realm. ...",
				"But then I made the mistake of using a magical portal and entering this part of the world. Everything is strange and different here and the worst thing: my spells don't work! It will take some time until I can use the portal again. ...",
				"Thus I'm stuck here for a while. But there are some children who lost their first milk tooth and are now waiting for their presents. Without my spells, I'm feeling utterly helpless. ...",
				"I don't dare going to their homes at night but I know they will be sad about the missing presents. Would you help me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end

		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy) == 1 then
			if player:removeItem(25303, 3) then
				npcHandler:say({
					"You're bringing the milk teeth! Thank you, human being; you were of great assistance to me! Please take this in return. It's the part of a map. If you find the other parts, it will show you the way to a hidden fairy treasure. ...",
					"Oh, and if you're interested, there's still another {cause} you could help me with.",
				}, npc, creature)
				player:addItem(24943, 1)
				player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy, 2)
			else
				npcHandler:say("You need to bring me 3 milk teeth.", npc, creature)
			end
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say({
			"Thank you very much, human being! You have to find three children: Quero's daughter in Thais, Allen's son in Venore and Rowenna's daughter in Carlin. Go to their bedrooms and find their milk teeth. ...",
			"Usually they put them on their bed stands. Then you have to put the gifts on their beds. Please take these presents and go to Thais, Carlin and Venore. Come back with the milk teeth.",
		}, npc, creature)
		player:addItem(25302, 3)
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy, 1)
		npcHandler:setTopic(playerId, 0)
	end

	if (MsgContains(message, "cause") or MsgContains(message, "tooth") or MsgContains(message, "teeth") or MsgContains(message, "fang")) and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.ToothFairy) == 2 then
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TeethCollection) < 1 then
			npcHandler:say({
				"As I'm the tooth fairy it should not surprise you to hear that I have a small collection. Yes, a tooth collection, of course. But I'm still lacking some special specimens. ...",
				"I would give you a little reward if you bring me all of the following: an orc tooth, a shark tooth, a vampire tooth, a behemoth fang, a carrion worm fang or a werewolf fangs.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TeethCollection, 1)
		end
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TeethCollection) == 1 then
			npcHandler:say("Did you brought all the teeth for my collection?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		if player:removeItem(10196, 1) and player:removeItem(22649, 1) and player:removeItem(9685, 1) and player:removeItem(5893, 1) and player:removeItem(10275, 1) and player:removeItem(22052, 1) then
			npcHandler:say("Oh, I see! You really found all the teeth for me! Thank you, human being! Please take this in return.", npc, creature)
			player:addItem(3026, 6)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission04.TeethCollection, 2)
			if not player:hasAchievement("Toothfairy Assistant") then
				player:addAchievement("Toothfairy Assistant")
			end
		else
			npcHandler:say("You don't have all of the teeth I need for my collection.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is a secret. Sorry but I won't tell you." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the {tooth fairy}. I would think that says it all. I took over the body of a {seagull}." })
keywordHandler:addKeyword({ "tooth fairy" }, StdModule.say, { npcHandler = npcHandler, text = "I'm a fae. A rather unique kind of {fae}, because - as I said - I have a special responsibility for mortal children's {milk teeth}." })
keywordHandler:addKeyword({ "seagull" }, StdModule.say, { npcHandler = npcHandler, text = "Outside of our secret {realm} my {siblings} and I can't keep our true shape. If we want to travel other parts of the world, we must take over the bodies of animals. But we are causing them no harm and we just take control if necessary." })
keywordHandler:addKeyword({ "fae", "siblings" }, StdModule.say, { npcHandler = npcHandler, text = "Some call us nature spirits or peri but we prefer the term fae. Most of us are rather reclusive and live peaceful lives in our secret {realm}. We only leave it in order to {protect} our home. As we tend to be secretive about our true nature I'm afraid I can't tell you more." })
keywordHandler:addKeyword({ "protect" }, StdModule.say, { npcHandler = npcHandler, text = "Something is threatening our realm. But I don't know the details. If you are interested you should talk to {Alkestios}." })
keywordHandler:addKeyword({ "realm" }, StdModule.say, { npcHandler = npcHandler, text = "We call it Feyrist and it is a secret, hidden place. Just few mortals get permission to enter it. A long time ago, we learned how to hide our realm from the outside world. Only if you gain our trust I will tell you how to reach it." })
keywordHandler:addKeyword({ "alkestios" }, StdModule.say, { npcHandler = npcHandler, text = "He's a brother of mine. He took it upon himself to kind of lead our mission in the outside world. You may find him south of {Ab'Dendriel}." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of life, huge trees, lush plants and various animals." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "This is the world we are living in - and this place here in particular is very strange, if you're asking me." })
keywordHandler:addKeyword({ "thais", "carlin", "venore" }, StdModule.say, { npcHandler = npcHandler, text = "It's a place full of stone buildings and people. In addition, there is a small {child} waiting for a present. *sigh*." })
keywordHandler:addKeyword({ "child" }, StdModule.say, { npcHandler = npcHandler, text = "Small creatures, the offspring of mortals like {humans}, {elves} or {dwarves}. They have the most colourful and vivid dreams. And they lose their first teeth when they grow. I gather these teeth and give them a present in return." })
keywordHandler:addKeyword({ "human" }, StdModule.say, { npcHandler = npcHandler, text = "They inhabit these huge places filled with stone buildings. They call them towns, I guess. And they have children who are waiting for their presents. *sigh*." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "They are inhabiting Ab'Dendriel and live in close touch with nature." })
keywordHandler:addKeyword({ "dwarves" }, StdModule.say, { npcHandler = npcHandler, text = "They are living underneath the earth and are ... digging. Or so I heard." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, human being.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care of your teeth!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
