local internalNpcName = "Dorian"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 22,
	lookBody = 58,
	lookLegs = 77,
	lookFeet = 21,
	lookAddons = 2,
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
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 1 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission01) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission01, 1)
			npcHandler:say({
				"Your first job is quite easy. The Thaian officials are unwilling to share the wealth they've accumulated in their new town Port Hope. ...",
				"They insist that most resources belong to the crown. This is quite sad, especially ivory is in high demand. Collect 10 elephant tusks and bring them to me.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission01) == 1 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 2 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission02) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission02, 1)
			npcHandler:say({
				"A client of our guild would like to get a certain vase. Unfortunately, it's not for sale. Well, by the original owner, that is. ...",
				"We, on the other hand, would gladly sell him the vase. Therefore, it would come in handy if we get this vase in our hands. ...",
				"Luckily, the walls of the owner's house are covered with vines, that will make a burglary quite easy. ...",
				"You'll still need some lock picks to get the chest open in which the vase is stored. Must be your lucky day, as I'm selling lock picks for a fair price. ...",
				"You might need some of them to get that chest open. The soon to be ex-owner of that vase is Sarina, the proprietor of Carlin's general store.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission02) == 2 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 3 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission03) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission03, 1)
			npcHandler:say({
				"Our beloved king will hold a great festivity at the end of the month. Unfortunately he forgot to invite one of our guild's representatives. ...",
				"Of course it would be rude to point out this mistake to the king. It will be your job to get us an invitation to the ball. ...",
				"Moreover, It will be a great chance to check the castle for, well, opportunities. I'm sure you understand. However, it's up to that pest Oswald to give out invitations, so he's the man you're looking for.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission03) == 2 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 4 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04, 1)
			npcHandler:say({
				"Your next mission is somewhat bigger and I'm sure much fun for you. Some new-rich merchant is being a bit more greedy than it's good for him. ...",
				"The good thing is he's as stupid as greedy, so we have a little but cunning plan. We arranged the boring correspondence in advance, so you'll come in when the fun starts. ...",
				"You'll disguise yourself as the dwarven ambassador and sell that fool the old dwarven bridge, south of Kazordoon. ...",
				"Well, actually it is a bit more complicated than that. Firstly, you'll have to get forged documents. Ask around in the criminal camp to find a forger. ...",
				"Secondly, you'll need a disguise. Percybald in Carlin is an eccentric actor that might help you with that. ...",
				"As soon as you got both things, travel to Venore and find the merchant Nurik. Trade the false documents for the famous painting of Mina Losa and bring it to me.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04) == 7 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 5 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission05) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission05, 1)
			npcHandler:say({
				"Your next mission will lead you to Tiquanda. There is a hidden smugglers cave, north of town. ...",
				"These smugglers think they don't have to pay us respect and try to withhold our share of the profit. Recently, they got hold of a certain valuable goblet. ...",
				"Find them and get us this goblet as rightful payment. If you have to bash some noses during your mission, even better.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission05) == 1 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 6 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission06) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission06, 1)
			npcHandler:say({
				"Your next job will be kidnapping. You'll get us the only creature that this scrupulous trader Theodore Loveless in Liberty Bay holds dear. ...",
				"His little goldfish! To get that fish, you'll have to get in his room somehow. ...",
				"As you might know I sell lock picks, but I fear unless you're extremely lucky, you won't crack this expensive masterpiece of a lock. However, get us that fish, regardless how.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission06) == 3 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 7 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission07) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission07, 1)
			npcHandler:say({
				"We'd like to ease our lives somewhat. Therefore, we would appreciate the cooperation with one of the Venore city guards. ...",
				"Find some dirt about one of them. It's unimportant what it is. As soon as we have a foothold, we'll convince him to cooperate. Bring me whatever you may find.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission07) == 1 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) == 8 and player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08) < 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08, 1)
			player:addItem(7873, 1)
			npcHandler:say({
				"Competition might be an interesting challenge but our guild isn't really keen on competition. ...",
				"Unfortunately, we are lacking some good fighters, which is quite a disadvantage against certain other organisations. However, I think you're a really good fighter ...",
				"Travel to the Plains of Havoc and find the base of our competitors under the ruins of the dark cathedral ...",
				"On the lowest level, you'll find a wall with two trophies. Place a message of our guild on the wall, right between the trophies. On your way, get rid of as many of our competitors as you can.",
			}, npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08) == 2 then
			npcHandler:say("Have you finished your mission?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 1)
			npcHandler:say({
				"Excellent. You'll learn this trade from scratch. Our operations cover many fields of work. Some aren't even illegal. ...",
				"Well, as long as you don't get caught at least. Ask me for a mission whenever you're ready.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeItem(3044, 10) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission01, 2)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 2)
				npcHandler:say("What a fine material. That will be worth a coin or two. So far, so good. Ask me for another mission if you're ready for it.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(227, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission02, 3)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 3)
				npcHandler:say("What an ugly vase. But who am I to question the taste of our customers? Anyway, I might have another mission in store for you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(7933, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission03, 3)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 4)
				npcHandler:say({
					"Ah, the key to untold riches. Don't worry, we'll make sure that no one will connect you to the disappearance of certain royal possessions. ...",
					"You're too valuable to us. Speaking about your value, I might have some other mission for you.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(7871, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission04, 8)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 5)
				npcHandler:say("Excellent, that serves this fool right. I fear in your next mission, you'll have to get your hands dirty. Just ask me to learn more about it.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(7369, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission05, 2)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 6)
				npcHandler:say("That goblet is hardly worth all this trouble but we had to insist on our payment. However, I assume you are eager for more missions, so just ask.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(7936, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission06, 4)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 7)
				npcHandler:say("This little goldfish will bring us a hefty ransom! Just ask me if you're ready for another mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(7935, 1) then
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission07, 2)
				player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 8)
				npcHandler:say({
					"Excellent, that little letter will do the trick for sure ...",
					"I think you're really capable and if you finish another mission, I'll allow you full access to our black market of lost and found items. Just ask me to learn more about that mission.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Mission08, 3)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline, 9)
			player:setStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Door, 1)
			npcHandler:say({
				"Once again you've finished your job, and I'll keep my promise. From now on, you can trade with old Black Bert somewhere upstairs to get access to certain items that mightbe of value to someone like you. ...",
				"If you like, you can also enter the room to the left and pick one item of your choice.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "thieves") or MsgContains(message, "join") then
		if player:getStorageValue(Storage.Quest.U8_2.TheThievesGuildQuest.Questline) < 1 then
			npcHandler:say("Hm. Well, we could use some fresh blood. Ahum. Do you want to join the thieves guild, |PLAYERNAME|?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "lock pick") then
		npcHandler:say("Yes, I sell lock picks. Ask me for a trade.", npc, creature)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|! Why do you disturb me?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "lock pick", clientId = 7889, buy = 50 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
