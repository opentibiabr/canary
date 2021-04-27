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
	if player then
		npcHandler:setMessage(MESSAGE_GREET, "Greeting, |PLAYERNAME|! I welcome you to this sacred {place}. \z
			If you are interested in {missions} just ask.")
		end
	npcHandler:addFocus(cid)
	return true
end

-- Keywords
keywordHandler:addKeyword({"place"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This place is a sanctuary of Crunor and provides me with a opportunity of spiritual contemplation."
	}
)

keywordHandler:addKeyword({"me"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"I'm a member of a circle of persons, that joined wisdom and resources for a common purpose. \z
				Let's say, we have an eye on the greater picture in the matters of our world. ...",
			"We are watching and evaluating what is happening in our world. \z
				Trying to avert the worst and offering a helping hand where we deem it needed. ...",
			"We usually avoid to interfere directly in the affairs of the world and vain politics are not our concern at all."
		}
	}
)

keywordHandler:addKeyword({"circle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We focus our interest on this we see as threatening for live and the laws of nature itself."
	}
)

keywordHandler:addKeyword({"persons"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Well, while I focus more on the matters of life, some of my peers have different approaches \z
				and emphasize other aspects of the world more in their observations. ...",
			"Regardless we share a common goal of balance and harmony."
		}
	}
)

keywordHandler:addKeyword({"approaches"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We might not be many but we are diverse. \z
			Our rather informal order came together in the dawn of time, when the wars of the gods ravaged the world."
	}
)

keywordHandler:addKeyword({"dawn"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Even we know the individual that was somewhat of our funder, only as the wise man. ...",
			"He was the first to bring bright and dedicated minds together, \z
				to bring at least a little order and guidance into troubled and chaotic times. ...",
			"The order predates mankind and never bothered to give itself a name. \z
				Such assumptions of pretence and vanity have no place in our mindset."
		}
	}
)

keywordHandler:addKeyword({"guidance"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Most times we are silent watchers and keeper of knowledge that share what they have learned with each other. \z
				We are more concerned about knowledge and wisdom and power means little to us. ...",
			"To solve problems we usually try to convince the right people to do the right thing. \z
				We usually even lack the means for a more direct interference."
		}
	}
)

keywordHandler:addKeyword({"direct"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Sometimes it's necessary to do something about a situation that became threatening to the world itself. ...",
			"It is gladly a rare occurrence and usually it is sufficient to somewhat offer a guiding hand to \z
				avert a course that would lead to more dire consequences. Nonetheless sometimes we have to interfere."
		}
	}
)

keywordHandler:addKeyword({"interfere"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Interference comes in different forms. \z
			In this particular case there is sadly little time for subtlety and a more direct approach is necessary."
	}
)

keywordHandler:addKeyword({"feyrist"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The fae granted me permission to enter their hidden realm. \z
			As a druid I'm in close touch with nature so I could gain their trust. \z
			The nature spirits are inhabiting this peninsula for ages."
	}
)

keywordHandler:addKeyword({"fae"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"The fae vary greatly in size and appearance. \z
				There are different kinds of fae like fauns, pixies, pookas, swan maidens, nymphs and boogies. \z
				Those mystical creatures are wielding power in magic and elementals. ...",
			"Most of them are rather reclusive and live peaceful lives in their secret realm. \z
				Sometimes they are called the 'children of dreams' or 'the dream born' \z
				because the fae are born from the mortals' dreams."
		}
	}
)

keywordHandler:addKeyword({"fauns"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Fauns are half-human, half-beast nature spirits inhabiting the woods and mountains of Feyrist. \z
				They are a slightly roguish but cheerful folk, lovers of wine and dancing. ...",
			"Fauns show a youthful and graceful aspect but they are also brave and fearless \z
				when it comes to defend themselves. As Maelyrra told me, they emerge from mortals' \z
				dreams about celebrations, music and dancing. ...",
			"Lately, some fauns on Feyrist are tainted by the mysterious, sinister force that is \z
				threatening Feyrist as well as the rest of Tibia."
		}
	}
)

