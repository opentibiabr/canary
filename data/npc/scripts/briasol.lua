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

local voices = { {text = 'Come and take a look at the finest gems in the lands of Tibia.'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "fine vase") then
		if player:getStorageValue(Storage.TravellingTrader.Mission04) == 1 then
			npcHandler:say({
				"Rashid sent you, I suppose. Before I sell you that vase, one word of advice. ...",
				"Make room in your backpack so that I can place the vase carefully inside it. If it falls to the floor, it will most likely shatter or break if you try to pick it up again. ...",
				"This vase it not meant to be touched by human hands, so just keep your hands off it. Are you ready to buy that vase for 1000 gold?"
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:getMoney() + player:getBankBalance() >= 1000 then
				npcHandler:say("Here it is.", cid)
				player:setStorageValue(Storage.TravellingTrader.Mission04, 2)
				player:addItem(7582, 1)
				player:removeMoneyNpc(1000)
			else
				npcHandler:say("You don't have enought money.", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Greetings, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Good bye, |PLAYERNAME|."})

npcHandler:addModule(FocusModule:new())