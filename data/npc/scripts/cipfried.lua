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
	{ text = 'Feeling lost, my child? Ask me for hints or help!' },
	{ text = 'Come to me if you need healing!' },
	{ text = 'Welcome to the temple of Rookgaard!' },
	{ text = 'Don\'t despair! Help is near!' }
}
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	local health = player:getHealth()
	local lowHealth = health < 65
	local poisoned = player:getCondition(CONDITION_POISON)
	if lowHealth or poisoned then
		npcHandler:setMessage(MESSAGE_GREET, 'Hello, |PLAYERNAME|! You are looking really bad. Let me heal your wounds. It\'s my job after all.')
		if lowHealth then player:addHealth(65 - health) end
		if poisoned then player:removeCondition(CONDITION_POISON) end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Hello, |PLAYERNAME|! I\'ll {heal} you if you are injured or poisoned. Feel free to ask me for {help} or general {hints}.')
	end
	return true
end

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Cipfried.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Me? Oh, I\'m just a humble {monk}. Ask me if you need {help} or {healing}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Now it is |TIME|, my child.'})
keywordHandler:addKeyword({'monk'}, StdModule.say, {npcHandler = npcHandler, text = 'I have sacrificed my life to serve the good gods of {Tibia} and to help newcomers in this world.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'You can deposit your money at the bank. That way you won\'t lose it if you get {killed}. The bank is just under the academy and to the right.'})
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Your near destiny will be to choose a {vocation} once you are level 8. Whether you will become a {knight}, {sorcerer}, {paladin} or {druid} is a big decision!'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s where we are - the world of Tibia, in a village called {Rookgaard}, to be precise, with many {monsters}, {quests} and {citizens} around.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'How can I help you? I can tell you about specific {citizens} if you tell me their name. I can also give you general {hints} about {Tibia}. '})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'Only a few people live in our village, most of them are {merchants}. You can either ask them for a {trade} or about various other topics, like the names of other citizens, their {job} or Tibia in general.'})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t have any goods for trade, but if you ask one of the {merchants}, he or she will gladly show you what you can buy or sell.'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'A single rat doesn\'t pose a grave danger to you, but be careful not to get cornered by many of them. They could still {kill} you.'})
keywordHandler:addKeyword({'spider'}, StdModule.say, {npcHandler = npcHandler, text = 'If you face spiders, beware of the {poisonous} ones. If you are poisoned, you will constantly lose health. Come to me and I\'ll heal you from poison.'})
keywordHandler:addKeyword({'kill'}, StdModule.say, {npcHandler = npcHandler, text = 'If you get killed, you will revive in this temple. However, you will lose experience and also equipment, which can be quite painful. Take good care of yourself!'})
keywordHandler:addKeyword({'poison'}, StdModule.say, {npcHandler = npcHandler, text = 'Poison is very dangerous! Don\'t ever drink green liquids, they are poisonous and will make you lose health!'})
keywordHandler:addKeyword({'vocation'}, StdModule.say, {npcHandler = npcHandler, text = 'There are four vocations in Tibia: {knight}, {sorcerer}, {paladin} or {druid}. Each vocation has its unique special abilities.'})
keywordHandler:addKeyword({'knight'}, StdModule.say, {npcHandler = npcHandler, text = 'Knights are close combat fighters. They usually wield melee weapons such as swords, axes or clubs.'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'Druids are nature magicians. Their speciality is casting ice and earth magic, as well as providing healing for others.'})
keywordHandler:addKeyword({'paladin'}, StdModule.say, {npcHandler = npcHandler, text = 'Paladins are well-trained distance fighters and can cast holy magic. You will usually see them wearing bows or crossbows.'})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorcerers are elemental magicians. They have mastered fire, energy and death magic.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy and sell goods from merchants. To do so, simply talk to them and ask them for a {trade}. They will gladly show you their offers and also the things they buy from you.'})
keywordHandler:addKeyword({'equip'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy equipment from the {merchants} in this village once you earned some {gold}. Some {monsters} also carry equipment pieces with them.'})
keywordHandler:addKeyword({'shovel'}, StdModule.say, {npcHandler = npcHandler, text = 'Shovels are very useful. There may be a hidden entrance under a loose pile of stone and without a shovel, how would you know?'})
keywordHandler:addKeyword({'rope'}, StdModule.say, {npcHandler = npcHandler, text = 'Never go adventuring without a rope! If you don\'t have one when you fall through a hole in the ground, you won\'t be able to leave without a rope.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'To defend yourself against enemies, you will need a weapon. You can purchase weapons at {Obi}\'s shop.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Food is very important for your health. If you are hurt in a fight with a {monster}, select \'Use\' on food such as cheese, ham or meat to eat it. This will slowly refill your health.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'As a premium adventurer, you are an official tax payer and thus privileged in many ways. For example, you can travel by {ship} and get better deals from {merchants}.'})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = {'Ships are a comfortable way of travelling to distant cities. At any harbour, you can board the ship and ask its captain where he sails to.', 'Travelling by ship will cost you some gold, though, so be sure to have money with you.'}})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'Potions will come in handy once you are in a fight deep in a dungeon. If you aren\'t in immediate danger, you can simply eat {food} to regain health, though.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The academy is just north of here. You can learn helpful things there from {Seymour}, if you wish to!'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, King Tibianus of course. The island of {Rookgaard} belongs to his kingdom.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'The {gods} have chosen this isle as the point of arrival for newborn souls. The {citizens} will help you if you ask them.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'They created {Tibia} and all life on it. Visit our {academy} and learn about them.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Monsters are a constant threat to this village. You would tremendously help us by fighting them, starting with {rats} in the {sewers}, then turning to {spiders} or {wolves}.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy and sell goods from merchants. To do so, simply talk to them and ask them for a {trade}. They will gladly show you their offers and also the things they buy from you.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'The sewers are right below this village. North of this temple, you find a sewer grate which leads down, but there are also many small huts in the village which are connected to the sewers.'})

keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but I\'m not interested in worldly goods. If you want to buy or sell something, you should ask a local merchant for a trade.'})
keywordHandler:addAliasKeyword({'sell'})

