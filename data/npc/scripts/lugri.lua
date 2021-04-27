	local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "outfit") or msgcontains(msg, "addon") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) < 1 then
			npcHandler:say("This skull shows that you are a true follower of Zathroth and the glorious gods of darkness. Are you willing to prove your loyalty?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "shield") or msgcontains(msg, "medusa shield") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 1 then
			npcHandler:say("Is it your true wish to sacrifice a medusa shield to Zathroth?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "mail") or msgcontains(msg, "dragon scale mail") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 2 then
			npcHandler:say("Is it your true wish to sacrifice a dragon scale mail to Zathroth?", cid)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "legs") or msgcontains(msg, "crown legs") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 3 then
			npcHandler:say("Is it your true wish to sacrifice crown legs to Zathroth?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "ring") or msgcontains(msg, "ring of the sky") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 4 then
			npcHandler:say("Is it your true wish to sacrifice a ring of the sky to Zathroth?", cid)
			npcHandler.topic[cid] = 6
		end

	------------Task Part-------------
	elseif msgcontains(msg, "task") then
		if player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) <= 0 then
			npcHandler:say({
				"What? Who are you to imply I need help from a worm like you? ...",
				"I don't need help. But if you desperately wish to do something to earn the favour of Zathroth, feel free. Don't expect any reward though. ...",
				"Do you want to help and serve Zathroth out of your own free will, without demanding payment or recognition?"
			}, cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			if player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount) >= 4000 then
				npcHandler:say({
					"You've slain a mere {4000 necromancers and priestesses}. Still, you've shown some dedication. Maybe that means you can kill one of those so-called 'leaders' too. ...",
					"Deep under Drefia, a necromancer called Necropharus is hiding in the Halls of Sacrifice. I'll place a spell on you with which you will be able to pass his weak protective gate. ...",
					"Know that this will be your only chance to enter his room. If you leave it or die, you won't be able to return. We'll see if you really dare enter those halls."
				}, cid)
				player:setStorageValue(17521, 1)
				player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 2)
			else
				npcHandler:say("Come back when you have slain {4000 necromancers and priestesses!}", cid)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 2 then
			npcHandler:say({
				"So you had the guts to enter that room. Well, it's all fake magic anyway and no real threat. ...",
				"What are you looking at me for? Waiting for something? I told you that there was no reward. Despite being allowed to stand before me without being squashed like a bug. Get out of my sight!"
			}, cid)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 3)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 3 then
			npcHandler:say("You can't live without serving, can you? Although you are quite annoying, you're still somewhat useful. Continue killing Necromancers and Priestesses for me. 1000 are enough this time. What do you say?", cid)
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("It will be a hard task which requires many sacrifices. Do you still want to proceed?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Good decision, |PLAYERNAME|. Your first sacrifice will be a medusa shield. Bring it to me and do give it happily.", cid)
			player:setStorageValue(Storage.OutfitQuest.WizardAddon, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(2536, 1) then
				npcHandler:say("Good. I accept your sacrifice. The second sacrifice I require from you is a dragon scale mail. Bring it to me and do give it happily.", cid)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 2)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have it...", cid)
			end
		elseif npcHandler.topic[cid] == 4 then
			if player:removeItem(2492, 1) then
				npcHandler:say("Good. I accept your sacrifice. The third sacrifice I require from you are crown legs. Bring them to me and do give them happily.", cid)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 3)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have it...", cid)
			end
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(2488, 1) then
				npcHandler:say("Good. I accept your sacrifice. The last sacrifice I require from you is a ring of the sky. Bring it to me and do give it happily.", cid)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 4)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have it...", cid)
			end
		elseif npcHandler.topic[cid] == 6 then
			if player:removeItem(2123, 1) then
				npcHandler:say("Good. I accept your sacrifice. You have proven that you are a true follower of Zathroth and do not hesitate to sacrifice worldly goods. Thus, I will reward you with this headgear. ", cid)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 5)
				player:addOutfitAddon(145, 2)
				player:addOutfitAddon(149, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have it...", cid)
			end
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say({
				"You do? I mean - wise decision. Let me explain. By now, Tibia has been overrun by numerous followers of different cults and beliefs. The true Necromancers died or left Tibia long ago, shortly after their battle was lost. ...",
				"What is left are mainly pseudo-dark pretenders, the old wisdom and power being far beyond their grasp. They think they have the right to tap that dark power, but they don't. ...",
				"I want you to eliminate them. As many as you can. All of the upstart necromancer orders, and those priestesses. And as I said, don't expect a reward - this is what has to be done to cleanse Tibia of its false dark prophets."
			}, cid)

			-- aqui
			player:setStorageValue(JOIN_STOR, 1)
			-- aqui
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 1)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, 0)
		elseif npcHandler.topic[cid] == 8 then
			npcHandler:say("Good. Then go.", cid)
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancers, 4)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] > 1 then
			npcHandler:say("Then no.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "What is it that you want, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
