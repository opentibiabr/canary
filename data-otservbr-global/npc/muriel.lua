local internalNpcName = "Muriel"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 115,
	lookBody = 94,
	lookLegs = 97,
	lookFeet = 76,
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getLevel() < 35 then
			npcHandler:say("Indeed there is something to be done, but I need someone more experienced. Come back later if you want to.", npc, creature)
			return true
		end

		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == -1 then
			npcHandler:say({
				"Indeed, there is something you can do for me. You must know I am researching for a new spell against the undead. ...",
				"To achieve that I need a desecrated bone. There is a cursed bone pit somewhere in the dungeons north of Thais where the dead never rest. ...",
				"Find that pit, dig for a well-preserved human skeleton and conserve a sample in a special container which you receive from me. Are you going to help me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == 1 then
			npcHandler:say({
				"The rotworms dug deep into the soil north of Thais. Rumours say that you can access a place of endless moaning from there. ...",
				"No one knows how old that common grave is but the people who died there are cursed and never come to rest. A bone from that pit would be perfect for my studies.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == 2 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit, 3)
			if player:removeItem(131, 1) then
				player:addItem(6299, 1)
				npcHandler:say("Excellent! Now I can try to put my theoretical thoughts into practice and find a cure for the symptoms of undead. Here, take this for your efforts.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					"I am so glad you are still alive. Benjamin found the container with the bone sample inside. Fortunately, I inscribe everything with my name, so he knew it was mine. ...",
					"I thought you have been haunted and killed by the undead. I'm glad that this is not the case. Thank you for your help.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		else
			npcHandler:say("I am very glad you helped me, but I am very busy at the moment.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "addons") then
		local hasMasks = player:getItemCount(25088) >= 3
		local hasFeathers = player:getItemCount(25089) >= 50
		if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) == 2 and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1) == 1 and hasMasks then
			npcHandler:say("I see you have the porcelain masks. Are you ready to exchange them for the first addon?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) == 2 and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2) == 1 and hasFeathers then
			npcHandler:say("I see you have the colourful feathers. Are you ready to exchange them for the second addon?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say("You need the outfit and 3 porcelain masks or 50 colored feathers to get the festive costume accessories.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mask") and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1) == 1 then
		if player:removeItem(25088, 3) then
			player:addOutfit(929, 1)
			player:addOutfit(931, 1)
			npcHandler:say("Very good! You gained the first addon to the festive outfit.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Oh, sorry but you don't have enough porcelain masks!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "feather") and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2) == 1 then
		if player:removeItem(25089, 50) then
			player:addOutfit(929, 2)
			player:addOutfit(931, 2)
			npcHandler:say("Very good! You gained the second addon to the festive outfit.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Oh, sorry but you don't have enough colourful feathers!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Great! Here is the container for the bone. Once, I used it to collect ectoplasma of ghosts, but it will work here as well. ...",
				"If you lose it, you can buy a new one from the explorer's society in North Port or Port Hope. Ask me about the mission when you come back.",
			}, npc, creature)
			player:addItem(4852, 1)
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me three porcelain masks. For the second addon you need fifty colourful ostrich feathers. Do you want one of these addons?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("What do you have for me: the porcelain masks or the colourful feathers?", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1, 1)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me three porcelain masks. For the second addon you need fifty colourful ostrich feathers. Do you want one of these addons?", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2, 1)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Ohh, then I need to find another adventurer who wants to earn a great reward. Bye!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|! Looking for wisdom and power, eh?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
