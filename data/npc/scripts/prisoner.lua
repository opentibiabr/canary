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
	{ text = "Ahhhh!" },
	{ text = "Have mercy!" },
	{ text = "I admit! I admit!" },
	{ text = "I repent!" },
	{ text = "Noooooo!" },
	{ text = "Please! I beg you to stop!" },
	{ text = "Take it away! Please!" }
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
