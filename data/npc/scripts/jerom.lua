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
	{ text = 'My house! Uahahahaha <sniffs>.' },
	{ text = 'Dear gods! My precious house, DESTROYED!!' },
	{ text = 'Oh no!! What am I supposed to do now?!?' }
}

npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Hello. Sorry, but I'm not in the best {mood} today.")
npcHandler:addModule(FocusModule:new())
