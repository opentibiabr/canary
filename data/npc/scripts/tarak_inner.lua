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
	if msgcontains(msg, "monument tower") or msgcontains(msg, "passage") or msgcontains(msg, "trip") then
		npcHandler:say("Do you want to travel to the {monument tower} for a 50 gold fee?", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			local player = Player(cid)
			if player:getMoney() + player:getBankBalance() >= 50 then
				player:removeMoneyNpc(50)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(Position(32940, 31182, 7), false)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler.topic[cid] = 0

			elseif player:getBankBalance() >= 50 then
				getBankMoney(cid, 50)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(Position(32940, 31182, 7), false)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have enought money.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Can I interest you in a trip to the {monument tower}?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
