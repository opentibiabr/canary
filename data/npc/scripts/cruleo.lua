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

local voices = {
	{ text = '<gulp gulp>' },
	{ text = 'This will earn me some handsome amount of gold!' },
	{ text = 'Muhahaha!' }
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
