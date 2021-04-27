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
	{ text = 'Increase your knowledge of spells here, young paladin.' },
	{ text = 'Need ammunition, bows or crossbows? Have a look at my wares.' }
}

npcHandler:addModule(VoiceModule:new(voices))

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Ashari, |PLAYERNAME|. If you're a distance fighter, you might want to have a look at my wares and spells."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi, |PLAYERNAME|."})

npcHandler:setMessage(MESSAGE_GREET, "Ashari, |PLAYERNAME|. If you're a distance fighter, you might want to have a look at my wares and spells.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new())