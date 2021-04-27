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

local travelNode = keywordHandler:addKeyword({'teleport'}, StdModule.say, {npcHandler = npcHandler, text = 'You will now be travelled out of here. Are you sure that you want to face that teleport?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, destination = Position(32834, 32275, 9) })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Then stay here in these ghostly halls.'})

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can offer you a {teleport}.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Dont mind me.'})

npcHandler:setMessage(MESSAGE_GREET, "Ah, I feel a mortal walks these ancient halls again. Pardon me, I barely notice you. I am so lost in my thoughts.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell then.")

npcHandler:addModule(FocusModule:new())
