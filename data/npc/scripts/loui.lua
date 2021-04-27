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
	{ text = 'BEWARE! Beware of that hole!' },
	{ text = 'STAY AWAY FROM THAT HOLE!' },
	{ text = 'What are you doing here?? Get away from that hole!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Loui.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a {monk}. I wanted to do something here, but I forgot what it was when I fell in that {hole}.'})
keywordHandler:addKeyword({'monk'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a humble servant of the {gods}.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'They created Tibia and all lifeforms.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'I have no idea how long I\'ve been in this {hole}. It seemed like an eternity!'})
keywordHandler:addKeyword({'hole'}, StdModule.say, {npcHandler = npcHandler, text = 'While looking for something - which I forgot - I found that {hole}. I went down, even though I had no torch. And then I heard {THEM}! There must be dozens!'})
keywordHandler:addKeyword({'them'}, StdModule.say, {npcHandler = npcHandler, text = 'They were so many, EVERYWHERE! I could barely escape alive. I have no clue what THEY were but one more second down there and I\'d have been dead!'})
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I\'m out of mana and ingredients, please visit Cipfried in town.'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'The good thing is that those horrible rats stay mostly in town. The bad thing is that they do so because of bigger {monsters} that would devour them outside.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Everything around us, that is Tibia.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'Most adventurers take their first steps there.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Pah, king! He should do something about this {hole}!'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'This is the place where everything starts.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'Was it...? Yes, I might have looked for blueberries as I foolishly entered this unholy {hole}.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'There must be an army of them, just down this {hole}.'})
keywordHandler:addKeyword({'rabbit'}, StdModule.say, {npcHandler = npcHandler, text = 'Then, they must be magic wielding beasts using creature illusion! Good thing you escaped.'})
keywordHandler:addKeyword({'life'}, StdModule.say, {npcHandler = npcHandler, text = 'The gods blessed Tibia with abundant forms of life.'})
keywordHandler:addKeyword({'story'}, StdModule.say, {npcHandler = npcHandler, text = 'The good thing is that those horrible rats stay mostly in town. The bad thing is that they do so because of bigger {monsters} that would devour them outside.'})

keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'I have no quests but to stay away from that {hole} and I recommend you to do the same.'})
keywordHandler:addAliasKeyword({'task'})

keywordHandler:addKeyword({'cash'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m penniless and poor as becomes a humble monk like me.'})
keywordHandler:addAliasKeyword({'gold'})

-- Names
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She owns a shop in town.'})
keywordHandler:addAliasKeyword({'lily'})
keywordHandler:addAliasKeyword({'lee\'delle'})

keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'She owns a bar in town.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Waaaah! Don\'t shock me like that!'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He has his own monsters, I believe.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Harmless old woman.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'He owns a shop in town.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Who\'s that? Never heard about her.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He owns a shop in town.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a farmer.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'The gods may protect me from his rudeness.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'A hermit on the other side of town.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'The oracle! Yes! You should get off this island as fast as you can!'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Young and inexperienced he is.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is the headmaster of the local {academy}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sure he has never seen monsters like those in this hole before.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'I tried to warn him about these monsters but he just laughed at me!! It\'s an outrage!'})
keywordHandler:addAliasKeyword({'zerbrus'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'STAY AWAY FROM THAT HOLE!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'May the gods protect you! And stay away from that hole!')
npcHandler:setMessage(MESSAGE_GREET, 'BEWARE! Beware of that {hole}!')

npcHandler:addModule(FocusModule:new())
