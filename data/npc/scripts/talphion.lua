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
	if msgcontains(msg, "dress pattern") then
		if player:getStorageValue(Storage.Postman.Mission06) == 3 then
			if npcHandler.topic[cid] < 1 then
				npcHandler:say("DRESS FLATTEN? WHO WANTS ME TO FLATTEN A DRESS?", cid)
				npcHandler.topic[cid] = 1
			elseif npcHandler.topic[cid] == 1 then
				npcHandler:say("A PRESS LANTERN? NEVER HEARD ABOUT IT!", cid)
				npcHandler.topic[cid] = 2
			elseif npcHandler.topic[cid] == 2 then
				npcHandler:say("CHESS? I DONT PLAY CHESS!", cid)
				npcHandler.topic[cid] = 3
			elseif npcHandler.topic[cid] == 3 then
				npcHandler:say("A PATTERN IN THIS MESS?? HEY DON'T INSULT MY MACHINEHALL!", cid)
				npcHandler.topic[cid] = 4
			elseif npcHandler.topic[cid] == 4 then
				npcHandler:say("AH YES! I WORKED ON THE DRESS PATTERN FOR THOSE UNIFORMS. STAINLESS TROUSERES, STEAM DRIVEN BOOTS! ANOTHERMARVEL TO BEHOLD! I'LL SENT A COPY TO KEVIN IMEDIATELY!", cid)
				player:setStorageValue(Storage.Postman.Mission06, 4)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
