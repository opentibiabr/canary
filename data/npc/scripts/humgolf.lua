
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
	if(msgcontains(msg, "farmine")) then
		if(player:getStorageValue(Storage.TheNewFrontier.Questline) == 15) then
			npcHandler:say("Bah, Farmine here, Farmine there. Is there nothing else than Farmine to talk about these days? Hrmpf, whatever. So what do you want?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif(msgcontains(msg, "flatter")) then
		if(npcHandler.topic[cid] == 1) then
			if(player:getStorageValue(Storage.TheNewFrontier.BribeHumgolf) < 1) then
				npcHandler:say("Yeah, of course they can't do without my worms. Mining and worms go hand in hand. Well, in the case of the worms it is only an imaginary hand of course. I'll send them some of my finest worms.", cid)
				player:setStorageValue(Storage.TheNewFrontier.BribeHumgolf, 1)
				player:setStorageValue(Storage.TheNewFrontier.Mission05, player:getStorageValue(Storage.TheNewFrontier.Mission05) + 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			end
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
