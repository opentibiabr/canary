local internalNpcName = "Bron"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 143,
	lookHead = 95,
	lookBody = 94,
	lookLegs = 132,
	lookFeet = 86,
	lookAddons = 2
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh no! Was that really me? This is so embarassing, I have no idea what has gotten into me. Was that the fighting spirit you gave me?")
	end
	return true
end

keywordHandler:addKeyword({'gelagos'}, StdModule.say, {npcHandler = npcHandler, text = "This... person... makes me want to... say something bad... must... control myself. <sweats>"})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({"recruitment", "violence", "outfit", "addon"}, message) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) < 1 then
			npcHandler:say({
				"Convincing Ajax that it is not always necessary to use brute force... this would be such an achievement. Definitely a hard task though. ...",
				"Listen, I simply have to ask, maybe a stranger can influence him better than I can. Would you help me with my brother?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif(MsgContains(message, "fist")) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 3 then
			npcHandler:say("Oh! He really said that? I am so proud of you, |PLAYERNAME|. These are really good news. Everything would be great... if only there wasn't this {person} near my house.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif(MsgContains(message, "person")) then
		if(npcHandler:getTopic(playerId) == 3) then
			npcHandler:say({
				"This... person... makes me want to... say something bad... must... control myself. <sweats> I really don't know what to do anymore. ...",
				"I wonder if Ajax has an idea. Could you ask him about Gelagos?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif(MsgContains(message, "fighting spirit")) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 5 then
			if player:removeItem(5884, 1) then
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 6)
				npcHandler:say("Fighting spirit? What am I supposed to do with this fi... - oh! I feel strange... ME MIGHTY! ME WILL CHASE OFF ANNOYING KIDS!GROOOAARR!! RRRRRRRRRRRRAAAAAAAGE!!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif(MsgContains(message, "cloth")) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 7 then
			npcHandler:say("Have you really managed to fulfil the task and brought me 50 pieces of red cloth and 50 pieces of green cloth?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif(MsgContains(message, "silk")) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 8 then
			npcHandler:say("Oh, did you bring 10 rolls of spider silk yarn for me?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif(MsgContains(message, "sweat")) then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 9 then
			npcHandler:say("Were you able to get hold of a flask with pure warrior's sweat?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		end
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say({
				"Really! That is such an incredibly nice offer! I already have a plan. You have to teach him that sometimes words are stronger than fists. ...",
				"Maybe you can provoke him with something to get angry, like saying... 'MINE!' or something. But beware, I'm sure that he will try to hit you. ...",
				"Don't do this if you feel weak or ill. He will probably want to make you leave by using violence, but just stay strong and refuse to give up. ...",
				"If he should ask what else is necessary to make you leave, tell him to 'say please'. Afterwards, do leave and return to him one hour later. ...",
				"This way he might learn that violence doesn't always help, but that a friendly word might just do the trick. ...",
				"Have you understood everything I told you and are really willing to take this risk?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("You are indeed not only well educated, but also very courageous. I wish you good luck, you are my last hope.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler:setTopic(playerId, 0)
		elseif(npcHandler:getTopic(playerId) == 4) then
			npcHandler:say("Again, I have to thank you for your selfless offer to help me. I hope that Ajax can come up with something, now that he has experienced the power of words.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 4)
			npcHandler:setTopic(playerId, 0)
		elseif(player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 6 and npcHandler:getTopic(playerId) == 0) then
			npcHandler:say({
				"I'm impressed... I am sure this was Ajax' idea. I would love to give him a present, but if I leave my hut to gather ingredients, hewill surely notice. ...",
				"Would you maybe help me again, one last time, my friend? I assure you that your efforts will not be in vain."
			}, npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif(npcHandler:getTopic(playerId) == 6) then
			npcHandler:say({
				"Great! You see, I really would love to sew a nice shirt for him. I just need a few things for that, so please listen closely: ...",
				"He loves green and red, so I will need about 50 pieces of red cloth - like the material heroes make their capes of - and 50 pieces of the green cloth Djinns like. ...",
				"Secondly, I need about 10 rolls of spider silk yarn. I think mermaids can yarn silk of large spiders to create a smooth thread. ...",
				"The only remaining thing needed would be a bottle of warrior's sweat to spray it over the shirt... he just loves this smell. ...",
				"Have you understood everything I told you and are willing to handle this task?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif(npcHandler:getTopic(playerId) == 7) then
			npcHandler:say("Thank you, my friend! Come back to me once you have collected 50 pieces of red cloth and 50 pieces of green cloth.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 7)
			npcHandler:setTopic(playerId, 0)
		elseif(npcHandler:getTopic(playerId) == 8) then
			if player:getItemCount(5910) >= 50 and player:getItemCount(5911) >= 50 then
				npcHandler:say("Terrific! I will start to trim it while you gather 10 rolls of spider silk. I'm sure that Ajax will love it.", npc, creature)
				player:removeItem(5910, 50)
				player:removeItem(5911, 50)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 8)
				npcHandler:setTopic(playerId, 0)
			end
		elseif(npcHandler:getTopic(playerId) == 9) then
			if player:removeItem(5886, 10) then
				npcHandler:say("I'm impressed! You really managed to get spider silk yarn for me! I will immediately start to work on this shirt. Please don't forget to bring me warrior's sweat!", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 9)
				npcHandler:setTopic(playerId, 0)
			end
		elseif(npcHandler:getTopic(playerId) == 10) then
			if player:removeItem(5885, 1) then
				npcHandler:say("Good work, |PLAYERNAME|! Now I can finally finish this present for Ajax. Because you were such a great help, I have also a present for you. Will you accept it?", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 10)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 10 then
			npcHandler:say("I have kept this traditional barbarian wig safe for many years now. It is now yours! I hope you will wear it proudly, friend.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 11)
			player:addOutfitAddon(147, 2)
			player:addOutfitAddon(143, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care!")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
