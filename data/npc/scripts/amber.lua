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
	{ text = "I wish I could eat some salmon right now... best prepared in Liberty Bay style... yummy." },
	{ text = "Wow, I'm tired. I really should get some sleep... zzzz." },
	{ text = "What was that word again in Orcish language... hmm." },
	{ text = "Hey you! Are you an adventurer, too?" },
	{ text = "<sings> Stormy weathers, stormy weathers... stormy weathers on the sea!" }
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local addonProgress = player:getStorageValue(Storage.OutfitQuest.Citizen.AddonBackpack)
	if msgcontains(msg, "addon") or msgcontains(msg, "outfit")
	or (addonProgress == 1 and msgcontains(msg, "leather"))
	or ((addonProgress == 1 or addonProgress == 2) and msgcontains(msg, "backpack")) then
		if addonProgress < 1 then
			npcHandler:say("Sorry, the backpack I wear is not for sale. It's handmade from rare minotaur leather.", cid)
			npcHandler.topic[cid] = 1
		elseif addonProgress == 1 then
			npcHandler:say("Ah, right, almost forgot about the backpack! \z
						   Have you brought me 100 pieces of minotaur leather as requested?", cid)
			npcHandler.topic[cid] = 3
		elseif addonProgress == 2 then
			if player:getStorageValue(Storage.OutfitQuest.Citizen.AddonBackpackTimer) < os.time() then
				npcHandler:say("Just in time! Your backpack is finished. Here you go, I hope you like it.", cid)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
				player:setStorageValue(Storage.OutfitQuest.Citizen.MissionBackpack, 0)
				player:setStorageValue(Storage.OutfitQuest.Citizen.AddonBackpack, 3)

				player:addOutfitAddon(136, 1)
				player:addOutfitAddon(128, 1)
			else
				npcHandler:say("Uh... I didn't expect you to return that early. \z
							   Sorry, but I'm not finished yet with your backpack. \z
							   I'm doing the best I can, promised.", cid)
			end
		elseif addonProgress == 3 then
			npcHandler:say("Sorry, but I can only make one backpack per person, \z
						   else I'd have to close my shop and open a leather manufactory.", cid)
		end
		return true
	end

	if npcHandler.topic[cid] == 1 then
		if msgcontains(msg, "backpack") or msgcontains(msg, "minotaur") or msgcontains(msg, "leather") then
			npcHandler:say("Well, if you really like this backpack, I could make one for you, \z
						   but minotaur leather is hard to come by these days. Are you willing to put some work into this?", cid)
			npcHandler.topic[cid] = 2
		end

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, "yes") then
			player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.AddonBackpack, 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.MissionBackpack, 1)
			npcHandler:say("Alright then, if you bring me 100 pieces of fine minotaur leather I will \z
						   see what I can do for you. You probably have to kill really many minotaurs though... so good luck!", cid)
			npcHandler:releaseFocus(cid)
		else
			npcHandler:say("Sorry, but I don't run a welfare office, you know... no pain, no gain.", cid)
		end
		npcHandler.topic[cid] = 0

	elseif npcHandler.topic[cid] == 3 then
		if msgcontains(msg, "yes") then
			if player:getItemCount(5878) < 100 then
				npcHandler:say("Sorry, but that's not enough leather yet to make one of these backpacks. \z
							   Would you rather like to buy a normal backpack for 10 gold?", cid)
			else
				npcHandler:say("Great! Alright, I need a while to finish this backpack for you. Come ask me later, okay?", cid)

				player:removeItem(5878, 100)

				player:setStorageValue(Storage.OutfitQuest.Citizen.MissionBackpack, 2)
				player:setStorageValue(Storage.OutfitQuest.Citizen.AddonBackpack, 2)
				player:setStorageValue(Storage.OutfitQuest.Citizen.AddonBackpackTimer, os.time() + 2 * 60 * 60)
			end
		else
			npcHandler:say("I know, it's quite some work... don't lose heart, \z
						   just keep killing minotaurs and you'll eventually get lucky. \z
						   Would you rather like to buy a normal backpack for 10 gold?", cid)
		end
		npcHandler.topic[cid] = 0
	end
end

npcHandler:addModule(VoiceModule:new(voices))

-- Basic keywords
keywordHandler:addKeyword({"hint"}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({"how", "are", "you"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm recovering from a {sea} passage."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm an {explorer} who seeks {adventures}."
	}
)
keywordHandler:addKeyword({"explore"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I've been almost everywhere in {Tibia}."
	}
)
keywordHandler:addKeyword({"adventure"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I fought fierce {monsters}, climbed the highest mountains, explored the deepest {dungeons} \z
			   and crossed the {sea} on a {raft}."
	}
)
keywordHandler:addKeyword({"sea"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My voyage on the sea was exhausting. \z
			   The weather was bad, the waves high and my raft quite simple. \z
			   There's a certain excitement to it, though."
	}
)
keywordHandler:addKeyword({"time"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sorry, I lost my watch in a storm."
	}
)
keywordHandler:addKeyword({"help"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Well, I can give you general {hints} or tell you about my {adventures} and many other topics. \z
				Oh, and if you are bored, I might have a small {quest} for you."
	}
)
keywordHandler:addKeyword({"information"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Well, I can give you general {hints} or tell you about my {adventures} and many other topics. \z
				Oh, and if you are bored, I might have a small {quest} for you."
	}
)
keywordHandler:addKeyword({"dungeon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I had no time to explore the dungeons of this isle yet, \z
				but I've seen two big caves in the East, and there is a ruined tower to the north-west. \z
				Oh, and there're the {sewers}."
	}
)
keywordHandler:addKeyword({"sewer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I like sewers. I made my very first battle experience in the sewers below {Thais}. \z
				The small sewer system of {Rookgaard} has some nasty rats to fight."
	}
)
keywordHandler:addKeyword({"monster"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Oh, I fought {orcs}, {cyclopses}, {minotaurs}, even {dragons}, and many other creatures."
	}
)
keywordHandler:addKeyword({"cyclops"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I don't like the way they look at you. Their eye seems to pierce right through you. Creepy!"
	}
)
keywordHandler:addKeyword({"minotaur"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "They are nasty monsters, particularly as they have distance fighters and mages in their clans. \z
				My {backpack} is handmade from minotaur leather."
	}
)
keywordHandler:addKeyword({"dragon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Their breath is so hot! I had to cut my hair after my last encounter with \z
				a dragon because the ends were all burnt. That's what you gotta deal with as a female adventurer!"
	}
)
keywordHandler:addKeyword({"raft"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I left my raft at the south-eastern shore. I forgot my private {notebook} on it. \z
				If you could return it to me, I would be very grateful."
	}
)
keywordHandler:addKeyword({"quest"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I left my raft at the south-eastern shore. I forgot my private {notebook} on it. \z
				If you could return it to me, I would be very grateful."
	}
)
keywordHandler:addKeyword({"mission"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I left my raft at the south-eastern shore. I forgot my private {notebook} on it. \z
				If you could return it to me, I would be very grateful."
	}
)
keywordHandler:addKeyword({"seymour"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I think this poor guy was a bad choice as head of the {academy}."
	}
)
keywordHandler:addKeyword({"academy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A fine institution, but it needs definitely more funds from the {king}."
	}
)
keywordHandler:addKeyword({"king"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "King Tibianus is the ruler of {Thais}. The island of {Rookgaard} belongs to his kingdom."
	}
)
keywordHandler:addKeyword({"thais"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A fine city, but the {king} has some problems enforcing the law."
	}
)
keywordHandler:addKeyword({"weapon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The best weapons on this isle are just toothpicks \z
				compared with the weapons warriors wield on the {mainland}."
	}
)
keywordHandler:addKeyword({"magic"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Spells are only taught in the guildhalls of the mainland."
	}
)
keywordHandler:addKeyword({"tibia"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm trying to explore each spot of Tibia, and one day I'll have seen it all."
	}
)
keywordHandler:addKeyword({"castle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If you travel to Thais, you really should visit the marvelous castle there."
	}
)
keywordHandler:addKeyword({"mainland"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You'll be surprised once you leave this island. The world outside there is gigantic."
	}
)
keywordHandler:addKeyword({"tools"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The most important tools you need are a {rope}, a {shovel} and maybe a {torch}."
	}
)
keywordHandler:addKeyword({"rope"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "One day I fell into a hole without having a rope. I was yelling for help for three whole days! \z
				Eventually a fisherman passed by and pulled me out with his own rope, lucky me."
	}
)
keywordHandler:addKeyword({"shovel"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sometimes I have the strong urge to use it to knock someone out."
	}
)
keywordHandler:addKeyword({"torch"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You know, on mainland you will be able to cast magic spells which provide you with light. \z
				You won't really need torches anymore."
	}
)
keywordHandler:addKeyword({"bank"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have almost no money with me anyway, so no need to deposit any at the bank."
	}
)
keywordHandler:addKeyword({"destiny"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You will find your destiny. I'm sure it's something big and important."
	}
)
keywordHandler:addKeyword({"academy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A fine institution, but it needs definitely more funds from the {king}."
	}
)
keywordHandler:addKeyword({"trade"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Oh, I'm sorry, but I'm not interested in buying or selling anything."
	}
)
keywordHandler:addKeyword({"premium"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I wouldn't want to miss being a premium adventurer. Everything is so much easier!"
	}
)

-- Names
keywordHandler:addKeyword({"al", "dee"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I don't have much to say about him. I think he sells {tools}."
	}
)
keywordHandler:addKeyword({"loui"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Never seen him around."
	}
)
keywordHandler:addKeyword({"zirella"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She seriously asked me if she could have the remains of my {raft} as fire wood! Can you imagine that??"
	}
)
keywordHandler:addKeyword({"santiago"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He promised to repair my {raft}."
	}
)
keywordHandler:addKeyword({"amber"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Did you know my name is also the name of a gem?"
	}
)
keywordHandler:addKeyword({"tom"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "To me he seems a bit rude, but maybe that's just my impression."
	}
)
keywordHandler:addKeyword({"lee'delle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I heard her offers are extraordinarily good."
	}
)
keywordHandler:addKeyword({"oracle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The oracle is said to show you your {destiny} once you are level 8."
	}
)
keywordHandler:addKeyword({"norma"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She has changed a lot since I last saw her."
	}
)
keywordHandler:addKeyword({"seymour"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I think this poor guy was a bad choice as head of the {academy}."
	}
)
keywordHandler:addKeyword({"lily"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hm, I think I haven't met her yet."
	}
)
keywordHandler:addKeyword({"billy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He brought me some of his famous rat stew. I really didn't want to insult him, \z
				but I simply can't eat something like that. So I told him I'm a vegetarian and I only eat fish. <gulps>"
	}
)
keywordHandler:addKeyword({"willie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He's funny in his own way."
	}
)
keywordHandler:addKeyword({"paulie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "No, I didn't go to the {bank} yet."
	}
)
keywordHandler:addKeyword({"cipfried"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A gentle person. You should visit him if you have questions or need healing."
	}
)
keywordHandler:addKeyword({"hyacinth"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hyacinth is a great healer. He lives somewhere hidden on this isle."
	}
)
keywordHandler:addKeyword({"obi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He's a funny little man."
	}
)
keywordHandler:addKeyword({"dixi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I don't really know her, but she seems to be a nice girl."
	}
)
keywordHandler:addKeyword({"zerbrus"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "An extraordinary warrior. He's the first and last line of defense of {Rookgaard}."
	}
)
keywordHandler:addAliasKeyword({"dallheim"})

-- Orc language
keywordHandler:addKeyword({"orc"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Not the nicest guys you can encounter. \z
				I had some clashes with them and finally ended up being their {prisoner} for a few months."
	}
)
local prisonerKeyword = keywordHandler:addKeyword({"prisoner"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I speak some Orcish words, not many though, just a few basics like '{yes}' and '{no}'."
	}
)
	prisonerKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "It's 'mok' in Orcish. I tell you more if you bring me some {food}.",
		reset = true
	}
)
	prisonerKeyword:addChildKeyword({"no"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In Orcish that's 'burp'. I tell you more if you bring me some {food}.",
		reset = true
	}
)
keywordHandler:addAliasKeyword({"language"})

-- Food (Salmon)
keywordHandler:addKeyword({"food"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My favorite dish is {salmon}. Oh please, bring me some."
	}
)
local salmonKeyword = keywordHandler:addKeyword({"salmon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Yeah! If you give me some salmon, I'll tell you another Orcish word. Okay?"
	}
)
salmonKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Thank you. Orcs call arrows 'pixo'.",
		reset = true
	},
		function(player)
			return player:getItemCount(2668) > 0
		end,
		function(player)
			player:removeItem(2668, 1)
		end
	)
salmonKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You don't have any salmon!",
		reset = true
	}
)
salmonKeyword:addChildKeyword({""}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ok, then I won't tell you another Orcish word.",
		reset = true
	}
)

-- Logbook Quest
local bookKeyword = keywordHandler:addKeyword({"book"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Do you bring me my notebook?"
	}
)
bookKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Excellent. Here, take this short sword as a reward.",
		reset = true
	},
		function(player)
			return player:getItemCount(1955) > 0
		end,
		function(player)
			player:addItem(2406, 1) player:removeItem(1955, 1)
		end
	)
bookKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Mhm, whatever you have there, it is not my notebook.",
		reset = true
	}
)
bookKeyword:addChildKeyword({""}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Too bad.",
		reset = true
	}
)
keywordHandler:addAliasKeyword({"notebook"})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Yeah, see you later.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you later, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_GREET, "Oh hello, nice to see you |PLAYERNAME|. \z
									  Are you here to hear some stories of my {adventures} or do you need {help}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