keywordHandler:addKeyword({'shield'}, StdModule.say, {npcHandler = npcHandler, text = 'To defend yourself against enemies, you will need armor and shields. You can purchase both at {Dixi}\'s shop.'})
keywordHandler:addAliasKeyword({'armor'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'You can earn a fair amount of gold by fighting {monsters} and picking up the things they carry. Many {citizens} are buying some of that loot, simply ask around.'})
keywordHandler:addAliasKeyword({'gold'})

keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, I can handle my tasks myself, thank you. If you are looking for something to do, you should listen to the local {citizens} and ask them for {quests}. You could also help us fight {monsters}.'})
keywordHandler:addAliasKeyword({'mission'})

keywordHandler:addKeyword({'wolf'}, StdModule.say, {npcHandler = npcHandler, text = 'Wolves can only be found outside of the village. If you want to know where their dens are, best talk to {Dallheim} or {Zerbrus} at the bridges.'})
keywordHandler:addAliasKeyword({'wolves'})

keywordHandler:addKeyword({'adventure'}, StdModule.say, {npcHandler = npcHandler, text = 'I can see a bright future for you... you will soon embark on a very big adventure and explore the world of {Tibia} - maybe even influence history!'})
keywordHandler:addAliasKeyword({'explore'})

keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You are poisoned. I will help you.'},
	function(player) return player:getCondition(CONDITION_POISON) end,
	function(player)
		local health = player:getHealth()
		if health < 65 then player:addHealth(65 - health) end
		player:removeCondition(CONDITION_POISON)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'Let me heal your wounds.'},
	function(player) return player:getHealth() < 185 and player:getHealth() < player:getBaseMaxHealth() end,
	function(player)
		local health = player:getHealth()
		player:addHealth(185 - health)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You aren\'t looking really bad, |PLAYERNAME|. I can only help in cases of real emergencies. Raise your health simply by eating {food}.'})

-- Names
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'Obi\'s {shop} is to the north-east of this humble temple. He sells {weapons}, and his granddaughter {Dixi} sells {armor} and {shields} upstairs.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'She recently opened a little bar north of this village.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s a sad story. He used to help me guard this temple, but for some reason he went out of his mind.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'I absolutely appreciate what he\'s doing. He has helped me a lot since he took up the job of welcoming newcomers to this island.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'That old lady hasn\'t had an easy life. Her son {Tom} completely abandoned her, but I have no idea why.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'In Al Dee\'s shop you\'ll find important general equipment such as {ropes}, {shovels} and torches.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Amber is such a lovely girl, and also a very experienced {explorer} and {adventurer}. It\'s always interesting to chat with her.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a farmer, just like his cousin {Willie}. He doesn\'t talk to everybody, though.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Willie is a farmer, just like his cousin {Billy}. His farm is located left of the temple. You can buy and sell {food} there.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes? How can I {help} you?'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s {Obi\'s} granddaughter. Her counter is just upstairs from Obi\'s shop. She helps him by selling {armor} and {shields}.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Hyacinth is a close friend of mine. He left the village many years ago to live in solitude. I think all this bustle here simply was too much for him.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Lee\'Delle\'s shop is on the {premium} side of the village. You should visit her!'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'You must have passed the house of Lily on your way here. She sells {potions}. If you pick blueberries or find cookies, she\'ll buy them from you.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8 to find your {destiny}.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'He is the {bank} clerk, making sure your {money} remains safe.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour is a loyal follower of the {king} and a teacher in the {academy}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Tom is the main provider for leather armor in this village. You can sell fresh corpses or even minotaur leather to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'May the gods bless our loyal guardsmen! Day and night they stand watch on our bridges, ensuring that it is not passed by dangerous {monsters}!'})
keywordHandler:addAliasKeyword({'zerbrus'})

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, |PLAYERNAME|!')
npcHandler:addModule(FocusModule:new())
