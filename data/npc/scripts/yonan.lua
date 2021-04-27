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

local playerTopic = {}
local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.Kilmaresh.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[cid] = 1
	elseif (player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) <= 50)
	and player:getStorageValue(Storage.Kilmaresh.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[cid] = 15
	elseif player:getStorageValue(Storage.Kilmaresh.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.First.Mission, 5)
		playerTopic[cid] = 20
	end
	npcHandler:addFocus(cid)
	return true
end

local function creatureSayCallback(cid, type, msg)
if not npcHandler:isFocused(cid) then
	return false
end
npcHandler.topic[cid] = playerTopic[cid]
local player = Player(cid)
if msgcontains(msg, "mission") and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 1 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 1 then
		npcHandler:say({"Could you help me do a ritual?"}, cid)-- It needs to be revised, it's not the same as the global
		npcHandler.topic[cid] = 1
		playerTopic[cid] = 1
	end
elseif msgcontains(msg, "yes") and playerTopic[cid] == 1 and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 1 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 1 then	
		player:addItem(36552, 1) -- Yonans List
		player:addItem(36448, 1) -- Pick Enchanted
		npcHandler:say({"Here is the list with the missing ingredients to complete the ritual."}, cid)-- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.Eighth.Yonan, 2)
		npcHandler.topic[cid] = 2
		playerTopic[cid] = 2
	else
		npcHandler:say({"Sorry."}, cid)
	end
end
if msgcontains(msg, "mission") and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 2 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 2 then
		npcHandler:say({"Did you bring all the materials I informed you about? "}, cid)-- It needs to be revised, it's not the same as the global
		npcHandler.topic[cid] = 3
		playerTopic[cid] = 3
	end	
elseif msgcontains(msg, "yes") and playerTopic[cid] == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 2 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 2 and player:getItemById(10568, 3) and player:getItemById(36160, 12) and player:getItemById(36168, 10) then
		player:removeItem(10568, 3)
		player:removeItem(36160, 12)
		player:removeItem(36168, 10)
		npcHandler:say({"Thank you this stage of the ritual is complete."}, cid)-- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.Eighth.Yonan, 3)
		npcHandler.topic[cid] = 4
		playerTopic[cid] = 4
	else
		npcHandler:say({"Sorry."}, cid)-- It needs to be revised, it's not the same as the global
	end
end
return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')
npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
