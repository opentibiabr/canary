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
	if(msgcontains(msg, "necrometer")) then
		--[[if player:getStorageValue(Storage.Oramond.TaskProbing == 1) then
		--for this mission is needed script of the npc Doubleday]]
			npcHandler:say("A necrometer? Have you any idea how rare and expensive a necrometer is? There is no way I could justify giving a necrometer to an inexperienced adventurer. Hm, although ... if you weren't inexperienced that would be a different matter. ...", cid)
			npcHandler:say("Did you do any measuring task for Doubleday lately?", cid)
			npcHandler.topic[cid] = 1
		--end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) and player:getStorageValue(Storage.DarkTrails.Mission09) == 1 then
			npcHandler:say("Indeed I heard you did a good job out there. <sigh> I guess that means I can hand you one of our necrometers. Handle it with care", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.DarkTrails.Mission10, 1)
			player:addItem(23495,1)
			else
			npcHandler:say("You already got the Necrometer.", cid)
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
