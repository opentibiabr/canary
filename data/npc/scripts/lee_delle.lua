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
	{ text = 'Ask me if you need help!' },
	{ text = 'Buy and sell everything you want here!' },
	{ text = 'No need to run from shop to shop, my place is all that\'s needed!' },
	{ text = 'Special offers for premium customers!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Basic keywords
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Lee\'Delle.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a merchant. If you like to see my offers, just ask me for a {trade}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s about |TIME|.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, it\'s a good idea to leave most of your money in the bank and only take what you need. That way your gold is safe.'})
keywordHandler:addKeyword({'cookie'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh no! I\'ve got to watch what I eat. {Lily} loves cookies, though.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many merchants in this village. Just ask them for a {trade} to see their offers. But I can promise you - my offers are the best around!'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m fine. I\'m delighted to welcome you as my customer.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'What kind of information do you need? I could tell you about different topics such as {equipment}, {monsters} or {Rookgaard} in general.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'How can I help you? Would you like to {trade} with me? I can also give you general {hints}. Or just ask me anything you\'d like to know.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'You should really take some time and travel around the marvellous areas of Tibia. There\'s everything - ice islands, deserts, jungles and mountains!'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is the place to go when you are very low on {health} or poisoned. Ask {Cipfried} for a heal - he usually notices emergencies by himself.'})
keywordHandler:addKeyword({'health'}, StdModule.say, {npcHandler = npcHandler, text = 'Health potions will heal you for about 75 hit points. It can\'t hurt to carry one with you, just in case.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, very important equipment would be a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}. Maybe also a torch if you\'re heading into a dark {dungeon}.'})
keywordHandler:addKeyword({'fishing'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell fishing rods and worms in case you want to go fishing. Simply ask me for a {trade}.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'You could check out which weapons I offer by asking me for a {trade}. Don\'t be shy!'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I\'m sorry, that\'s one of the things I don\'t have for sale. But {Willie} or {Billy} surely have something to eat for you.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'The king supports our little village very much!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'In the academy you can get a lot of information from books. You can also try out a few things by yourself.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Isn\'t it lovely here? You\'ll be surprised once you reach the {mainland} -  so much to explore!'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, the mainland also consists of several continents. You can go there once you\'ve reached level 8 and talked to the {oracle}.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Good monsters to start with are rats. They live in the {sewers} under the village of {Rookgaard}.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see what I buy from you.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Be careful down there! Make sure you bought enough {torches} and a {rope} or you might get lost.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many sewer entrances throughout Rookgaard. If you want to know more details about monsters and dungeons, best talk to one of the guards.'})

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see my offers. Apart from that, I also sell {footballs}.'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'buy'})

keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'I really love flowers. My favourites are {honey flowers}. Sadly, they are very rare on this isle. If you can find one for me, I\'ll give you a little reward.'})
keywordHandler:addAliasKeyword({'mission'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'You could check out which armors or shields I offer by asking me for a {trade}. Don\'t be shy!'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I\'m selling that. Simply ask me for a {trade} to view all my offers.'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'torch'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, no gold, no deal. Earn gold by fighting {monsters} and picking up the things they carry. Sell it to {merchants} to make profit!'})
keywordHandler:addAliasKeyword({'gold'})

-- Names
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells {weapons}. However, I can offer you better deals than him!'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m glad she stopped selling stuff. There was too much of a competition going on!'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Sometimes, I see him walking outside the village near some hole.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He dedicated his life to welcome newcomers to this island.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Poor old woman, her son {Tom} never visits her.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Al Dee has a general {equipment} store in the north-western part of the village.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'She lives under the {academy}. Always nice to chat with her!'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a local farmer. If you need fresh {food} to regain health, it\'s a good place to go. He\'s only trading with premium adventurers, though.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a local farmer. If you need fresh {food} to regain your health, it\'s a good place to go. However, many monsters carry also food such as meat. Or you could simply pick {blueberries}.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'Visiting Cipfried in the {temple} is a good idea if you are injured or poisoned. He can heal you.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi\'s} granddaughter and deals with {armors} and {shields}, just as I do.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'He mostly stays by himself. He\'s a hermit outside of town - good luck finding him.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'She buys all {blueberries} and {cookies} you can find.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8 to reach more areas of {Tibia}.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He is the {bank} clerk, just below the academy.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is a teacher running the {academy}. He has a lot of important {information} about Tibia.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He is a great warrior and our protector.'})
keywordHandler:addAliasKeyword({'zerbrus'})

-- Football
local footballKeyword = keywordHandler:addKeyword({'football'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to buy a football for 111 gold?'})
	footballKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Here you go.', reset = true},
			function(player) return player:getMoney() + player:getBankBalance() >= 111 end,
			function(player)
				if player:removeMoneyNpc(111) then
					player:addItem(2109, 1)
				end
			end
	)
	footballKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'You don\'t have enough money.', reset = true})
	footballKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, but it\'s fun to play!', reset = true})

-- Honey Flower
keywordHandler:addKeyword({'honey', 'flower'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, thank you so much! Please take this piece of armor as reward.'},
	function(player) return player:getItemCount(2103) > 0 end,
	function(player) player:removeItem(2103, 1) player:addItem(2468, 1) end
)
keywordHandler:addKeyword({'honey', 'flower'}, StdModule.say, {npcHandler = npcHandler, text = 'Honey flowers are my favourites <sighs>.'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Bye, bye.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye, bye, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Sure, take a look, honey.')
npcHandler:setMessage(MESSAGE_GREET, 'Nice to see you, |PLAYERNAME|! Ask me for a {trade} if you like to see my exclusive offers.')

npcHandler:addModule(FocusModule:new())
