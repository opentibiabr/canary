local internalNpcName = "Hjaern"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 154,
	lookHead = 0,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 114,
	lookAddons = 3
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


	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 3 then
			if player:getStorageValue(Storage.TheIceIslands.Mission02) < 1 then
			npcHandler:say({
				"We could indeed need some help. These are very cold times. The ice is growing and becoming thicker everywhere ...",
				"The problem is that the chakoyas may use the ice for a passage to the west and attack Svargrond ...",
				"We need you to get a pick and to destroy the ice at certain places to the east. You will quickly recognise those spots by their unstable look ...",
				"Use the pickaxe on at least three of these places and the chakoyas probably won't be able to pass the ice. Once you are done, return here and report about your mission."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Mission02, 1) -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
			npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 4 then
			npcHandler:say("The spirits are at peace now. The threat of the chakoyas is averted for now. I thank you for your help. Perhaps you should ask Silfind if you can help her in some matters. ", npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 5)
			player:setStorageValue(Storage.TheIceIslands.Mission02, 5) -- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 29 then
			npcHandler:say({
				"There is indeed an important mission. For a long time, the spirits have been worried and have called us for help. It seems that some of our dead have not reached the happy hunting grounds of after life ...",
				"Everything we were able to find out leads to a place where none of our people is allowed to go. Just like we would never allow a stranger to go to that place ...",
				"But you, you are different. You are not one of our people, yet you have proven worthy to be one us. You are special, the child of two worlds ...",
				"We will grant you permission to travel to that isle of Helheim. Our legends say that this is the entrance to the dark world. The dark world is the place where the evil and lost souls roam in eternal torment ...",
				"There you find for sure the cause for the unrest of the spirits. Find someone in Svargrond who can give you a passage to Helheim and seek for the cause. Are you willing to do that?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 31 then
			npcHandler:say({
				"There is no need to report about your mission. To be honest, Ive sent a divination spirit with you as well as a couple of destruction spirits that were unleashed when you approached the altar ...",
				"Forgive me my secrecy but you are not familiar with the spirits and you might have get frightened. The spirits are at work now, destroying the magic with that those evil creatures have polluted Helheim ...",
				"I cant thank you enough for what you have done for the spirits of my people. Still I have to ask: Would you do us another favour?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 38 then
			npcHandler:say({
				"These are alarming news and we have to act immediately. Take this spirit charm of cold. Travel to the mines and find four special obelisks to mark them with the charm ...",
				"I can feel their resonance in the spirits world but we cant reach them with our magic yet. They have to get into contact with us in a spiritual way first ...",
				"This will help us to concentrate all our frost magic on this place. I am sure this will prevent to melt any significant number of demons from the ice ...",
				"Report about your mission when you are done. Then we can begin with the great ritual of summoning the children of Chyll ...",
				"I will also inform Lurik about the events. Now go, fast!"
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 39)
			player:setStorageValue(Storage.TheIceIslands.Mission11, 2) -- Questlog The Ice Islands Quest, Formorgar Mines 3: The Secret
			player:setStorageValue(Storage.TheIceIslands.Mission12, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			player:addItem(7289, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 39
				and player:getStorageValue(Storage.TheIceIslands.Obelisk01) == 5
				and player:getStorageValue(Storage.TheIceIslands.Obelisk02) == 5
				and player:getStorageValue(Storage.TheIceIslands.Obelisk03) == 5
				and player:getStorageValue(Storage.TheIceIslands.Obelisk04) == 5 then
			if player:removeItem(7289, 1) then
				player:setStorageValue(Storage.TheIceIslands.Questline, 40)
				player:setStorageValue(Storage.TheIceIslands.yakchalDoor, 1)
				player:setStorageValue(Storage.TheIceIslands.Mission12, 6) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
				player:setStorageValue(Storage.OutfitQuest.NorsemanAddon, 1) -- Questlog Norseman Outfit Quest
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
				player:addOutfit(251, 0)
				player:addOutfit(252, 0)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say({
					"Yes, I can feel it! The spirits are in touch with the obelisks. We will begin to channel a spell of ice on the caves. That will prevent the melting of the ice there ...",
					"If you would like to help us, you can turn in frostheart shards from now on. We use them to fuel our spell with the power of ice. ...",
					"Oh, and before I forget it - since you have done a lot to help us and spent such a long time in this everlasting winter, I have a special present for you. ...",
					"Take this outfit to keep your warm during your travels in this frozen realm!"
				}, npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		else
		npcHandler:say("I have now no mission for you.", npc, creature)
		npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "shard") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 40 then
			npcHandler:say("Do you bring frostheart shards for our spell?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 42 then
			npcHandler:say("Do you bring frostheart shards for our spell? ", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 44 then
			npcHandler:say("Do you want to sell all your shards for 2000 gold coins per each? ", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "reward") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 41 then
			npcHandler:say("Take this. It might suit your Nordic outfit fine. ", npc, creature)
			player:addOutfitAddon(252, 1)
			player:addOutfitAddon(251, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.TheIceIslands.Questline, 42)
			player:setStorageValue(Storage.OutfitQuest.NorsemanAddon, 2) -- Questlog Norseman Outfit Quest
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 43 then
			player:addOutfitAddon(252, 2)
			player:addOutfitAddon(251, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say("Take this. It might suit your Nordic outfit fine. From now on we only can give you 2000 gold pieces for each shard. ", npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 44)
			player:setStorageValue(Storage.OutfitQuest.NorsemanAddon, 3) -- Questlog Norseman Outfit Quest
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "tylaf") then
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 36 then
			npcHandler:say({
				"You encountered the restless ghost of my apprentice Tylaf in the old mines? We must find out what has happened to him. I enable you to talk to his spirit ...",
				"Talk to him and then report to me about your mission."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 37)
			player:setStorageValue(Storage.TheIceIslands.Mission10, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 2: Ghostwhisperer
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.Hjaern) ~= 1 then
			npcHandler:say('You want to sacrifice a cookie to the spirits?', npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("This is good news. As I explained, travel to Helheim, seek the reason for the unrest there and then report to me about your mission. ", npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 30)
			player:setStorageValue(Storage.TheIceIslands.Mission07, 2) -- Questlog The Ice Islands Quest, The Secret of Helheim
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Thank you my friend. The local representative of the explorers society has asked for our help ...",
				"You know their ways better than my people do and are probably best suited to represent us in this matter.",
				"Search for Lurik and talk to him about aprobable mission he might have for you."
			}, npc, creature)
			player:setStorageValue(Storage.TheIceIslands.Questline, 32)
			player:setStorageValue(Storage.TheIceIslands.Mission08, 1) -- Questlog The Ice Islands Quest, The Contact
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(7290, 5) then
				npcHandler:say("Excellent, you collected 5 of them. If you have collected 5 or more, talk to me about your {reward}. ", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 41)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(7290, 10) then
				npcHandler:say("Excellent, you collected 10 of them. If you have collected 15 or more, talk to me about your {reward}. ", npc, creature)
				player:setStorageValue(Storage.TheIceIslands.Questline, 43)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:getItemCount(7290) > 0 then
				local count = player:getItemCount(7290)
				player:addMoney(count * 2000)
				player:removeItem(7290, count)
				npcHandler:say("Here your are. " .. count * 2000 .. " gold coins for " .. count .. " shards.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			if not player:removeItem(130, 1) then
				npcHandler:say('You have no cookie that I\'d like.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.Hjaern, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('In the name of the spirits I accept this offer ... UHNGH ... The spirits are not amused!', npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	elseif MsgContains(message, 'no') then
		if npcHandler:getTopic(playerId) == 6 then
			npcHandler:say('I see.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, |PLAYERNAME|. The {spiritual} world looks upon you and your deeds.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
