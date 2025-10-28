local internalNpcName = "Gerimor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 144,
	lookHead = 60,
	lookBody = 22,
	lookLegs = 24,
	lookFeet = 32,
	lookAddons = 2,
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player then
		npcHandler:setMessage(MESSAGE_GREET, "Greeting, |PLAYERNAME|! I welcome you to this sacred {place}. If you are interested in {missions} just ask.")
	end

	return true
end

-- Keywords
keywordHandler:addKeyword({ "place" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "This place is a sanctuary of Crunor and provides me with a opportunity of spiritual contemplation.",
})

keywordHandler:addKeyword({ "me" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"I'm a member of a circle of persons, that joined wisdom and resources for a common purpose. Let's say, we have an eye on the greater picture in the matters of our world. ...",
		"We are watching and evaluating what is happening in our world.	Trying to avert the worst and offering a helping hand where we deem it needed. ...",
		"We usually avoid to interfere directly in the affairs of the world and vain politics are not our concern at all.",
	},
})

keywordHandler:addKeyword({ "circle" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We focus our interest on this we see as threatening for live and the laws of nature itself.",
})

keywordHandler:addKeyword({ "persons" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Well, while I focus more on the matters of life, some of my peers have different approaches and emphasize other aspects of the world more in their observations. ...",
		"Regardless we share a common goal of balance and harmony.",
	},
})

keywordHandler:addKeyword({ "approaches" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We might not be many but we are diverse. Our rather informal order came together in the dawn of time, when the wars of the gods ravaged the world.",
})

keywordHandler:addKeyword({ "dawn" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Even we know the individual that was somewhat of our funder, only as the wise man. ...",
		"He was the first to bring bright and dedicated minds together, to bring at least a little order and guidance into troubled and chaotic times. ...",
		"The order predates mankind and never bothered to give itself a name. Such assumptions of pretence and vanity have no place in our mindset.",
	},
})

keywordHandler:addKeyword({ "guidance" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Most times we are silent watchers and keeper of knowledge that share what they have learned with each other. We are more concerned about knowledge and wisdom and power means little to us. ...",
		"To solve problems we usually try to convince the right people to do the right thing. We usually even lack the means for a more direct interference.",
	},
})

keywordHandler:addKeyword({ "direct" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Sometimes it's necessary to do something about a situation that became threatening to the world itself. ...",
		"It is gladly a rare occurrence and usually it is sufficient to somewhat offer a guiding hand to avert a course that would lead to more dire consequences. Nonetheless sometimes we have to interfere.",
	},
})

keywordHandler:addKeyword({ "interfere" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Interference comes in different forms. In this particular case there is sadly little time for subtlety and a more direct approach is necessary.",
})

keywordHandler:addKeyword({ "feyrist" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The fae granted me permission to enter their hidden realm. As a druid I'm in close touch with nature so I could gain their trust. The nature spirits are inhabiting this peninsula for ages.",
})

keywordHandler:addKeyword({ "fae" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The fae vary greatly in size and appearance. There are different kinds of fae like fauns, pixies, pookas, swan maidens, nymphs and boogies. Those mystical creatures are wielding power in magic and elementals. ...",
		"Most of them are rather reclusive and live peaceful lives in their secret realm. Sometimes they are called the 'children of dreams' or 'the dream born' because the fae are born from the mortals' dreams.",
	},
})

keywordHandler:addKeyword({ "fauns" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Fauns are half-human, half-beast nature spirits inhabiting the woods and mountains of Feyrist. They are a slightly roguish but cheerful folk, lovers of wine and dancing. ...",
		"Fauns show a youthful and graceful aspect but they are also brave and fearless when it comes to defend themselves. As Maelyrra told me, they emerge from mortals' dreams about celebrations, music and dancing. ...",
		"Lately, some fauns on Feyrist are tainted by the mysterious, sinister force that is threatening Feyrist as well as the rest of Tibia.",
	},
})

keywordHandler:addKeyword({ "pixies" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Pixies are small nature spirits and mythical creatures inhabiting the forests and plains of Feyrist. They are generally benign, but at times, they may also display mischievous traits. ...",
		"Like most of the fae, pixies love dancing and are often gathering in larger groups to dance on secluded glades. Pixies love flowers, butterflies, shimmering beetles, gems and other colourful things. ...",
		"They also love the taste of honey, sweetened oat and ripe grapes. As Maelyrra told me, pixies emerge from mortals' dreams about friends and family.",
	},
})

