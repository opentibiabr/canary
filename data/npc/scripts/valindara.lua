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

local voices = { {text = 'Im eager for a bath in the lake.'},{text = 'Im interested in shiny precious things, if you have some.'},{text = 'No, you cant have this cloak.'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Greatings, mortal beigin.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Yes, i have some potions and runes if you are interested. Or do you want to buy only potions or only runes?oh if you want sell or buy gems, your may also ask me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:addModule(FocusModule:new())
