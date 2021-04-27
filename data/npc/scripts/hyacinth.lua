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

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|. You must be the one sent by Lily. Do you have a sack of {herbs} for me?")
	elseif player:getStorageValue(Storage.TheRookieGuard.Mission04) == 3 or player:getStorageValue(Storage.TheRookieGuard.Mission04) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller |PLAYERNAME|. I still have a present for you! Would you like to have it now?")
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Greetings, traveller |PLAYERNAME|. As you have found the way to my hut, how can I {help} you?')
	end
	return true
end

-- The Rookie Guard Quest - Mission 04: Home-Brewed

-- Mission 4: Confirm (Give herbs)
keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Thank you so much! I'm just too old to walk into the village each day, and the herbs must be fresh. Say, would you like to have a sample of my potions as reward?"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 and player:getItemCount(13827) >= 1 end,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission04, 3)
	player:removeItem(13827, 1)
end
)
keywordHandler:addAliasKeyword({"herbs"})

-- Mission 4: Decline (Give herbs)
local mission4LostHerbs = keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, then I must have mistaken you with someone else. Or did you lose it on the way?"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 2 end
)

-- Mission 4: Confirm (Lost herbs)
mission4LostHerbs:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "That's too bad... but I'm sure Lily could give you another one. Just walk back and talk to her again.",
	reset = true
})

-- Mission 4: Decline (Lost herbs)
mission4LostHerbs:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Alright then. Good luck on your travels.",
	ungreet = true
})

-- Mission 4: Accept (First reward)
keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Here you go - two small health potions. If you use them on yourself, they will recover some of your hitpoints. ...",
		"I recommend setting them on a hotkey so you don't have to search for them in a case of emergency. ...",
		"Once you are a bit more experienced and have chosen a vocation, you'll have access to many different potions and also spells to restore your health. ...",
		"Oh, and I also have another present for you! Do you still have some space in your inventory?"
	}
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 3 end,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission04, 4)
	player:addItemEx(Game.createItem(8704, 2), true, CONST_SLOT_BACKPACK)
end
)

-- Mission 4: Accept (Second reward)
keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Take this star ring. When you wear it in your ring slot, it will improve the effect of food that you have eaten for a limited time. So as long as you're not hungry, you will have increased hitpoint regeneration. ...",
		"It makes sense to undress it when you have full hitpoints, so that the effect of the ring won't be wasted. ...",
		"There are a lot of different rings in Tibia, but this one only works as long as you haven't learnt a vocation, so don't be afraid to use it. ...",
		"Anyway, thanks so much for your help. I can brew a lot of potions from these herbs. If you're in the area and find yourself in need of potions, don't hesitate to drop by and ask me for a {trade}. ...",
		"Anyway, this old man has taken enough of your time. Why don't you go back to the village and talk to Vascalir? If you stay on the path, you should be safe. Don't forget your potions!"
	}
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 4 end,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission04, 5)
	player:addItemEx(Game.createItem(13825, 1), true, CONST_SLOT_BACKPACK)
end
)

-- Mission 4: Decline (First reward)
keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Oh, but I insist! After all you made the long way. Please, take my reward!"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 3 end
)

-- Mission 4: Decline (Second reward)
keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, make some space and then talk to me again. I give you something really useful."
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission04) == 4 end
)

-- Basic Keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Time doesn\'t matter to me.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Hyacinth.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a {druid} and healer, a follower of {Crunor}.'})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = 'May Crunor bless you and protect you on your journeys!'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {npcHandler = npcHandler, text = 'There are only two other druids on Rookgaard, {Lily} and {Cipfried}.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Storage for worldly wealth.'})
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Who knows what it will be? Only time will show.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Thank the gods, I\'m fine.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'What help do you seek? I sell health potions, ask me for a {trade} if you need one.'})
keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, text = 'I can\'t teach you magic. On the {mainland} you will learn spells early enough.'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m one of the few magic users on this isle. I can sense a follower of the dark path of magic hiding somewhere in the depths of the dungeons.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'It is shaped by the will of the gods, so we don\'t have to question it.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'I used to be there with my old friend Cipfried to heal adventurers. After all these years, I prefer solitude now.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'Teaching you about the gods would require too much time. But you can always read the books in the {library}.'})
keywordHandler:addKeyword({'library'}, StdModule.say, {npcHandler = npcHandler, text = 'The library is in the {academy}, north of the {temple}.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'A place to learn about {Tibia}.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you hungry? I\'m sorry, I have no food here.'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I sell small health potions. Ask me for a trade if you need one.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t care about kings, queens, and the like.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'I rarely visit the town. It\'s much better here.'})
keywordHandler:addKeyword({'main'}, StdModule.say, {npcHandler = npcHandler, text = 'There\'s a huge world waiting for you.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Most of the so-called monsters of this isle are only creatures of the gods. There are some beasts that are truly monstrous on the {mainland}.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you hungry? I\'m sorry, I have no food here.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'The dungeons are dangerous for inexperienced adventurers.'})

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = 'Just ask me for a {trade} to check out my offers. I have only small health potions for sale, though.'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'sell'})

keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'You\'ll have to buy that from the merchants in town. I\'m just a simple druid and healer.'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'backpack'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addAliasKeyword({'armor'})
keywordHandler:addAliasKeyword({'helmet'})

keywordHandler:addKeyword({'deposit'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'ll pay you 5 gold for every empty vial and potion flask. Just ask me for a {trade}.'})
keywordHandler:addAliasKeyword({'flask'})
keywordHandler:addAliasKeyword({'vial'})

-- Names
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'A greedy and annoying person just like most people are.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Now she has completely gotten out of her mind.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'He was a promising young druid when something happened to his mind. It\'s a sad story.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'He does a good job out there.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'I know her since she was little.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'One of these greedy merchants.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'I saw her stranding with her raft.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a farmer and behaves a little better than his cousin.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'An unpleasant person.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'His healing powers equal mine.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'I think she\'s under bad influence.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s my name.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s actually quite nice.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'She\'s a druid. Since she started selling health potions, people visit me only rarely. Which is a good thing, but of course I\'ll help if I\'m needed.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'The oracle will lead you to your {destiny} once you are level 8.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'I think that guy is new. He\'s a {bank} clerk.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'He has some inner devils that torture him.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Tom is the local tanner. That means he always needs fresh corpses or leather.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'A man of the sword.'})
keywordHandler:addAliasKeyword({'zerbrus'})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'May Crunor bless you.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'May Crunor bless you.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Here. Don\'t forget, if you buy potions, there\'s a {deposit} of 5 gold on the empty flask.')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
