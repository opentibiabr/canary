local internalNpcName = "Cael"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "I wish I could learn more about this strange world."},
	{text = "Those different cultures are amazing."},
	{text = "What an interesting continent."}
}

local tomes = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge
-- Npc shop
npcConfig.shop = {
	{ itemName = "didgeridoo", clientId = 2965, buy = 5000, storageKey = tomes, storageValue = 6 },
	{ itemName = "war drum", clientId = 2966, buy = 1000, storageKey = tomes, storageValue = 6 },
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "tome") or MsgContains(message, "knowledge") then
		--The first 8 missions of The New Frontier Quest completed to be able to trade 6 Tomes of Knowledge with NPC Cael.
		if player:getStorageValue(TheNewFrontier.Mission08) == 2 then
			if player:getStorageValue(TheNewFrontier.TomeofKnowledge) < 1 then --tome1
				npcHandler:say("Oh! That sounds fascinating. Have you found a Tome of Knowledge for me to read?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif player:getStorageValue(TheNewFrontier.TomeofKnowledge) >= 1 and player:getStorageValue(TheNewFrontier.TomeofKnowledge) <= 5 then --tome2 - tome6
				npcHandler:say("Oh! That sounds fascinating. Have you found a new Tome of Knowledge for me to read?", npc, creature)
				npcHandler:setTopic(playerId, player:getStorageValue(TheNewFrontier.TomeofKnowledge) +1)
			elseif player:getStorageValue(TheNewFrontier.TomeofKnowledge) >= 6 and player:getStorageValue(TheNewFrontier.TomeofKnowledge) <= 11 then --tome7 - tome12
				--The New Frontier Quest completed to trade more Tomes of Knowledge with NPC Cael.
				if player:getStorageValue(TheNewFrontier.Mission10[1]) == 2 then
					npcHandler:say("Oh! That sounds fascinating. Have you found a new Tome of Knowledge for me to read?", npc, creature)
					npcHandler:setTopic(playerId, player:getStorageValue(TheNewFrontier.TomeofKnowledge) +1)
				else
					npcHandler:say("I'm sorry I'm busy. Speak with Ongulf to get some missions!", npc, creature)
				end
			elseif player:getStorageValue(TheNewFrontier.TomeofKnowledge) >= 12 then -- more then 12 tomes
				npcHandler:say("Oh! That sounds fascinating. Have you found a Tome of Knowledge for me to read? I have the feeling though that I can only share some of my experience with you now. Is that alright with you?", npc, creature)
				npcHandler:setTopic(playerId, 13)
			end
		else
			npcHandler:say("I'm sorry I'm busy. Speak with Ongulf to get some missions!", npc, creature)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) >= 1 and npcHandler:getTopic(playerId) <= 13 then
		if player:removeItem(10217, 1) then --remove tome
			if npcHandler:getTopic(playerId) == 1 then	--tome1
				npcHandler:say("Thank you! I look forward to reading this interesting discovery of yours and learn a few things about {Zao}.", npc, creature)
				player:setStorageValue(TheNewFrontier.TomeofKnowledge, 1)
				npcHandler:setTopic(playerId, 21)
			elseif npcHandler:getTopic(playerId) >= 2 and npcHandler:getTopic(playerId) <= 12 then --tome2 - tome12
				npcHandler:say("Thank you! I look forward to reading this interesting discovery of yours and learn a few things about {Zao}.", npc, creature)
				player:setStorageValue(TheNewFrontier.TomeofKnowledge, player:getStorageValue(TheNewFrontier.TomeofKnowledge) + 1)
				if player:getStorageValue(TheNewFrontier.TomeofKnowledge) == 10 then
					player:setStorageValue(TheNewFrontier.ZaoPalaceDoors, 1)
				elseif player:getStorageValue(TheNewFrontier.TomeofKnowledge) == 7 then
					player:setStorageValue(TheNewFrontier.SnakeHeadTeleport, 1)
				elseif player:getStorageValue(TheNewFrontier.TomeofKnowledge) == 8 then
					player:setStorageValue(TheNewFrontier.CorruptionHole, 1)
				end
				npcHandler:setTopic(playerId, player:getStorageValue(TheNewFrontier.TomeofKnowledge) +20)
			elseif npcHandler:getTopic(playerId) == 13 then -- more then 12 tomes
				player:addExperience(5000, true)
				npcHandler:say("Thank you! I look forward to reading this interesting discovery of yours and learn a few things about {Zao}. Let me share some experience with you.", npc, creature)
				npcHandler:setTopic(playerId, 33)
			end
		else
			npcHandler:say("You dont have one!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "zao")) then
		if npcHandler:getTopic(playerId) == 21 then	--tome1
			npcHandler:say("I've learnt more about the {lizard} culture. It's really fascinating.", npc, creature)
			npcHandler:setTopic(playerId, 40)
		elseif npcHandler:getTopic(playerId) == 22 then	--tome2
			npcHandler:say("I've learnt more about the {minotaur} culture. It's really fascinating.", npc, creature)
			npcHandler:setTopic(playerId, 41)
		elseif npcHandler:getTopic(playerId) == 23 then	--tome3
			npcHandler:say("I've learnt more about the {Draken} culture by now. It's really fascinating.", npc, creature)
			npcHandler:setTopic(playerId, 42)
		elseif npcHandler:getTopic(playerId) == 24 then	--tome4
			npcHandler:say("I've learnt something interesting about a certain {food} that the lizardmen apparently prepare.", npc, creature)
			npcHandler:setTopic(playerId, 43)
		elseif npcHandler:getTopic(playerId) == 25 then	--tome5
			npcHandler:say("I've learnt something interesting about a city called {Zzaion}.", npc, creature)
			npcHandler:setTopic(playerId, 44)
		elseif npcHandler:getTopic(playerId) == 26 then	--tome6
			npcHandler:say("I've learnt a few things about the primitive {human} culture on this continent.", npc, creature)
			npcHandler:setTopic(playerId, 45)
		elseif npcHandler:getTopic(playerId) == 27 then	--tome7
			npcHandler:say("I've learnt something interesting about the Zao {steppe}.", npc, creature)
			npcHandler:setTopic(playerId, 46)
		elseif npcHandler:getTopic(playerId) == 28 then	--tome8
			npcHandler:say("I've learnt a few things about an illness, or how I prefer to call it, {corruption} of this land.", npc, creature)
			npcHandler:setTopic(playerId, 47)
		elseif npcHandler:getTopic(playerId) == 29 then	--tome9
			npcHandler:say("I've learnt something interesting about the Draken {origin}.", npc, creature)
			npcHandler:setTopic(playerId, 48)
		elseif npcHandler:getTopic(playerId) == 30 then	--tome10
			npcHandler:say("This book actually IS about Zao. Not about the continent, but about the mythical {founder} of the lizard dynasty.", npc, creature)
			npcHandler:setTopic(playerId, 49)
		elseif npcHandler:getTopic(playerId) == 31 then	--tome11
			npcHandler:say("I've learnt something interesting about {dragons} and their symbolism.", npc, creature)
			npcHandler:setTopic(playerId, 50)
		elseif npcHandler:getTopic(playerId) == 32 then	--tome12
			npcHandler:say("The last tome contained a lot of information about status symbols and insignia - such as {thrones} - and reveals some of the power structures in Zao.", npc, creature)
			npcHandler:setTopic(playerId, 51)
		elseif npcHandler:getTopic(playerId) == 33 then	--more than tome12
			npcHandler:say("I've learnt many things from your books. Still, I guess that's just a fragment of what I could still discover about this interesting continent.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "lizard")) then --tome1
		if npcHandler:getTopic(playerId) == 40 then
			npcHandler:say({
				"Did you know that the lizardmen were among the first races roaming this continent? They were waging war against the orcs, minotaurs and humans on Zao and for a long time it seemed that the forces were even. ...",
				"However, a while later, also a race of dragons arrived on this continent. Seeing the lizards as distant relatives, they decided to support their war, and together they drove all other races back into the steppe. ...",
				"It turned out though that the dragonkin didn't really view the lizards as allies but as servants and demanded gold and slaves for their help. Part of the lizard population agreed and obeyed their new masters, the others stirred up a violent rebellion. ...",
				"It doesn't really say what happened afterwards, but in the book were also pictures of special symbols the lizards use for their flags and banners. I've given this to Pompan. Maybe he can find a way to use it."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "minotaur")) then --tome2
		if npcHandler:getTopic(playerId) == 41 then
			npcHandler:say({
				"Did you know that most of the minotaurs you might have met by now do not originally come from Zao? The original minotaur race stood no chance against the united force of dragons and lizards. ...",
				"Most of them were killed and captured, but a few of them were able to flee the continent. They found other minotaurs, mighty Mooh'Tah masters, and told them their story. ...",
				"The Mooh'Tah masters actually found the continent Zao and started to look for their lost brothers, but it doesn't say whether they actually found any survivors. ...",
				"In the tome, there was also a really nice pattern of a carrying device that might have been used by minotaurs. Or maybe by enemies of minotaurs. I've given it to Pompan. ...",
				"Maybe he can find a way to use it... we dwarfs are not that skilled when it comes to fashion."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "draken")) then --tome3
		if npcHandler:getTopic(playerId) == 42 then
			npcHandler:say({
				"According to what I've read in that tome, the Draken seem to be a crossbreed between lizards and dragons, combining the dragons' strength with the lizards' swiftness. They seem to be the main figures in the dragons' internal quarrels. ...",
				"They can't fly and are stuck with walking on two feet, but else they combine the best of two worlds - they are intelligent, powerful and both strong magic users and skilled weapon wielders. ...",
				"Have you been to one of their settlements yet? They seem to have really beautifully adorned weapon racks. I've given a construction plan of such a rack to Esrik. Maybe he can recreate it."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "food")) then --tome4
		if npcHandler:getTopic(playerId) == 43 then
			npcHandler:say({
				"I discovered an interesting recipe in this Tome of Knowledge. Maybe you've seen the large rice terraces in Muggy Plains - that is how the lizardmen apparently call that region. ...",
				"The book is a lot of blabla about how they cultivate and harvest their rice, but there's something we could actually learn, and that is a certain way to prepare that rice. ...",
				"If you ever come across a ripe rice plant, bring it to Swolt in the tavern and he might help you prepare it - grumpily."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "zzaion")) then --tome5
		if npcHandler:getTopic(playerId) == 44 then
			npcHandler:say({
				"Have you ever seen the towers of the large lizard city south-east of Zao? It's the last one south of the mountains and who knows how long they are able to hold it. ...",
				"It's under constant and heavy siege by the steppe orcs and minotaurs. Sometimes they manage to crush the gates and storm the city. Watch out, you probably don't want to stumble right into the middle of a war. Or maybe you do? ...",
				"Anyway, I found another nice pattern in this book. It's for a lizard carrying device. I've given it to Pompan, just in case you're interested."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "human")) then --tome6
		if npcHandler:getTopic(playerId) == 45 then
			npcHandler:say({
				"Well, to be honest it doesn't say much about humans in this book. However, it seems that the humans on this continent used to live in the steppe. ...",
				"In the great war against dragons and lizards, they didn't stand the slightest chance due to lack of equipment and well, let's face it, intelligence. The other races were superior in every way. ...",
				"They were driven back into the mountains and survived by growing mushrooms, collecting herbs and probably hunting smaller animals. Today, the orcs pose a major threat to them, so I guess they need every help they can possibly get. ...",
				"Anyway! The humans seem to make a so-called 'great hunt' now and then, and for that they play war instruments. If you're interested in drums or a didgeridoo and want to trade, let me know. I've recreated a few, they don't actually sound bad!"
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "steppe")) then --tome7
		if npcHandler:getTopic(playerId) == 46 then
			npcHandler:say({
				"Maybe you don't know that the great steppe was once a fertile ground. Well, to be precise - in the distant past it probably did not look any different from what it looks today. ...",
				"But when the lizard civilisation was at its peak, they apparently developed advanced irrigation systems to water the steppe and used this area as major source for their supplies on rice and other food. ...",
				"Back in those times, the lizard population was immense and their need of supplies tremendous. Therefore, they did not allow other races to co-exist and exterminated most of them almost completely. ...",
				"Some relics of the settlements of the pre-lizard cultures can still be found. Most of them were probably converted by the victorious lizardmen into something that suited their purposes better. ...",
				"All that talk about relics reminds me about something I've recently seen when getting some fresh air up in the mountains. Right next to the carpet pilot - may earth protect me from ever having to step on that thing - was an old lizard relic. ...",
				"Incredible how far their realm might have stretched at the peak of their civilisation! Time left its marks on the relic and I suppose it looks rather dangerous, but I am convinced that it is safe. You should try it out sometime."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "corruption")) then --tome8
		if npcHandler:getTopic(playerId) == 47 then
			npcHandler:say({
				"You know, while all this talk about growing and preparing rice might sound boring, there are actually some bits of vital information hidden in all those lists. ...",
				"It seems that not only the loss of the southern area hampered the rice harvest of the lizards. ...",
				"Ever since the dragon kings established their reign, the harvest constantly got worse. And this is not all! It's reported that everything that is growing in this land experienced a fertility decrease. ...",
				"Even the lizards themselves seem to suffer from a population decline. It's widely blamed to a plague that ravaged the land in the past, but that seems unlikely given the fact that also plants and various animals were affected. ...",
				"Additionally, several plants changed in shape and became poisonous or toxic. Also, some new-born lizards seem to be affected by this. ...",
				"According to the descriptions, I'd call them mentally unstable, but their people see them as 'blessed by the dragon emperor'. I assume there are strange forces at work in this land, and I have a bad feeling about it. ...",
				"Anyway, you know what else was mentioned in this book? A path down to a hidden cave system below the Muggy Plains. ...",
				"Apparently, at first this system was used to hide - or rather to get rid of - new-born lizards that carried the sign of corruption - before the lizards decided to view it as a blessing. ...",
				"Who knows what happens down there now - maybe it's worth a look, maybe not. Maybe you won't even discover anything. In any case, be careful."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "origin")) then --tome9
		if npcHandler:getTopic(playerId) == 48 then
			npcHandler:say({
				"I think the origin of the Draken sheds some new light on certain aspects of the lizard society. It is obvious from the books that the Draken appeared only after the dragon kings revealed themselves to the lizards. ...",
				"It is specifically mentioned that the tide of the battle turned when they joined the army of the lizards. Parts of the tome were obviously erased and later overwritten. ...",
				"In the parts of the original text that I was able to reconstruct with the help of some alchemy, there were some references to lizard spawns that were sighted in the Tiquanda area and linked to the snake god. ...",
				"Admittedly, it is just a hypothesis that is based on a few hints in these tomes and my correspondence about serpent spawns with the sage Edowir... ...",
				"...However, considering everything that I could figure out about their origin, they seem to hatch from the same eggs like ordinary lizardmen. ...",
				"It seems that some of those eggs are imbued with spiritual or magical power and as a result bear a serpent spawn. It appears that this changed when the dragon emperor became the ruler of this land. ...",
				"Unlike serpent spawns, the Draken hatched from some of the eggs in the hatcheries. ...",
				"I can only imagine what this might imply. As I said, it's only a theory, but I think a quite valid one and I'd treasure any additional information about that topic. ...",
				"In the meantime, I've also talked to Esrik about some information that I found in the tome concerning weaponry and armory. Knowing this dwarf, he might have some interesting offers for you by now."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "founder")) then --tome10
		if npcHandler:getTopic(playerId) == 49 then
			npcHandler:say({
				"It seems that some parts of the tome are just copies from other sources and rather unrelated to each other. As far as I could piece them together, there was a mythical founder of the lizard civilisation. ...",
				"His name was Zao and his deeds and exploits are immortalised in lizard folklore. Some of the earliest records in the tomes suggest a slightly different story though. ...",
				"Many records talk about an early lizard dynasty, but I doubt that Zao was a single person born into that dynasty. ...",
				"My guess is that several members of this dynasty are responsible for or connected to the feats that were attributed to the mythical 'Zao'. ...",
				"The improbable lifespan of 'Zao' can thus be explained with the time the Zao dynasty reigned. On the other hand, we all know larger-than-life heroes did exist and some of them had an extremely long lifespan. ...",
				"Most likely, he also had children which could explain the mentioning of a Zao family. I think even the lizardmen don't know for sure what happened in such distant past and so this might be one of those riddles that will never be solved. ...",
				"It seems that the origin of the Zao dynasty was somewhere in the Dragonblaze Peaks, or rather under them. Legends tell of a large fortress, once erected up the highest peak, but now buried deep underground. Who knows, maybe you'll find answers there?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "dragons")) then --tome11
		if npcHandler:getTopic(playerId) == 50 then
			npcHandler:say({
				"Dragons are of great symbolism for this land. Even before the dragons came here and took control over Zao, the lizards worshipped the dragons as strong mythical beasts. ...",
				"When the future dragon kings came here - seemingly from a distant and foreign land - they probably took some advantage of this cult. ...",
				"Another symbol - that of the snake - that must have been much more popular than the dragon, faded into unimportance over the years. ...",
				"I think in the past, the lizardmen of this country might have worshipped a snake god or goddess just like their brethren in Tiquanda if we can believe the reports from this area. The dragons replaced the snake worship at some point of history. ...",
				"The reference to heretics and their extermination suggests that there might have been a rebellion against the dragons, which in turn hints at some close link between lizards and dragons, maybe a forced one. ...",
				"While reading this tome, I discovered a drawing of this beautiful statue. I was a skilled sculptor in the past, so I can't resist. ...",
				"I'm probably not that good anymore, but if you're interested and find me a red lantern, I could make one of those for you."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "thrones")) then --tome12
		if npcHandler:getTopic(playerId) == 51 then
			npcHandler:say({
				"In the modern lizard culture thrones seem to be only a reminiscent of the past. Whereas in the past the rulers of the lizardmen used thrones and other insignia to show their status, in our days they are ruled by dragon kings. ...",
				"Those kings seem to be massive dragons of immense power. Of course they do not actually 'use' thrones anymore, but claim them nonetheless as symbol for their position. ...",
				"From what I can tell, the lizards are bound to those dragon kings by some kind of magic. I'm not sure what this magic does, but I guess it ensures their loyalty to some extent. ...",
				"On an interesting side note - there were some hints in the tome that the dragon kings themselves are somehow bound to the dragon emperor through the same kind of magic. ...",
				"It seems this kind of liege system was formed sometime after the arrival of the dragons in this land. It's definitely an interesting field of research and shows us how much we still have to learn and to discover. ...",
				"Well, I've certainly learnt how the great old thrones look like. If you bring me some red cloth, I could probably try and reconstruct one for you."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "lantern") then
		if player:getStorageValue(TheNewFrontier.TomeofKnowledge) >= 11 then
		 	npcHandler:say("Have you brought me a red lantern for a dragon statue?", npc, creature)
			npcHandler:setTopic(playerId, 65)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 65 then
		if player:removeItem(10289, 1) then
			player:addItem(10216,1)
			npcHandler:say("Let's put this little lantern here.. there you go. I wrap it up for you, just unwrap it in your house again!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You don't have a red lantern.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "cloth") then
		if player:getStorageValue(TheNewFrontier.TomeofKnowledge) >= 12 then
		 	npcHandler:say("Have you brought me a piece of red cloth? I can make that throne for you if you want. But remember, I won't do that all the time - so try and don't destroy it, okay?", npc, creature)
			npcHandler:setTopic(playerId, 66)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 66 then
		if player:removeItem(5911, 1) then
			player:addItem(10288,1)
			npcHandler:say("Let's put this cloth over the seat.. there you go. I wrap it up for you, just unwrap it in your house again!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You don't have a red cloth.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "crest") then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 336 or 335) and player:getItemCount(10199) > 0 then
		 	npcHandler:say("Oh, wow! Now THAT is an interesting relic! Can I have that serpent crest?", npc, creature)
			npcHandler:setTopic(playerId, 60)
		elseif player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 336 or 335) and player:getItemCount(10198) > 0 then
			npcHandler:say("Oh, wow! Now THAT is an interesting relic! Can I have that tribal crest?", npc, creature)
			npcHandler:setTopic(playerId, 61)
		else
			npcHandler:say("You don't have a Warmaster Outfit or the crest to get the Addons.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) >= 60 and npcHandler:getTopic(playerId) <= 61 then
		if npcHandler:getTopic(playerId) == 60 then
			if not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 336 or 335, 1) and player:removeItem(10199, 1) then
				player:addOutfitAddon(335, 1)
				player:addOutfitAddon(336, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say("Thank you! Let me reward you with something I stumbled across recently and which might fit your warmaster outfit perfectly.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have a crest or already have this Outfitaddon.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 61 then
			if not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 336 or 335, 2) and player:removeItem(10198, 1) then
				player:addOutfitAddon(335, 2)
				player:addOutfitAddon(336, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say("Thank you! Let me reward you with something I stumbled across recently and which might fit your warmaster outfit perfectly.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have a crest or already have this Outfitaddon.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(TheNewFrontier.TomeofKnowledge) < 6 then
		npcHandler:say("Sorry, I don't have items to trade now.", npc, creature)
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_SENDTRADE, "Keep in mind you won't find better offers here. Just browse through my wares.")

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
