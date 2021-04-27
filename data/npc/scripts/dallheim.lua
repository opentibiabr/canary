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
	{ text = 'The most dangerous monsters of Rookgaard are on the other side of this bridge.' },
	{ text = 'Want to know what monsters are good for you at your level? Just ask me!' },
	{ text = 'I\'ll crush all monsters who dare to attack our base.' },
	{ text = 'Are you injured or poisoned? I can help you.' },
	{ text = 'For Rookgaard! For Tibia!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Greeting and Farewell
keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = 'Greetings, |PLAYERNAME|! You\'re looking really bad. Let me heal your wounds.'},
	function(player) return player:getHealth() < 65 or player:getCondition(CONDITION_POISON) ~= nil end,
	function(player)
		local health = player:getHealth()
		if health < 65 then player:addHealth(65 - health) end
		player:removeCondition(CONDITION_POISON)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
)
keywordHandler:addAliasKeyword({'hello'})

keywordHandler:addGreetKeyword({'hi'}, {npcHandler = npcHandler, text = '<nods> At your service, |PLAYERNAME|, protecting the {village} from {monsters}.'}, function(player) return player:getSex() == PLAYERSEX_FEMALE end)
keywordHandler:addAliasKeyword({'hello'})

keywordHandler:addFarewellKeyword({'bye'}, {npcHandler = npcHandler, text = 'Bye, |PLAYERNAME|.'})
keywordHandler:addAliasKeyword({'farewell'})

local function addMonsterKeyword(level, text, marks)
	local keyword = keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = text},
		function(player) return player:getLevel() >= level end,
		function(player)
			if marks then
				for i = 1, #marks do
					player:addMapMark(marks[i].position, marks[i].type, marks[i].description)
				end
			end
		end
	)
end

-- Monster
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Hmm, |PLAYERNAME|. I really don\'t know if you should go into the wilderness without a shield. You should earn some money by hunting rats under the village first until you can afford at least a wooden shield.'}, function(player) return not player:hasRookgaardShield() end)

