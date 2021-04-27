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
	if msgcontains(msg, 'letter') then
		if player:getStorageValue(Storage.ThievesGuild.Mission06) == 1 then
			npcHandler:say('You would like Chantalle\'s letter? only if you are willing to pay a price. {gold} maybe?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'gold') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Are you willing to pay 1000 gold for this letter?', cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 2 then
			if player:removeMoneyNpc(1000) then
				player:addItem(8768, 1)
				npcHandler:say('Here you go kind sir.', cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
