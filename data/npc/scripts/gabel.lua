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
	local missionProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission03)
	if msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission02) ~= 2 then
			npcHandler:say({
				'So you would like to fight for us, would you. Hmm. ...',
				'That is a noble resolution you have made there, human, but I\'m afraid I cannot accept your generous offer at this point of time. ...',
				'Do not get me wrong, but I am not the kind of guy to send an inexperienced soldier into certain death! So you might ask around here for a more suitable mission.'
			}, cid)

		elseif missionProgress < 1 then
			npcHandler:say({
				'Sooo. Fa\'hradin has told me about your extraordinary exploit, and I must say I am impressed. ...',
				'Your fragile human form belies your courage and your fighting spirit. ...',
				'I hardly dare to ask you because you have already done so much for us, but there is a task to be done, and I cannot think of anybody else who would be better suited to fulfill it than you. ...',
				'Think carefully, human, for this mission will bring you into real danger. Are you prepared to do us that final favour?'
			}, cid)
			npcHandler.topic[cid] = 1

		elseif missionProgress == 1 then
			npcHandler:say('You haven\'t finished your final mission yet. Shall I explain it again to you?', cid)
			npcHandler.topic[cid] = 1

		elseif missionProgress == 2 then
			npcHandler:say('Have you found Fa\'hradin\'s lamp and placed it in Malor\'s personal chambers?', cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say('There\'s no mission left for you, friend of the Marid. However, I have a task for you.', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'All right. Listen! Thanks to Rata\'mari\'s report we now know what Malor is up to: he wants to do to me what I have done to him - he wants to imprison me in Fa\'hradin\'s lamp! ...',
				'Of course, that won\'t happen. Now, we know his plans. ...',
				'But I am aiming at something different. We have learnt one important thing: At this point of time, Malor does not have the lamp yet, which means it is still where he left it. We need that lamp! If we get it back we can imprison him again! ...',
				'From all we know the lamp is still in the Orc King\'s possession! Therefore I want to ask you to enter thewell guarded halls over at Ulderek\'s Rock and find the lamp. ...',
				'Once you have acquired the lamp you must enter Mal\'ouquah again. Sneak into Malor\'s personal chambersand exchange his sleeping lamp with Fa\'hradin\'s lamp! ...',
				'If you succeed, the war could be over one night later! I and all djinn will be in your debt forever! May Daraman watch over you!'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 1)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('As you wish.', cid)
		end
		npcHandler.topic[cid] = 0

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'Daraman shall bless you and all humans! You have done us all a huge service! Soon, this awful war will be over! ...',
				'Know, that from now on you are considered one of us and are welcome to trade with Haroun and Nah\'bob whenever you want to!'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission03, 3)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.DoorToEfreetTerritory, 1)
			player:addAchievement('Marid Ally')

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Don\'t give up! May Daraman watch over you!', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Welcome, human |PLAYERNAME|, to our humble abode."})

npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, stranger. May Uman open your minds and your hearts to Daraman's wisdom!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, stranger. May Uman open your minds and your hearts to Daraman's wisdom!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())