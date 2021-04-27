
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
	local player = Player(cid)
	if not npcHandler:isFocused(cid) then
		return false
	--The New Frontier
	elseif msgcontains(msg, "farmine") then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 15 then
			npcHandler:say("Oh yes, that project the whole dwarven community is so excited about. I guess I already know why you are here, but speak up.", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "impress") or msgcontains(msg, "plea") then
		if npcHandler.topic[cid] == 1 then
			if player:getStorageValue(Storage.TheNewFrontier.BribeLeeland) < 1 then
				npcHandler:say("The idea of a promising market and new resources suits us quite well. I think it is reasonable to send some assistance.", cid)
				player:setStorageValue(Storage.TheNewFrontier.BribeLeeland, 1)
				player:setStorageValue(Storage.TheNewFrontier.Mission05, player:getStorageValue(Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
