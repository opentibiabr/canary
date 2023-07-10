local internalNpcName = "Lugri"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 145,
	lookHead = 132,
	lookBody = 114,
	lookLegs = 0,
	lookFeet = 38,
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

	if MsgContains(message, "outfit") or MsgContains(message, "addon") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) < 1 then
			npcHandler:say("This skull shows that you are a true follower of Zathroth and the glorious gods of darkness. Are you willing to prove your loyalty?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "shield") or MsgContains(message, "medusa shield") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 1 then
			npcHandler:say("Is it your true wish to sacrifice a medusa shield to Zathroth?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "mail") or MsgContains(message, "dragon scale mail") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 2 then
			npcHandler:say("Is it your true wish to sacrifice a dragon scale mail to Zathroth?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "legs") or MsgContains(message, "crown legs") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 3 then
			npcHandler:say("Is it your true wish to sacrifice crown legs to Zathroth?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "ring") or MsgContains(message, "ring of the sky") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 4 then
			npcHandler:say("Is it your true wish to sacrifice a ring of the sky to Zathroth?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end

	------------Task Part-------------
	elseif MsgContains(message, "task") then
		if player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) < 0 and player:getLevel() >= 60 then
			npcHandler:say({
				"What? Who are you to imply I need help from a worm like you? ...",
				"I don't need help. But if you desperately wish to do something to earn the favour of Zathroth, feel free. Don't expect any reward though. ...",
				"Do you want to help and serve Zathroth out of your own free will, without demanding payment or recognition?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount) >= 4000 then
				npcHandler:say({
					"You've slain a mere "..player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount).." necromancers and priestesses. Still, you've shown some dedication. Maybe that means you can kill one of those so-called 'leaders' too. ...",
					"Deep under Drefia, a necromancer called Necropharus is hiding in the Halls of Sacrifice. I'll place a spell on you with which you will be able to pass his weak protective gate. ...",
					"Know that this will be your only chance to enter his room. If you leave it or die, you won't be able to return. We'll see if you really dare enter those halls."
				}, npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 1)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.NecropharusCount, 0)
			else
				npcHandler:say("Come back when you have slain 4000 necromancers and priestesses!", npc, creature)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 2 then
			npcHandler:say({
				"Hrm. So you had the guts to enter that room. Well, it's all fake magic anyway and no real threat. ...",
				"What are you looking at me for? Waiting for something? I told you that there was no reward. Despite being allowed to stand before me without being squashed like a bug. Get out of my sight!"
			}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 4)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 3 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount) >= 1000 then
				npcHandler:say("Good job!", npc, creature)
				player:addExperience(40000, true)
				player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 4)
			else
				npcHandler:say("Come back when you have slain 1000 necromancers and priestesses!", npc, creature)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 4 then
			npcHandler:say("You can't live without serving, can you? Although you are quite annoying, you're still somewhat useful. Continue killing Necromancers and Priestesses for me. 1000 are enough this time. What do you say?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("It will be a hard task which requires many sacrifices. Do you still want to proceed?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Good decision, |PLAYERNAME|. Your first sacrifice will be a medusa shield. Bring it to me and do give it happily.", npc, creature)
			player:setStorageValue(Storage.OutfitQuest.WizardAddon, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(3436, 1) then
				npcHandler:say("Good. I accept your sacrifice. The second sacrifice I require from you is a dragon scale mail. Bring it to me and do give it happily.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(3386, 1) then
				npcHandler:say("Good. I accept your sacrifice. The third sacrifice I require from you are crown legs. Bring them to me and do give them happily.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 3)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(3382, 1) then
				npcHandler:say("Good. I accept your sacrifice. The last sacrifice I require from you is a ring of the sky. Bring it to me and do give it happily.", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 4)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(3006, 1) then
				npcHandler:say("Good. I accept your sacrifice. You have proven that you are a true follower of Zathroth and do not hesitate to sacrifice worldly goods. Thus, I will reward you with this headgear. ", npc, creature)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 5)
				player:addOutfitAddon(145, 2)
				player:addOutfitAddon(149, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have it...", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say({
				"You do? I mean - wise decision. Let me explain. By now, Tibia has been overrun by numerous followers of different cults and beliefs. The true Necromancers died or left Tibia long ago, shortly after their battle was lost. ...",
				"What is left are mainly pseudo-dark pretenders, the old wisdom and power being far beyond their grasp. They think they have the right to tap that dark power, but they don't. ...",
				"I want you to eliminate them. As many as you can. All of the upstart necromancer orders, and those priestesses. And as I said, don't expect a reward - this is what has to be done to cleanse Tibia of its false dark prophets."}, npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PriestessCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodPriestCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodHandCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.ShadowPupilCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say("Good. Then go.", npc, creature)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PriestessCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodPriestCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodHandCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.ShadowPupilCount, 0)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 3)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) > 1 then
			npcHandler:say("Then no.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "What is it that you {want}, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
