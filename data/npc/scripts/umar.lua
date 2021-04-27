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

local function greetCallback(cid, message)
	local player = Player(cid)
	if not msgcontains(message, 'djanni\'hah') and player:getStorageValue(Storage.DjinnWar.Faction.MaridDoor) ~= 1 then
		npcHandler:say('Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else.', cid)
		return false
	end

	if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) == -1 then
		npcHandler:say({
			'Hahahaha! ...',
			'|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!'
		}, cid)
		return false
	end

	if player:getStorageValue(Storage.DjinnWar.Faction.MaridDoor) ~= 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Whoa? You know the word! Amazing, |PLAYERNAME|! ...',
			'I should go and tell Fa\'hradin. ...',
			'Well. Why are you here anyway, |PLAYERNAME|?'
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, '|PLAYERNAME|! How\'s it going these days? What brings you {here}?')
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	-- To Appease the Mighty Quest
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) == 1 then
			npcHandler:say({
				'I should go and tell Fa\'hradin. ...',
				'I am impressed you know our address of welcome! I honour that. So tell me who sent you on a mission to our fortress?'}, cid)
			npcHandler.topic[cid] = 9
			elseif msgcontains(msg, "kazzan") and npcHandler.topic[cid] == 9 then
			npcHandler:say({
				'How dare you lie to me?!? The caliph should choose his envoys more carefully. We will not accept his peace-offering ...',
				'...but we are always looking for support in our fight against the evil Efreets. Tell me if you would like to join our fight.'}, cid)
			player:setStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
	end

	if msgcontains(msg, 'passage') then
		if player:getStorageValue(Storage.DjinnWar.Faction.MaridDoor) ~= 1 then
			npcHandler:say({
				'If you want to enter our fortress you have to become one of us and fight the Efreet. ...',
				'So, are you willing to do so?'
			}, cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('You already have the permission to enter Ashta\'daramai.', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			if player:getStorageValue(Storage.DjinnWar.Faction.EfreetDoor) ~= 1 then
				npcHandler:say('Are you sure? You pledge loyalty to king Gabel, who is... you know. And you are willing to never ever set foot on Efreets\' territory, unless you want to kill them? Yes?', cid)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say('I don\'t believe you! You better go now.', cid)
				npcHandler.topic[cid] = 0
			end

		elseif msgcontains(msg, 'no') then
			npcHandler:say('This isn\'t your war anyway, human.', cid)
			npcHandler.topic[cid] = 0
		end

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'Oh. Ok. Welcome then. You may pass. ...',
				'And don\'t forget to kill some Efreets, now and then.'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.Faction.MaridDoor, 1)
			player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 0)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('This isn\'t your war anyway, human.', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Whoa! A human! This is no place for you, |PLAYERNAME|. Go and play somewhere else"})

npcHandler:setMessage(MESSAGE_FAREWELL, '<salutes>Aaaa -tention!')
npcHandler:setMessage(MESSAGE_WALKAWAY, '<salutes>Aaaa -tention!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())