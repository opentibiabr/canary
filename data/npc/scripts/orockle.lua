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

--[[
	if msgcontains(msg, "fight") then
		npcHandler:say("You can help in the fight against the hive. There are several missions available to destabilise the hive. Just ask for them if you want to learn more. After completing many missions you might be worthy to get a reward.", cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "mission") then
		npcHandler:say("You could try to blind the hive, you might disrupt its digestion, you could gather acid or you can disable the swarm pores. ...", cid)
		npcHandler.topic[cid] = 2

	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("So be it. Now you are a member of the inquisition. You might ask me for a mission to raise in my esteem.", cid)
			npcHandler.topic[cid] = 0
		end
	end
--]]
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
