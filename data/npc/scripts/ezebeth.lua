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
		if player:getStorageValue(Storage.DarkTrails.Mission01) == -1 then
			npcHandler:say("Well, there is little where we need help beyond the normal tasks you can do for the city. However, there is one thing out of the ordinary where some {assistance} would be appreciated.", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say("You already asked for a mission, go to the next.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "assistance") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say(" It's nothing really important, so no one has yet found the time to look it up. It concerns the towns beggars that have started to behave {strange} lately.", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "strange") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("They usually know better than to show up in the streets and harass our citizens, but lately they've grown more bold or desperate or whatever. I ask you to investigate what they are up to. If necessary, you may scare them away a bit.", cid)
			player:setStorageValue(Storage.DarkTrails.Mission01, 1) -- Mission 1 start
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "outfit") then
		if player:getStorageValue(Storage.DarkTrails.Mission18) == 1 then
			npcHandler:say("Nice work, take your outfit.", cid)
			player:setStorageValue(Storage.DarkTrails.Outfit, 1)
			doPlayerAddOutfit(610, 1)
			doPlayerAddOutfit(618, 1)
			npcHandler.topic[cid] = 0
	elseif player:getStorageValue(Storage.DarkTrails.Outfit) == 1 then
			npcHandler:say("You already have the outfit.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello! I guess you are here for a {mission}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
