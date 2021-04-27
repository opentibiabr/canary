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
	if msgcontains(msg, "want") then
		if player:getStorageValue(Storage.DarkTrails.Mission01) == 1 then
			npcHandler:say("The guys from the magistrate sent you here, didn't they?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes")  then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Thought so. You'll have to talk to the king though. The beggar king that is. The king does not grant an audience to just everyone. You know how those kings are, don't you? ... ",
				"However, to get an audience with the king, you'll have to help his subjects a bit. ... ",
				"His subjects that would be us, the poor, you know? ... ",
				"So why don't you show your dedication to the poor? Go and help Chavis at the poor house. He's collecting food for people like us. ... ",
				"If you brought enough of the stuff you'll see that the king will grant you entrance in his {palace}."
			}, cid, false, true, 10)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.DarkTrails.Mission01, 2) -- Mission 1 end
			player:setStorageValue(Storage.DarkTrails.Mission02, 1) -- Mission 2 start
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi! What is it, what d'ye {want}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
