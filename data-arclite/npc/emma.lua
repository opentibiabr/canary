local internalNpcName = "Emma"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 139,
	lookHead = 79,
	lookBody = 90,
	lookLegs = 52,
	lookFeet = 15,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
local fire = Condition(CONDITION_FIRE)
fire:setParameter(CONDITION_PARAM_DELAYED, true)
fire:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
fire:addDamage(25, 9000, -10)
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.SecretService.Quest, 1)
			player:addAchievement("Secret Agent")
			npcHandler:say('I am still a bit sceptical, but well, welcome to the girls brigade.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:removeItem(648, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission01, 2)
				player:setStorageValue(Storage.SecretService.Quest, 3)
				npcHandler:say('How unnecessarily complicated, but that\'s the way those Thaians are. In the end we got what we wanted and they can\'t do anything about it.', npc, creature)
			else
				npcHandler:say('Bring me the spellbook.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(652, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission02, 2)
				player:setStorageValue(Storage.SecretService.Quest, 5)
				npcHandler:say('I think the druids will be pleased to hear that the immediate threat has been averted.', npc, creature)
			else
				npcHandler:say('Bring me the heart as proof.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			player:setStorageValue(Storage.SecretService.CGBMission03, 3)
			player:setStorageValue(Storage.SecretService.Quest, 7)
			npcHandler:say('Great! This blow strikes them where it hurts most: profit.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(399, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission04, 2)
				player:setStorageValue(Storage.SecretService.Quest, 9)
				npcHandler:say('I hope our craftsmen can do something with this stuff. For me it makes hardly any sense.', npc, creature)
			else
				npcHandler:say('You need to bring me those plans!', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:removeItem(400, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission05, 2)
				player:setStorageValue(Storage.SecretService.Quest, 11)
				npcHandler:say('I will have this correspondence examined by our specialists. I am sure they are quite revealing.', npc, creature)
			else
				npcHandler:say('Bring me back some hints or something!', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(401, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission06, 2)
				player:setStorageValue(Storage.SecretService.Quest, 13)
				npcHandler:say('I hope this old book will do those researches any good. Personally I see little use to proof some bloodlines after we cut all ties to Thais.', npc, creature)
			else
				npcHandler:say('You need to bring us that book of family trees!', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(396, 1) then
				player:setStorageValue(Storage.SecretService.Mission07, 2)
				player:setStorageValue(Storage.SecretService.Quest, 15)
				player:addAchievement("Top CGB Agent")
				player:addItem(898, 1)
				npcHandler:say({
				'Excellent. The queen was not amused about this threat. It\'s a good thing that you have saved the city ...',
				'Unfortunately, as we are secret agents we can\'t parade for you or something like that, but let me express our gratitude for everything you have done for our city ...',
				'Take this token of gratitude. You will know when to use it!'
				}, npc, creature)
			else
				npcHandler:say('Please bring me proof of the mad technomancers defeat!', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') then
		npcHandler:say('As you wish.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'join') then
		if player:getStorageValue(Storage.SecretService.Quest) < 1 then
			if player:getSex() == PLAYERSEX_FEMALE then
				npcHandler:say({
					"The girls brigade is the foremost front on which we fight the numerous enemies of our city ...",
					"It's a constant race to stay ahead of our enemies. Absolute loyalty and the willingness to put ones life at stake are attributes that are vital for this brigade ...",
					"If you join, you dedicate your service to Carlin alone! Do you truly think that you are girl enough to join the brigade?"
				}, npc, creature)
			else
				npcHandler:say({
					"A man in the girls brigade? Come on this is hilarious, this is outright stupid, this is ...",
					"exactly what no one would expect. Mhm, on second thought the element of surprise might offset your male inferiority. The girls brigade is the foremost front on which we fight the numerous enemies of our city ...",
					"It's a constant race to stay ahead of our enemies. Absolute loyalty and the willingness to put ones life at stake are attributes that are vital for this brigade ...",
					"If you join, you dedicate your service to Carlin alone! Do you truly think that you are girl enough to join the brigade?"
				}, npc, creature)
			end
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.SecretService.TBIMission01) > 0 or player:getStorageValue(Storage.SecretService.AVINMission01) > 0 then
			npcHandler:say("Don't try to fool me. We are perfectly aware to whom you are loyal.", npc, creature)
		end
	elseif MsgContains(message, 'mission') then
		if player:getStorageValue(Storage.SecretService.Quest) == 1 and player:getStorageValue(Storage.SecretService.TBIMission01) < 1 and player:getStorageValue(Storage.SecretService.CGBMission01) < 1 then
			player:setStorageValue(Storage.SecretService.Quest, 2)
			player:setStorageValue(Storage.SecretService.CGBMission01, 1)
			npcHandler:say({
			'Our relations with Thais can be called strained at best. Therefore, it\'s not really astounding that the Thaian financed Edron\'s academy but refuse to share some knowledge with our druids ..',
			'But we won\'t accept this so easily. With the help of divination, we learnt that the knowledge our druids are looking for is found in a certain book ...',
			'It will be your task to enter the academy and to steal this book for us.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission01) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.SecretService.CGBMission01) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 3 then
			player:setStorageValue(Storage.SecretService.Quest, 4)
			player:setStorageValue(Storage.SecretService.CGBMission02, 1)
			npcHandler:say({
				'The druids have asked the brigade for a favour. Given that we heavily rely on their resources and they are important supporters of our cities, we can\'t deny them the request ...',
				'A wandering druid has recently visited the Green Claw Swamp, located north west of that corrupted hell hole Venore. While gathering herbs, he noticed some malignant presence in the said area ...',
				'Searching for the source of evil there, he detected some old ruin. Suddenly, he was attacked by bonelords and their undead minions. He barely managed to escape alive ...',
				'The evidence he found let him conclude that the bonelords in the ruins were raising so-called death trees.These trees are full of negative energy and slowly but steadily corrupt their surrounding ...',
				'After the druid\'s return to Carlin, divination confirmed his upsetting assumptions about the existence of these trees ...',
				'Over the years, hundreds have fallen victim to the swamp, conserved by mud and water for eternity. With the help of the death trees, the bonelords strive for an army of undeads. This cannot be tolerated ...',
				'Travel to Green Claw Swamp and rip out the heart out of the master tree. Without it, the unnatural trees will wither soon. Bring me the heart as proof.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission02) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.SecretService.CGBMission02) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 5 then
			player:setStorageValue(Storage.SecretService.Quest, 6)
			player:setStorageValue(Storage.SecretService.CGBMission03, 1)
			player:addItem(350, 1)
			npcHandler:say({
				'The scheming Venoreans are a constant thorn in our side. They supply our enemies with all kind of equipment to boost the threat they pose to our freedom. It will be your task to hinder future weapon deliveries significantly ...',
				'The druids have supplied us with some exotic bugs. They are called rust bugs and they did not receive this name for their colour ...',
				'Take this box of rust bugs and use them on the keyhole of the smithy in the Ironhouse. These \'pets\' will ruin all metal there and it will take them a while to get rid of them.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission03) == 2 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.SecretService.CGBMission03) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 7 then
			player:setStorageValue(Storage.SecretService.Quest, 8)
			player:setStorageValue(Storage.SecretService.CGBMission04, 1)
			npcHandler:say({
				'Venore has plans for a new kind of ship. It will be faster and more resilient than any other known ship. It will surely improve their dominance over the sea trade. Unless we get those plans for ourselves ...',
				'And this is where you come into play. Find the ship plans in the Venorean shipyard or perhaps at the harbour and bring them here immediately.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission04) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(Storage.SecretService.CGBMission04) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 9 then
			player:setStorageValue(Storage.SecretService.Quest, 10)
			player:setStorageValue(Storage.SecretService.CGBMission05, 1)
			npcHandler:say({
			'Ruins of some ancient cathedral are found south west of Venore. It was a project that the Thaians never finished. However, our scouts reported some suspicious activities there ...',
			'There is a continual coming and going which hints on something big hiding there. We ask you to enter the ruins of the cathedral and to find out what all these people are doing there ...',
			'You might find several hints there, but I am sure you will know exactly when you have found what we are looking for.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission05) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif player:getStorageValue(Storage.SecretService.CGBMission05) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 11 then
			player:setStorageValue(Storage.SecretService.Quest, 12)
			player:setStorageValue(Storage.SecretService.CGBMission06, 1)
			npcHandler:say({
				'As you might know, once the old aristocracy of our city shared blood-ties with the noblemen of Thais. There are many unresolved claims for titles and family heirlooms and Thais does little to help in this matter ...',
				'Therefore, we will take matters into our own hands. There is a grave in the crypts on the Isle of the Kings in which we assume a book containing ancient family histories and family trees ...',
				'We need this book! We will not ask how you acquired it.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 13 then
			player:setStorageValue(Storage.SecretService.Quest, 14)
			player:setStorageValue(Storage.SecretService.Mission07, 1)
			npcHandler:say({
				'I have bad news: a mad dwarf threatens to destroy our beloved city. He claims to have invented some device that enables him to destroy the whole city ...',
				'He has a laboratory somewhere in Kazordoon, probably somewhere near the technomancer hall. Find him and kill him! Bring me his beard as a proof!'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 2 and player:getStorageValue(Storage.SecretService.Mission07) == 1 then
			npcHandler:say('Have you been successful?', npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
-- basic
keywordHandler:addKeyword({"queen"}, StdModule.say, {npcHandler = npcHandler, text = "I am privileged to be in service of our beloved queen!"})
keywordHandler:addKeyword({"carlin"}, StdModule.say, {npcHandler = npcHandler, text = "We are proud people who fought hard for their freedom and won't allow others to oppress us again."})
keywordHandler:addKeyword({"service"}, StdModule.say, {npcHandler = npcHandler, text = "I am the head of Carlin's Girls Brigade, also known as CGB."})
keywordHandler:addKeyword({"cgb"}, StdModule.say, {npcHandler = npcHandler, text = {
"The CGB is a patriotic organisation that fights our numerous enemies with means that guards or army do not have at their disposal. ...",
"We work secretly and covertly. We uncover secret plots and we are both the first line of defence of our city and the last. We are joined only by the best of the best."}})
keywordHandler:addKeyword({"avin"}, StdModule.say, {npcHandler = npcHandler, text = {
"The AVIN is rather a crime syndicate than anything else. If there is something dirty and illegal, they are most likely involved. ...",
"They are unscrupulous and also do not back away from blackmailing and assassination."}})
keywordHandler:addKeyword({"tbi"}, StdModule.say, {npcHandler = npcHandler, text = {
"The TBI is as old-fashioned, stubborn and inflexible as only males can be. What makes this bureaucracy somewhat dangerous, is the money they have at their disposal. ...",
"They buy spies and traitors - all of them weak-willed or greedy individuals."}})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I am the head of Carlin's Girls Brigade, also known as CGB."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I am known as Emma."})
keywordHandler:addKeyword({"ab'dendriel"}, StdModule.say, {npcHandler = npcHandler, text = {
"The elves of Ab'Dendriel are our allies. Our druids contribute most to keeping such a good relation. ...",
"They seem to understand the elves a bit better than we ordinary people do."}})
keywordHandler:addKeyword({"thais"}, StdModule.say, {npcHandler = npcHandler, text = "The Thaians never got over the fact that we gained our independence. They do everything they can to hinder the prospering of our city."})
keywordHandler:addKeyword({"venore"}, StdModule.say, {npcHandler = npcHandler, text = "Venore is a hellhole of evil. The trade barons' greed lets them plot against all other cities and even against each other."})
keywordHandler:addKeyword({"svargrond"}, StdModule.say, {npcHandler = npcHandler, text = "Svargrond is an important project for our city. It's not a colony but many of our people live there alongside those barbarians. If everything works out fine, Carlin and Svargrond will both prosper."})
keywordHandler:addKeyword({"ankrahmun"}, StdModule.say, {npcHandler = npcHandler, text = "Strange people with strange customs live in this city. Luckily, we rarely have to deal with them."})
keywordHandler:addKeyword({"darashia"}, StdModule.say, {npcHandler = npcHandler, text = "Darashia never bothers about the affairs of other cities."})
keywordHandler:addKeyword({"liberty bay"}, StdModule.say, {npcHandler = npcHandler, text = {
"The name of the city is a cruel joke. The people there are oppressed by Thais and Venore who slowly bleed the isle and its people white. ...",
"It shows what would have happened to us if our rebellion had failed."}})
keywordHandler:addKeyword({"port hope"}, StdModule.say, {npcHandler = npcHandler, text = "It's just another Thaian puppet. Still, it is distant enough to stand a fair chance to get rid of Thais's oppression one day."})
keywordHandler:addKeyword({"kazordoon"}, StdModule.say, {npcHandler = npcHandler, text = "The dwarfs of Kazordoon usually mind their own business. I wish all other cities would do the same."})
npcHandler:setMessage(MESSAGE_GREET, "HAIL TO THE QUEEN!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE QUEEN! You may leave now!")
-- npcType registering the npcConfig table
npcType:register(npcConfig)
