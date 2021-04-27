local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local fire = Condition(CONDITION_FIRE)
fire:setParameter(CONDITION_PARAM_DELAYED, true)
fire:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
fire:addDamage(25, 9000, -10)

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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.SecretService.Quest, 1)
			npcHandler:say('I am still a bit sceptical, but well, welcome to the girls brigade.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			if player:removeItem(8190, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission01, 2)
				player:setStorageValue(Storage.SecretService.Quest, 3)
				npcHandler:say('How unnecessarily complicated, but that\'s the way those Thaians are. In the end we got what we wanted and they can\'t do anything about it.', cid)
			else
				npcHandler:say('Bring me the spellbook.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(7736, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission02, 2)
				player:setStorageValue(Storage.SecretService.Quest, 5)
				npcHandler:say('I think the druids will be pleased to hear that the immediate threat has been averted.', cid)
			else
				npcHandler:say('Bring me the heart as proof.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 4 then
			player:setStorageValue(Storage.SecretService.CGBMission03, 3)
			player:setStorageValue(Storage.SecretService.Quest, 7)
			npcHandler:say('Great! This blow strikes them where it hurts most: profit.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(7702, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission04, 2)
				player:setStorageValue(Storage.SecretService.Quest, 9)
				npcHandler:say('I hope our craftsmen can do something with this stuff. For me it makes hardly any sense.', cid)
			else
				npcHandler:say('You need to bring me those plans!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 6 then
			if player:removeItem(7703, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission05, 2)
				player:setStorageValue(Storage.SecretService.Quest, 11)
				npcHandler:say('I will have this correspondence examined by our specialists. I am sure they are quite revealing.', cid)
			else
				npcHandler:say('Bring me back some hints or something!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			if player:removeItem(7704, 1) then
				player:setStorageValue(Storage.SecretService.CGBMission06, 2)
				player:setStorageValue(Storage.SecretService.Quest, 13)
				npcHandler:say('I hope this old book will do those researches any good. Personally I see little use to proof some bloodlines after we cut all ties to Thais.', cid)
			else
				npcHandler:say('You need to bring us that book of family trees!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(7699, 1) then
				player:setStorageValue(Storage.SecretService.Mission07, 2)
				player:setStorageValue(Storage.SecretService.Quest, 15)
				player:addItem(7961, 1)
				npcHandler:say({
				'Excellent. The queen was not amused about this threat. It\'s a good thing that you have saved the city ...',
				'Unfortunately, as we are secret agents we can\'t parade for you or something like that, but let me express our gratitude for everything you have done for our city ...',
				'Take this token of gratitude. You will know when to use it!'
				}, cid)
			else
				npcHandler:say('Please bring me proof of the mad technomancers defeat!', cid)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') then
		npcHandler:say('As you wish.', cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'join') then
		if player:getStorageValue(Storage.SecretService.Quest) < 1 then
			npcHandler:say({
				player:getSex() == PLAYERSEX_FEMALE and
				'The girls brigade is the foremost front on which we fight the numerous enemies of our city ...',
				'It\'s a constant race to stay ahead of our enemies. Absolute loyalty and the willingness to put ones life at stake are attributes that are vital for this brigade ...',
				'If you join, you dedicate your service to Carlin alone! Do you truly think that you are girl enough to join the brigade?'
				or
				'A man in the girls brigade? Come on this is hilarious, this is outright stupid, this is ...',
				'exactly what no one would expect. Mhm, on second thought the element of surprise might offset your male inferiority.',
				'If you join, you dedicate your service to Carlin alone! Do you truly think that you are girl enough to join the brigade?'
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.SecretService.Quest) == 1 and player:getStorageValue(Storage.SecretService.TBIMission01) < 1 and player:getStorageValue(Storage.SecretService.CGBMission01) < 1 then
			player:setStorageValue(Storage.SecretService.Quest, 2)
			player:setStorageValue(Storage.SecretService.CGBMission01, 1)
			npcHandler:say({
			'Our relations with Thais can be called strained at best. Therefore, it\'s not really astounding that the Thaian financed Edron\'s academy but refuse to share some knowledge with our druids ..',
			'But we won\'t accept this so easily. With the help of divination, we learnt that the knowledge our druids are looking for is found in a certain book ...',
			'It will be your task to enter the academy and to steal this book for us.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission01) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 2
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
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission02) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.SecretService.CGBMission02) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 5 then
			player:setStorageValue(Storage.SecretService.Quest, 6)
			player:setStorageValue(Storage.SecretService.CGBMission03, 1)
			player:addItem(7698, 1)
			npcHandler:say({
				'The scheming Venoreans are a constant thorn in our side. They supply our enemies with all kind of equipment to boost the threat they pose to our freedom. It will be your task to hinder future weapon deliveries significantly ...',
				'The druids have supplied us with some exotic bugs. They are called rust bugs and they did not receive this name for their colour ...',
				'Take this box of rust bugs and use them on the keyhole of the smithy in the Ironhouse. These \'pets\' will ruin all metal there and it will take them a while to get rid of them.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission03) == 2 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.SecretService.CGBMission03) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 7 then
			player:setStorageValue(Storage.SecretService.Quest, 8)
			player:setStorageValue(Storage.SecretService.CGBMission04, 1)
			npcHandler:say({
				'Venore has plans for a new kind of ship. It will be faster and more resilient than any other known ship. It will surely improve their dominance over the sea trade. Unless we get those plans for ourselves ...',
				'And this is where you come into play. Find the ship plans in the Venorean shipyard or perhaps at the harbour and bring them here immediately.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission04) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 5
		elseif player:getStorageValue(Storage.SecretService.CGBMission04) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 9 then
			player:setStorageValue(Storage.SecretService.Quest, 10)
			player:setStorageValue(Storage.SecretService.CGBMission05, 1)
			npcHandler:say({
			'Ruins of some ancient cathedral are found south west of Venore. It was a project that the Thaians never finished. However, our scouts reported some suspicious activities there ...',
			'There is a continual coming and going which hints on something big hiding there. We ask you to enter the ruins of the cathedral and to find out what all these people are doing there ...',
			'You might find several hints there, but I am sure you will know exactly when you have found what we are looking for.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission05) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 6
		elseif player:getStorageValue(Storage.SecretService.CGBMission05) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 11 then
			player:setStorageValue(Storage.SecretService.Quest, 12)
			player:setStorageValue(Storage.SecretService.CGBMission06, 1)
			npcHandler:say({
				'As you might know, once the old aristocracy of our city shared blood-ties with the noblemen of Thais. There are many unresolved claims for titles and family heirlooms and Thais does little to help in this matter ...',
				'Therefore, we will take matters into our own hands. There is a grave in the crypts on the Isle of the Kings in which we assume a book containing ancient family histories and family trees ...',
				'We need this book! We will not ask how you acquired it.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 13 then
			player:setStorageValue(Storage.SecretService.Quest, 14)
			player:setStorageValue(Storage.SecretService.Mission07, 1)
			npcHandler:say({
				'I have bad news: a mad dwarf threatens to destroy our beloved city. He claims to have invented some device that enables him to destroy the whole city ...',
				'He has a laboratory somewhere in Kazordoon, probably somewhere near the technomancer hall. Find him and kill him! Bring me his beard as a proof!'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.CGBMission06) == 2 and player:getStorageValue(Storage.SecretService.Mission07) == 1 then
			npcHandler:say('Have you been successful?', cid)
			npcHandler.topic[cid] = 8
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