keywordHandler:addKeyword({"pixies"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Pixies are small nature spirits and mythical creatures inhabiting the forests and plains of Feyrist. \z
				They are generally benign, but at times, they may also display mischievous traits. ...",
			"Like most of the fae, pixies love dancing and are often gathering in larger groups \z
				to dance on secluded glades. Pixies love flowers, butterflies, shimmering beetles, \z
				gems and other colourful things. ...",
			"They also love the taste of honey, sweetened oat and ripe grapes. \z
				As Maelyrra told me, pixies emerge from mortals' dreams about friends and family."
		}
	}
)

keywordHandler:addKeyword({"pookas"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Pookas are nature spirits in animal form, looking like big hares with a faintly glittering fur. \z
				They are benign but mischievous, for sure with good reason regarded as the tricksters among the fae. ...",
			"Pookas love to play pranks on others, snitching and hiding things or telling made-up stories. \z
				They are capricious and fickle creatures. \z
				Pookas emerge from mortals' dreams about gems, treasures and gold. ...",
			"Lately, some pookas on Feyrist are tainted by a mysterious, sinister force that is \z
				threatening Feyrist as well as the rest of Tibia."
		}
	}
)

keywordHandler:addKeyword({"swan maidens"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Swan maidens are fae who can shapeshift from human form to swan form. \z
				The magical item allowing this transformation is a swan feather cloak, a garment with swan feathers attached. ...",
			"Here on Feyrist it is always hard to tell whether a swan swimming on a lake \z
				is an ordinary animal or a swan maiden in her bird shape. ...",
			"They protect the wilds of their secret realm from every intruder and live in small \z
				flocks along secluded lakeshores. As Maelyrra told me, swan maidens emerge from mortals' dreams about flying."
		}
	}
)

keywordHandler:addKeyword({"nymphs"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Nymphs are female nature spirits and usually take the form of beautiful, \z
				young maidens who love to dance and sing. They dwell in the hills and forests of Feyrist, \z
				often near lakes and streams and they can't die of old age nor illness. ...",
			"They have a special, strong bond to the plants and animals of their domain and are very \z
				protective of Feyrist's flora and fauna. As Maelyrra told me, nymphs emerge from mortals' dreams about love."
		}
	}
)

keywordHandler:addKeyword({"boogies"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"Boogies are a rather twisted kind of fae. Other than pixies, nymphs or fauns they favour \z
				underground caves and tunnels over forests or lush meadows. ...",
			"Only at night, they are roaming the surface, chasing other fae and visitors to Feyrist alike. \z
				They were once clumsy yet peaceful fae, but they are now twisted and tainted by a mysterious, sinister force."
		}
	}
)

keywordHandler:addKeyword({"maelyrra"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"She's the queen of a fae court. You can find her on a glade in the deep forest. \z
				It was queen Maelyrra who granted me permission to stay here in Feyrist. ...",
			"I promised to inform her about anything I find out about the abominable force that threatens this world."
		}
	}
)

keywordHandler:addKeyword({"fae court"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"The fae vary greatly in size and appearance. \z
				There are different kinds of fae like fauns, pixies, pookas, swan maidens, nymphs and boogies. \z
				Those mystical creatures are wielding power in magic and elementals. ...",
			"Most of them are rather reclusive and live peaceful lives in their secret realm. \z
				Sometimes they are called the ,children of dreams' or ,the dream born' \z
				because the fae are born from the mortals' dreams."
		}
	}
)

keywordHandler:addKeyword({"cults"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"It doesn't seem that the cults share a common theme or object of reverence but there has to \z
				be some connection beyond being at the centre of culminations of disruptive power from beyond. ...",
			"The connection is of second thought though. Connected or not, they further the death of our world. \z
				That alone makes it imperative to dig those cults out and destroy their cores. ...",
			"We won't be able to rout our each and any movement but if we manage to neutralize the worst, \z
				we gain some time and deny the enemy much of its leverage on the future of our world."
		}
	}
)

keywordHandler:addKeyword({"worst"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"We have located some of the worst culminations of otherworldly presence and our sources \z
				returned information about them with different results of success. ...",
			"Some information I can provide you will be rather sparse and much is left to speculation \z
				but you should have at least some lead where to go and investigate."
		}
	}
)

keywordHandler:addKeyword({"investigate"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Those cults have to be stopped by any means possible. \z
			These are desperate times and they demand desperate actions."
	}
)
keywordHandler:addKeyword({"actions"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Spare lives where you see it fit but the cults may not be allowed to exist and disrupt \z
			the fabric of the world even more."
	}
)
keywordHandler:addKeyword({"fabric"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The weakened fabric of our reality still repels the unnatural intruder. The cults provide the \z
			thing a hold and supply it with more power, even if we couldn't figure out yet, how this works at all."
	}
)

