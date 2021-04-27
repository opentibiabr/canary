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

function creatureSayCallback(cid, type, msg)
	if(not(npcHandler:isFocused(cid))) then
		return false
	end

	local player = Player(cid)
	-- Missing script for complete the mission 16 of dark trails
	if(msgcontains(msg, "mission")) then
		if player:getStorageValue(Storage.DarkTrails.Mission16) == 1 then
			npcHandler:say("Ahhhhhhhh! Find and investigate the hideout, the mission 17", cid)
			setPlayerStorageValue(cid, Storage.DarkTrails.Mission17, 1)
			setPlayerStorageValue(cid, Storage.DarkTrails.DoorHideout, 1)
		end
	else
		npcHandler:say("Ahhhhhhhh! ", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
