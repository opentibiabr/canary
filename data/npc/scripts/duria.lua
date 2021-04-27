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

keywordHandler:addSpellKeyword({'find', 'person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation = VOCATION.CLIENT_ID.KNIGHT})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation = VOCATION.CLIENT_ID.KNIGHT})
keywordHandler:addSpellKeyword({'cure', 'poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation = VOCATION.CLIENT_ID.KNIGHT})
keywordHandler:addSpellKeyword({'wound', 'cleansing'}, {npcHandler = npcHandler, spellName = 'Wound Cleansing', price = 0, level = 8, vocation = VOCATION.CLIENT_ID.KNIGHT})
keywordHandler:addSpellKeyword({'great', 'light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation = VOCATION.CLIENT_ID.KNIGHT})

keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Wound Cleansing}' and '{Cure Poison}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Light}', '{Find Person}' and '{Great Light}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {healing spells} and {support spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that.'})

npcHandler:setMessage(MESSAGE_GREET, 'Hiho, fellow knight |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Be carefull out there, jawoll.')

npcHandler:addModule(FocusModule:new())
