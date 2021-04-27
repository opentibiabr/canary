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

local voices = { {text = 'Now, where was I...'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local missionProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission01)
	if msgcontains(msg, 'recipe') or msgcontains(msg, 'mission') then
		if missionProgress < 1 then
			npcHandler:say({
				'My collection of recipes is almost complete. There are only but a few that are missing. ...',
				'Hmmm... now that we talk about it. There is something you could help me with. Are you interested?'
			}, cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('I already told you about the recipes I am missing, now please try to find a cookbook of the dwarven kitchen.', cid)
		end

	elseif msgcontains(msg, 'cookbook') then
		if missionProgress == -1 then
			npcHandler:say({
				'I\'m preparing the food for all djinns in Ashta\'daramai. ...',
				'Therefore, I\'m what is commonly called a cook, although I do not like that word too much. It is vulgar. I prefer to call myself \'chef\'.'
			}, cid)
		elseif missionProgress == 1 then
			npcHandler:say('Do you have the cookbook of the dwarven kitchen with you? Can I have it?', cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say('Thanks again, for bringing me that book!', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'Fine! Even though I know so many recipes, I\'m looking for the description of some dwarven meals. ...',
				'So, if you could bring me a cookbook of the dwarven kitchen, I\'ll reward you well.'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Start, 1)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 1)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Well, too bad.', cid)
		end
		npcHandler.topic[cid] = 0

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			if not player:removeItem(2347, 1) then
				npcHandler:say('Too bad. I must have this book.', cid)
				return true
			end

			npcHandler:say({
				'The book! You have it! Let me see! <browses the book> ...',
				'Dragon Egg Omelette, Dwarven beer sauce... it\'s all there. This is great! Here is your well-deserved reward. ...',
				'Incidentally, I have talked to Fa\'hradin about you during dinner. I think he might have some work for you. Why don\'t you talk to him about it?'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 2)
			player:addItem(2146, 3)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Too bad. I must have this book.', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Greeting
keywordHandler:addGreetKeyword({"djanni'hah"}, {npcHandler = npcHandler, text = "Hey! A human! What are you doing in my kitchen, |PLAYERNAME|?"})

npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye. I am sure you will come back for more. They all do.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Goodbye. I am sure you will come back for more. They all do.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