addMonsterKeyword(10, 'It looks like you have mastered the drill.')
addMonsterKeyword(8, 'It looks like you have mastered the drill. Talk to the {oracle} to travel to other places and start getting some real battle experience.')
addMonsterKeyword(7, 'You are almost strong enough to leave this island. If you\'d like to go somewhere new, why don\'t you try skeletons? I\'ll mark a cave on your map, but be careful, there are lots of other creatures on the way.',
	{{position = Position(31972, 32130, 7), type = MAPMARK_GREENSOUTH, description = 'Skeleton Cave'}}
)
addMonsterKeyword(6, 'Nice job out there, |PLAYERNAME|. Have you already explored the whole North Ruin? If you are courageous enough, you could test your skills on wasps. But be careful, they are fast and poisonous! I\'ll mark them for you.',
	{{position = Position(32000, 32139, 7), type = MAPMARK_GREENNORTH, description = 'Wasps\' Nest'}, {position = Position(32000, 32137, 6), type = MAPMARK_GREENNORTH, description = 'Wasp Hive'}}
)
addMonsterKeyword(5, 'Are you already tired of the North Ruin? You could try some bears, but be careful, they hit hard. I\'ll mark a cave on your map.',
	{{position = Position(32146, 32207, 7), type = MAPMARK_GREENSOUTH, description = 'Bear Cave'}}
)
addMonsterKeyword(4, 'You\'re halfway on leaving this island. I guess you might be ready for some stronger monsters such as {trolls} or {orcs}. Check out the North Ruin which I\'ll mark on your map right now, but don\'t go too deep.',
	{{position = Position(32094, 32137, 7), type = MAPMARK_GREENSOUTH, description = 'North Ruin'}}
)
addMonsterKeyword(3, 'Well, you can still stay with {spiders} or {snakes}, but maybe you\'d like to try fighting a {bug} or even a {wolf}? I\'ll mark a den that I know on your map right now. Don\'t forget torch and rope!',
	{{position = Position(32155, 32122, 7), type = MAPMARK_GREENSOUTH, description = 'Wolf Den'}}
)
addMonsterKeyword(2, 'You still look a little wimpy. If you want to kill something other than {rats}, you may leave town to hunt {spiders} or {snakes}. I\'ll mark some spawns on your map right now. Don\'t forget torch and rope!',
	{{position = Position(32027, 32171, 7), type = MAPMARK_GREENSOUTH, description = 'Snake Swamp'}, {position = Position(31967, 32169, 7), type = MAPMARK_GREENSOUTH, description = 'Spiderweb Hole'}}
)
addMonsterKeyword(1, 'You are much too young and inexperienced to cross the bridge. Stay in the sewers. I\'ll mark an entrance on your map right now.',
	{{position = Position(32097, 32205, 7), type = MAPMARK_GREENSOUTH, description = 'Sewer Entrance'}}
)

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Dallheim, at your service.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the guard of this bridge. I defend Rookgaard against the beasts of the {wilderness} and the {dungeons}, and even of the stinking {sewers}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'My duty is eternal. Time is of no importance.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Before you fight monsters, deposit your money there. If you die, you won\'t lose it if it\'s save in the bank.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Fine.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'I have to stay here, sorry. But I can heal you if you are wounded. I have also valuable information about {monsters}.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m an expert concerning the wildlife and {monsters} on this island.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'ll protect all citizens alike. That is my {job} and duty.'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Did you know that rats are among the most dangerous animals in whole Tibia? Each day, they kill many people who are overestimating their powers. Don\'t be one of them!'})
keywordHandler:addKeyword({'spider'}, StdModule.say, {npcHandler = npcHandler, text = 'There are two types of spiders on this island: normal spiders and poison spiders. As their name says, the latter ones can poison you which will cause a constant loss of your health. Beware of them!'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Once you have upgraded your starter {equipment} a little - maybe leather stuff - and got a better weapon as well as a shield, you should be able to kill trolls.'})
keywordHandler:addKeyword({'wolf'}, StdModule.say, {npcHandler = npcHandler, text = 'You need a stronger weapon than the starter club to kill wolves. Maybe a {sabre} or a short {sword} will do.'})
keywordHandler:addAliasKeyword({'wolves'})
keywordHandler:addKeyword({'orc'}, StdModule.say, {npcHandler = npcHandler, text = 'Orcs are a constant menace. There are even stronger species of orcs on the main continent.'})
keywordHandler:addKeyword({'minotaur'}, StdModule.say, {npcHandler = npcHandler, text = 'Minotaurs are very strong. You will need a group of people or at least level 6 and good equipment to be able to kill them.'})
keywordHandler:addKeyword({'bug'}, StdModule.say, {npcHandler = npcHandler, text = 'They are a little tougher than they look like, but they\'re still good beginner monsters.'})
keywordHandler:addKeyword({'skeleton'}, StdModule.say, {npcHandler = npcHandler, text = 'The skeletons on this island are usually fairly hidden. They are often found near graves and always underground. Beware of their evil life drain.'})
keywordHandler:addKeyword({'bear'}, StdModule.say, {npcHandler = npcHandler, text = 'A bear can easily kill you if you don\'t pay attention.'})
keywordHandler:addKeyword({'wasp'}, StdModule.say, {npcHandler = npcHandler, text = 'Wasps are the fastest monsters on this island and they poison you. If you ever run into one and are already low of health, fear for your life!'})
keywordHandler:addKeyword({'snake'}, StdModule.say, {npcHandler = npcHandler, text = 'Snakes can poison you, too, but their poison is usually not as dangerous as that of poison spiders. Just be careful and kill them fast.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Premium warriors pay. They gain many advantages this way.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'HAIL TO THE KING!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'All that theory won\'t help you without some real battle practice.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'A place of protection. Nothing can harm you there.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'I can mark you some dungeons on your map if you ask me about {monsters} suited for your level.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'The sewers are crowded with {rats}. They make fine targets for young heroes.'})
keywordHandler:addKeyword({'wilderness'}, StdModule.say, {npcHandler = npcHandler, text = 'There are {wolves}, {bears}, {snakes}, {deer}, and {spiders} in the wilderness past this bridge.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a follower of {Banor}.'})
keywordHandler:addKeyword({'banor'}, StdModule.say, {npcHandler = npcHandler, text = 'The heavenly warrior! Hail to him!'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not interested in such party tricks.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'A nice place for a hero, but nothing for whelps.'})

keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s my duty to protect this village and its {citizens}.'})
keywordHandler:addAliasKeyword({'village'})

keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'It looks like you have mastered the drill.'})

keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t trade. Ask the shop owners for a trade instead.'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'sell'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'sword'})
keywordHandler:addAliasKeyword({'sabre'})
keywordHandler:addAliasKeyword({'equip'})
keywordHandler:addAliasKeyword({'weapon'})
keywordHandler:addAliasKeyword({'armor'})
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addAliasKeyword({'food'})
keywordHandler:addAliasKeyword({'potion'})

-- Names
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t approve of her opening a bar. Those drunken adventurers stumbling over the bridge at nighttime are not especially helpful in improving the situation.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Zerbrus tells me such strange stories about him. Well, he sees him all day from the west bridge.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He dedicated his life to welcoming newcomers to this island.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Nice old lady.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'He has been on this island as long as me.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t trust her.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He guards the temple and can heal you if you are badly injured or poisoned, just like me.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi\'s} granddaughter and deals with {armors} and {shields}. Her shop is south west of town, close to the temple.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Strange fellow, hides somewhere in the mountains of the isle.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her shop is on the {premium} side of town. Best offers around.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Sometimes I wish I had an easy job like her, selling {potions} all day.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above Seymour. Go there when you are level 8.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'The local bank clerk.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Leave me alone with this wimp.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'At your service.'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s guarding the west bridge. Not that a real threat would lurk on the other side.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He is a fine cook and farmer. He buys and sells {food}.'})
keywordHandler:addAliasKeyword({'willie'})

-- Healing
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You are poisoned. I will help you.'},
	function(player) return player:getCondition(CONDITION_POISON) ~= nil end,
	function(player)
		local health = player:getHealth()
		if health < 65 then player:addHealth(65 - health) end
		player:removeCondition(CONDITION_POISON)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You are looking really bad. Let me heal your wounds.'},
	function(player) return player:getHealth() < 65 end,
	function(player)
		local health = player:getHealth()
		if health < 65 then player:addHealth(65 - health) end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You aren\'t looking really bad. Eat some food to regain strength.'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Hm.')

npcHandler:addModule(FocusModule:new())
