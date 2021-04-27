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
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 10 then
			if player:getPosition().z == 12 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest01) < 1 and npcHandler.topic[cid] ~= 1 then
				npcHandler:say({
					"Although we are willing to hand this item to you, there is something you have to understand: There is no such thing as 'the' sceptre. ...",
					"Those sceptres are created for special purposes each time anew. Therefore you will have to create one on your own. It will be your {mission} to find us three keepers and to get the three parts of the holy sceptre. ...",
					"Then go to the holy altar and create a new one."
				}, cid)
				npcHandler.topic[cid] = 1
			elseif npcHandler.topic[cid] == 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				npcHandler.topic[cid] = 2
			elseif player:getPosition().z == 13 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest02) < 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				npcHandler.topic[cid] = 3
			elseif player:getPosition().z == 14 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest03) < 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, cid)
				npcHandler.topic[cid] = 4
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest01, 1)
				player:removeMoneyNpc(5000)
				player:addItem(12324, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 3 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest02, 1)
				player:removeMoneyNpc(5000)
				player:addItem(12325, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest03, 1)
				player:removeMoneyNpc(5000)
				player:addItem(12326, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] then
		npcHandler:say("No deal then.", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
