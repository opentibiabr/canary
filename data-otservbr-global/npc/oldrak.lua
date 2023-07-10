local internalNpcName = "Oldrak"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 150
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 57,
	lookHead = 115,
	lookBody = 113,
	lookLegs = 31,
	lookFeet = 38,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {
	{ itemName = "holy tible", clientId = 2836 }
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

keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I guard this humble temple as a monument for the order of the {nightmare knights}."})
keywordHandler:addAliasKeyword({"visitors"})

keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "My name is Oldrak."})
keywordHandler:addKeyword({"monster"}, StdModule.say, {npcHandler = npcHandler, text = "These plains are not safe for ordinary travellers. It will take heroes to survive here."})
keywordHandler:addKeyword({"help"}, StdModule.say, {npcHandler = npcHandler, text = "I can't help you, sorry!"})
keywordHandler:addKeyword({"goshnar"}, StdModule.say, {npcHandler = npcHandler, text = "The greatest necromant who ever cursed our land with the steps of his feet. He was defeated by the nightmare knights."})
keywordHandler:addKeyword({"nightmare"}, StdModule.say, {npcHandler = npcHandler, text = "This ancient order was created by a circle of wise humans who were called 'The {Dreamers}'. The order became {extinct} a long time ago."})
keywordHandler:addKeyword({"extinct"}, StdModule.say, {npcHandler = npcHandler, text = "Many perished in their battles against evil, some went mad, not able to stand their nightmares any longer. Others were seduced by the darkness."})
keywordHandler:addKeyword({"dreamers"}, StdModule.say, {npcHandler = npcHandler, text = "They learned the ancient art of {dreamwalking} from some elves they befriended."})
keywordHandler:addKeyword({"dreamwalking"}, StdModule.say, {npcHandler = npcHandler, text = "While the dreamwalkers of the elves experienenced the brightest dreams of pleasure, the humans strangely had dreams of {dark omen}."})
keywordHandler:addKeyword({"omen"}, StdModule.say, {npcHandler = npcHandler, text = "They dreamed of doom, destruction, talked to dead, tormented souls, and gained unwanted insight into the {schemes of darkness}."})
keywordHandler:addKeyword({"schemes of darkness"}, StdModule.say, {npcHandler = npcHandler, text = "They figured out how to interpret their dark dreams and so could foresee the plans of the dark gods and their minions."})
keywordHandler:addKeyword({"plan"}, StdModule.say, {npcHandler = npcHandler, text = "Using this knowledge they formed an order to thwart these plans, and because they battled their nightmares as brave as knights, they named their order accordingly."})
keywordHandler:addKeyword({"necromant"}, StdModule.say, {npcHandler = npcHandler, text = "It is rumoured to open the entrance to the pits of inferno, also called the nightmare pits. Even if I knew about this secret I wouldn't tell you."})
keywordHandler:addKeyword({"havok"}, StdModule.say, {npcHandler = npcHandler, text = "Before the battles raged across them, they were called the fair plains."})
keywordHandler:addKeyword({"tibia"}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are. The world of Tibia."})
keywordHandler:addKeyword({"god"}, StdModule.say, {npcHandler = npcHandler, text = "They created Tibia and all life on it ... and unlife, too."})
keywordHandler:addKeyword({"unlife"}, StdModule.say, {npcHandler = npcHandler, text = "Beware the foul undead!"})
keywordHandler:addKeyword({"undead"}, StdModule.say, {npcHandler = npcHandler, text = "Beware the foul undead!"})
keywordHandler:addKeyword({"excalibug"}, StdModule.say, {npcHandler = npcHandler, text = "A weapon of myth and legend. It was lost in ancient times ... perhaps lost forever."})
keywordHandler:addKeyword({"yenny the gentle"}, StdModule.say, {npcHandler = npcHandler, text = "Yenny, known as the Gentle, was one of most powerfull magicwielders in ancient times and known throughout the world for her mercy and kindness."})
keywordHandler:addKeyword({"offer"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({"trade"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({"sell"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({"buy"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({"have"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you the holy tible for a small fee."})
keywordHandler:addKeyword({"time"}, StdModule.say, {npcHandler = npcHandler, text = "Now, it is |TIME|."})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	-- Demon oak quest
	if MsgContains(message, "mission") or MsgContains(message, "demon oak") then
		if player:getStorageValue(Storage.DemonOak.Done) < 1 then
			npcHandler:say("How do you know? Did you go into the infested area?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.DemonOak.Progress) == 2 and player:getStorageValue(Storage.DemonOak.Done) < 1 then
			npcHandler:say("You better don't return here until you've defeated the Demon Oak.", npc, creature)
		elseif player:getStorageValue(Storage.DemonOak.Done) == 1 then
			npcHandler:say({
				"You chopped down the demon oak?!? Unbelievable!! Let's hope it doesn't come back. As long as evil is still existent in the soil of the plains, it won't be over. Still, the demons suffered a setback, that's for sure. ...",
				"For your brave action, I tell you a secret which has been kept for many many years. There is an old house south of the location where you found the demon oak. There should be a grave with the name 'Yesim Adeit' somewhere close by. ...",
				"It belongs to a Daramian nobleman named 'Teme Saiyid'. I knew him well and he told me -almost augured- that someone will come who is worthy to obtain his treasure. I'm sure this 'someone' is you. Good luck in finding it!"
			}, npc, creature)
			player:setStorageValue(Storage.DemonOak.Done, 2)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		player:setStorageValue(Storage.DemonOak.Progress, 1)
		if player:getStorageValue(Storage.DemonOak.Progress) == 1 then
			npcHandler:say("A demon oak?!? <mumbles some blessings> May the gods be on our side. You'll need a {hallowed axe} to harm that tree. Bring me a simple {axe} and I'll prepare it for you.", npc, creature)
			player:setStorageValue(Storage.DemonOak.Progress, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I don't believe a word of it! How rude to lie to a monk!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "axe") then
		if player:getStorageValue(Storage.DemonOak.Progress) == 2 then
			npcHandler:say("Ahh, you've got an axe. Very good. I can make a hallowed axe out of it. It will cost you... er... a donation of 1,000 gold. Alright?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say("You have to first talk about {demon oak} or the {mission} before we continue.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		if player:getStorageValue(Storage.DemonOak.Progress) == 2 then
			if player:getMoney() + player:getBankBalance() >= 1000 then
				if player:removeItem(3274, 1) and player:removeMoneyBank(1000) then
					npcHandler:say("Let's see....<mumbles a prayer>....here we go. The blessing on this axe will be absorbed by all the demonic energy around here. I presume it will not last very long, so better hurry. Actually, I can refresh the blessing as often as you like.", npc, creature)
					player:addItem(919, 1)
					npc:getPosition():sendMagicEffect(CONST_ME_YELLOWENERGY)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("There is no axe with you.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			else
				npcHandler:say("There is not enough of money with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("What a pity! Let me know when you managed to get in there. Maybe I can help you when we know what we are dealing with.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("No then.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	-- The paradox tower quest
	if MsgContains(message, "hugo") then
		npcHandler:say("Ah, the curse of the Plains of Havoc, the hidden beast, the unbeatable foe. I've been living here for years and I'm sure this is only a myth.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "myth") then
		if player:getStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo) < 1 then
			-- Questlog: The Paradox Tower
			player:setStorageValue(Storage.Quest.U7_24.TheParadoxTower.QuestLine, 1)
			-- Questlog: The Feared Hugo (Zoltan)
			player:setStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo, 1)
		end
		npcHandler:say("There are many tales about the fearsome Hugo. It's said it's an abnormality, accidentally created by Yenny the Gentle. It's half demon, half something else and people say it's still alive after all these years.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yenny the gentle") then
		npcHandler:say("Yenny, known as the Gentle, was one of the most powerful wielders of magic in ancient times. She was known throughout the world for her mercy and kindness.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! Only rarely I can welcome {visitors} these days.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care, it's dangerous out there.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good Bye, |PLAYERNAME|")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
