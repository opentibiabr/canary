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
	{ text = 'Only quality steel and wood used for my weapons!' },
	{ text = 'Buy your weapons here!' },
	{ text = 'Selling and buying all sorts of weapons, come and have a look!' },
	{ text = 'Give those monsters a good whipping with my weapons!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, how can I help you? Do you need some general {hints}? Or, if you\'re interested in a {trade}, just ask.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'What kind of information do you need? I could tell you about different topics such as {equipment}, {monsters} or {Rookgaard} in general.'})
keywordHandler:addKeyword({'torch'}, StdModule.say, {npcHandler = npcHandler, text = '{Al Dee} sells torches.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Be careful down there! Make sure you bought enough {torches} and a {rope} or you might get lost.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'The king encouraged salesmen to travel here, but only I dared to take the risk, and a risk it was!'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s about |TIME|. Yes, |TIME|. I\'m so sorry, I have no watches for sale.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Obi, just Obi, the honest merchant. If you like to {trade}, just ask.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a merchant and the local {weapon} smith. If you like to see my quality wares or sell weapons to me, ask me for a {trade}.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'As an adventurer you should always have at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'If I were you, I\'d invest my money in quality steel rather than putting it in a so-called safe bank account!'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, the mainland also consists of several continents. You can go there once you are level 8 and have talked to the {oracle}.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Ah, Rookgaard. Home sweet home, that\'s what it became for me, but I will always miss {Thais} and {Sam}.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, Thais, I\'ll be back. One day, I\'ll be back.'})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = 'My good old cousin Sam. Oh, how I miss him.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'I think good practice is better than reading a boring book. Of course, you will need proper {equipment} to be able to get practice!'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = ' told them to let me sell food, but no! Sorry, you have to ask {Willie} or {Billy} on the farms west of here.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Good monsters to start with are rats. They live in the {sewers} under the village of {Rookgaard}.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many sewer entrances throughout Rookgaard. One is right outside this shop and to the left. For more details about monsters and dungeons, best talk to one of the {guards}.'})
keywordHandler:addKeyword({'guard'}, StdModule.say, {npcHandler = npcHandler, text = 'The bridge guard {Dallheim} is north of here, just follow the street, you can\'t miss it.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'Sadly, not many merchants are as honest as I am.'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'I wish I could help you with that, but no, I was told to stick to weapons. Go see {Lily}.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many blueberry bushes in and around this village. Nature\'s for free.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m fine. It\'s a little hot near the crucible, but I enjoy the sound of forging {weapons}.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see which things I buy from you.'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, just upstairs. My granddaughter {Dixi} is in charge of selling armors and shields.'})
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addAliasKeyword({'helmet'})

keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I\'m selling weapons. Just ask me for a {trade} to see my offers and the things I buy from you.'})

keywordHandler:addKeyword({'gold'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, no gold, no deal. Earn gold by fighting {monsters} and picking up the things they carry. Sell it to {merchants} to make profit!'})
keywordHandler:addAliasKeyword({'money'})

keywordHandler:addKeyword({'rope'}, StdModule.say, {npcHandler = npcHandler, text = 'I wish I could help you with that, but no, I was told to stick to weapons. Go see {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'backpack'})
keywordHandler:addAliasKeyword({'fishing'})

keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell {weapons} of all kinds. Just ask me for a {trade} if you like to see my offers.'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'offer'})

-- Names
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t know how anyone could give up the flourishing business she led. She should have listened to me and find someone who continues that business for her.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'I told him there was no danger, but he wouldn\'t listen to me, no one listens to me.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'I suggested him opening a tourist guide company with me, Obi\'s and Santiago\'s, but he didn\'t approve. I really don\'t understand why.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'An old woman shouldn\'t be treated like that, no way, that\'s bad.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, this guy is so greedy, so greedy. Ripping off poor adventurers like you!'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'She is beautiful, very, very beautiful. I hope I can impress her somehow.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s just like his cousin {Willie}.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'This guy doesn\'t understand that he should entrust me with the food business, too. He really should do. Then he had time for his farm.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He shouldn\'t heal people for free, no he shouldn\'t. That would be a great source of income for the village that could be invested in enhancing the smithy.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, what an endearing little girl, and she\'s working so hard to help me, even without receiving payment. Such a sweet little girl!'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t like him, actually I dislike him deeply. He is so greedy that he doesn\'t want to share his profit he gains from health potions.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'She ruins the market with her offers! This is bad for us honest merchants, really bad.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'I knew it! I knew she would try to get the monopoly on potions in this village! But no one has listened to me!'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'The oracle, ah, such a weird being! It will lead you off this island once you are level 8, yes it will, mark my words.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'I told everyone he will cause trouble. He talks people into giving him their money and putting it on the {bank}! They rather should leave it here with us honest merchants!'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'He is the head of the local academy. I encouraged him to sponsor you, but no one listens to Obi, no one listens to me, as usual.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, he just buys what no one else wants. Stuff that\'s long dead. I can live with that, yes, I can live with that.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'What a hero, what a hero.'})
keywordHandler:addAliasKeyword({'zerbrus'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Um yeah, good day.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, I hope you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Of course, just browse through my wares.')
npcHandler:setMessage(MESSAGE_GREET, 'Hello, hello, |PLAYERNAME|! Please come in, look, and buy! If you like to see my offers, ask me for a {trade}!')

npcHandler:addModule(FocusModule:new())
