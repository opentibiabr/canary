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
	{ text = 'Are you injured or poisoned? I can help you.' },
	{ text = 'For Rookgaard! For Tibia!' },
	{ text = 'No monster shall go past me.' },
	{ text = 'The premium side of Rookgaard lies beyond.' },
	{ text = 'Want to know what monsters are good for you at your level? Just ask me!' }
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
	keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = text},
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
addMonsterKeyword(8, 'Wow, |PLAYERNAME|! You have grown so much. I think there is nothing more I could teach you. Talk to the {oracle} to travel to other places which will pose more of a challenge for you. <bows>')
addMonsterKeyword(7, 'Impressive, |PLAYERNAME|. You are almost strong enough to leave this island. Maybe you can take on minotaurs or rotworms now. There are no rotworms on this side of the island, ask Dallheim for their location.')
addMonsterKeyword(6, 'Nice job out there,|PLAYERNAME|. If you are looking for a challenge, descend into the troll cave as deep as you can. Or explore the northern side of this island. Talk to {Dallheim} for directions.')
addMonsterKeyword(5, 'Nice job out there, |PLAYERNAME|. Are you looking for other monsters than {trolls} or {wolves}? Maybe you\'d like to check out {skeletons}. I\'ll mark them for you so you can find them easily.',
	{{position = Position(31977, 32228, 7), type = MAPMARK_GREENSOUTH, description = 'Skeleton Cave'}}
)
addMonsterKeyword(4, 'You\'re halfway to leaving this island, well done. {Spiders} or {wolves} are always good to fight, but if you want to move on, why don\'t you check out trolls? I\'ll mark you the troll cave on this side.',
	{{position = Position(32002, 32212, 7), type = MAPMARK_GREENSOUTH, description = 'Troll Cave'}}
)
addMonsterKeyword(3, 'Good progress, |PLAYERNAME|. You can still stay with {spiders} or {snakes}, but maybe you\'d like to try fighting a {wolf}? I\'ll mark some of their hills on your map.',
	{{position = Position(32002, 32225, 7), type = MAPMARK_GREENNORTH, description = 'Wolf Hill'}, {position = Position(31989, 32198, 7), type = MAPMARK_GREENNORTH, description = 'Wolf Hill'}}
)
addMonsterKeyword(2, 'You\'ve already grown some, |PLAYERNAME|. You can either stay with {rats} or leave town to hunt {spiders} or {snakes}. I\'ll mark some spawns on your map.',
	{{position = Position(32001, 32238, 7), type = MAPMARK_GREENSOUTH, description = 'Snake Pit'}, {position = Position(32046, 32188, 7), type = MAPMARK_GREENSOUTH, description = 'Spider Cave'}}
)
addMonsterKeyword(1, 'You are just beginning your journey, dear |PLAYERNAME|. You can start by helping me fight {rats} in the sewers. I\'ll mark an entrance on your map.',
	{{position = Position(32097, 32205, 7), type = MAPMARK_GREENSOUTH, description = 'Sewer Entrance'}}
)

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Zerbrus, at your service.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the guard of this bridge. I defend Rookgaard against the beasts of the {wilderness} and the {dungeons}, and even of the stinking {sewers}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'My duty is eternal. Time is of no importance.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Before you fight monsters, deposit your money there. If you die, you won\'t lose it if it\'s save in the bank.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Fine.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'I have to stay here, sorry. But I can {heal} you if you are wounded. I have also valuable information about {monsters}.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m an expert concerning the wildlife and {monsters} on this island.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not a gossiper, but if you want to know something about a certain Rookgaardian, ask.'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'They\'re not that dangerous, but don\'t let yourself get cornered by many of them. They still can hurt.'})
keywordHandler:addKeyword({'spider'}, StdModule.say, {npcHandler = npcHandler, text = 'There are two types of spiders on this island: normal spiders and poison spiders. As their name says, the latter ones can poison you which will cause a constant loss of your health. Beware of them!'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Once you have upgraded your starter {equipment} a little - maybe leather stuff - and got a better weapon as well as a shield, you should be able to kill trolls.'})
keywordHandler:addKeyword({'wolf'}, StdModule.say, {npcHandler = npcHandler, text = 'You need a stronger weapon than the starter club to kill wolves. Maybe a {sabre} or a short {sword} will do.'})
keywordHandler:addAliasKeyword({'wolves'})
keywordHandler:addKeyword({'orc'}, StdModule.say, {npcHandler = npcHandler, text = 'The orcs have a hideout under the troll cave, just descend deep. Still, be very careful!'})
keywordHandler:addKeyword({'minotaur'}, StdModule.say, {npcHandler = npcHandler, text = 'Minotaurs are very strong. You will need a group of people or at least level 6 and good equipment to be able to kill them.'})
keywordHandler:addKeyword({'bug'}, StdModule.say, {npcHandler = npcHandler, text = 'They are a little tougher than they look like, but they\'re still good beginner monsters.'})
keywordHandler:addKeyword({'skeleton'}, StdModule.say, {npcHandler = npcHandler, text = 'The skeletons on this island are usually fairly hidden. They are often found near graves and always underground. Beware of their evil life drain.'})
keywordHandler:addKeyword({'bear'}, StdModule.say, {npcHandler = npcHandler, text = 'There is a bear cave close to this bridge. Be careful, though, they hit hard!'})
keywordHandler:addKeyword({'wasp'}, StdModule.say, {npcHandler = npcHandler, text = 'Wasp hives exist only behind the north bridge, so ask {Dallheim} for information. I\'m glad there are no wasps here. They always make me jump.'})
keywordHandler:addKeyword({'snake'}, StdModule.say, {npcHandler = npcHandler, text = 'Snakes can poison you, too, but their poison is usually not as dangerous as that of poison spiders. Just be careful and kill them fast.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Premium warriors pay. They gain many advantages this way.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'HAIL TO THE KING!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s north of the temple.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'A place of protection. Nothing can harm you there.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'I can mark you some dungeons on your map if you ask me about {monsters} suited for your level.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'The sewers are crowded with {rats}. They make fine targets for young heroes.'})
keywordHandler:addKeyword({'wilderness'}, StdModule.say, {npcHandler = npcHandler, text = 'There are {wolves}, {bears}, {snakes}, {deer}, and {spiders} in the wilderness past this bridge.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a follower of {Banor}.'})
keywordHandler:addKeyword({'banor'}, StdModule.say, {npcHandler = npcHandler, text = 'The heavenly warrior! Read {books} to learn about him.'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'You will learn about magic soon enough.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'In the world of Tibia, many challenges await the brave adventurer.'})
keywordHandler:addKeyword({'book'}, StdModule.say, {npcHandler = npcHandler, text = 'There are many books in the {academy}. Theory can be just as important as practice.'})

keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s my duty to protect this village and its {citizens}.'})
keywordHandler:addAliasKeyword({'protect'})

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
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Such a chicken-hearted person.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He sells {weapons}. His shop is south west of town, close to the {temple}.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He dedicated his life to welcoming newcomers to this island.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'She has her own problems.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'There\'s something about this guy I don\'t like.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s very attractive. Too bad my duty leaves me no time to date her.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'He guards the temple and can heal you if you are badly injured or poisoned, just like me.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s {Obi\'s} granddaughter and deals with {armors} and {shields}. Her shop is south west of town, close to the temple.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'One of these reclusive druids.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her shop is just north of the bridge. She really has good offers.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Gentle girl, but a little to esoteric for my taste. However, her {potions} might come in handy.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'You can find the oracle on the top floor of the {academy}, just above {Seymour}. Go there when you are level 8.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'The local {bank} clerk.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'His job of teaching young heroes is important for the survival of all of us.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s the local tanner. You could try selling fresh corpses or leather to him.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He does a fine job, protecting the north bridge. He\'s been on duty longer than me and knows the north side of Rookgaard well.'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'At your service.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a farmer. A little more friendly than his cousin {Willie}, he also buys and sells {food}.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s quite rude. Also, he buys and sells {food}.'})

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
