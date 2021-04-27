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
	{ text = 'Buying fresh corpses of rats, rabbits and wolves.' },
	{ text = 'Oh yeah, I\'m also interested in wolf paws and bear paws.' },
	{ text = 'Also buying minotaur leather.' }
}
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	-- Starting mission 6
	if player:getStorageValue(Storage.TheRookieGuard.Mission06) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey there, |PLAYERNAME|. Did Vascalir send you to me for a {mission}?")
	-- Not finished mission 6
	elseif player:getStorageValue(Storage.TheRookieGuard.Mission06) > 1 and player:getStorageValue(Storage.TheRookieGuard.Mission06) < 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Now, now - we can't work with that. Go back to that wolf den and fulfil your mission! Unless there is anything else I can help you with.")
	-- Finishing mission 6
	elseif player:getStorageValue(Storage.TheRookieGuard.Mission06) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey there, |PLAYERNAME|. You look... exhausted. Did you run a lot? And more importantly, were you able to find some war wolf leather?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hey there, |PLAYERNAME|. I'm Tom the tanner. If you have fresh {corpses}, leather, paws or other animal body parts, {trade} with me.")
	end
	return true
end

local function farewellCallback(cid)
	local player = Player(cid)
	if player:getSex() == PLAYERSEX_FEMALE then
		npcHandler:setMessage(MESSAGE_FAREWELL, "Good hunting, child.")
	else
		npcHandler:setMessage(MESSAGE_FAREWELL, "Good hunting, son.")
	end
	return true
end

-- The Rookie Guard Quest - Mission 06: Run Like a Wolf

-- Mission 6: Start
local mission6 = keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"I can help you get boots, but I can't give them to you for free. Besides, you'd want good boots, not that stuff made from rat leather. The best leather you'd find on Rook is wolf leather. ...",
		"War wolf leather, to be precise. Problem is - war wolves are rare, and you can't hope to fight and defeat them. So your only chance is to find an already dead war wolf, take his skin, and escape really fast. ...",
		"What an interesting coincidence that I've seen a poacher sneak into the wolf den just a few hours ago. I'm not exactly a fan of poachers - they kill too many of our wolves. ...",
		"Sooo... what I'm suggesting is: follow his traces into the wolf den, and if you get lucky, you'll be able to take one of his illegally obtained war wolf skins. ...",
		"That's why I wouldn't call it 'stealing', what an ugly word... anyway, if you bring the skin back to me, I'll make some great war wolf boots from them. What do you say?"
	}
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission06) == 1 end
)
keywordHandler:addAliasKeyword({"mission"})

-- Mission 6: Decline start
keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Alright. Can I help you with something else then?"
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission06) == 1 end
)

-- Mission 6: Accept
mission6:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "That's what I thought. I marked the wolf den on your map. To go there, exit the village to the north and walk north-east. Good luck finding that poacher and figuring out a plan to take those skins! Hehe.",
	ungreet = true
},
nil,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission06, 2)
	player:addMapMark({x = 32138, y = 32132, z = 7}, MAPMARK_GREENSOUTH, "War Wolf Den")
end
)

-- Mission 6: Decline
mission6:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, then walk Rookgaard barefoot. It's up to you!",
	reset = true
})

-- Mission 6: Finish - Confirm (Give skin)
keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Hmm... unfortunately the skin is damaged too badly. Whoever skinned this wolf wasn't very skilled at it. Hmm. ...",
		"Ah, no need to fret. Tell you what kid, I'm gonna give you some normal leather boots instead. They should keep your feet warm as well. Here you go. ...",
		"By the way... that running you did to get out of the cave will be your normal walking speed when you are several levels higher. With each level you gain, you'll also become a little faster. ...",
		"There are also other items, spells and equipment that increase your speed. ...",
		"You can also tame creatures to ride on that will also increase your speed. So don't worry if you're out of breath now - you won't always be that slow. Now off with you and back to Vascalir, I have work to do."
	}
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission06) == 6 and player:getItemCount(13879) >= 1 end,
function(player)
	player:setStorageValue(Storage.TheRookieGuard.Mission06, 7)
	player:removeItem(13879, 1)
	player:addItemEx(Game.createItem(2643, 1), true, CONST_SLOT_WHEREEVER)
