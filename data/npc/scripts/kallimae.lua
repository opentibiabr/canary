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
if msgcontains(msg, "mission") and player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) == 11 then
	if player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) == 11 then
		npcHandler:say({"Some residents are in need of ingredients to finish a ritual. You can help?"}, cid)-- It needs to be revised, it's not the same as the global
		npcHandler.topic[cid] = 1
		playerTopic[cid] = 1
	end	
elseif msgcontains(msg, "yes") and playerTopic[cid] == 1 then
	if player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) == 11 then
		npcHandler:say({"Search for the NPCs Yonan, Narsai, Shimun and Tefrit."}, cid)-- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.Set.Ritual, 1)
		player:setStorageValue(Storage.Kilmaresh.Set.Yonan, 1)
		player:setStorageValue(Storage.Kilmaresh.Set.Narsai, 1)
		player:setStorageValue(Storage.Kilmaresh.Set.Shimun, 1)
		player:setStorageValue(Storage.Kilmaresh.Set.Tefrit, 1)
		player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, 12)
		npcHandler.topic[cid] = 2
		playerTopic[cid] = 2
	else
		npcHandler:say({"Sorry."}, cid)-- It needs to be revised, it's not the same as the global
	end
end
if msgcontains(msg, "mission") and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Tefrit) == 3 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Tefrit) == 3 then
		npcHandler:say({"Did you help some residents with ingredients?"}, cid)-- It needs to be revised, it's not the same as the global
		npcHandler.topic[cid] = 3
		playerTopic[cid] = 3
	end
elseif msgcontains(msg, "yes") and playerTopic[cid] == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Tefrit) == 3 then
	if player:getStorageValue(Storage.Kilmaresh.Eighth.Yonan) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Shimun) == 3 and player:getStorageValue(Storage.Kilmaresh.Eighth.Tefrit) == 3 then
		npcHandler:say({"Thanks. I need you to go to 4 places indicated by Goddess Bastesh."}, cid)-- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.Nine.Owl, 1)
		npcHandler.topic[cid] = 4
		playerTopic[cid] = 4
	else
		npcHandler:say({"Sorry."}, cid)-- It needs to be revised, it's not the same as the global
	end
end
if msgcontains(msg, "mission") and player:getStorageValue(Storage.Kilmaresh.Eleven.Basin) == 1 then
	if player:getStorageValue(Storage.Kilmaresh.Eleven.Basin) == 1 then
		npcHandler:say({"Did you check all the points and bring the Symbol of Sun and Sea?"}, cid)-- It needs to be revised, it's not the same as the global
		npcHandler.topic[cid] = 5
		playerTopic[cid] = 5
	end	
elseif msgcontains(msg, "yes") and playerTopic[cid] == 5 and player:getStorageValue(Storage.Kilmaresh.Eleven.Basin) == 1 then
	if player:getStorageValue(Storage.Kilmaresh.Eleven.Basin) == 1 and player:getItemById(36266, 1) then
		player:addItem(36407, 1)
		npcHandler:say({"Thanks. Here is your reward."}, cid)-- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.Twelve.Boss, 1)
		player:setStorageValue(Storage.Kilmaresh.Eleven.Basin, 2)
		npcHandler.topic[cid] = 6
		playerTopic[cid] = 6
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
