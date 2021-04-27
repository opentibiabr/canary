local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
npcHandler.rats = {}
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
	{ text = 'Newcomers - visit me! I\'ll answer your questions!' },
	{ text = 'Get some training in the academy!' },
	{ text = 'Feeling lost? Ask me for help!' },
	{ text = 'Gain some knowledge in the academy!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Greeting and Farewell
local hiKeyword = keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Hello, |PLAYERNAME|. Welcome to the Academy of Rookgaard. May I sign you up as a {student}?'})
	hiKeyword:addChildKeyword({'student'}, StdModule.say, {npcHandler = npcHandler, text = 'Brilliant! We need fine adventurers like you! If you are ready to learn, just ask me for a lesson. You can always ask for the differently coloured words - such as this one - to continue the lesson.', reset = true})
	hiKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Brilliant! We need fine adventurers like you! If you are ready to learn, just ask me for a lesson. You can always ask for the differently coloured words - such as this one - to continue the lesson.', reset = true})
	hiKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Only nonsense on your mind, eh?', reset = true})
keywordHandler:addAliasKeyword({'hello'})

keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Good bye, |PLAYERNAME|! And remember: No running up and down in the academy!'})
keywordHandler:addAliasKeyword({'farewell'})

-- Rats
local ratsKeyword = keywordHandler:addKeyword({'%d+', 'dead', 'rat'}, StdModule.say, {npcHandler = npcHandler},
	function(player, data) npcHandler.rats[player.uid] = data[1] return data[1] and data[1] > 0 and data[1] < 0xFFFFFFFF end,
	function(player)
		npcHandler:say(string.format('Have you brought %d dead rats to me to pick up your reward?', npcHandler.rats[player.uid]), player.uid)
	end)
	ratsKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you! Here is your reward.', reset = true},
		function(player) return player:getItemCount(2813) >= npcHandler.rats[player.uid] end,
		function(player) player:removeItem(2813, npcHandler.rats[player.uid]) player:addMoney(2 * npcHandler.rats[player.uid]) end
	)
	ratsKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'HEY! You don\'t have so many!', reset = true})
	ratsKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Go and find some rats to kill!', reset = true})

local ratKeyword = keywordHandler:addKeyword({'dead', 'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Have you brought a dead rat to me to pick up your reward?'})
	ratKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank you! Here is your reward.', reset = true},
		function(player) return player:getItemCount(2813) > 0 end,
		function(player) player:removeItem(2813, 1) player:addMoney(2) end
	)
	ratKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'HEY! You don\'t have one! Stop playing tricks on me or I\'ll give you some extra work!', reset = true})
	ratKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Go and find some rats to kill!', reset = true})

-- Quest
local boxKeyword = keywordHandler:addKeyword({'box'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you have a suitable present box for me?'})
	boxKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'THANK YOU! Here is a helmet that will serve you well.', reset = true},
		function(player) return player:getItemCount(1990) > 0 end,
		function(player) player:removeItem(1990, 1) player:addItem(2480, 1) end
	)
	boxKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'HEY! You don\'t have one! Stop playing tricks on me or I\'ll give you some extra work!', reset = true})

keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, I would like to send our king a little present but I do not have a suitable box. If you find a nice box, please bring it to me.'},
	function(player) return player:getLevel() >= 4 end)
keywordHandler:addAliasKeyword({'quest'})
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = 'You are pretty inexperienced. I think killing rats is a suitable challenge for you. For each fresh {dead rat} I will give you two shiny coins of gold.'})
keywordHandler:addAliasKeyword({'quest'})

keywordHandler:addKeyword({'fuck'}, StdModule.say, {npcHandler = npcHandler, text = 'For this remark I will wash your mouth with soap, young lady!'},
	function(player) return player:getSex() == PLAYERSEX_FEMALE end,
	function(player) player:getPosition():sendMagicEffect(CONST_ME_YELLOW_RINGS) end)
