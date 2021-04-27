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

keywordHandler:addKeyword({'task'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you here to get a task or to report you finished task?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Me humble name is Rafzan. Good old goblin name meaning honest, generous and nice person, I swear!'})
keywordHandler:addKeyword({'goblin'}, StdModule.say, {npcHandler = npcHandler, text = 'Most goblins so afraid of everything, that they fight everything. Me different. Me just want trade.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'You humans are so big, strong, clever and beautiful. Me really feel little and green beside you. Must be sooo fun to be human. You surely always make profit!'})
keywordHandler:addKeyword({'profit'}, StdModule.say, {npcHandler = npcHandler, text = 'To be honest to me human friend, me only heard about it, never seen one. I imagine it\'s something cute and cuddly.'})
keywordHandler:addKeyword({'swamp'}, StdModule.say, {npcHandler = npcHandler, text = 'Swamp is horrible. Slowly eating away at health of poor little goblin. No profit here at all. Me will die poor and desperate, probably eaten by giant mosquitoes.'})
keywordHandler:addKeyword({'dwarf'}, StdModule.say, {npcHandler = npcHandler, text = 'Beardmen are nasty. Always want to kill little goblin. No trade at all. Not good, not good.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'So much to do, so little help. Me poor goblin desperately needs help. Me have a few tasks me need to be done. I can offer you all money I made if you only help me a little with stuff which is easy to strong smart human but impossible for poor, little me.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Me heard Thais is big city with king! Must be strong and clever, to become chief of all humans. Me cannot imagine how many people you have to beat up to become king of all humans. Surely he makes lot of profit in his pretty city.'})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = 'They are mean and cruel. Humble goblin rarely trades with them. They would rather kill poor me if not too greedy for stuff only me can get them. Still, they rob me of it for a few spare coins and there is noooo profit for poor goblin.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Me job merchant is. Me trade with all kinds of things. Me not good trader though, so you get everything incredibly cheap! You might think me mad, but please don\'t rip off poor goblin too much. Me has four or five wives and dozens of kids to feed!'})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, text = 'Humans so clever. Much, much smarter than poor, stupid goblin. They have big rich town. Goblin lives here poor and hungry. Me so impressed by you strong and smart humans. So much to learn from you. Poor goblin only sees pretty city from afar. Poor goblin too afraid to go there.'})
keywordHandler:addKeyword({'gold'}, StdModule.say, {npcHandler = npcHandler, text = 'Me have seen a gold coin once or twice. So bright and shiny it hurt me poor eyes. You surely are incredibly rich human who has even three or four coins at once! Perhaps you want to exchange them for some things me offer? Just don\'t rob me too much, me little stupid goblin, have no idea what stuff is worth... you look honest, you surely pay fair price like I ask and tell if it\'s too cheap.'})
keywordHandler:addKeyword({'ratmen'}, StdModule.say, {npcHandler = npcHandler, text = 'Furry guys are strange fellows. Always collecting things and stuff. Not easy to make them share, oh there is noooo profit for little, poor me to be made. They build underground dens that can stretch quite far. Rumour has it the corym have strange tunnels that connect their different networks all over the world.'})

npcHandler:addModule(FocusModule:new())
