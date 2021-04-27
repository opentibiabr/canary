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
	if msgcontains(msg, "errand") or msgcontains(msg, "gold") then
		if player:getStorageValue(Storage.TheShatteredIsles.TheErrand) == 1 then
			npcHandler:say("Oh, so you brought some gold from Eleonore to me?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:removeMoneyNpc(200) then
				npcHandler:say("Hmm, it seems that Eleonore does trust you. Perhaps she is even right. However. Since we need some help right now I guess we can't be too picky. Return to Eleonore and tell her the secret password: 'peg leg'. She will tell you more about her problem.", cid)
				player:setStorageValue(Storage.TheShatteredIsles.TheErrand, 2)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say("You don't have enough...", cid)
			end
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] >= 1 then
			npcHandler:say("Then no.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Ah, welcome! Welcome |PLAYERNAME|! If you need druid spells, you've come to the right place. Otherwise it's just nice to have a visitor.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
