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
	{ text = 'Are you injured or poisoned? Get your potions here! All natural, no artificial ingredients!' },
	{ text = 'Hey you, over there! Let\'s have a little chat, shall we?' },
	{ text = 'Oh, just in case you are looking for the marketplace and dungeons, just follow the path to the east.' },
	{ text = 'Anyone got some cookies for me?' },
	{ text = 'Do you need help? Just ask me about anything you\'d like to know!' },
	{ text = 'I\'m buying all of your blueberries for my famous blueberry juice!' }
}
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	-- Continue mission 4
	if player:getStorageValue(Storage.TheRookieGuard.Mission04) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh hey, |PLAYERNAME|! Vascalir must have sent you to help me with a little {mission}, right?")
	-- Not finished mission 4
	elseif player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME|! Back so soon? Have you delivered the herbs to Hyacinth?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! You look a little stressed today. If you like to view my offers of potions, just ask me for a {trade}. In case you're looking for the marketplace and dungeons, just follow the path to the east!")
	end
	return true
end

-- The Rookie Guard Quest - Mission 04: Home-Brewed

-- Mission 4: Start
local mission4 = keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"That's great to hear! You see, I'm not the only potion brewer on Rookgaard. The hermit Hyacinth has his little alchemy lab outside the village. ...",
		"He's old and can't make his way into the village anymore, but needs some of the herbs that grow only around here. Could you please deliver a bag of herbs to Hyacinth?"
	}
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 1 end
)
keywordHandler:addAliasKeyword({"mission"})

-- Mission 4: Decline
keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Oh. In that case, maybe you're interested in a {trade} - I sell potions and buy a few other things.",
	reset = true
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 1 end
)

-- Mission 4: Accept
mission4:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Here you go, honey. I really appreciate your help. To find Hyacinth, leave the village to the north and go pretty much straight to the east. ...",
		"His little alchemy lab is on top of a mountain. I'll mark the ramp leading up on your map, here. Don't stray from the path! There are dangerous monsters roaming the island."
	}
},
nil,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission04, 2)
	player:addItemEx(Game.createItem(13827, 1), true, CONST_SLOT_WHEREEVER)
	player:addMapMark({x = 32091, y = 32178, z = 7}, MAPMARK_GREENNORTH, "North Exit")
	player:addMapMark({x = 32139, y = 32176, z = 7}, MAPMARK_GREENNORTH, "To Hyacinth")
end
)

-- Mission 4: Decline
mission4:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Oh. Well, if you change your mind, let me know.",
	reset = true
})

-- Mission 4: Confirm Delivered (Without)
keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "No, you haven't. If you're looking for the way to Hyacinth, just leave the village to the north and then go east. I've marked it on your map!"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 end
)

-- Mission 4: Confirm Not Delivered (Without)
local mission4LostHerbs = keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Is something... wrong? You didn't lose the herbs, did you?"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 end
)

-- Mission 4: Confirm Lost Herbs
local mission4AcceptAnotherHerbs = mission4LostHerbs:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, at least you're honest. I can give you another sack, but only if you promise not to lose them this time. Okay?"
})

-- Mission 4: Decline Lost Herbs
mission4LostHerbs:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Phew. That's a relief. Well, don't forget to deliver them to Hyacinth! They have to be fresh to create potions.",
	reset = true
})

-- Mission 4: Accept Lost Herbs
mission4AcceptAnotherHerbs:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Here you go, honey. I really appreciate your help. To find Hyacinth, leave the village to the north and go pretty much straight to the east. ...",
		"His little alchemy lab is on top of a mountain. I'll mark the ramp leading up on your map, here. Don't stray from the path! There are dangerous monsters roaming the island."
	},
	reset = true
},
nil,
function(player)
	player:addItemEx(Game.createItem(13827, 1), true, CONST_SLOT_WHEREEVER)
end
)

-- Mission 4: Reject Lost Herbs
mission4AcceptAnotherHerbs:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Oh. Well, if you change your mind, let me know.",
	reset = true
})

