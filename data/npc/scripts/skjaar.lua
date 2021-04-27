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
	if msgcontains(msg, 'key') then
		npcHandler:say('I will give the key to the crypt only to the closest followers of my master. Would you like me to test you?', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 then
		npcHandler:say('Before we start I must ask you for a small donation of 1000 gold coins. Are you willing to pay 1000 gold coins for the test?', cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 2 then
		if player:removeMoneyNpc(1000) then
			npcHandler:say('All right then. Here comes the first question. What was the name of Dago\'s favourite pet?', cid)
			npcHandler.topic[cid] = 3
		else
			npcHandler:say('You don\'t have enough money', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'redips') and npcHandler.topic[cid] == 3 then
		npcHandler:say('Perhaps you knew him after all. Tell me - how many fingers did he have when he died?', cid)
		npcHandler.topic[cid] = 4
	elseif msgcontains(msg, '7') and npcHandler.topic[cid] == 4 then
		npcHandler:say('Also true. But can you also tell me the colour of the deamons in which master specialized?', cid)
		npcHandler.topic[cid] = 5
	elseif msgcontains(msg, 'black') and npcHandler.topic[cid] == 5 then
		npcHandler:say('It seems you are worthy after all. Do you want the key to the crypt?', cid)
		npcHandler.topic[cid] = 6
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 6 then
		npcHandler:say('Here you are', cid)
		local key = player:addItem(2089, 1)
		if key then
			key:setActionId(3142)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Another creature who believes thinks physical strength is more important than wisdom! Why are you disturbing me?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Run away, unworthy |PLAYERNAME|!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
