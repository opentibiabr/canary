local internalNpcName = "Julius"
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
	lookHead = 114,
	lookBody = 114,
	lookLegs = 114,
	lookFeet = 113,
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

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(BloodBrothers.QuestLine) < 0 then
		npcHandler:setMessage(MESSAGE_GREET, "Be greeted, adventurer |PLAYERNAME|. I assume you have read the {note} about the {vampire} threat in this city.")
	elseif player:getStorageValue(BloodBrothers.QuestLine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Be greeted, adventurer |PLAYERNAME|. Please excuse me if I appear {distracted}!")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	if isInArray({"mission", "note", "vampire"}, message:lower()) then
		if player:getStorageValue(BloodBrothers.QuestLine) < 0 then
			npcHandler:say("Our nightly blood-sucking visitors put the inhabitants of Yalahar in constant danger. The worst thing is that anyone in this city could be a vampire. Maybe an outsider like you could help us. Would you try?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(BloodBrothers.Mission01) == 1 then
			if player:getSlotItem(CONST_SLOT_NECKLACE) then
				if player:getSlotItem(CONST_SLOT_NECKLACE).itemid == 3083 then
					npcHandler:say("Hmm, I see, I see. That necklace is only a small indication though... I think I need another proof, just to make sure. Say... have you ever baked {garlic bread}?", npc, creature)
					player:setStorageValue(BloodBrothers.Mission01, 2)
					npcHandler:setTopic(playerId, 2)
				else
					npcHandler:say("I fear that will not do. Sorry.", npc, creature)
				end
			else
				npcHandler:say("I fear that will not do. Sorry.", npc, creature)
			end
		elseif player:getStorageValue(BloodBrothers.Mission01) == 3 then
			npcHandler:say("Let me check - yes indeed, there's garlic in it. Now eat one, in front of my eyes. Right now! Say '{aaah}' when you've chewed it all down so that I can see you're not hiding it!", npc, creature)
			player:setStorageValue(BloodBrothers.GarlicBread, 0)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(BloodBrothers.Mission01) == 4 and player:getStorageValue(BloodBrothers.Mission02) < 0 then
			npcHandler:say("So, are you ready for your first real task?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(BloodBrothers.Mission02) == 1 then
			npcHandler:say("Are you back with confirmed names of possible vampires?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(BloodBrothers.Mission02) == 2 and player:getStorageValue(BloodBrothers.Mission03) < 0 then
			npcHandler:say({
				"Listen, I thought of something. If we could somehow figure out who among those five is their leader and manage to defeat him,the others might give up too. ...",
				"Without their leader they will at least be much weaker. Before I explain my plan, do you think you could do that?"}, npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(BloodBrothers.Mission03) == 2 then
			npcHandler:say("Oh! You look horrible - I mean, rather weary. What happened? Who is the master vampire?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(BloodBrothers.Mission03) == 3 and player:getStorageValue(BloodBrothers.Mission04) < 0 then
			npcHandler:say({
				"You know, I came to think that the spell didn't work because there is another, greater power behind all of this. I fear that if we don't find the source of the vampire threat we can't defeat them. ...",
				"I heard that there is an island not far from here. Unholy and fearsome things are said to happen there, and maybe that means vampires are not far away. ...",
				"I want you to try and convince someone with a boat to bring you to this island, Vengoth. I'll give you an empty map. Please map the area for me and pay special attention to unusual spots. ...",
				"Mark them on my map and come back once you have found at least five remarkable places on Vengoth. Can you do that for me?"}, npc, creature)
			npcHandler:setTopic(playerId, 12)
		end
	elseif message == "yes" then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Well, there's one problem. How would I know I can trust you? You might be one of them... hm. Can you think of something really unlikely for a vampire? If you know a way to prove it to me, ask me about your {mission}.", npc, creature)
			player:setStorageValue(BloodBrothers.QuestLine, 1)
			player:setStorageValue(BloodBrothers.Mission01, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Fine then. Talk to me again about your mission once you have the garlic bread. You can get holy water from a member of the inquisition.", npc, creature)
			player:setStorageValue(BloodBrothers.Mission01, 3)
		elseif npcHandler:getTopic(playerId) == 5 and player:getStorageValue(BloodBrothers.Mission01) == 4 then
		npcHandler:say({
			"As I already told you, anyone in this city could really be a vampire, even the most unsuspicious citizen. I want you to find that brood. ...",
			"You can possibly identify the vampires by using a trick with hidden garlic, but better put it into something unsuspicious, like... cookies maybe! ...",
			"Just bake a few by using holy water on flour, then use that holy water dough on garlic, use the garlic dough on a baking tray and finally place the tray on an oven. Then just play little girl scout and distribute some cookies to the citizens. ...",
			"Watch their reaction! If it's suspicious, write down the name and let me know. Then we'll work something out against them. Agreed?"}, npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Fine. Good luck! Talk to me again about your mission once you have confirmed the names of five suspects.", npc, creature)
			player:setStorageValue(BloodBrothers.Mission02, 1)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Alright, wait a moment. Tell me one name at a time so I can note them down carefully. Who is a suspect?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say({
				"Great, now here's my plan. As I said, my strength lies not on the battlefield, but it's theory and knowledge. While you were distributing cookies I developed a spell. ...",
				"This spell is designed to reveal the identity of the master vampire and force him to show his true face. It is even likely that it instantly defeats him. ...",
				"I want you to go to the five vampires you detected and try out the magic formula on them. One of them - the oldest and most powerful - will react to it, I'm sure of it. The words are: '{Alori Mort}'. Please repeat them."}, npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 12 then
			npcHandler:say({
				"Here is the map. When you are standing near a remarkable spot, use it to mark that spot on the map. Don't forget, come back with at least five marks! ...",
				"Also, they say there is a castle on this island. That mark HAS to be included, it's far too important to leave it out. Good luck!"}, npc, creature)
			player:addItem(8200)
			player:setStorageValue(BloodBrothers.Mission04, 1)
			player:setStorageValue(BloodBrothers.VengothAccess, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "garlic bread") or message == "no" then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Well, you need to mix flour with holy water and use that dough on garlic to create a special dough. Bake it like normal bread, but I guarantee that no vampire can eat that. Are you following me?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BloodBrothers.Cookies.Serafin) == 2 and player:getStorageValue(BloodBrothers.Cookies.Lisander) == 2 and player:getStorageValue(BloodBrothers.Cookies.Ortheus) == 2 and player:getStorageValue(BloodBrothers.Cookies.Maris) == 2 and player:getStorageValue(BloodBrothers.Cookies.Armenius) == 2 then
				npcHandler:say("I guess Armenius, Lisander, Maris, Ortheus and Serafin are all the names we can get for now. Let me think for a moment what we are going to do, talk to me about your mission again later.", npc, creature)
				player:setStorageValue(BloodBrothers.Mission02, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("No, no, I was asking for one of the names.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "aaah") then
		if npcHandler:getTopic(playerId) == 4 and player:getStorageValue(BloodBrothers.GarlicBread) == 1 then
			npcHandler:say("Very well. I think I can trust you now. Sorry that I had to put you through this embarassing procedure, but I'm sure you understand. So, are you ready for your first real task?", npc, creature)
			player:setStorageValue(BloodBrothers.Mission01, 4)
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:say("No, no, you didn't eat it! Vampire Brood! Say '{aaah}' once you have eaten the bread or get out of her instantly!", npc, creature)
		end
	elseif isInArray({"maris", "ortheus", "serafin", "lisander", "armenius"}, message:lower()) and npcHandler:getTopic(playerId) == 8 then
		if MsgContains(message, "maris") then
			if player:getStorageValue(BloodBrothers.Cookies.Maris) == 1 then
				npcHandler:say("He really doesn't look like the man of the sea he pretends to be, does he? Noted down! Any other name?", npc, creature)
				player:setStorageValue(BloodBrothers.Cookies.Maris, 2)
			elseif player:getStorageValue(BloodBrothers.Cookies.Maris) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		elseif MsgContains(message, "ortheus") then
			if player:getStorageValue(BloodBrothers.Cookies.Ortheus) == 1 then
				npcHandler:say("I always thought that there is not really a poor beggar hidden under those ragged clothes. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BloodBrothers.Cookies.Ortheus, 2)
			elseif player:getStorageValue(BloodBrothers.Cookies.Ortheus) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		elseif MsgContains(message, "serafin") then
			if player:getStorageValue(BloodBrothers.Cookies.Serafin) == 1 then
				npcHandler:say("Nice angelic name for a vampire. But he didn't escape your attention, well done. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BloodBrothers.Cookies.Serafin, 2)
			elseif player:getStorageValue(BloodBrothers.Cookies.Serafin) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		elseif MsgContains(message, "lisander") then
			if player:getStorageValue(BloodBrothers.Cookies.Lisander) == 1 then
				npcHandler:say("Yes, that pale skin and those black eyes speak volumes. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BloodBrothers.Cookies.Lisander, 2)
			elseif player:getStorageValue(BloodBrothers.Cookies.Lisander) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		elseif MsgContains(message, "armenius") then
			if player:getStorageValue(BloodBrothers.Cookies.Armenius) == 1 then
				npcHandler:say("Ahh, I always thought something was suspicious about him. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BloodBrothers.Cookies.Armenius, 2)
			elseif player:getStorageValue(BloodBrothers.Cookies.Armenius) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif npcHandler:getTopic(playerId) == 7 then
		npcHandler:say("Then try harder.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 8 then
		npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
	elseif message:lower() == "alori mort" and npcHandler:getTopic(playerId) == 10 then
		npcHandler:say("Good. Don't play around with the spell, only use it when standing in front of those vampires. Come back and report to me about your progress later.", npc, creature)
		player:setStorageValue(BloodBrothers.Mission03, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "armenius") and npcHandler:getTopic(playerId) == 11 then
		npcHandler:say("I see... so Armenius is the master, and the spell didn't even cause a scratch on him... Well, that went worse than expected. Let me think for a moment and then ask me about a mission again.", npc, creature)
		player:setStorageValue(BloodBrothers.Mission03, 3)
		npcHandler:setTopic(playerId, 0)
	else
		npcHandler:say("Getting cold feet, eh?", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
end
--Basic
keywordHandler:addKeyword({"distracted"}, StdModule.say, {npcHandler = npcHandler, text = "I come from a family of {vampire} hunters, but to be honest, I'm more into the theoretic part and strategic planning."})
keywordHandler:addAliasKeyword({"job"})
keywordHandler:addKeyword({"yalahar"}, StdModule.say, {npcHandler = npcHandler, text = "A better name would be Gomorrah, if you ask me."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "My name is Julius."})
keywordHandler:addKeyword({"storkus"}, StdModule.say, {npcHandler = npcHandler, text = "Storkus? Oh yes, I know him. A long time ago we used to hunt together... sometimes."})
keywordHandler:addKeyword({"time"}, StdModule.say, {npcHandler = npcHandler, text = "It's about time you showed the vampires that they should never bother the citizens again."})
keywordHandler:addKeyword({"news"}, StdModule.say, {npcHandler = npcHandler, text = "Another vampire raid last night. But then again, that's nothing new."})
keywordHandler:addKeyword({"thank"}, StdModule.say, {npcHandler = npcHandler, text = "Well, I should be the one to thank you I guess."})

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. Never trust anyone.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "I'll reward you for every pair of vampire teeth you bring me.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "blood preservation", clientId = 11449, sell = 320 },
	{ itemName = "vampire teeth", clientId = 9685, sell = 275 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