keywordHandler:addKeyword({ "pookas" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Pookas are nature spirits in animal form, looking like big hares with a faintly glittering fur. They are benign but mischievous, for sure with good reason regarded as the tricksters among the fae. ...",
		"Pookas love to play pranks on others, snitching and hiding things or telling made-up stories. They are capricious and fickle creatures. Pookas emerge from mortals' dreams about gems, treasures and gold. ...",
		"Lately, some pookas on Feyrist are tainted by a mysterious, sinister force that is threatening Feyrist as well as the rest of Tibia.",
	},
})

keywordHandler:addKeyword({ "swan maidens" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Swan maidens are fae who can shapeshift from human form to swan form. The magical item allowing this transformation is a swan feather cloak, a garment with swan feathers attached. ...",
		"Here on Feyrist it is always hard to tell whether a swan swimming on a lake is an ordinary animal or a swan maiden in her bird shape. ...",
		"They protect the wilds of their secret realm from every intruder and live in small flocks along secluded lakeshores. As Maelyrra told me, swan maidens emerge from mortals' dreams about flying.",
	},
})

keywordHandler:addKeyword({ "nymphs" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Nymphs are female nature spirits and usually take the form of beautiful, young maidens who love to dance and sing. They dwell in the hills and forests of Feyrist, often near lakes and streams and they can't die of old age nor illness. ...",
		"They have a special, strong bond to the plants and animals of their domain and are very protective of Feyrist's flora and fauna. As Maelyrra told me, nymphs emerge from mortals' dreams about love.",
	},
})

keywordHandler:addKeyword({ "boogies" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Boogies are a rather twisted kind of fae. Other than pixies, nymphs or fauns they favour underground caves and tunnels over forests or lush meadows. ...",
		"Only at night, they are roaming the surface, chasing other fae and visitors to Feyrist alike. They were once clumsy yet peaceful fae, but they are now twisted and tainted by a mysterious, sinister force.",
	},
})

keywordHandler:addKeyword({ "maelyrra" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"She's the queen of a fae court. You can find her on a glade in the deep forest. It was queen Maelyrra who granted me permission to stay here in Feyrist. ...",
		"I promised to inform her about anything I find out about the abominable force that threatens this world.",
	},
})

keywordHandler:addKeyword({ "fae court" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The fae vary greatly in size and appearance. There are different kinds of fae like fauns, pixies, pookas, swan maidens, nymphs and boogies. Those mystical creatures are wielding power in magic and elementals. ...",
		"Most of them are rather reclusive and live peaceful lives in their secret realm. Sometimes they are called the ,children of dreams' or ,the dream born' because the fae are born from the mortals' dreams.",
	},
})

keywordHandler:addKeyword({ "cults" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"It doesn't seem that the cults share a common theme or object of reverence but there has to be some connection beyond being at the centre of culminations of disruptive power from beyond. ...",
		"The connection is of second thought though. Connected or not, they further the death of our world. That alone makes it imperative to dig those cults out and destroy their cores. ...",
		"We won't be able to rout our each and any movement but if we manage to neutralize the worst, we gain some time and deny the enemy much of its leverage on the future of our world.",
	},
})

keywordHandler:addKeyword({ "worst" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"We have located some of the worst culminations of otherworldly presence and our sources returned information about them with different results of success. ...",
		"Some information I can provide you will be rather sparse and much is left to speculation but you should have at least some lead where to go and investigate.",
	},
})

keywordHandler:addKeyword({ "investigate" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Those cults have to be stopped by any means possible. These are desperate times and they demand desperate actions.",
})
keywordHandler:addKeyword({ "actions" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Spare lives where you see it fit but the cults may not be allowed to exist and disrupt the fabric of the world even more.",
})
keywordHandler:addKeyword({ "fabric" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The weakened fabric of our reality still repels the unnatural intruder. The cults provide the thing a hold and supply it with more power, even if we couldn't figure out yet, how this works at all.",
})

