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
	if(msgcontains(msg, "funding")) then
		if(player:setStorageValue(Storage.DarkTrails.Mission07) == 1) then
			selfSay("So far you earned x votes. Each single vote can be spent on a different topic or you're also able to cast all your votes on one voting. ...", cid)
			selfSay("Well in the topic b you have the possibility to vote for the funding of the {archives}, import of bug {milk} or street {repairs}.", cid)
			npcHandler.topic[cid] = 1
			else selfSay("You cant vote yet.", cid)
		end
	elseif(msgcontains(msg, "archives")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("How many of your x votes do you want to cast?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif(msgcontains(msg, "1")) then
		if(npcHandler.topic[cid] == 2) then
			npcHandler:say("Did I get that right: You want to cast 1 of your votes on funding the {archives?}", cid)
			npcHandler.topic[cid] = 3
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 3) then
		   player:setStorageValue(Storage.DarkTrails.Mission08, 1)
			npcHandler:say("Thanks, you successfully cast your vote. Feel free to continue gathering votes by helping the city! Farewell.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