keywordHandler:addKeyword({'fuck'}, StdModule.say, {npcHandler = npcHandler, text = 'For this remark I will wash your mouth with soap, young man!'}, nil,
	function(player) player:getPosition():sendMagicEffect(CONST_ME_YELLOW_RINGS) end)

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'island', 'of', 'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'This is an island with {vocation} teachers. You can learn all about the different vocations there once you are level 8.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s |TIME|, so you are late. Hurry!'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Seymour, but for you I am \'Sir\' Seymour.'})
keywordHandler:addKeyword({'sir'}, StdModule.say, {npcHandler = npcHandler, text = 'At least you know how to address a man of my importance.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the master of this fine {academy}, giving {lessons} to my students.'})
keywordHandler:addKeyword({'lesson'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, which lesson did you want to attend again? Was it {Rookgaard}, {fighting}, {equipment}, {citizens}, the {academy} or the {oracle}?'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'In a bank you can deposit your earned gold coins safely. Just go downstairs to {Paulie} and ask him to {deposit} your money.'})
keywordHandler:addKeyword({'deposit'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, depositing your money will keep it safe, so it is a good idea to store it in the bank. Of course, you can always withdraw it again.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, the {king} doesn\'t send troops anymore, the {academy} is dreadfully low on money, and the end of the world is pretty nigh. Apart from that I\'m reasonably fine, I suppose.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'Most of the citizens here are {merchants}. You can give me the name of any non-player character and I will tell you something about him or her.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'Merchants buy and sell goods. Just ask them for a {trade} to see what they offer or buy from you.'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Trolls are quite nasty monsters which you shouldn\'t face before level 3 or 4 depending on your {equipment}. Ask the bridge {guards} for their locations!'})
keywordHandler:addKeyword({'guard'}, StdModule.say, {npcHandler = npcHandler, text = 'The guards {Dallheim} and {Zerbrus} protect our village from {monsters} trying to enter. They also mark useful {dungeon} locations on your map.'})
keywordHandler:addKeyword({'vocation'}, StdModule.say, {npcHandler = npcHandler, text = 'There are four vocations: {knights}, {paladins}, {sorcerers} and {druids}. You can choose your vocation once you are level 8 and have talked to the {oracle}.'})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorcerers are talented elemental magicians. You will learn all about them once you are level 8 and reached the Island of {Destiny}.'})
keywordHandler:addKeyword({'knight'}, StdModule.say, {npcHandler = npcHandler, text = 'Knights are strong melee fighters. You will learn all about them once you are level 8 and reached the Island of {Destiny}.'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'Druids are nature magic users and great healers. You will learn all about them once you are level 8 and reached the Island of {Destiny}.'})
keywordHandler:addKeyword({'paladin'}, StdModule.say, {npcHandler = npcHandler, text = 'Paladins are swift distance fighters. You will learn all about them once you are level 8 and reached the Island of {Destiny}.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'We have a {weapon} and an {armor} shop south of the academy. {Equipment} such as {ropes} are sold to the north-west. {Potions} can be bought to the south. And then there are the {farms}.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'The world of Tibia is very large with tons of places to explore. Vast deserts, Caribbean islands, deep jungles, green meadows and jagged mountains await you!'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is the place to go when you are very low on {health} or poisoned. Ask {Cipfried} for a heal - he usually notices emergencies by himself.'})
keywordHandler:addKeyword({'health'}, StdModule.say, {npcHandler = npcHandler, text = 'Your current health is shown by the red bar on the right side. {Death} awaits you if it goes down to zero.'})
keywordHandler:addKeyword({'death'}, StdModule.say, {npcHandler = npcHandler, text = 'Dying in Tibia is painful, so try to avoid it. You will lose part of your {experience} points and also equipment. Make sure your {health} always stays up!'})
keywordHandler:addKeyword({'experience'}, StdModule.say, {npcHandler = npcHandler, text = 'You gain experience when fighting {monsters}. You can take a look at your skill window to check your progress.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Good monsters to start hunting are {rats}. They live in the {sewers} below the village.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'One entrance to the sewers is south of this {academy}. Look for a sewer grate, then use it to climb down.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'The academy is the building you are standing in. We have a {library}, a {bank} and the room of the {oracle}.'})
keywordHandler:addKeyword({'library'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many books in the bookcases around you, unless some naughty kids stole them again. Read them for more and detailed information.'})
keywordHandler:addKeyword({'equip'}, StdModule.say, {npcHandler = npcHandler, text = 'Don\'t go hunting without proper equipment. You need at least a suitable {weapon}, {armor}, {shield}, {rope} and {shovel}. A {torch} is also good as well as {legs}, a {helmet} and {shoes}.'})
keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'Make money by killing {monsters} and picking up their {loot}. You can sell many of the things they carry.'})
keywordHandler:addKeyword({'loot'}, StdModule.say, {npcHandler = npcHandler, text = 'Once a monster is dead, you can select \'Open\' on the {corpse} to check what\'s inside. Sometimes they carry {money} or other items which you can sell to {merchants}.'})
keywordHandler:addKeyword({'corpse'}, StdModule.say, {npcHandler = npcHandler, text = 'You can even sell some corpses! For example, you can sell fresh dead rats to {Tom} the tanner or me. He also buys other dead creatures, just ask him for a {trade}.'})
keywordHandler:addKeyword({'rope'}, StdModule.say, {npcHandler = npcHandler, text = 'You definitely need a rope to progress in dungeons, else you might end up stuck. Buy one from {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addKeyword({'shovel'}, StdModule.say, {npcHandler = npcHandler, text = 'A shovel is needed to dig some {dungeon} entrances open. \'Use\' it on a loose stone pile to make a hole large enough to enter.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'You should not descend into dungeons without proper {equipment}. Once you are all prepared, ask the bridge {guards} for suitable {monsters}.'})
keywordHandler:addKeyword({'torch'}, StdModule.say, {npcHandler = npcHandler, text = 'A torch will provide you with light in dark {dungeons}. \'Use\' it to light it. You can buy them from {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addKeyword({'student'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, I could give you valuable {lessons} or some general {hints} about the game, or a small {quest} if you\'re interested.'})
keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'The starter armor, a coat, does not protect you well. First of all, earn some money and try to get a sturdy leather armor from {Dixi}\'s  or {Lee\'Delle}\'s shop. Simply ask for a {trade}.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'The starter weapon, a club, won\'t get you far. You should earn some {money} and buy a better weapon such as a sabre from {Obi}\'s or {Lee\'Delle}\'s shop. Simply ask for a {trade}.'})
keywordHandler:addKeyword({'helmet'}, StdModule.say, {npcHandler = npcHandler, text = 'A sturdy leather helmet is a good choice for a beginner. You can either buy it from {Dixi} and {Lee\'Delle}, or, once you are strong enough, {loot} them from {trolls}.'})
keywordHandler:addKeyword({'shield'}, StdModule.say, {npcHandler = npcHandler, text = 'I fear you have to buy your first shield by yourself. A wooden shield from {Dixi} or {Lee\'Delle} is a good choice.'})
keywordHandler:addKeyword({'shoe'}, StdModule.say, {npcHandler = npcHandler, text = 'Leather boots are basic shoes which will protect you well. You can either buy them from {Dixi} and {Lee\'Delle}, or, once you are strong enough, {loot} them from {trolls}.'})
keywordHandler:addKeyword({'leg'}, StdModule.say, {npcHandler = npcHandler, text = 'Leather legs might be a good basic protection. You can buy them from {Dixi} or {Lee\'Delle}. Or, once you are strong enough, hunt {trolls}. They sometimes carry them in their {loot}.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Many monsters, such as rabbits or deer, are excellent food providers. You can also buy food from {Willie} or {Billy}, the farmers.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Paying for your Tibia account will turn it into a premium account. This means access to more areas and functions of the game as well as other neat features.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Hail to King Tibianus! Long live our king! Not that he cares for an old veteran who is stuck on this godforsaken island...'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'Use a small health potion in case of emergencies to fill up around 75 health points. You can buy them at {Lily}\'s shop. She also has {antidote} potions.'})
keywordHandler:addKeyword({'antidote'}, StdModule.say, {npcHandler = npcHandler, text = 'Some monsters poison you. To heal poison, use an antidote potion on yourself. Buy them at {Lily}\'s store.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Rookgaard is the name of this {village} as well as of the whole {island}. It belongs to the kingdom of {Thais}, in our world which is called {Tibia}.'})
keywordHandler:addKeyword({'island'}, StdModule.say, {npcHandler = npcHandler, text = 'The island is separated into a {premium} side and a non-premium side. On both sides you will find {dungeons}, but the premium side tends to be a little less crowded with other players.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'The city of Thais is reigned by King Tibianus. Of course, there are many other cities but you will learn about them later.'})
keywordHandler:addKeyword({'village'}, StdModule.say, {npcHandler = npcHandler, text = 'The most important places in this village are the {temple}, the different {shops}, the {academy} and the {bridges}.'})
keywordHandler:addKeyword({'bridge'}, StdModule.say, {npcHandler = npcHandler, text = 'There is a bridge to the north and one to the west which lead outside the village. You should only leave once you are well {equipped} and at least level 2.'})
keywordHandler:addKeyword({'main'}, StdModule.say, {npcHandler = npcHandler, text = 'You can leave for mainland once you are level 8. To do so talk to the {oracle}.'})
keywordHandler:addKeyword({'fighting'}, StdModule.say, {npcHandler = npcHandler, text = 'You have to fight {monsters} to train your {skills} and {level}. If you lose {health}, eat {food} to regain it or use a {potion}.'})
keywordHandler:addKeyword({'skill'}, StdModule.say, {npcHandler = npcHandler, text = 'The more you fight with a weapon, the better will be your skill handling this weapon. Don\'t worry about that right now though, this will become important once you have a {vocation}.'})
keywordHandler:addKeyword({'level'}, StdModule.say, {npcHandler = npcHandler, text = 'Once you gained enough experience for a level, you will advance. This means - among other things - more {health} points, a faster walking speed and more strength to carry things.'})
keywordHandler:addKeyword({'farm'}, StdModule.say, {npcHandler = npcHandler, text = 'The farms are west of here. You can buy and sell {food} there which you need to regain {health}.'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'To attack a rat, simply click on it in your battle list. Make sure that you have proper {equipment}, though! Also, I give you 2 gold coins for each {dead rat}.'})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = 'I personally don\'t have anything to trade, but you can ask {merchants} for a trade. That will open a window where you can see their offers and the things they buy from you.'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, I could give you valuable {lessons} or some general {hints} about the game, or a small {quest} if you\'re interested.'})
keywordHandler:addAliasKeyword({'information'})

local destinyKeyword = keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Shall I try and take a guess at your destiny?'}, function(player) return player:getStorageValue(Storage.RookgaardDestiny) == -1 end)
destinyKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, reset = true}, nil,
	function(player)
		local destiny = math.random(1, 4)
		if destiny == 1 then
			npcHandler:say('Hmmm, let me look at you. You got that intelligent sparkle in your eyes and you\'d love to handle great power - that must be a future sorcerer!', player.uid)
		elseif destiny == 2 then
			npcHandler:say('Hmmm, let me look at you. You have an aura of great wisdom and may have healing hands as well as a sense for the powers of nature - I think you\'re a natural born druid!', player.uid)
		elseif destiny == 3 then
			npcHandler:say('Hmmm, let me look at you. <missing message, destiny for paladin>!', player.uid)
		elseif destiny == 4 then
			npcHandler:say('Hmmm, let me look at you. Strong and sturdy, with a determined look in your eyes - no doubt the knight profession would be suited for you!', player.uid)
		end
		player:setStorageValue(Storage.RookgaardDestiny, destiny)
	end
)

keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, like I told you before, I really think you got that spirit of a sorcerer in you. But of course it\'s completely up to you!'}, function(player) return player:getStorageValue(Storage.RookgaardDestiny) == 1 end)
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, like I told you before, I really think you got that spirit of a druid in you. But of course it\'s completely up to you!'}, function(player) return player:getStorageValue(Storage.RookgaardDestiny) == 2 end)
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, like I told you before, I really think you got that spirit of a paladin in you. But of course it\'s completely up to you!'}, function(player) return player:getStorageValue(Storage.RookgaardDestiny) == 3 end)
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, like I told you before, I really think you got that spirit of a knight in you. But of course it\'s completely up to you!'}, function(player) return player:getStorageValue(Storage.RookgaardDestiny) == 4 end)

