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

-- Promotion
local promoteKeyword = keywordHandler:addKeyword({'promot'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to be promoted in your vocation for 20000 gold?'})
	promoteKeyword:addChildKeyword({'yes'}, StdModule.promotePlayer, {npcHandler = npcHandler, level = 20, cost = 20000})
	promoteKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Ok, whatever.', reset = true})

npcHandler:setMessage(MESSAGE_GREET, 'Be mourned, pilgrim in flesh. Are you looking for a promotion?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new())
