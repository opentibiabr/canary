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

	if msgcontains(msg, "weapons") then
		if player:getStorageValue(Storage.SecretService.AVINMission06) == 1 then
			npcHandler:say("Crate of weapons you say.. for me?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:removeItem(7707, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission06, 2)
				npcHandler:say("Why thank you |PLAYERNAME|.", cid)
			else
				npcHandler:say("You don't have any crate of weapons!", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "I hope you have a cold day, friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "I hope you have a cold day, friend.")
npcHandler:setMessage(MESSAGE_GREET, "Welcome, to my cool home.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
