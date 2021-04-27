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
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) <= 1 then
			npcHandler:say("Ya wanna join the hunt fo' the sea serpent? Be warned ya may pay with ya life! Are ya in to it?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("A'right, we are here to resupply our stock of baits to catch the sea serpent. Your first task is to bring me 5 fish they are easy to catch. When you got them ask me for the bait again.", cid)
			player:setStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba, 2)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say("Let's go fo' a hunt and bring the beast down!", cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(31947, 31045, 6), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "bait") then
		if player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) == 2 then
			if player:removeItem(2667, 5) then
				npcHandler:say("Excellent, now bring me 5 northern pike.", cid)
				player:setStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba, 3)
				npcHandler.topic[cid] = 3
			end
		elseif player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) == 3 then
			if player:removeItem(2669, 5) then
				npcHandler:say("Excellent, now bring me 5 green perch.", cid)
				player:setStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba, 4)
				npcHandler.topic[cid] = 4
			end
		elseif player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) == 4 then
			if player:removeItem(7159, 5) then
				npcHandler:say("Excellent, now bring me 5 rainbow trout.", cid)
				player:setStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba, 5)
				npcHandler.topic[cid] = 5
			end
		elseif player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) == 5 then
			if player:removeItem(7158, 5) then
				npcHandler:say("Excellent, that should be enough fish to make the bait. Tell me when ya're ready fo' the hunt.", cid)
				player:setStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba, 6)
				npcHandler.topic[cid] = 6
			end
		end
	elseif msgcontains(msg, "hunt") then
		if player:getStorageValue(Storage.TheHuntForTheSeaSerpent.CaptainHaba) == 6 then
			npcHandler:say("A'right, wanna put out to sea?", cid)
			npcHandler.topic[cid] = 7
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Harrr, landlubber wha'd ya want?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")

npcHandler:addModule(FocusModule:new())
