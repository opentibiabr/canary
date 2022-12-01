local internalNpcName = "Raymond Striker"
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
	lookHead = 39,
	lookBody = 77,
	lookLegs = 98,
	lookFeet = 95,
	lookAddons = 1
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

	if MsgContains(message, "eleonore") then
		if player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) < 1 then
			npcHandler:say("Eleonore ... Yes, I remember her... vaguely. She is a pretty girl ... but still only a girl and now I am in love with a beautiful and passionate woman. A true {mermaid} even.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) < 1 then
			npcHandler:say("Don't ask about silly missions. All I can think about is this lovely {mermaid}.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) == 3 and player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) < 1 then
			npcHandler:say("Ask around in the settlement where you can help out. If you have proven your worth I might have some missions for you.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 14 and player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) < 1 then
			npcHandler:say({
				'Indeed, I could use some help. The evil pirates of Nargor have convinced an alchemist from Edron to supply them with a substance called Fafnar\'s Fire ...',
				'It can burn even on water and is a threat to us all. I need you to travel to Edron and pretend to the alchemist Sandra that you are the one whom the other pirates sent to get the fire ...',
				'When she asks for a payment, tell her \'Your continued existence is payment enough\'. That should enrage any member of the Edron academy enough to refuse any further deals with the pirates.',
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission1, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 2 then
			npcHandler:say("I think that means 'mission accomplished'. Hehe. I guess that will put an end to their efforts to buy any alchemical substance from Edron.", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 15)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission1, 3)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 3 and player:getStorageValue(Storage.TheShatteredIsles.RaysMission2) < 1 then
			npcHandler:say({
				'The mission on which I will send you is vital to our cause. It is a sabotage mission. Nargor is guarded by several heavy catapults. ...',
				'I need you to sabotage the most dangerous of those catapults which can be found right in their harbour, aiming at ships passing by the entrance. ...',
				'Get a fire bug - you can buy them in Liberty Bay - and set this catapult on fire. ...',
				'Make sure to use the bug on the left part of the catapult where its lever is. That is where it\'s most vulnerable. ...',
				'If you see a short explosion, you will know that it worked. I will tell Sebastian to bring you to Nargor, but beware. ...',
				'Of course, he can\'t drop you off directly in the pirate\'s base. However, we have discovered a secret way into the Howling Grotto. ...',
				'Try to make your way through the caves of Nargor to reach their harbour. This is where you will find the catapult in question.'
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.AccessToNargor, 1)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission2, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission2) == 2 and player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 16 then
			npcHandler:say("You did it! Excellent!", npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 18)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission2, 3)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission2) == 3 and player:getStorageValue(Storage.TheShatteredIsles.RaysMission3) < 1 then
			npcHandler:say({
				'If you manage to accomplish this vital mission you will prove yourself to be a worthy member of our community. Imight even grant you your own ship and pirate clothing! ...',
				'So listen to the first step of my plan. I want you to infiltrate their base. Try to enter their tavern, which meansthat you have to get past the guard. ...',
				'You will probably have to deceive him somehow, so that he thinks you are one of them. ...',
				'In the tavern, the pirates feel safe and plan their next strikes. Study ALL of their maps and plans lying around ...',
				'Afterwards, return here and report to me about your mission.'
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission3, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission3) == 1 and player:getStorageValue(Storage.TheShatteredIsles.TavernMap1) == 1 and player:getStorageValue(Storage.TheShatteredIsles.TavernMap2) == 1 and player:getStorageValue(Storage.TheShatteredIsles.TavernMap3) == 1 then
			npcHandler:say({
				'Well done, my friend. That will help us a lot. Of course there are other things to be done though. ...',
				'I learned that Klaus, the owner of the tavern, wants me dead. He is offering any of those pirates a mission to kill me....',
				'If we could convince him that you fulfilled that mission, the pirates will have the party of their lives. This would beour chance for a sneak attack to damage their boats and steal their plunder! ...',
				'Obtain this mission from him and learn what he needs as a proof. Then return to me and report to me about yourmission so we can formulate an appropriate plan.'
			}, npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 20)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission3, 3)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 1)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 2 then
			npcHandler:say("My pillow?? They know me all too well... <sigh> I've owned it since my childhood. However. Here, take it and convincehim that I am dead.", npc, creature)
			player:addItem(6105, 1)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 3)
		elseif player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 4 then
			npcHandler:say({
				'Incredible! You did what no other did even dare to think about! You are indeed a true hero to our cause ...',
				'Sadly I have no ship that lacks a captain, else you would of course be our first choice. I am still true to my word asbest as I am able. ...',
				'So take this as your very own ship. Oh, and remind me about the pirate outfit sometime.'
			}, npc, creature)
			player:addItem(2994, 1)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 21)
			player:setStorageValue(Storage.TheShatteredIsles.RaysMission4, 5)
		end
	elseif MsgContains(message, "mermaid") then
		if player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) < 1 then
			if npcHandler:getTopic(playerId) == 1 then
				npcHandler:say("The mermaid is the most beautiful creature I have ever met. She is so wonderful. It was some kind of magic as we first met. A look in her eyes and I suddenly knew there would be never again another woman in my life but her.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				player:setStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid, 1)
			end
		elseif player:getStorageValue(Storage.TheShatteredIsles.APoemForTheMermaid) == 1 and player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) < 1 then
			npcHandler:say("I am deeply ashamed that I lacked the willpower to resist her spell. Thank you for your help in that matter. Now my head is once more free to think about our {mission}.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "pirate outfit") then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToLagunaIsland) == 1 and player:getStorageValue(Storage.OutfitQuest.PirateBaseOutfit) < 1 and player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 5 then
			npcHandler:say("Ah, right! The pirate outfit! Here you go, now you are truly one of us.", npc, creature)
			player:addOutfit(151)
			player:addOutfit(155)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			player:setStorageValue(Storage.OutfitQuest.PirateBaseOutfit, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "task") and player:getStorageValue(Storage.TheShatteredIsles.RaysMission4) == 5 then
		if player:getStorageValue(Storage.KillingInTheNameOf.PirateTask) < 0 then
			npcHandler:say({
				"The pirates on Nargor are becoming more and more of a threat to us each day. I wish someone could get rid of them once and for all, but unfortunately they just keep coming! ...",
				"Only a dead pirate is a good pirate. I think killing a large number of them would definitely help us to make Sabrehaven a safer place. ...",
				"It doesn't matter how long it takes, but... would you be willing to kill 3000 pirates for us?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PirateTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.PirateCount) >= 3000 then
				if player:getStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1) <= 2 then
					npcHandler:say({
						"Hey, great. You've done well! As a small reward I give you some coins from our treasure box. Also, let me tell you an interesting piece of information. ...",
						"One of our spies told us about a secret hideout somewhere on Nargor. Supposedly, one of the four pirate leaders can be found there sometimes. If you dare go there, you might be able to face him or her in one on one combat. ...",
						"Beware though - prepare yourself well and only flee if you must. This might be your only chance to get into there, so be careful and don't die!"}, npc, creature)
					player:setStorageValue(Storage.KillingInTheNameOf.PirateTask, 1)
					player:addExperience(10000, true)
					player:addMoney(5000)
				elseif player:getStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1) == 3 then
					npcHandler:say({
						"This was probably the last time you will be able to enter that hideout. Well done, my friend, our thanks are with you. ...",
						"You are most welcome to keep on killing pirates for us though for some bucks and experience. If you want to do so, just ask me about a {task} anytime."}, npc, creature)
					player:setStorageValue(Storage.KillingInTheNameOf.PirateTask, 1)
					player:addExperience(10000, true)
					player:addMoney(5000)
				elseif player:getStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1) > 3 then
					npcHandler:say("Ahh, thank you, my friend! What would we do without you? Here, take this reward for your efforts. If you want to continue to help us killing pirates, just ask me about that {task}.", npc, creature)
					player:setStorageValue(Storage.KillingInTheNameOf.PirateTask, 3)
					player:addExperience(10000, true)
					player:addMoney(5000)
				end
			else
				npcHandler:say("Go kill more pirates.", npc, creature)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PirateTask) == 2 then
			npcHandler:say({
				"So you went into the leaders' hideout? I hope you were successful and got what you were looking for! Thank you, my friend. Pirates still keep coming here, unfortunately. ...",
				"Do you, by chance, would like to kill pirates again for us?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PirateTask) == 3 then
			npcHandler:say("Do you, by chance, would like to kill pirates again for us?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Perfect. I know it sounds like a lot, but really, take your time. You won't do it for nothing, I promise.", npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.PirateCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateMarauderCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateCutthroadCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateBuccaneerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateCorsairCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.PirateTask, 0)
			player:setStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1, math.max(player:getStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1), 0))
			player:setStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1, player:getStorageValue(REPEATSTORAGE_BASE + #tasks.GrizzlyAdams + 1) + 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted. Is there anything I can {do for you}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
