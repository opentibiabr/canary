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
	if msgcontains(msg, "report") then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 7 or player:getStorageValue(Storage.InServiceofYalahar.Questline) == 13 then
			npcHandler:say("Uhm, report, eh? <slowly gives a clumsy description of recent problems>. ", cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, math.max(1, player:getStorageValue(Storage.InServiceofYalahar.Questline) +1))
			player:setStorageValue(Storage.InServiceofYalahar.Mission02, math.max(1, player:getStorageValue(Storage.InServiceofYalahar.Mission02) +1)) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "pass") then
		npcHandler:say("You can {pass} either to the {Arena Quarter} or {Foreigner Quarter}. Which one will it be?", cid)
		npcHandler.topic[cid] = 1
	elseif(msgcontains(msg, "arena")) then
		if npcHandler.topic[cid] == 1 then
			player:teleportTo(Position(32695, 31254, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
		end
	elseif(msgcontains(msg, "foreigner")) then
		if npcHandler.topic[cid] == 1 then
			player:teleportTo(Position(32695, 31259, 7))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
