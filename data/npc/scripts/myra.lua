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

-- Start
local tiaraKeyword = keywordHandler:addKeyword({'tiara'}, StdModule.say, {npcHandler = npcHandler, text = 'Well... maybe, if you help me a little, I could convince the academy of Edron that you are a valuable help here and deserve an award too. How about it?'}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == -1 end)
	local yesKeyword = tiaraKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler,
		text = {
			'Okay, great! You see, I need a few magical ingredients which I\'ve run out of. First of all, please bring me 70 bat wings. ...',
			'Then, I urgently need a lot of red cloth. I think 20 pieces should suffice. ...',
			'Oh, and also, I could use a whole load of ape fur. Please bring me 40 pieces. ...',
			'After that, um, let me think... I\'d like to have some holy orchids. Or no, many holy orchids, to be safe. Like 35. ...',
			'Then, 10 spools of spider silk yarn, 60 lizard scales and 40 red dragon scales. ...',
			'I know I\'m forgetting something.. wait... ah yes, 15 ounces of magic sulphur and 30 ounces of vampire dust. ...',
			'That\'s it already! Easy task, isn\'t it? I\'m sure you could get all of that within a short time. ...',
			'Did you understand everything I told you and are willing to handle this task?'
		}}
	)

	yesKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Fine! Let\'s start with the 70 bat wings. I really feel uncomfortable out there in the jungle.', reset = true}, nil, function(player) player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak, 1) player:setStorageValue(Storage.OutfitQuest.MageSummoner.MissionHatCloak, 1) player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1) end)
	yesKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Would you like me to repeat the task requirements then?', moveup = 2})

tiaraKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s a pity.', reset = true})
keywordHandler:addAliasKeyword({'award'})

-- When asking for your award before completing your tasks
keywordHandler:addKeyword({'tiara'}, StdModule.say, {npcHandler = npcHandler, text = 'Before I can nominate you for an award, please complete your task'}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) > 0 and player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) < 10 end)
keywordHandler:addAliasKeyword({'award'})

-- What happens when you say task
local function addTaskKeyword(value, text)
	keywordHandler:addKeyword({'task'}, StdModule.say, {npcHandler = npcHandler, text = text}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == value end)
	if value == 10 then
		keywordHandler:addAliasKeyword({'tiara'})
		keywordHandler:addAliasKeyword({'award'})
	end
end

addTaskKeyword(1, 'Your current task is to bring me 70 bat wings, |PLAYERNAME|.')
addTaskKeyword(2, 'Your current task is to bring me 20 pieces of red cloth, |PLAYERNAME|.')
addTaskKeyword(3, 'Your current task is to bring me 40 pieces of ape fur, |PLAYERNAME|.')
addTaskKeyword(4, 'Your current task is to bring me 35 holy orchids, |PLAYERNAME|.')
addTaskKeyword(5, 'Your current task is to bring me 10 spools of spider silk yarn, |PLAYERNAME|.')
addTaskKeyword(6, 'Your current task is to bring me 60 lizard scales, |PLAYERNAME|.')
addTaskKeyword(7, 'Your current task is to bring me 40 red dragon scales, |PLAYERNAME|.')
addTaskKeyword(8, 'Your current task is to bring me 15 ounces of magic sulphur, |PLAYERNAME|.')
addTaskKeyword(9, 'Your current task is to bring me 30 ounces of vampire dust, |PLAYERNAME|.')
addTaskKeyword(10, 'Go to the academy in Edron and tell Zoltan that I sent you, |PLAYERNAME|.')
addTaskKeyword(11, 'I don\'t have any tasks for you right now, |PLAYERNAME|. You were of great help.')

