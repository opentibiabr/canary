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
	{ text = 'Are you looking for the best trades? Come to my shop!' },
	{ text = 'Feeling lost? You can always ask me about general hints!' },
	{ text = 'Tools and general equipment at Al Dee\'s!' },
	{ text = 'Don\'t head for adventure without a rope and torches! Buy your supplies here!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Basic Keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see what I buy from you.'})
keywordHandler:addKeyword({'stuff'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see my offers.'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'buy'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'If you need general {equipment}, just ask me for a {trade}. I can also provide you with some general {hints} about the game.'})
keywordHandler:addAliasKeyword({'information'})

keywordHandler:addKeyword({'equip'}, StdModule.say, {npcHandler = npcHandler, text = 'As an adventurer, you should always have at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addAliasKeyword({'tools'})

keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m fine. I\'m so glad to have you here as my customer.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a merchant. Just ask me for a {trade} to see my offers.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Al Dee, but you can call me Al. Can I interest you in a {trade}?'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s about |TIME|. I\'m so sorry, I have no watches to sell. Do you want to buy something else?'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'If you want to challenge monsters in the {dungeons}, you need some {weapons} and {armor} from the local {merchants}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'If you want to explore the dungeons such as the {sewers}, you have to {equip} yourself with the vital stuff I am selling. It\'s {vital} in the deepest sense of the word.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, our sewer system is very primitive - it\'s so primitive that it\'s overrun by {rats}. But the stuff I sell is safe from them. Just ask me for a {trade} to see it!'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'The king encouraged salesmen to travel here, but only I dared to take the risk, and a risk it was!'})
keywordHandler:addKeyword({'bug'}, StdModule.say, {npcHandler = npcHandler, text = 'Bugs plague this isle, but my wares are bug-free, totally bug-free.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'One day I will return to the continent as a rich, a very rich man!'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Thais is a crowded town.'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'Have you ever wondered what that \'main\' is people are talking about? Well, once you\'ve reached level 8, you should talk to the {oracle}. You can choose a {profession} afterwards and explore much more of Tibia.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I\'m sorry, but I don\'t deal with weapons. That\'s {Obi\'s} or {Lee\'Delle\'s} business. I could offer you a {pick} in exchange for a {small axe} if you should happen to own one.'})
keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Armor and shields can be bought at {Dixi\'s} or at {Lee\'Delle\'s}. Dixi runs that shop near {Obi\'s}.'})
keywordHandler:addKeyword({'shield'}, StdModule.say, {npcHandler = npcHandler, text = 'Armor and shields can be bought at {Dixi\'s} or at {Lee\'Delle\'s}. Dixi runs that shop near {Obi\'s}.'})
keywordHandler:addKeyword({'cooki'}, StdModule.say, {npcHandler = npcHandler, text = 'I you want to find someone who may want to buy your cookies, you should meet Lily.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'Blueberries grow on bushes. They\'re quite common in Tibia. Just pick them from a bush if you need a snack!'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t sell potions. You should visit {Lily} for that.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Hmm, the best address to look for food might be {Willie} or {Billy}. {Norma} also has some snacks for sale.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'A bank is quite useful. You can deposit your money safely there. This way you don\'t have to carry it around with you all the time. You could also invest your money in my {wares}!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The big building in the centre of Rookgaard. They have a library, a training centre, a {bank} and the room of the {oracle}. {Seymour} is the teacher there.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The monk {Cipfried} takes care of our temple. He can heal you if you\'re badly injured or poisoned.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'As a premium adventurer you have many advantages. You really should check them out!'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'If you tell me the name of a citizen, I\'ll tell you what I know about him or her.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'To view the offers of a merchant, simply talk to him or her and ask for a {trade}. They will gladly show you their offers and also the things they buy from you.'})
keywordHandler:addKeyword({'profession'}, StdModule.say, {npcHandler = npcHandler, text = 'You will learn everything you need to know about professions once you\'ve reached the {Island of Destiny}.'})
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'The Island of Destiny can be reached via the {oracle} once you are level 8. This trip will help you choose your {profession}!'})

keywordHandler:addKeyword({'torch'}, StdModule.say, {npcHandler = npcHandler, text = 'No thank you. I can already overstock the market with torches.'})
keywordHandler:addKeyword({'fishing'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell fishing rods and worms if you want to fish. Simply ask me for a {trade}.'})
keywordHandler:addKeyword({'shovel'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I am selling that. Simply ask me for a {trade} to view all my offers.'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'backpack'})

-- Names
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He is just an old monk. However, he can heal you if you are badly injured or poisoned.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Poor old woman, her son {Tom} never visits her.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He dedicated his life to welcome newcomers to this island.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'No idea who that is.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Yep, that\'s me. Smart of you to notice that!'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local {bank} clerk.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'He mostly stays by himself. He\'s a hermit outside of town - good luck finding him.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi\'s} granddaughter and deals with {armors} and {shields}. Her shop is south west of town, close to the {temple}.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells {weapons}. His shop is south west of town, close to the {temple}.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'If you are a {premium} adventurer, you should check out {Lee\'Delle\'s} shop. She lives in the western part of town, just across the bridge.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s currently recovering from her travels in the {academy}. It\'s always nice to chat with her!'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is a teacher running the {academy}. He has many important {information} about Tibia.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'She sells health {potions} and antidote potions. Also, she buys {blueberries} and {cookies} in case you find any.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'This is a local farmer. If you need fresh {food} to regain your health, it\'s a good place to go. However, many monsters also carry food such as meat or cheese. Or you could simply pick {blueberries}.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'This is a local farmer. If you need fresh {food} to regain your health, it\'s a good place to go. He\'s only trading with {premium} adventurers though.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'She used to sell equipment, but I think she has opened a small bar now. Talks about changing her name to \'Mary\' and such, strange girl.'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'Some call him a hero. He protects the town from {monsters}.'})
keywordHandler:addAliasKeyword({'dallheim'})

-- Pick quest
local pickKeyword = keywordHandler:addKeyword({'pick'}, StdModule.say, {npcHandler = npcHandler, text = 'Picks are hard to come by. I trade them only in exchange for high quality small axes. Would you like to make that deal?'})
	pickKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Splendid! Here, take your pick.', reset = true},
		function(player) return player:getItemCount(2559) > 0 end,
		function(player)
			player:removeItem(2559, 1)
			player:addItem(2553, 1)
		end
	)
	pickKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I am looking for a SMALL axe.', reset = true})
	pickKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Well, then don\'t.', reset = true})
keywordHandler:addAliasKeyword({'small', 'axe'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Bye, bye.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye, bye |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Take a look in the trade window to your left.')
npcHandler:setMessage(MESSAGE_GREET, {
	'Hello, hello, |PLAYERNAME|! Please come in, look, and buy! I\'m a specialist for all sorts of {tools}. Just ask me for a {trade} to see my offers! You can also ask me for general {hints} about the game. ...',
	'You can also ask me about each {citizen} of the isle.'
})

npcHandler:addModule(FocusModule:new())
