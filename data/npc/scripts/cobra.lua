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

local function greetCallback(cid)
	local player = Player(cid)
	if player:getCondition(CONDITION_POISON) then
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Venture the path of decay!")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(Position(33396, 32836, 14))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	else
		npcHandler:say("Begone! Hissssss! You bear not the mark of the cobra!", cid)
		return false
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
