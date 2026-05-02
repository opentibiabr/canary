local internalNpcName = "Wyda"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 54,
	lookHead = 0,
	lookBody = 119,
	lookLegs = 119,
	lookFeet = 126,
}

npcConfig.flags = {
	floorchange = false,
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

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(60, 2000, -10)

local boredMiniWorldChangeKV = KV.scoped("worldchanges"):scoped("bored")

local function isBored()
	return boredMiniWorldChangeKV:get("active") == true
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	if not player then
		return true
	end

	if isBored() then
		npcHandler:setMessage(MESSAGE_GREET, "I'm bored! Bored bored bored! Nothing ever happens here!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "What? A mundane talking to me? Amusing.")
	end

	return true
end

local function farewellCallback(npc, creature)
	local player = Player(creature)
	if not player then
		return true
	end

	if isBored() then
		npcHandler:setMessage(MESSAGE_FAREWELL, "NO! Don't go! I need someone to entertain me!")
	else
		npcHandler:setMessage(MESSAGE_FAREWELL, "Good luck on your journeys.")
	end

	return true
end

local function walkawayCallback(npc, creature)
	local player = Player(creature)
	if not player then
		return true
	end

	if isBored() then
		npcHandler:setMessage(MESSAGE_WALKAWAY, "NO! Don't go! I need someone to entertain me!")
	else
		npcHandler:setMessage(MESSAGE_WALKAWAY, "Good luck on your journeys.")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "cookie") then
		if player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.Questline) == 31 and player:getStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Wyda) ~= 1 and player:getItemCount(130) > 0 then
			npcHandler:say("You brought me a cookie?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif isBored() then
			npcHandler:say("I was so bored that I made cookies with insects in them. I sold them in Venore. Maybe you ate one recently.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I bake cookies now and then in my spare time.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "quest") then
		if isBored() then
			npcHandler:say("To be honest, I'm drowning in blood herbs by now.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("A quest? Well, if you're so keen on doing me a favour... Why don't you try to find a blood herb?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "bloodherb") or MsgContains(message, "blood herb") then
		if isBored() then
			if player:getItemCount(3734) > 0 then
				npcHandler:say("Arrr... here we go again.... do you have a #$*§# blood herb for me?", npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say("To be honest, I'm drowning in blood herbs by now. But if it helps you, well yes.. I guess I could use another blood herb...", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		else
			npcHandler:say({
				"The blood herb is very rare. This plant would be very useful for me, but I don't know any accessible places to find it.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.Quest.U8_1.WhatAFoolishQuest.CookieDelivery.Wyda, 1)
			player:addCondition(condition)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("Well, it's a welcome change from all that gingerbread ... AHHH HOW DARE YOU??? FEEL MY WRATH!", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeItem(3734, 1) then
				player:setStorageValue(Storage.BloodHerbQuest, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				local TornTeddyRand = math.random(1, 100)
				if TornTeddyRand <= 70 then
					player:addItem(3454, 1) -- witchesbroom
					npcHandler:say("Thank you -SOOO- much! No, I really mean it! Really! Here, let me give you a reward...", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else
					player:addItem(12617, 1) -- torn teddy
					npcHandler:say("Thank you -SOOO- much! No, I really mean it! Really! Ah, you know what, you can have this old thing...", npc, creature)
					player:addAchievement("Torn Treasures")
					npcHandler:setTopic(playerId, 0)
				end
			else
				npcHandler:say("No, you don't have any...", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 or npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I see.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "job") or MsgContains(message, "profession") then
		if isBored() then
			npcHandler:say("I think witches these days are underpaid. Who needs a witch anyway?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I am a witch. Didn't you notice?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "gods") then
		if isBored() then
			npcHandler:say("Goddess, yes, you may call me that, thank you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I believe that nature itself is God.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "plant") or MsgContains(message, "plants") then
		if isBored() then
			npcHandler:say("I've heard about a whole different set of corrupted plants. I wonder what kind of potions you could make from them?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("There are many kinds of swamp plants, some can be used for potions, some not.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mushrooms") then
		if isBored() then
			npcHandler:say("Some mushrooms have strange effects. I just recently noticed that one certain sort lets your hands grow.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Mushrooms taste good and are useful for potions.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "herbs") then
		if isBored() then
			npcHandler:say("To be honest, I'm drowning in blood herbs by now.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("The swamp is home to a wide variety of herbs, but the most famous is the blood herb.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "magic") or MsgContains(message, "spell") then
		if isBored() then
			npcHandler:say("I want to invent a new spell. I just need a good idea.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("The magic of the witches is one of our secrets!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "magic") or MsgContains(message, "spell") then
		if isBored() then
			npcHandler:say("Here's a secret I've never told anyone before. I actually have a key to the Kazordoon treasury. No, you can't have it.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I keep my keys where they belong - in my pocket.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "king") then
		if isBored() then
			npcHandler:say("I've heard of a new festival called 'Kingsday'. Why don't they make a 'Witchday'?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("There are too many royals on this continent if you ask me...", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "tibianus") then
		if isBored() then
			npcHandler:say("Haha, still a stupid name.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Haha, that's a stupid name. Who's that?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "queen eloise") then
		if isBored() then
			npcHandler:say("She has become kinda fat over the years, don't you think? Ha... nothing beats some good gossip. I feel almost entertained.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Eloise is Queen of Carlin. I don't care about royals much, as long as they don't try to tax me.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "name") then
		if isBored() then
			npcHandler:say("You should know me after all these years!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("My name is Wyda, and what's yours?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "time") then
		if isBored() then
			npcHandler:say("It's about time SOMETHING HAPPENED HERE!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I think it is the fourth year after Queen Eloise's crowning, but I cannot tell you date or time.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "swamp") then
		if isBored() then
			npcHandler:say("Swamp water is good for your skin.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Be careful of the swamp water, it's poisonous!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "druid") then
		if isBored() then
			npcHandler:say("Being a druid is fine, you know. Since household injuries are among the most common, you can at least mend your own wounds well.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Druids are mostly fine people. I'm always happy when I meet one.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "sorcerer") then
		if isBored() then
			npcHandler:say("I wouldn't mind learning a new spell or two. Maybe I should dabble some in sorcerer magic.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Sorcerers have forgotten about the root of all beings: nature.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "knight") then
		if isBored() then
			npcHandler:say("Even a knight would be a welcome distraction right now. I could use his little sword to poke him in the eye.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Knights succumb to the blindness of rage and the desire for violence and blood.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "paladin") then
		if isBored() then
			npcHandler:say("I once knew a paladin who had a magic lamp. No wait... different story.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Paladins can use bows, but not brains.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "black knight") then
		if isBored() then
			npcHandler:say("Many creatures live in, around, and beneath the swamp. Be careful... MWIHIHIHIHIHI.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("A black knight? Black is the color of witches, why whould any knight carry black?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "giant spider") then
		if isBored() then
			npcHandler:say("Oooooh why are you asking? *whistles*", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Yes, there is such a thing in the east, on a small island. It's very powerful.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "hunter") then
		if isBored() then
			npcHandler:say("To hunt or to be hunted, I guess it's either of the two.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("To the east, there is a little settlement of hunters. They are cruel humans who attack everything they see.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "witches") or MsgContains(message, "sister") then
		if isBored() then
			npcHandler:say("They never let me join their parties. It's not my fault that I'm smarter and prettier than them. They're just jealous!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Some sisters of mine are having a meeting nearby. Don't disturb them, or they will get angry and attack you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "wand") then
		if isBored() then
			npcHandler:say("I use a wooden wand. Why are you asking?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I use a wooden spellwand. Why are you asking?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "crystal ball") then
		if isBored() then
			npcHandler:say("Let me take a look... ah, yes, you'll have a good day. Or maybe a bad one. Doesn't really say it clearly.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("It's a magical item that only witches can use.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "coffin") then
		if isBored() then
			npcHandler:say("Want to end up in one? Keep your nose out!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("That's none of your business.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "fly broom") then
		if isBored() then
			npcHandler:say("Sadly, my license expired.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Haha, no... where did you get that idea? I use it to sweep my platform.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "orange") then
		if isBored() then
			npcHandler:say("Actually, I feel more like mangos.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I love exotic fruits. I have oranges imported from the south sometimes, but that's very expensive.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "carlin") then
		if isBored() then
			npcHandler:say("I've heard a band of male bards plays there sometimes. Maybe I should pay it a visit.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Carlin is a beautiful town, but far from here. Do you live there?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "kazordoon") then
		if isBored() then
			npcHandler:say("Ah, the pretty city of... dullness.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Isn't that the name of the little bearded fellows' town?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "thais") then
		if isBored() then
			npcHandler:say("Not. Interested.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I've heard stories about that city. It's nowhere near here, that's all I can tell you about it.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "plains of havoc") then
		if isBored() then
			npcHandler:say("The Plains of Havoc... ah, fond memories. I used to go there as a little witch and run from all the giant spiders. How scary!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Many tales exist about some so-called Plains of Havoc. It seems to be a dangerous place.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "dwarven bridge") then
		if isBored() then
			npcHandler:say("Good if you don't want to get your feet wet, I guess. Hey, actually that's a brilliant idea. I could destroy a few bridges... hahaha.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("There's a bridge to the west, but it's guarded by dwarfs.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "ferumbras") then
		if isBored() then
			npcHandler:say("Look, behind you!! WAHAHAHAHAHAHA.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Haha, that's a stupid name. Who's that?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "become witch") and player:getSex() == PLAYERSEX_MALE then
		npcHandler:say("You're a MAN!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "evil") then
		if isBored() then
			npcHandler:say("I'm not evil. What are you implying?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Evilness doesn't scare me.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "tibia") then
		if isBored() then
			npcHandler:say("You're a smart one, aren't you?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Tibia is the name of our continent.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "health") then
		if isBored() then
			npcHandler:say("Nah sorry. Hehehehehe.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I do not have any potions for healing available right now.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "voodoo") then
		if isBored() then
			npcHandler:say("I've recently met that fellow Chondur on a convention. He has some... interesting... skills. *giggles*", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("I don't practice such nonsense, that's just a rumour.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

keywordHandler:addKeyword({ "nature" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There are many swamp plants, mushrooms, and herbs around here.",
})
keywordHandler:addKeyword({ "potion", "recipe", "secret" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The recipe of the potions is one of the witches' secrets!",
})
keywordHandler:addKeyword({ "help" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can only help with knowledge. About what do you want me to tell you something?",
})
keywordHandler:addKeyword({ "my name is |PLAYERNAME|" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Nice to meet you.",
})
keywordHandler:addKeyword({ "monsters", "creatures" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Many creatures live in, around, and beneath the swamp. Be careful!",
})
keywordHandler:addKeyword({ "bonelords" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Bonelords? Strange creatures that have mysterious magical abilities.",
})
keywordHandler:addKeyword({ "slime" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There's lots of slime around. It is said that they live from the swamp water.",
})
keywordHandler:addKeyword({ "broom" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "What about it?",
})
keywordHandler:addKeyword({ "little bearded fellows", "dwarf", "dwarves" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The little bearded fellows have a town somewhere to the north-west.",
})
keywordHandler:addKeyword({ "earthquakes" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The earth in this region shakes now and then. Foolish people think that this is because the gods are angry.",
})
keywordHandler:addKeyword({ "witch" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Aye, I am a witch.",
})
keywordHandler:addKeyword({ "man" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There are only female witches.",
})
keywordHandler:addKeyword({ "platform" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "This platform and house were built by my mother, long ago.",
})
keywordHandler:addKeyword({ "mother" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Of course my mother was also a witch!",
})
keywordHandler:addKeyword({ "granny weatherwax" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I think I've heard that name before...",
})
keywordHandler:addKeyword({ "nanny ogg" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I think I've heard that name before...",
})
keywordHandler:addKeyword({ "buy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I'm currently not selling anything.",
})
keywordHandler:addKeyword({ "sell" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There's nothing I need right now, thanks.",
})

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_FAREWELL, farewellCallback)
npcHandler:setCallback(CALLBACK_ON_DISAPPEAR, walkawayCallback)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