-- Hand over items
local function addItemKeyword(keyword, text, value, itemId, count, last)
	local itemKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text[1]}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == value end)
		itemKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'No, no. That\'s not enough, I fear.', reset = true}, function(player) return player:getItemCount(itemId) < count end)
		local rewardKeyword = itemKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[2]}, nil,
			function(player)
				player:removeItem(itemId, count)
				player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak, player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) + 1)
				player:setStorageValue(Storage.OutfitQuest.MageSummoner.MissionHatCloak, player:getStorageValue(Storage.OutfitQuest.MageSummoner.MissionHatCloak) + 1)
				if not last then
					npcHandler:resetNpc(player.uid)
				end
			end
		)

		if last then
			rewardKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I thought so. Go to the academy of Edron and tell Zoltan that I sent you. I will send a nomination to him. You were really a great help. Thanks again!', reset = true})
			rewardKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Really? Well, if you should change your mind, go to the academy of Edron and tell Zoltan that I sent you. I will send a nomination to him.', reset = true})
		end

		itemKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'That\'s a pity.', reset = true})
	keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text[3]})
end

addItemKeyword('bat wing', {'Oh, did you bring the 70 bat wings for me?', 'Thank you! I really needed them for my anti-wrinkle lotion. Now, please bring me 20 pieces of {red cloth}.', 'I love to say \'creatures of the night\'. Got a dramatic as well as romantic ring to it.'}, 1, 5894, 70)
addItemKeyword('red cloth', {'Have you found 20 pieces of red cloth?', 'Great! This should be enough for my new dress. Don\'t forget to bring me 40 pieces of {ape fur} next!', 'Nice material for a cape, isn\'t it?'}, 2, 5911, 20)
addItemKeyword('ape fur', {'Were you able to retrieve 40 pieces of ape fur?', 'Nice job, player. You see, I\'m testing a new depilation cream. I guess if it works on ape fur it\'s good quality. Next, please bring me 35 {holy orchids}.', 'This feels really smooth.'}, 3, 5883, 40)
addItemKeyword('holy orchid', {'Did you convince the elves to give you 35 holy orchids?', 'Thank god! The scent of holy orchids is simply the only possible solution against the horrible stench from the tavern latrine. Now, please bring me 10 rolls of {spider silk yarn}!', 'I heard that some elves cultivate these flowers.'}, 4, 5922, 35)
addItemKeyword('spider silk', {'Oh, did you bring 10 spools of spider silk yarn for me?', 'I appreciate it. My pet doggie manages to bite through all sorts of leashes, which is why he is always gone. I\'m sure this strong yarn will keep him. Now, go for the 60 {lizard scales}!', 'Only very large spiders produce silk which is strong enough to be yarned. I heard that mermaids can turn spider silk into yarn.'}, 5, 5886, 10)
addItemKeyword('lizard scale', {'Have you found 60 lizard scales?', 'Good job. They will look almost like sequins on my new dress. Please go for the 40 {red dragon scales} now.', 'Lizard scales are great for all sorts of magical potions.'}, 6, 5881, 60)
addItemKeyword('red dragon scale', {'Were you able to get all 40 red dragon scales?', 'Thanks! They make a pretty decoration, don\'t you think? Please bring me 15 ounces of {magic sulphur} now!', 'Red dragon scales are hard to come by, but much harder than the green ones.'}, 7, 5882, 40)
addItemKeyword('magic sulphur', {'Have you collected 15 ounces of magic sulphur?', 'Ah, that\'s enough magic sulphur for my new peeling. You should try it once, your skin gets incredibly smooth. Now, the only thing I need is {vampire dust}. 30 ounces will suffice.', 'Magic sulphur can be extracted from magical weapons. I heard that Djinns are good at magical extractions.'}, 8, 5904, 15)
addItemKeyword('vampire dust', {'Have you gathered 30 ounces of vampire dust?', 'Ah, great. Now I can finally finish the potion which the academy of Edron asked me to. I guess, now you want your reward, don\'t you?', 'The Tibian vampires are quite restistant. I needs a special blessed stake to turn their corpse into dust, and it doesn\'t work all the time. Maybe a priest can help you.'}, 9, 5905, 30, true)

-- Basic
keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = 'This Tiara is an award by the academy of Edron in recognition of my service here.'})

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, |PLAYERNAME|. If you are looking for sorcerer {spells} don\'t hesitate to ask.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell.')

npcHandler:addModule(FocusModule:new())
