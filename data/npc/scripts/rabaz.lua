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
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) < 1 then
			npcHandler.topic[cid] = 1
				npcHandler:say({
					"Why yes, there is indeed some minor issue I could need your help with. I was always a friend of nature and it was not recently I discovered the joys of plants, growths, of all the flora around us. ...",
					"Botany my friend. The study of plants is of great importance for our future. Many of the potions we often depend on are made of plants you know. Plants can help us tending our wounds, cure us from illness or injury. ...",
					"I am currently writing an excessive compilation of all the knowledge I have gathered during my time here in Farmine and soon hope to publish it as 'Rabaz' Unabridged Almanach Of Botany'. ...",
					"However, to actually complete my botanical epitome concerning Zao, I would need someone to enter these dangerous lands. Someone able to get closer to the specimens than I can. ...",
					"And this is where you come in. There are two extremely rare species I need samples from. Typically not easy to come by but it should not be necessary to venture too far into Zao to find them. ...",
					"Explore the anterior outskirts of Zao, use my almanach and find the two specimens with missing samples on their pages. The almanach can be found in a chest in my storage, next to my shop. It's the door over there. ...",
					"If you lose it I will have to write a new one and put it in there again - which will undoubtedly take me a while. So keep an eye on it on your travels. ...",
					"Once you find what I need, best use a knife to carefully cut and gather a leaf or a scrap of their integument and press it directly under their appropriate entry into my botanical almanach. ...",
					"Simply return to me after you have done that and we will discuss your reward. What do you say, are you in?"
				}, cid)
		elseif player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 3 then
			npcHandler.topic[cid] = 2
			npcHandler:say("Well fantastic work, you gathered both samples! Now I can continue my work on the almanach, thank you very much for your help indeed. Can I take a look at my book please?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 1)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotanyChestDoor, 0)
			npcHandler:say("Yes? Yes! That's the enthusiasm I need! Remember to bring a sharp knife to gather the samples, plants - even mutated deformed plants - are very sensitive you know. Off you go and be careful out there, Zao is no place for the feint hearted mind you.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			if player:removeItem(12655, 1) then
				player:addItem(12656, 1)
				player:addItem(2152, 10)
				player:addExperience(3000, true)
				player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 4)
				npcHandler:say({
					"Ah, thank you. Now look at that texture and fine colour, simply marvellous. ...",
					"I hope the sun in the steppe did not exhaust you too much? Shellshock. A dangerous foe in the world of field science and exploration. ...",
					"Here, I always wore this comfortable hat when travelling, take it. It may be of use for you on further reconnaissances in Zao. Again you have my thanks, friend."
				}, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Oh, you don't have my book.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
