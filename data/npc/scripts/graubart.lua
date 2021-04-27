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

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Graubart, captain of the great SeaHawk!"})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, my whole proud: My ship named SeaHawk. We rode out so many stormy nights together. I think I couldn't live without it."})
keywordHandler:addKeyword({'seahawk'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, my whole proud: My ship named SeaHawk. We rode out so many stormy nights together. I think I couldn't live without it."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm a merchant. I sail all over the world with my ship and trade with many different races!"})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = "A merchant is someone who trades goods with other people and tries to make a little profit. *laughs*"})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = "I trade nearly everything, for example weapons, food, water, and even magic runes."})
keywordHandler:addKeyword({'races'}, StdModule.say, {npcHandler = npcHandler, text = "You know; elves, dwarfs, lizardmen, minotaurs and many others."})
keywordHandler:addKeyword({'water'}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, sold out."})
keywordHandler:addKeyword({'marlene'}, StdModule.say, {npcHandler = npcHandler, text = "Pssst. Marlene is not near right now...? You know... she is a lovely woman, but she talks too much! So I always try to keep distance from her because she can't stop talking."})
keywordHandler:addKeyword({'bruno'}, StdModule.say, {npcHandler = npcHandler, text = "Bruno is one of the best sailors I know. He is nearly as good as me. *laughs loudly*"})

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_GREET, "Ahoi, young man |PLAYERNAME|. Looking for work on my ship?")

npcHandler:addModule(FocusModule:new())
