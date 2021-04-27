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
	if msgcontains(msg, 'disguise') then
		if player:getStorageValue(Storage.ThievesGuild.TheatreScript) < 0 then
			npcHandler:say({
				'Hmpf. Why should I waste my time to help some amateur? I\'m afraid I can only offer my assistance to actors that are as great as I am. ...',
				'Though, your futile attempt to prove your worthiness could be amusing. Grab a copy of a script from the prop room at the theatre cellar. Then talk to me again about your test!'
			}, cid)
			player:setStorageValue(Storage.ThievesGuild.TheatreScript, 0)
		end
	elseif msgcontains(msg, 'test') then
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 5 then
			npcHandler:say('I hope you learnt your role! I\'ll tell you a line from the script and you\'ll have to answer with the corresponding line! Ready?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('How dare you? Are you mad? I hold the princess hostage and you drop your weapons. You\'re all lost!', cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say('Too late puny knight. You can\'t stop my master plan anymore!', cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 5 then
			npcHandler:say('What\'s this? Behind the doctor?', cid)
			npcHandler.topic[cid] = 6
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say('Grrr!', cid)
			npcHandler.topic[cid] = 8
		elseif npcHandler.topic[cid] == 9 then
			npcHandler:say('You\'re such a monster!', cid)
			npcHandler.topic[cid] = 10
		elseif npcHandler.topic[cid] == 11 then
			npcHandler:say('Ah well, I think you passed the test! Here is your disguise kit! Now get lost, fate awaits me!', cid)
			player:setStorageValue(Storage.ThievesGuild.Mission04, 6)
			player:addItem(8693, 1)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'I don\'t think so, dear doctor!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			npcHandler.topic[cid] = 3
		else
			npcHandler:say('No no no! That is not correct!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 4 then
		if msgcontains(msg, 'Watch out! It\'s a trap!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			npcHandler.topic[cid] = 5
		else
			npcHandler:say('No no no! That is not correct!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 6 then
		if msgcontains(msg, 'Look! It\'s Lucky, the wonder dog!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			npcHandler.topic[cid] = 7
		else
			npcHandler:say('No no no! That is not correct!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 8 then
		if msgcontains(msg, 'Ahhhhhh!') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			npcHandler.topic[cid] = 9
		else
			npcHandler:say('No no no! That is not correct!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 10 then
		if msgcontains(msg, 'Hahaha! Now drop your weapons or else...') then
			npcHandler:say('Ok, ok. You\'ve got this one right! Ready for the next one?', cid)
			npcHandler.topic[cid] = 11
		else
			npcHandler:say('No no no! That is not correct!', cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
