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

	if msgcontains(msg, 'barrel') then
		if player:getStorageValue(Storage.SecretService.AVINMission03) == 2 then
			npcHandler:say('Do you bring me a barrel of beer??', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'whisper beer') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 11 then
			npcHandler:say('Do you want to buy a bottle of our finest whisper beer for 80 gold?', cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			if player:removeItem(7706, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission03, 3)
				npcHandler:say('Three cheers for the noble |PLAYERNAME|.', cid)
			else
				npcHandler:say("You don't have any barrel of beer!", cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 11 then
				if player:removeMoneyNpc(80) then
					npcHandler:say("Here. Don't take it into the city though.", cid)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 12)
					player:addItem(6106, 1)
					npcHandler.topic[cid] = 0
				else
					npcHandler:say("You don't have enough money.", cid)
				end
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_GREET, 'Pshhhht! Not that loud ... but welcome.')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