end
)

-- Mission 6: Finish - Decline (Give skin)
keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Are you sure? I think I see some war wolf leather on you. You should reply with {yes}."
},
function(player) return player:getStorageValue(Storage.TheRookieGuard.Mission06) == 6 and player:getItemCount(13879) >= 1 end
)

-- Basic keywords
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Tom the tanner.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the local {tanner}. I buy fresh animal {corpses}, tan them, and convert them into fine leather clothes which I then sell to {merchants}.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = '{Dixi} and {Lee\'Delle} sell my leather clothes in their shops.'})
keywordHandler:addKeyword({'tanner'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s my job. It can be dirty at times but it provides enough income for my living.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Do I look like a tourist information centre? Go ask someone else.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Help? I will give you a few gold coins if you have some fresh dead {animals} for me. Note the word {fresh}.'})
keywordHandler:addKeyword({'fresh'}, StdModule.say, {npcHandler = npcHandler, text = 'Fresh means: shortly after their death.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Much to do these days.'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Good monsters to start with are rats. They live in the {sewers} under the village of {Rookgaard}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Dungeons can be dangerous without proper {equipment}.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'You need at least a {backpack}, a {rope}, a {shovel}, a {weapon}, an {armor} and a {shield}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I haven\'t been outside for a while, so I don\'t know.'})

keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'Troll leather stinks. Can\'t use it.'})
keywordHandler:addKeyword({'orc'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t buy orcs. Their skin is too scratchy.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you crazy?!', ungreet = true})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Go see {Al Dee} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'rope'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Ask {Dixi} or {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Nope, sorry, don\'t sell that. Ask {Obi} or {Lee\'Delle}.'})

keywordHandler:addKeyword({'corpse'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m buying fresh {corpses} of rats, rabbits and wolves. I don\'t buy half-decayed ones. If you have any for sale, {trade} with me.'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'animal'})
keywordHandler:addAliasKeyword({'sell'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'offer'})

-- Names
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s an apple polisher.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Now that\'s an interesting woman.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s a better cook than his cousin {Willie}, actually.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'I kinda like him. At least he says what he thinks.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Yep.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'He sticks his nose too much in books.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'My mother?? Did you meet my mother??'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t have a problem with him.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Typical pencil pusher.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s in the academy, just above Seymour. Go there once you are level 8 to leave this place.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'He is such a hypocrite.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'I like her beer.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'She buys my fine leather clothes.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'I wonder what spectacular monsters he has found.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Her nose is a little high in the air, I think. She never shakes my hand.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'I wonder if he\'s angry because his potion monopoly fell.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m not what you\'d call a \'believer\'.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'He\'s okay.'})
keywordHandler:addAliasKeyword({'zerbrus'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "cough syrup") then
		npcHandler:say("I had some cough syrup a while ago. It was stolen in an ape raid. I fear if you want more cough syrup you will have to buy it in the druids guild in carlin.", cid)
	elseif msgcontains(msg, "addon") then
		if player:getStorageValue(Storage.OutfitQuest.DruidBodyAddon) < 1 then
			npcHandler:say("Would you like to wear bear paws like I do? No problem, just bring me 50 bear paws and 50 wolf paws and I'll fit them on.", cid)
			player:setStorageValue(Storage.OutfitQuest.DruidBodyAddon, 1)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "paws") or msgcontains(msg, "bear paws") then
		if player:getStorageValue(Storage.OutfitQuest.DruidBodyAddon) == 1 then
			npcHandler:say("Have you brought 50 bear paws and 50 wolf paws?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:getItemCount(5896) >= 50 and player:getItemCount(5897) >= 50 then
				npcHandler:say("Excellent! Like promised, here are your bear paws. ", cid)
				player:removeItem(5896, 50)
				player:removeItem(5897, 50)
				player:setStorageValue(Storage.OutfitQuest.DruidBodyAddon, 2)
				player:addOutfitAddon(148, 1)
				player:addOutfitAddon(144, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have all items.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_FAREWELL, farewellCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, 'D\'oh?')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Sure, check what I buy.')

npcHandler:addModule(FocusModule:new())