-- Basic Keywords
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see what I buy from you. If you want to sell {blueberries}, ask me about them separately.'})
keywordHandler:addKeyword({'stuff'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see my offers. If you want to sell {blueberries}, ask me about them separately.'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'buy'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'How can I help you? If you like to buy something, just ask me for a {trade}. We can also chat about {Tibia}. Or, I could give you general {hints} about the game.'})
keywordHandler:addAliasKeyword({'information'})

keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'equip'}, StdModule.say, {npcHandler = npcHandler, text = 'You definitely need a good {weapon}, an {armor} and a {shield}. Also, you should never leave for a {dungeon} without {rope}, {shovel} and {torch}.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m in tune with myself and with nature. Thank you.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a {druid}, bound to the spirit of nature. My {potions} will help you if you feel bad. I also buy {blueberries} and {cookies}. Just ask me for a {trade}.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Lily, like the flower. It also stands for purity, just like my {potions} are!'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s about |TIME|. But does it really matter? Don\'t rush yourself and enjoy all these little moments.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s wise to store most of your gold at the bank below the academy. It\'s safer that way.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'If you tell me the name of a citizen, I\'ll tell you what I know about him or her.'})
keywordHandler:addKeyword({'antidote'}, StdModule.say, {npcHandler = npcHandler, text = 'Antidote potions will cure {poisoning}. They also have a lovely {blueberry} taste. You only need them when you get poisoned deep down in a dungeon, else just go to the {temple} for a free heal!'})
keywordHandler:addKeyword({'poisoning'}, StdModule.say, {npcHandler = npcHandler, text = 'Some creatures like snakes or poison spiders can poison you. That will diminish your health over a certain amount of time, so be careful when dealing with those creatures!'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'Being a druid is a wonderful profession. You control the forces of nature and can heal others.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many shops around here which are owned by local {citizens}.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is just to the right. You can get a healing for free there if you are badly injured or poisoned.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Tibia is our beautiful world, created by the gods. Being a {druid}, I\'m a worshipper of {Crunor}.'})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = 'Crunor is the great lord of trees and the creator of all plants. Despite what some people believe, he didn\'t create the {monsters}, though.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I\'m sorry honey, I don\'t sell food. If you are hungry, visit one of the farmers {Billy} and {Willie}. I buy {blueberries} and {cookies}, though.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = {'If you purchase premium time for your account, this opens up a lot of possibilities. ...', 'For example, you will be able to travel off the mainland, ride a mount and benefit from offline training as well as having more outfits and magic spells to choose from.'}})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'I can offer you homemade {antidote} potions and small {health} potions. Ask me for a {trade} if you like to see them.'})
keywordHandler:addKeyword({'health'}, StdModule.say, {npcHandler = npcHandler, text = 'Health potions will heal you for about 75 hit points. It can\'t hurt to carry one with you, just in case.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'I think Tibia would be a better place without authorities who lead others to war. Can\'t we just all live in peace?'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The academy is the big stone building in the town centre. If you\'re ready to leave Rookgaard, go there to see the {oracle}.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, in this village and its surroundings you can {train} your skills until you are level 8. Then you should see the {oracle} and head to the {main} continent.'})
keywordHandler:addKeyword({'train'}, StdModule.say, {npcHandler = npcHandler, text = 'To train your skills, simply help us {fighting} monsters.'})
keywordHandler:addKeyword({'fight'}, StdModule.say, {npcHandler = npcHandler, text = ' If you want to fight monsters, you should get better {equipment} from the {merchants}. You should also talk to one of the bridge {guards} to find suitable monsters for you.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'To view the offers of a merchant, simply talk to him or her and ask for a {trade}. They will gladly show you their offers and also the things they buy from you.'})
keywordHandler:addKeyword({'main'}, StdModule.say, {npcHandler = npcHandler, text = 'The main continent is huge! The gods of Tibia created everything from great seas, deep jungles and large deserts.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Sadly, our little village of {Rookgaard} is invaded by monsters. From the {dungeons} they creep to the surface and attack the city. We always need adventurers helping us to {fight} them.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'If you are looking for weapons, you should visit {Obi}\'s shop east of here. Or, if you have a {premium} account, go to {Lee\'Delle} for better offers.'})
keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Armors? Best buy them at {Dixi}\'s little counter, just upstairs from {Obi}\'s shop. Or, if you have a {premium} account, go to {Lee\'Delle} for better offers.'})
keywordHandler:addKeyword({'shield'}, StdModule.say, {npcHandler = npcHandler, text = 'Shields? Best buy them at {Dixi}\'s little counter, just upstairs from {Obi}\'s shop. Or, if you have a {premium} account, go to {Lee\'Delle} for better offers.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'If you need information about the dungeons here, you should talk to one of the bridge {guards}. They will show you where to go.'})
keywordHandler:addKeyword({'guard'}, StdModule.say, {npcHandler = npcHandler, text = 'Our bridge guards are {Dallheim} and {Zerbrus}. You can find Dallheim if you follow the path to the right, then turn north at the {temple}.'})
keywordHandler:addKeyword({'cookie'}, StdModule.say, {npcHandler = npcHandler, text = 'Yum, cookies! If you have some for me, just ask me for a trade.'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'Earn gold by fighting {monsters} and picking up what they carry. Sell it to {merchants} to make profit!'})
keywordHandler:addAliasKeyword({'gold'})

keywordHandler:addKeyword({'deposit'}, StdModule.say, {npcHandler = npcHandler, text = 'I will pay you 5 gold for every empty vial and potion flask. Just ask me for a {trade}.'})
keywordHandler:addAliasKeyword({'flask'})
keywordHandler:addAliasKeyword({'vial'})

keywordHandler:addKeyword({'shovel'}, StdModule.say, {npcHandler = npcHandler, text = 'You best buy such equipment at {Al Dee}\'s store in the North of the village. Or, if you have a {premium} account, go to {Lee\'Delle} for better offers.'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'torch'})

local cookiKeyword = keywordHandler:addKeyword({'cooki'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh yes, I love cookies! Will you accept 1 gold for it?'})
	cookiKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Fine! Here\'s your gold.', reset = true},
		function(player) return player:getItemCount(2687) > 0 end,
		function(player)
			player:removeItem(2687, 1)
			player:addMoney(1)
		end
	)
	cookiKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, you do not have one.', reset = true})
	cookiKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, what a pity.', reset = true})

local blueberryKeyword = keywordHandler:addKeyword({'blueberry'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, do you have blueberries for sale? I need them for my {antidote potion}. I give you 1 gold for 5 of them, yes?'})
	blueberryKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Fine! Here\'s your gold.', reset = true},
		function(player) return player:getItemCount(2677) >= 5 end,
		function(player)
			player:removeItem(2677, 5)
			player:addMoney(1)
		end
	)
	blueberryKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I\'m sorry. I\'m not buying less than 5 blueberries.', reset = true})
	blueberryKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'As you wish.', reset = true})