keywordHandler:addKeyword({"works"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"We haven't completely figured out what our enemy exactly is. \z
				For one, this thing defies all laws of nature and comprehension, ...",
			"that understanding it is either impossible or twist a mind in ways that are not meant to be. \z
				Also the Yalahari who figured out way too much about the thing, became tainted and changed by this knowledge ...",
			"And ultimately not only fell and became his, they also provided the thing with something of their own, \z
				be it knowledge, understanding or even direction, purpose. ...",
			"In some way their tainted knowledge brought the unthinkable into a resemblance of existence. ...",
			"That is why we cant dabble too much in figuring this out and rather concentrate on our \z
				fight to severe its ties to our world."
		}
	}
)

keywordHandler:addKeyword({"ties"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have several missions available that deal with servering the ties of the corrupting influence on our world."
	}
)

local config = {
	missions = {
		["minotaurs"] = {
			text =  {
				"This is an animal-like cult. Only minotaurs can be found there, \z
					but no idea what there are expecting and what they are worshipping. ...",
				"Maybe they are a bit different to the creatures you already know. Would you like to dinf out more for me?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.Minotaurs.Mission,
			value = 5,
			rewardExp = 25000,

		},
		["prosperity"] = {
			text =  {
				"The alleged incentive to follow this cult is infinite prosperity. \z
					Therefore most of the worshippers are already very rich citizens of Tibia. ...",
				"This cult is abandoned in the recently opened new museum in Thais. \z
					This can be entered in the Thais exhibition. Would you like to have a look at this cult?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.MotA.Mission,
			value = 14,
			rewardExp = 50000,
		},
		["barkless"] = {
			text =  {
				"However, recently they became more prominent as their leader seems to hava taken a turn for the worse. \z
					Rumors of violent acts and disappearing people are linked to this cult. ...",
				"Someone... Should look into that, don't you think?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.Barkless.Mission,
			value = 6,
			rewardExp = 50000,
		},
		["orcs"] = {
			text =  {
				"Several Edron orcs have taken to a dangerous idol it seems. \z
					It may not be too late to stop them if you act quickly. \z
					A powerful cult of orcs with a broad following could prove unsurmountable in the end. ..."
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward.",
				"Are you prepared to investigate?"
			},
			storage = Storage.CultsOfTibia.Orcs.Mission,
			value = 2,
			rewardExp = 25000,
		},
		["life"] = {
			text =  {
				"Its worshippers wish for eternal, life free of pain and sorrow. \z
				The entrance to this cult can be found in the dark pyramid. Would you life to investigate it for me?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.Life.Mission,
			value = 9,
			rewardExp = 50000,

		},
		["misguided"] = {
			text =  {
				"There's a camp of outlaws to the east of Thais. \z
					Rumour has it that people are going missing but it's not linked to the bandits. ...",
				"Lights have been seen at night in the abandoned ruin in the vicinity of the camp, \z
					somewhere to the south-west. Brave enough to check it out?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.Misguided.Mission,
			value = 4,
			rewardExp = 50000,
		},
		["humans"] = {
			text =  {
				"It's a forbidden and abandoned place but... There is an ancient temple of Zathroth beneath Carlin. \z
					Some say it's not that abandoned anymore. ...",
				"Voices, flickering lights in the dead of night, and even a strange gate like sphere wich leads to \z
					who knows where. I can't really request this from you but... Someone should take a look, or not?"
			},
			completeText = {
				"Then you got it. Thank you. Here is your reward."
			},
			storage = Storage.CultsOfTibia.Humans.Mission,
			value = 2,
			rewardExp = 25000,
		}
	}
}

local storage = {}
local value = {}
local rewardExperience = {}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "missions") then
		-- Final boss check
		if player:getStorageValue(Storage.CultsOfTibia.FinalBoss.Mission) > 2 then
			npcHandler:say("You have already fulfilled your job to my full satisfaction. \z
			The cults are investigated and the final boss is eliminated. \z
			I have nothing more for you to do. Fare you well!", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.CultsOfTibia.Minotaurs.Mission) == 6
		and player:getStorageValue(Storage.CultsOfTibia.Life.Mission) == 10
		and player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 15
		and player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) == 7
		and player:getStorageValue(Storage.CultsOfTibia.Misguided.Mission) == 5
		and player:getStorageValue(Storage.CultsOfTibia.Orcs.Mission) == 3
		and player:getStorageValue(Storage.CultsOfTibia.Humans.Mission) == 3
		and player:getStorageValue(Storage.CultsOfTibia.FinalBoss.Mission) < 2 then
			npcHandler:say("It seems to me that you have done all the missions I gave you. \z
				All the cults have been revealed and now you can kill their leader, the final boss, \z
				to save the world from a possible catastrophe.", cid)
			npcHandler.topic[cid] = 0
			if player:getStorageValue(Storage.CultsOfTibia.FinalBoss.Mission) < 1 then
				player:setStorageValue(Storage.CultsOfTibia.FinalBoss.Mission, 1)
				player:setStorageValue(Storage.CultsOfTibia.FinalBoss.AccessDoor, 1)
			end
		elseif player:getStorageValue(Storage.CultsOfTibia.FinalBoss.Mission) == 2 then
			npcHandler:say("You did it! You put an end to the cults, and as a return, here's your reward.", cid)
			npcHandler.topic[cid] = 9
			local item = ""
			if player:getVocation():getClientId() == VOCATION.CLIENT_ID.SORCERER then
				player:addItem(29426)
				item = "reflecting crown"
			end
			if player:getVocation():getClientId() == VOCATION.CLIENT_ID.DRUID then
				player:addItem(29423)
				item = "leaf crown"
			end
			if player:getVocation():getClientId() == VOCATION.CLIENT_ID.PALADIN then
				player:addItem(29425)
				item = "incandescent crown"
			end
			if player:getVocation():getClientId() == VOCATION.CLIENT_ID.KNIGHT then
				player:addItem(29424)
				item = "iron crown"
			end
			player:addExperience(50000)
			player:addItem(29422)
			player:setStorageValue(Storage.CultsOfTibia.FinalBoss.Mission, 3)
			player:sendTextMessage(MESSAGE_EXPERIENCE, "You gained 50000 experience points.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained a mystery box.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gained a " .. item .. ".")
		else
			npcHandler:say("In wich of the following topics are you interested in? Cult of {Life}, \z
				Cult of {Prosperity}, Cult of the {Minotaurs}, Cult of the {Barkless}, Cult of the {Misguided}, \z
				Cult of {Orcs} or Cult of the {Humans}?", cid)
			npcHandler.topic[cid] = 2
		end
	-- General
	elseif npcHandler.topic[cid] == 2 then
		local missionsTable = config.missions[msg:lower()]
		if missionsTable then
			storage[cid] = missionsTable.storage
			value[cid] = missionsTable.value
			rewardExperience[cid] = missionsTable.rewardExp
			if player:getStorageValue(storage[cid]) > 0 and player:getStorageValue(storage[cid]) == value[cid] then
				npcHandler:say(missionsTable.completeText, cid)
				player:setStorageValue(storage[cid], player:getStorageValue(storage[cid]) + 1)
				player:addExperience(rewardExperience[cid])
				player:sendTextMessage(MESSAGE_EXPERIENCE, "You gained " .. rewardExperience[cid] .. " experience points.")
				npcHandler.topic[cid] = 0

			elseif player:getStorageValue(storage[cid]) > 0 and player:getStorageValue(storage[cid]) > value[cid] then
				npcHandler:say({"You already done this mission."}, cid)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say(missionsTable.text, cid)
				npcHandler.topic[cid] = 3
			end
		end
	-- Accept mission
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 3 then
		if player:getStorageValue(storage[cid]) < 1 then
			npcHandler:say("Very nice! Come back if you have found what's going on in this cult.", cid)
			player:setStorageValue(storage[cid], 1)
			if player:getStorageValue(Storage.CultsOfTibia.Questline) < 1 then
				player:setStorageValue(Storage.CultsOfTibia.Questline, 1)
			end
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(storage[cid]) > 0 then
			npcHandler:say("You have not finished your work yet. Come back when you're done.", cid)
			npcHandler.topic[cid] = 2
		end
	-- Recuse mission
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] == 3 then
		npcHandler:say("What a pitty! You can come back, when ever you want, if you have changed your opinion.", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
