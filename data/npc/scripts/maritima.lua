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
	if(msgcontains(msg, "quara")) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 41 and player:getStorageValue(Storage.InServiceofYalahar.QuaraInky) < 1  and player:getStorageValue(Storage.InServiceofYalahar.QuaraSplasher) < 1 and player:getStorageValue(Storage.InServiceofYalahar.QuaraSharptooth) < 1) then
			npcHandler:say({
				"The quara in this area are a strange race that seeks for inner perfection rather than physical one. ...",
				"However, recently the quara got mad because their area is flooded with toxic sewage from the city. If you could inform someone about it, they might stop the sewage and the quara could return to their own business."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 42)
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 3) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
