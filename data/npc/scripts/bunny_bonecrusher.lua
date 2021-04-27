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

keywordHandler:addKeyword({'hail general'}, StdModule.say, {npcHandler = npcHandler, text = "Salutations, commoner |PLAYERNAME|!"})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = "We are in constant training and in perfect health."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the general of the queen's army. I don't have time to explain this concept to you."})
keywordHandler:addKeyword({'bonecrusher'}, StdModule.say, {npcHandler = npcHandler, text = "Our family has been serving the Carlin army since countless generations!"})
keywordHandler:addKeyword({'sister'}, StdModule.say, {npcHandler = npcHandler, text = "Our family has been serving the Carlin army since countless generations!"})
keywordHandler:addKeyword({'family'}, StdModule.say, {npcHandler = npcHandler, text = "She is one of my beloved sisters and serves Carlin as a town guard."})
keywordHandler:addKeyword({'queen'}, StdModule.say, {npcHandler = npcHandler, text = "HAIL TO QUEEN ELOISE, OUR NOBLE {LEADER}!"})
keywordHandler:addKeyword({'leader'}, StdModule.say, {npcHandler = npcHandler, text = "Queen Eloise is a fine leader for our fair town, indeed!"})
keywordHandler:addKeyword({'army'}, StdModule.say, {npcHandler = npcHandler, text = "The army protects the defenceless males of our {city}. Our elite forces are the {Green Ferrets}."})
keywordHandler:addKeyword({'city'}, StdModule.say, {npcHandler = npcHandler, text = "Our city blends in with the nature surrounding it. Our {druids} take care of that."})
keywordHandler:addKeyword({'druids'}, StdModule.say, {npcHandler = npcHandler, text = "They are our main magic support and play a major role in our battle {tactics}."})
keywordHandler:addKeyword({'tactics'}, StdModule.say, {npcHandler = npcHandler, text = "Our tactic is to kiss."})
keywordHandler:addKeyword({'kiss'}, StdModule.say, {npcHandler = npcHandler, text = "K.I.S.S.! Keep It Simple, Stupid! Complicated tactics are too easy to be crushed by a twist of fate."})
keywordHandler:addKeyword({'green ferrets'}, StdModule.say, {npcHandler = npcHandler, text = "Our elite forces are trained by rangers and druids. In the woods they come a close second to elves."})
keywordHandler:addKeyword({'join'}, StdModule.say, {npcHandler = npcHandler, text = "Join what?"})
keywordHandler:addKeyword({'join army'}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, we don't recruit foreigners. Maybe you can join if you prove yourself in a mission for the queen."})

npcHandler:addModule(FocusModule:new())
