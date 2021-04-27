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
	if isInArray({"addon", "outfit"}, msg) then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) < 1 then
			npcHandler:say("What are you thinking! I would never allow you to slay my beloved friends for the sake of your narcism. Only {Faolan} can grant you a fur like this one.", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "faolan") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("I know where the great wolf mother lives, but I will not tell that to just anyone. You have to earn my respect first. Are you willing to help me?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 8 then
			npcHandler:say("Right, I will keep my promise. Faolan roams Tibia freely, but her favourite sleeping cave is on Cormaya. I will now enchant you so you will be able to speak the wolf language.", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 9)
			npcHandler.topic[cid] = 0
		end
	elseif isInArray({"griffinclaw", "container"}, msg) then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 1 then
			npcHandler:say("Were you able to obtain a sample of the Griffinclaw?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "task") then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 2 then
			npcHandler:say({
				"Listen, my next task for you is not exactly easy either. ...",
				"In the mountains between Ankrahmun and Tiquanda are two hydra lairs. The nothern one has many waterfalls whereas the southern one has just tiny water trickles. ...",
				"However, these trickles are said to contain water as pure and clean as nowhere else in Tibia. ...",
				"If you could reach one of these trickles and retrieve a water sample for me, it would be a great help. ...",
				"It is important that you take the water directly from the trickle, not from the pond - else it will not be as pure anymore. ...",
				"Have you understood everything I told you and will fulfil this task for me?"
			}, cid)
			npcHandler.topic[cid] = 6
		elseif player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 4 then
			npcHandler:say({
				"I'm glad that you are still with me, |PLAYERNAME|. Especially because my next task might require even more patience from your side than the ones before. ...",
				"Demons... these unholy creatures should have never been able to walk the earth. They are a brood fueled only by hatred and malice. ...",
				"Even if slain, their evil spirit is not fully killed. It needs a blessed stake to release their last bit of fiendishness and turn them into dust. ...",
				"It does not work all the time, but if you succeed, their vicious spirit is finally defeated. ...",
				"I want proof that you are on the right side, against Zathroth. Bring me 100 ounces of demon dust and I shall be convinced. ...",
				"You will probably need to ask a priest for help to obtain a blessed stake. ...",
				"Have you understood everything I told you and will fulfil this task for me?"
			}, cid)
			npcHandler.topic[cid] = 8
		elseif player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 6 then
			npcHandler:say({
				"I have one final task for you, |PLAYERNAME|. Many months ago, I was trying to free the war wolves which are imprisoned inside the orc fortress.",
				"Unfortunately, my intrusion was discovered and I had to run for my life. During my escape, I lost my favourite wolf tooth chain.",
				"It should still be somewhere in the fortress, if the orcs did not try to eat it. I really wish you could retrieve it for me.",
				"It has the letter 'C' carved into one of the teeth. Please look for it.",
				"Have you understood everything I told you and will fulfil this task for me?"
			}, cid)
			npcHandler.topic[cid] = 10
		end
	elseif msgcontains(msg, "waterskin") or msgcontains(msg, "water skin") then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 3 then
			npcHandler:say("Did you bring me a sample of water from the hydra cave?", cid)
			npcHandler.topic[cid] = 7
		end
	elseif msgcontains(msg, "dust") or msgcontains(msg, "demon dust") then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 5 then
			npcHandler:say("Were you really able to collect 100 ounces of demon dust?", cid)
			npcHandler.topic[cid] = 9
		end
	elseif msgcontains(msg, "chain") or msgcontains(msg, "wolf tooth chain") then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 7 then
			npcHandler:say("Have you really found my wolf tooth chain??", cid)
			npcHandler.topic[cid] = 11
		end
	elseif msgcontains(msg, "ceiron's waterskin") then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 3 then
			npcHandler:say("Have you lost my waterskin?", cid)
			npcHandler.topic[cid] = 12
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say({
				"I hope that I am not asking too much of you with this task. I heard of a flower which is currently unique in Tibia and can survive at only one place. ...",
				"This place is somewhere in the bleak mountains of Nargor. I would love to have a sample of its blossom, but the problem is that it seldom actually blooms. ...",
				"I cannot afford to travel there each day just to check whether the time has already come, besides I have no idea where to start looking. ...",
				"I would be deeply grateful if you could support me in this matter and collect a sample of the blooming Griffinclaw for me. ...",
				"Have you understood everything I told you and will fullfil this task for me?"
			}, cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Alright then. Take this botanist's container and return to me once you were able to retrieve a sample. Don't lose patience!", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			player:addItem(4869, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(5937, 1) then
				npcHandler:say("Crunor be praised! The Griffinclaw really exists! Now, I will make sure that it will not become extinct. If you are ready to help me again, just ask me for a {task}.", cid)
				player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 2)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 6 then
			npcHandler:say("Great! Here, take my waterskin and try to fill it with water from this special trickle. Don't lose my waterskin, I will not accept some random dirty waterskin.", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 3)
			player:addItem(5938, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			if player:removeItem(5939, 1) then
				npcHandler:say("Good work, |PLAYERNAME|! This water looks indeed extremely clear. I will examine it right away. If you are ready to help me again, just ask me for a {task}.", cid)
				player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 4)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 8 then
			npcHandler:say("Good! I will eagerly await your return.", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 5)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 9 then
			if player:removeItem(5906, 100) then
				npcHandler:say("I'm very impressed, |PLAYERNAME|. With this task you have proven that you are on the right side and are powerful as well. If you are ready to help me again, just ask me for a {task}.", cid)
				player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 6)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 10 then
			npcHandler:say("Thank you so much. I can't wait to wear it around my neck again, it was a special present from Faolan.", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 7)
			player:setStorageValue(Storage.OutfitQuest.DruidAmuletDoor, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 11 then
			if player:removeItem(5940, 1) then
				npcHandler:say("Crunor be praised! You found my beloved chain! |PLAYERNAME|, you really earned my respect and I consider you as a friend from now on. Remind me to tell you about {Faolan} sometime.", cid)
				player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 8)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 12 then
			npcHandler:say("I can give you a new one, but I fear that I have to take a small fee for it. Would you like to buy a waterskin for 1000 gold?", cid)
			npcHandler.topic[cid] = 13
		elseif npcHandler.topic[cid] == 13 then
			if player:removeMoneyNpc(1000) then
				player:addItem(5938, 1)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Always nice to meet a fellow druid, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May Crunor bless and guide you, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May Crunor bless and guide you, |PLAYERNAME|.")
npcHandler:addModule(FocusModule:new())
