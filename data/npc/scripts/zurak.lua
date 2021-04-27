
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
	elseif msgcontains(msg, "trip") or msgcontains(msg, "passage") then
		--if Player(cid):getStorageValue(Storage.TheNewFrontier.Questline) >= 24 then
			npcHandler:say("You want trip to Izzle of Zztrife?", cid)
			npcHandler.topic[cid] = 1
			--else
			--npcHandler:say("You need The New Frontier Quest to travel.", cid)
		--end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("It'zz your doom you travel to.", cid)
			local player, destination = Player(cid), Position(33102, 31056, 7)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Zzoftzzkinzz zzo full of fear.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'hurry') or msgcontains(msg, 'job')  then
		npcHandler:say('Me zzimple ferryman. I arrange {trip} to Izzle of Zztrife.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
