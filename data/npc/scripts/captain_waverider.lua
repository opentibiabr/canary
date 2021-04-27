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
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local player = Player(cid)

	if(msgcontains(msg, "peg leg")) then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToMeriana) == 1 then
			npcHandler:say("Ohhhh. So... <lowers his voice> you know who sent you so I sail you to you know where. <wink> <wink> It will cost 50 gold to cover my expenses. Is it that what you wish?", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say("Sorry, my old ears can't hear you.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif(msgcontains(msg, "passage")) then
			npcHandler:say("<sigh> I knew someone else would claim all the treasure someday. But at least it will be you and not some greedy and selfish person. For a small fee of 200 gold pieces I will sail you to your rendezvous with fate. Do we have a deal?", cid)
			npcHandler.topic[cid] = 2
		elseif(msgcontains(msg, "no")) then
			npcHandler:say("I have to admit this leaves me a bit puzzled.", cid)
			npcHandler.topic[cid] = 0
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			if player:removeMoneyNpc(50) then
				npcHandler:say("And there we go!", cid)
				player:teleportTo(Position(32346, 32625, 7))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler.topic[cid] = 0
		else
				npcHandler:say("You don't have enough money.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif(npcHandler.topic[cid] == 2) then
			if player:removeMoneyNpc(200) then
				npcHandler:say("And there we go!", cid)
				player:teleportTo(Position(32131, 32913, 7))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have enough money.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, daring adventurer. If you need a {passage}, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
