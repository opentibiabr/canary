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

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'fugio') then
		if player:getStorageValue(Storage.Quest.SimpleChest.FamilyBrooch) == 1 then
			npcHandler:say('To be honest, I fear the omen in my dreams may be true. \z
					Perhaps Fugio is unable to see the danger down there. \z
					Perhaps ... you are willing to investigate this matter?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'diary') then
		if player:getStorageValue(Storage.WhiteRavenMonastery.Diary) == 1 then
			npcHandler:say('Do you want me to inspect a diary?', cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, 'holy water') then
		local cStorage = player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline)
		if cStorage == 1 then
			npcHandler:say('Who are you to demand holy water from the White Raven Monastery? Who sent you??', cid)
			npcHandler.topic[cid] = 3
		elseif cStorage == 2 then
			npcHandler:say('I already filled your vial with holy water.', cid)
		end
	elseif msgcontains(msg, 'amanda') and npcHandler.topic[cid] == 0 then
		if player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) == 1 then
			npcHandler:say('Ahh, Amanda from Edron sent you! I hope she\'s doing well. So why did she send you here?', cid)
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Thank you very much! From now on you may open the warded doors to the catacombs.', cid)
			player:setStorageValue(Storage.WhiteRavenMonastery.Diary, 1)
			player:setStorageValue(Storage.WhiteRavenMonastery.Door, 1)
		elseif npcHandler.topic[cid] == 2 then
			if not player:removeItem(2325, 1) then
				npcHandler:say('Uhm, as you wish.', cid)
				return true
			end

			npcHandler:say('By the gods! This is brother Fugio\'s handwriting and what I read is horrible indeed! You have done our order a great favour by giving this diary to me! Take this blessed Ankh. May it protect you in even your darkest hours.', cid)
			player:addItem(2327, 1)
			player:setStorageValue(Storage.WhiteRavenMonastery.Diary, 2)
		end
	elseif npcHandler.topic[cid] == 3 then
		if not msgcontains(msg, 'amanda') then
			npcHandler:say('I never heard that name and you won\'t get holy water for some stranger.', cid)
			npcHandler.topic[cid] = 0
			return true
		end

		player:addItem(7494, 1)
		player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, 2)
		npcHandler:say('Ohh, why didn\'t you tell me before? Sure you get some holy water if it\'s for Amanda! Here you are.', cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'no') and isInArray({1, 2}, npcHandler.topic[cid]) then
		npcHandler:say('Uhm, as you wish.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Feel free to tell me what has brought you here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
