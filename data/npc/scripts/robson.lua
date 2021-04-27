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

local voices = {
	{ text = '<mumbles>' },
	{ text = 'Just great. Getting stranded on a remote underground isle was not that bad but now I\'m becoming a tourist attraction!' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'parcel') then
		npcHandler:say('Do you want to buy a parcel for 15 gold?', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'label') then
		npcHandler:say('Do you want to buy a label for 1 gold?', cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, 'yes') then
		local player = Player(cid)
		if npcHandler.topic[cid] == 1 then
			if not player:removeMoneyNpc(15) then
				npcHandler:say('Sorry, that\'s only dust in your purse.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:addItem(2595, 1)
			npcHandler:say('Fine.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			if not player:removeMoneyNpc(1) then
				npcHandler:say('Sorry, that\'s only dust in your purse.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:addItem(2599, 1)
			npcHandler:say('Fine.', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') then
		if isInArray({1, 2}, npcHandler.topic[cid]) then
			npcHandler:say('I knew I would be stuck with that stuff.', cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hrmpf, I'd say welcome if I felt like lying.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you next time!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "No patience at all!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
