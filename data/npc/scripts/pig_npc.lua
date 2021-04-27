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

npcHandler:setMessage(MESSAGE_GREET, "Oink.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if (msgcontains(msg, "kiss")) then
		npcHandler:say("Do you want to try to release me with a kiss?", cid)
		npcHandler.topic[cid] = 1
	elseif (msgcontains(msg, "yes")) then
		if (npcHandler.topic[cid] == 1) then
			npcHandler:say("Mhm Uhhh. Not bad, not bad at all! But you can still improve your skill a LOT.", cid)
			npcHandler.topic[cid] = 0
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
