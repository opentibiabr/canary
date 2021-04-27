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
	{ text = 'Add one fresh dead rat and stir it well... ' },
	{ text = 'Argh, if I only had a pan!' },
	{ text = 'Bread, cheese, ham and meat! All fresh!' },
	{ text = 'Buying fresh dead rats!' },
	{ text = 'Buying many types of food and ingredients, too!' },
	{ text = 'Hmm, hmm, now which ingredients do I need...' },
	{ text = 'Need food? I have plenty for sale!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Billy.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a farmer and a {cook}. I\'d love to make pancakes, but I\'m lacking a good {pan}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'I came here for peace and leisure, so leave me alone with \'time\'.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Rather give your {money} to me than leaving it at the bank. Hehe.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you, I\'m fine.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'If you need information, I can provide you with general {hints}.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a cook, not a priest. If you need information, I can provide you with general {hints}.'})
keywordHandler:addKeyword({'cook'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the best cook around. You can sell most types of {food} to me. Just ask me for a {trade} to see what I buy from you as well as my offers.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'Which citizen?'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'If you bring me a fresh rat for my famous stew, ask me for a {trade}.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'Nah, this is not a real shop. I have some offers, though. If you\'re interested, just ask me for a {trade}. There are other {merchants} on {Rookgaard} as well.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'There is so much to explore! Better hurry to get to the continent! Once you\'re level 8, look for the {oracle}.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'As an adventurer, you should always have at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'There are lots and lots of dusty books. You can read them for some basic knowledge about the world. Then again, you could also ask around in the village.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'The king and his tax collectors are far away. You\'ll meet them soon enough.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Ask {Obi} or {Lee\'Delle}. They make a fortune here with all those wannabe heroes.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'This island will prepare you for the main continent of {Tibia}. Learn to fight and grow stronger!'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Don\'t be scared, you should be safe as long as you stay in town. Dangerous monsters are roaming the {dungeons}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'You\'ll find a lot of dungeons if you look around. One example are the {sewers} below Rookgaard.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'The local sewers are invested by {rats}. Fresh rats give a good stew, you can sell them to me.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see what I buy from you. Food of almost any kind!'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'To view the offers of a merchant, simply talk to him or her and ask for a {trade}.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s right, I\'m the god of cooking!'})
keywordHandler:addKeyword({'recipe'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'d love to make pancakes, but I\'m lacking a decent {pan}. If you get me one, I\'ll reward you.'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Armor and shields can be bought at {Dixi\'s} or at {Lee\'Delle\'s}. Dixi runs that shop near {Obi\'s}.'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'Get that from {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'fishing'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, no gold, no deal. Earn gold by fighting {monsters} and picking up the things they carry. Sell it to {merchants} to make profit!'})
keywordHandler:addAliasKeyword({'gold'})

keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'I can spell but I don\'t know any spells.'})
keywordHandler:addAliasKeyword({'spell'})

keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see my offers.'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'offer'})

-- Names
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'I like him, we usually have a drink or two once a week and share stories about {Willie}.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'That girl is all about party now. I think she was fed up with {equipment} selling.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Now that\'s one crazy fellow. I usually hear him scream about some hole.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a fisherman and somehow his hut is always infested with cockroaches.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'That old hag always finds someone to do her work. I have no clue how she is doing that.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Decent guy. He sells general equipment such as {ropes}, {shovels} and so on.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s pretty indeed! I wonder if she likes bearded men.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'Gotta love that name.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Don\'t listen to this old wannabe, I\'m the best cook around.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He never leaves the temple. He spends his time caring for those who newly arrive here. You can ask him for a heal if you are badly injured or poisoned.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s {Obi\'s} granddaughter. She helps him out by selling {armors} and {shields}. I think she\'ll be a beauty when she\'s grown up.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'I never see that guy around.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her shop is super-duper exclusive. If you\'re a premium adventurer, check it out in the western part of town. Lotsa nice offers there.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'She lives in the very south of this town, selling her potions. Sweet - well, sweet-loving girl.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He must have the most boring job there is.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t like his headmaster behaviour. Then again, he IS the headmaster of the {academy}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Tom the tanner buys what\'s too nasty or too old to eat, animal-wise. Dead wolves and such.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He is one of the king\'s best men and here to protect us.'})
keywordHandler:addAliasKeyword({'zerbrus'})

-- Health Potion Quest
local panKeyword = keywordHandler:addKeyword({'pan'}, StdModule.say, {npcHandler = npcHandler, text = 'Have you found a pan for me?'})
	panKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'A pan! At last! Take this in case you eat something my cousin has cooked.', reset = true},
			function(player) return player:getItemCount(2563) > 0 end,
			function(player)
				player:removeItem(2563, 1)
				player:addItem(8704, 1)
			end
	)
	panKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Hey! You don\'t have one!', reset = true})
	panKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Then go and look for one!', reset = true})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'HOW RUDE!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Sure.')
npcHandler:setMessage(MESSAGE_GREET, 'Howdy |PLAYERNAME|. I\'m a farmer and cook, maybe I can interest you in a {trade} with food? You can also ask me for general {hints} about the game.')

npcHandler:addModule(FocusModule:new())
