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
	if msgcontains(msg, "endurance") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 15 then
			npcHandler:say({
				"Ah, the test is a piece of mushroomcake! Just take the teleporter over there in the south and follow the hallway. ...",
				"You'll need to run quite a bit. It is important that you don't give up! Just keep running and running and running and ... I guess you got the idea. ...",
				"At the end of the hallway you'll find a teleporter. Step on it and you are done! I'm sure you'll do a true gnomerun! Afterwards talk to me."
			}, cid)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 17)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 17 then
			npcHandler:say("Just take the teleporter over there to the south and follow the hallway. At the end of the hallway you'll find a teleporter. Step on it and you are done!", cid)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 18 then
			npcHandler:say("You have passed the test and are ready to create your soul melody. Talk to Gnomelvis in the east about it.", cid)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 19)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) < 15 then
			npcHandler:say("Your endurance will be tested here when the time comes. For the moment please continue with the other phases of your recruitment.", cid)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 19 then
			npcHandler:say("You have passed the test. If you consider what huge feet you have to move it's quite impressive.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