-- Names
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'Obi sells and buys {weapons}. You can find his shop south of the academy.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Norma has recently opened a bar here meaning she sells drinks and snacks. Nothing of importance to you, young student.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Oh, let\'s not talk about Loui.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'A fine and helpful man. Without him, many new adventurers would be quite clueless.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'This is Tom the tanner\'s mother. Other than that, I don\'t think she is of importance.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Al Dee has a general {equipment} store in the north-western part of the village. He sells useful stuff such as {ropes}.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'A traveller from the {main} continent. I wonder what brought her here. No one comes here of his own free will.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'Billy is {Willie}\'s cousin, but he has his farm on the {premium} side of the village.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Willie is a fine farmer, although he is short-tempered. He sells and buys {food}.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'A humble monk living in the {temple} south of here. He can heal you if you are wounded or poisoned.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'Dixi sells and buys {armors}, {shields}, {helmets} and {legs}. You can find her shop south of the academy, just go up the stairs in {Obi}\'s shop.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'A mysterious druid who lives somewhere in the wilderness. He sells small health {potions} just like {Lily}.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Lee\'Delle\'s shop is in the western part of town, on the {premium} side. She sells everything cheaper.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'In the southern part of town, Lily sells {potions} which might come in handy once you are deep in a dungeon and need {health}.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'The oracle is a mysterious being just upstairs. It will bring you to the {Island of Destiny} to choose your {vocation} once you are level 8.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, Paulie is very important. He is the local {bank} clerk.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Sir Seymour, yes, that\'s me.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Tom the tanner buys fresh {corpses}, minotaur leather and paws. Always good to make some {money} if you can carry the corpses there fast enough.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the guard on the north {bridge} and a great fighter. He can show you {monster} locations. Just ask him about monsters!'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the guard on the west {bridge} and a great fighter. He can show you {monster} locations. Just ask him about monsters!'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye! And remember: No running up and down in the academy!')

npcHandler:addModule(FocusModule:new())
