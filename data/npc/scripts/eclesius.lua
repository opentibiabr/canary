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
	{ text = "I'm looking for a new assistant!" },
	{ text = "Err, what was it again that I wanted...?" },
	{ text = "Do come in! Mind the step of the magical door, though." },
	{ text = "I'm so sorry... I promise it won't happen again. Problem is, I can't remember where I made the error..." },
	{ text = "Actually, I STILL prefer inexperienced assistants. They're easier to keep an eye on and don't tend to backstab you." },
	{ text = "So much to do, so much to do... uh... where should I start?" }
}

npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Who are you? What do you want? You seem too experienced to become my assistant. Please leave.")

npcHandler:addModule(FocusModule:new())
