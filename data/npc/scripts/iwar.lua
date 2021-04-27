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

local playerTopic = {}
local function greetCallback(cid)

	local player = Player(cid)
	npcHandler:addFocus(cid)
	return true
end


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	npcHandler.topic[cid] = playerTopic[cid]
	local player = Player(cid)
	local valorPicture = 10000

	-- Começou a quest
	if msgcontains(msg, "has the cat got your tongue?") and player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 4 then
			npcHandler:say({"Nice. You like your picture, haa? Give me 10,000 gold and I will deliver it to the museum. Do you {pay}?"}, cid)
			npcHandler.topic[cid] = 2
			playerTopic[cid] = 2
	elseif msgcontains(msg, "pay") or msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			if (player:getMoney() + player:getBankBalance()) >= valorPicture then
				npcHandler:say({"Well done. The picture will be delivered to the museum as last as possible."}, cid)
				npcHandler.topic[cid] = 0
				playerTopic[cid] = 0
				player:removeMoneyNpc(valorPicture)
				player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, 5)
			else
				npcHandler:say({"You don't have enough money."}, cid)
				npcHandler.topic[cid] = 1
				playerTopic[cid] = 1
			end
		end
	end
	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