keywordHandler:addKeyword({ "works" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"We haven't completely figured out what our enemy exactly is. For one, this thing defies all laws of nature and comprehension, ...",
		"that understanding it is either impossible or twist a mind in ways that are not meant to be. Also the Yalahari who figured out way too much about the thing, became tainted and changed by this knowledge ...",
		"And ultimately not only fell and became his, they also provided the thing with something of their own, be it knowledge, understanding or even direction, purpose. ...",
		"In some way their tainted knowledge brought the unthinkable into a resemblance of existence. ...",
		"That is why we cant dabble too much in figuring this out and rather concentrate on our fight to severe its ties to our world.",
	},
})

keywordHandler:addKeyword({ "ties" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I have several missions available that deal with servering the ties of the corrupting influence on our world.",
})

local config = {
	missions = {
		["minotaurs"] = {
			text = {
				"This is an animal-like cult. Only minotaurs can be found there, but no idea what there are expecting and what they are worshipping. ...",
				"Maybe they are a bit different to the creatures you already know. Would you like to dinf out more for me?",
			},
			completeText = {
				"You have found the source of power which strengthened the minotaurs. Thanks a lot! Here your reward.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission,
			value = 5,
			rewardExp = 25000,
		},
		["prosperity"] = {
			text = {
				"The alleged incentive to follow this cult is infinite prosperity. Therefore most of the worshippers are already very rich citizens of Tibia. ...",
				"This cult is abandoned in the recently opened new museum in Thais. This can be entered in the Thais exhibition. Would you like to have a look at this cult?",
			},
			completeText = {
				"Thanks a lot. As I already supposed the museum is just a disguise. ...",
				'You found out the true meaning. As you have described their cult object the AM on the floor might stand for "Aurea Manus". Here is your reward for your effort.',
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.MotA.Mission,
			value = 14,
			rewardExp = 50000,
		},
		["barkless"] = {
			text = {
				"However, recently they became more prominent as their leader seems to hava taken a turn for the worse. Rumors of violent acts and disappearing people are linked to this cult. ...",
				"Someone... Should look into that, don't you think?",
			},
			completeText = {
				"The Penitent, thats what they called him? If their spiritual leader and creator of this following changed so radically...",
				"Something far more dangerous must have stood behind this.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Barkless.Mission,
			value = 6,
			rewardExp = 50000,
		},
		["orcs"] = {
			text = {
				"Several Edron orcs have taken to a dangerous idol it seems. It may not be too late to stop them if you act quickly. A powerful cult of orcs with a broad following could prove unsurmountable in the end. ...",
			},
			completeText = {
				"That was no god - yet you rid the world of a being which, without the help of one, would not even have been here in the first place. Nicely done.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Orcs.Mission,
			value = 2,
			rewardExp = 25000,
		},
		["life"] = {
			text = {
				"Its worshippers wish for eternal, life free of pain and sorrow. The entrance to this cult can be found in the dark pyramid. Would you life to investigate it for me?",
			},
			completeText = {
				"Thanks a lot. You have revealed the mystery of this cult and killed the sandking. ...",
				"The signature AM you have seen, could stand for 'Aeterna Exsistentia' regarding the eternal life. As a reward I give this to you.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Life.Mission,
			value = 9,
			rewardExp = 50000,
		},
		["misguided"] = {
			text = {
				"There's a camp of outlaws to the east of Thais. Rumour has it that people are going missing but it's not linked to the bandits. ...",
				"Lights have been seen at night in the abandoned ruin in the vicinity of the camp, somewhere to the south-west. Brave enough to check it out?",
			},
			completeText = {
				"So the leader of these... Misguided was actually controlled and not the other way round? Whatever is behind all this, that's some first-rate irony right there.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission,
			value = 4,
			rewardExp = 50000,
		},
		["humans"] = {
			text = {
				"It's a forbidden and abandoned place but... There is an ancient temple of Zathroth beneath Carlin. Some say it's not that abandoned anymore. ...",
				"Voices, flickering lights in the dead of night, and even a strange gate like sphere wich leads to who knows where. I can't really request this from you but... Someone should take a look, or not?",
			},
			completeText = {
				"Zathroth wasn't behind this after all. That's good... what's not good is that we have to deal with an unknown power now, let's hope for the best.",
			},
			storage = Storage.Quest.U11_40.CultsOfTibia.Humans.Mission,
			value = 2,
			rewardExp = 25000,
		},
	},
}

local storage = {}
local value = {}
local rewardExperience = {}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "missions") then
		if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission) > 2 then
			npcHandler:say("You have already fulfilled your job to my full satisfaction. The cults are investigated and the final boss is eliminated. I have nothing more for you to do. Fare you well!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif
			player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.Mission) == 6
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Life.Mission) == 10
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 15
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Barkless.Mission) == 7
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission) == 5
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Orcs.Mission) == 3
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Humans.Mission) == 3
			and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission) < 2
		then
			npcHandler:say({
				"Your actions have weakened the worldly anchors of the enemy and unveiled the source they use to strengthen their cults. ...",
				"Our circle has used this opportunity to breach their protective shroud and aim a teleporter to this source. I would like to ask you to use it, to travel to this source and destroy it. ...",
				"But be warned, you will need a group twice as great compared to those with which you defeated the cults. Go now, with my blessings.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
			if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission) < 1 then
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission, 1)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.AccessDoor, 1)
			end
		elseif player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission) == 2 then
			npcHandler:say({
				"You have done our world a great favour and reason enough to be proud of yourself. ...",
				"Although we could not rout out each and every cult and they will soon find another source to fuel their evil, we have dealt the enemy a vital blow that will take time and resources to recouperate from. ...",
				"You have undoubtedly bought your world some valuable time and weakened the enemy. Take my thanks in behalf of the world and keep up your heroic work. For your reward you must have two free slots. Are you ready to receive it?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		local missionsTable = config.missions[message:lower()]
		if missionsTable then
			storage[playerId] = missionsTable.storage
			value[playerId] = missionsTable.value
			rewardExperience[playerId] = missionsTable.rewardExp
			if player:getStorageValue(storage[playerId]) > 0 and player:getStorageValue(storage[playerId]) == value[playerId] then
				npcHandler:say(missionsTable.completeText, npc, creature)
				player:setStorageValue(storage[playerId], player:getStorageValue(storage[playerId]) + 1)
				player:addExperience(rewardExperience[playerId])
				player:sendTextMessage(MESSAGE_EXPERIENCE, "You gained " .. rewardExperience[playerId] .. " experience points.")
				npcHandler:setTopic(playerId, 0)
			elseif player:getStorageValue(storage[playerId]) > 0 and player:getStorageValue(storage[playerId]) > value[playerId] then
				npcHandler:say("You already done this mission.", npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say(missionsTable.text, npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(storage[playerId]) < 1 then
				npcHandler:say("Very nice! Come back if you have found what's going on in this cult.", npc, creature)
				player:setStorageValue(storage[playerId], 1)
				if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Questline) < 1 then
					player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Questline, 1)
				end
				npcHandler:setTopic(playerId, 2)
			elseif player:getStorageValue(storage[playerId]) > 0 then
				npcHandler:say("You have not finished your work yet. Come back when you're done.", npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			local vocationRewards = {
				[VOCATION.BASE_ID.SORCERER] = { itemId = 26190, itemName = "reflecting crown" },
				[VOCATION.BASE_ID.DRUID] = { itemId = 26187, itemName = "leaf crown" },
				[VOCATION.BASE_ID.PALADIN] = { itemId = 26189, itemName = "incandescent crown" },
				[VOCATION.BASE_ID.KNIGHT] = { itemId = 26188, itemName = "iron crown" },
				[VOCATION.BASE_ID.MONK] = { itemId = 50313, itemName = "sensing crown" },
			}
			local vocationId = player:getVocation():getBaseId()
			local reward = vocationRewards[vocationId]
			local item = ""
			if reward then
				player:addItem(reward.itemId)
				item = reward.itemName
			end
			player:addExperience(50000)
			player:addItem(26186)
			player:addAchievement("Corruption Contained")
			player:sendTextMessage(MESSAGE_EXPERIENCE, "You gained 50000 experience points.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained a mystery box.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained a " .. item .. ".")
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.FinalBoss.Mission, 3)
			npcHandler:say("Here's your reward. Thank you and farewell!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("What a pitty! You can come back, when ever you want, if you have changed your opinion.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