keywordHandler:addAliasKeyword({'blueberries'})
keywordHandler:addAliasKeyword({'berry'})

-- Names
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells {weapons}. His shop is east of here.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t know what to think about all this new bar. {Rookgaard} needs a little peace!'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'He used to help me gather blueberries. Then, one day, he suddenly stopped comming here. They say he went a little out of his mind.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'We tried everything to fight that cockroach plague in his cellar, but natural anti-bug potions simply won\'t help. I guess those roaches need to be fought with stronger weapons.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'That poor old woman. I wish I could help her.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Best tool shop in town, if you ask me.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'I heard that she\'s recovering below the academy. She has been on an exciting expedition. I haven\'t talked to her yet, though.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'Visiting Cipfried in the {temple} is a good idea if you are injured or poisoned. He can heal you.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi}\'s granddaughter and deals with {armors} and {shields}, just upstairs from Obi\'s shop.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Hyacinth also sells small health potions. He lives outside the village, in a hidden place.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'If you are a {premium} adventurer, you should check out {Lee\'Delle\'s} shop. She lives in the western part of town, just across the bridge.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes?'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8 to reach more areas of {Tibia}.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He takes care of the {bank}, keeping our money safe.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is a teacher running the {academy}. He has many important {information} about Tibia.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He is a great warrior. He can also tell you much about {monsters} and {dungeons} on this island.'})
keywordHandler:addAliasKeyword({'zerbrus'})

keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a farmer and sells {food}. Food will help you regain health when you are injured. Many {monsters} also carry food with them.'})
keywordHandler:addAliasKeyword({'willie'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'May Crunor bless you!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Take care, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Of course, just browse through my offers. If you buy a potion, don\'t forget that there\'s a {deposit} of 5 gold on the empty flask.')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
