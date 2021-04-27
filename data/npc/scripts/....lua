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

local function greetCallback(cid)
	if Game.getStorageValue(GlobalStorage.FerumbrasAscendant.DesperateSoul) ~= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello my friend, I saw that you send my soul here.")
		return true
	end
	return false
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "mission") and player:getStorageValue(Storage.FerumbrasAscension.TarbazNotes) >= 2 then
		npcHandler.topic[cid] = 1
		npcHandler:say("Oh, are you talking about {Tevon}?", cid)
	elseif msgcontains(msg, "tevon") and npcHandler.topic[cid] == 1 then
		npcHandler.topic[cid] = 0
		npcHandler:say("Ok, sure, now you may pass the door.", cid)
		player:setStorageValue(Storage.FerumbrasAscension.TarbazDoor, 1)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
