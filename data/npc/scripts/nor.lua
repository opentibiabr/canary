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
	if msgcontains(msg, "crystal") then
		if player:getStorageValue(Storage.TheIceIslands.Mission08) == 2 then
			npcHandler:say("Here, take the memory crystal and leave immediately.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(7281, 1)
			player:setStorageValue(Storage.TheIceIslands.Mission08, 3) -- Questlog The Ice Islands Quest, The Contact
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
