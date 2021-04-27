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
	if msgcontains(msg, 'key') then
		if player:getStorageValue(Storage.ThievesGuild.Mission06) == 1
		and player:getSex() == PLAYERSEX_FEMALE then
			local headItem = player:getSlotItem(CONST_SLOT_HEAD)
			if headItem and headItem.itemid == 2665 and player:getStorageValue(Storage.Postman.Rank) == 5 then
				player:addItem(8762, 1)
				player:setStorageValue(Storage.ThievesGuild.Mission06, 2)
				npcHandler:say('Oh my! You look so great in your uniform! \z
				You archpostwomen are not only daring but also beautiful. \z
				Here take it, that\'s the key you wanted. Just promise to visit me now and then!', cid)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
