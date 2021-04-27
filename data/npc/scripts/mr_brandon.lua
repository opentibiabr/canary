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
	{ text = '<grumble> Maybe I should rearrange some warm currents to get rid of this horrible fog.' },
	{ text = 'All these treasures I cannot reach... what a pity.' }
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
