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

local voices = { {text = 'Selling herbs, mushrooms and flowers, all picked under the light of the full moon!'} }
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'offers'}, StdModule.say, {npcHandler = npcHandler, text = "I'm selling various herbs, mushrooms, and flowers. If you'd like to see my offers, ask me for a {trade}."})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller. Maybe you'd like to take a look at my {offers}...")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye, traveller.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye, traveller.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares.")
npcHandler:addModule(FocusModule:new())
