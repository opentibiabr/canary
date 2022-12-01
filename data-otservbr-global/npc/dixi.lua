local internalNpcName = "Dixi"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 96,
	lookBody = 99,
	lookLegs = 76,
	lookFeet = 115,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = '<clears throat> Get your armor and shields heeeeeeere! Upstairs!', yell = true },
	{ text = 'Need some help? Just ask me, I can show you around!' },
	{ text = 'Don\'t forget to protect yourself with a shield!' },
	{ text = 'Selling the finest armors on Rookgaard!' },
	{ text = 'Don\'t let these mean monsters hurt you - get better equipment now!' }
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end


-- Greeting and Farewell
keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Good day, Ma\'am. How may I help you, |PLAYERNAME|? If you like to see my offers, simply ask me for a trade!'}, function(player) return player:getSex() == PLAYERSEX_FEMALE end)
keywordHandler:addAliasKeyword({'hello'})
keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Good day, Sir. How may I help you, |PLAYERNAME|? If you like to see my offers, simply ask me for a trade!'}, function(player) return player:getSex() == PLAYERSEX_FEMALE end)
keywordHandler:addAliasKeyword({'hello'})
keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Good bye, Ma\'am.'}, function(player) return player:getSex() == PLAYERSEX_FEMALE end)
keywordHandler:addAliasKeyword({'farewell'})
keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Good bye, Sir.'})
keywordHandler:addAliasKeyword({'farewell'})

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Dixi.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = '<giggles> I love gossiping - err, I mean providing valuable information of course, just tell me a name! <winks>'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m helping my grandfather {Obi} with this shop. If you like to see my offers, simply ask me for a {trade}!'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s |TIME|.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'You can deposit your {money} there to keep it safe. However, you still need cash to buy something here.'})
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'The Island of Destiny can be reached via the {oracle} once you are level 8. This trip will help you choose your {profession}!'})
keywordHandler:addKeyword({'profession'}, StdModule.say, {npcHandler = npcHandler, text = 'You will learn everything you need to know about professions once you reach the {Island of Destiny}.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'As a premium adventurer you can visit different regions on this island, trade with {Lee\'Delle} and much more.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'As an adventurer, you should always have at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'torch'}, StdModule.say, {npcHandler = npcHandler, text = 'If you need a torch, go see {Al Dee}\'s store.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I\'m sorry, but my grandfather {Obi} doesn\'t like seeing me waving around with pointy things. He sells weapons himself, just go downstairs!'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you hungry? Then you should visit {Willie} or {Billy} in the West of town. {Norma} also has yummy stuff! Oh, and you could pick {blueberries} or eat the food some {monsters} carry with them.'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = '{Lily} sells effective health potions and antidote potions against poison.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The big building in the centre of Rookgaard. They have a library, a training centre, a {bank} and the room of the {oracle}. {Seymore} is the teacher there.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'King Tibianus is a wise and noble monarch. This island of {Rookgaard} belongs to his kingdom.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Our lovely village will provide shelter for you. Once you are level 8, you can travel to {mainland} and choose a {profession}.'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'If you want to fight monsters in {dungeons}, you definitely need some good {equipment} such as a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to check out my offers.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to see what I buy from you.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'To view the offers of a merchant, simply talk to him or her and ask for a {trade}.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many blueberry bushes in and around this village. Just use them to your liking!'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'You need to make sure you have some basic {equipment} before you head into dungeons such as the {sewers}.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'There is a sewer grate which you can use to enter the sewers just left of this building. Eww, this smell!'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m fine, thank you.'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'How can I help you? I can give you general {hints}, information about {citizens} or talk about many other topics. Just ask me!'})
keywordHandler:addAliasKeyword({'information'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry honey, but I can\'t lend you gold. Earn it yourself by fighting {monsters} and picking up the things they carry. Sell it to {merchants} to make profit!'})
keywordHandler:addAliasKeyword({'gold'})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'You should never embark on an adventure without it. Ask {Al Dee} or {Lee\'Delle} for it!'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'fishing'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I can sell that to you. Just ask me for a {trade} to see what I buy from you.'})
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addAliasKeyword({'helmet'})

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = 'Me and my grandfather {Obi} sell {equipment} of all kinds. Just ask him or me for a {trade} if you like to see our offers.'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})

-- Names
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Norma used to sell {equipment}, but she finally earned enough {money} to fulfil one of her dreams - her own bar!'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'I never understand what he\'s talking about.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m glad that he\'s here. He does a great job!'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Sometimes, I help Zirella collecting wood. Her old back aches all the time. It\'s a shame her son Tom doesn\'t help her.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'In Al Dee\'s shop you will find important general equipment such as {ropes}, {shovels} and torches.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'One day, I want to become a brave adventurer like her and leave this town!'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'Billy can be kind of scary. He swears a lot and doesn\'t talk to everybody.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Uncle Willie and {Billy} are farmers, which means they are a good place to sell and buy {food}.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He can heal you if you\'re injured or poisoned.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'Did I hear my name somewhere?'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'I think he\'s a bit strange, living alone outside this village. How can he dislike to chat with everybody here?'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Lee\'Delle\'s shop is on the {premium} side of the village. You should visit it!'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'I always give my cookies and blueberries to Lily. She loves them! Also, she sells {potions}.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8 to find your {destiny}.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He is the local {bank} clerk.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is a loyal follower of the {king} and a teacher in the {academy}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'I wish he would talk to his mother {Zirella} again. I feel so sorry for her. Anyway, as Tom is a tanner, you can sell leather and fresh corpses to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s one of our reliable guardsmen. Without them, many {monsters} would roam the village of {Rookgaard}!'})
keywordHandler:addAliasKeyword({'zerbrus'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Um yeah, good day.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Here, take a look and choose something nice for you!')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "brass helmet", clientId = 3354, sell = 22 },
	{ itemName = "brass shield", clientId = 3411, sell = 25 },
	{ itemName = "chain armor", clientId = 3358, sell = 40 },
	{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 12 },
	{ itemName = "coat", clientId = 3562, buy = 8 },
	{ itemName = "copper shield", clientId = 3430, sell = 50 },
	{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
	{ itemName = "jacket", clientId = 3561, buy = 10 },
	{ itemName = "leather armor", clientId = 3361, buy = 25, sell = 5 },
	{ itemName = "leather boots", clientId = 3552, sell = 2 },
	{ itemName = "leather helmet", clientId = 3355, buy = 12, sell = 3 },
	{ itemName = "leather legs", clientId = 3559, buy = 10, sell = 2 },
	{ itemName = "legion helmet", clientId = 3374, sell = 22 },
	{ itemName = "plate shield", clientId = 3410, sell = 40 },
	{ itemName = "studded armor", clientId = 3378, sell = 10 },
	{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
	{ itemName = "studded legs", clientId = 3362, sell = 15 },
	{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
	{ itemName = "viking helmet", clientId = 3367, sell = 25 },
	{ itemName = "wooden shield", clientId = 3412, buy = 15 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
