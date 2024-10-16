local internalNpcName = "Spectulus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 78,
	lookFeet = 97,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Precisely." },
	{ text = "So my initial calculations had been correct!" },
	{ text = "Looks like I have to find another way then." },
	{ text = "Hm, I need to recapitulate my equipment..." },
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
	local playerId = creature:getId()
	local player = Player(creature)

	if player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) < 10 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! You're late, do you have no concept of time? My mission is of utmost importance. If you are not interested in helping me, you might as well just leave.")
		npcHandler:setTopic(playerId, 0)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Ah hello again |PLAYERNAME|! I still have one or two other {missions} for you. There are also some {tasks} someone needs to attend to.")
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "research") and player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 11 then
		local qStorage = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01)
		local tombsStorage = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.TombUse)
		if qStorage == -1 then
			if npcHandler:getTopic(playerId) == 17 then
				npcHandler:say({
					"Alright. Let's go. At first we need to find out more about ghosts in general. ...",
					"I still need more information and values to properly calibrate the magical orientation of orange and turquoise sparkle attractors which we will need to actually contain ghost-emissions. ...",
					"So are you in?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 18)
			else
				npcHandler:say({
					"I fine-tuned another set of devices. You are the lucky candidate to first lay eyes on some revolutionary new concepts. ...",
					"Are you ready to help science once again?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 12)
			end
		elseif qStorage == 1 and tombsStorage >= 2 then
			npcHandler:say("You are back, how did the measurements go? Did you recognise anything of interest?", npc, creature)
			npcHandler:setTopic(playerId, 19)
		elseif qStorage == 2 then
			npcHandler:say({
				"Alright, now that we have enough results, the analysing can start. While I do this, I will need you to test the magically enhanced cage Sinclair developed to contain spirits effectively. ...",
				"Take the spirit cage from him and use it on the essence of a common ghost. Its essence will then be sucked into the cage and we can study him right here in the safety of the academy walls.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == -1 then
			npcHandler:say("Alright, you look bright enough to fulfil my requests - at least you do not fall asleep while standing there. Ahem... I heard about a certain inventor who created a {magic device} to actually sail the {sea of light}. Will you help me find him?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 1 then
			npcHandler:say("You should find the beggar somewhere in Edron. Stay persistent, I'm sure he knows more than he wants to tell us.", npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 2 then
			if not player:removeItem(9696, 1) then
				npcHandler:say("o have you talked to the beggar? What did he tell you? Where are the plans...? Wh...? He did? He is?  You've already got the plans? Beautiful!! Amazing! Alright it will take some time to recapitulate these plans.", npc, creature)
				return true
			end

			player:addExperience(400, true)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 3)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission1, 3)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.StudyTimer, os.time() + 1800)
			npcHandler:say("So have you talked to the beggar? What did he tell you? Where are the plans...? Wh...? He did? He is? You've already got the plans? Beautiful!! Amazing! Alright it will take some time to recapitulate these plans.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 3 then
			local timeStorage = player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.StudyTimer)
			if timeStorage > os.time() then
				npcHandler:say("It will take some time to work out the initial problem of the device. Come back when I've found the component needed to finish it. Alright, B connects to D and another two nails marked with S go... hmmm.", npc, creature)
			elseif timeStorage > 0 and timeStorage < os.time() then
				npcHandler:say("...connects to N942. Alright!! That's it! I just finished a prototype device! And it looks like I figured out the initial failure. A very special crystal is needed for the device to work. Aren't you as curious as me to know what went wrong?", npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 4 then
			npcHandler:say("Did you enter the Lost Mines yet? They are west of Edron, close to the sea. You will also need a pick once you get to the crystal deposit.", npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 5 then
			if player:getItemCount(9697) == 0 then
				npcHandler:say("Hm, so did you find a rare crystal? Show me... hey! That's not a rare crystal. What... where did you get that anyway? Please return to me with the right crystal.", npc, creature)
				return true
			end
			player:addExperience(500, true)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 6)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission2, 3)
			npcHandler:say({
				"Did you find a rare crystal? Show me... Amazing, absolutely amazing. This crystal alone is worth a small fortune. Ahem, of course I'm glad you brought it to me for further research instead of bringing it to a merchant. ...",
				"Please return here if you want to continue helping me with another mission.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 6 then
			npcHandler:say("Well, the only thing left to do would be to offer the crystal at the well of the collector. There must be a pedestal near the well, where you need to put your donation. Ha, do you think you could do that?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 7 then
			npcHandler:say("Found the well yet? Look on one of the ice isles near Carlin. I'm perfectly sure that the well with the pedestal is located on one of them. And be careful with the carrying device, I only have this one prototype.", npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 8 then
			npcHandler:say("So have you found the well and entered the lair? I hope you can find the {mirror crystal} in there. It is the only way to finish the {Lightboat}.", npc, creature)
		elseif player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 9 then
			if player:getItemCount(9699) == 0 then
				npcHandler:say("Put the mirror crystal into the special carrying device I gave you and bring it directly to me.", npc, creature)
				return true
			end
			npcHandler:say("Do you have the mirror crystal? Unbelievable! Alright I will extract the crystal from the device myself, would you please give me the device with the crystal and step back?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif (player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) == 10) and (player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) < 1) then
			npcHandler:say("After the debacle with the crystal, I started focussing on other things. There are also some {tasks} that still need to be done. If you can spare the time to continue helping me, it shall not be to your disadvantage. So are you in for another mission?", npc, creature)
			npcHandler:setTopic(playerId, 27)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 2 then
			npcHandler:say("So you found him? Have you talked to {Jack} yet?", npc, creature)
			npcHandler:setTopic(playerId, 30)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 4 then
			npcHandler:say("You're back from {Jack}! Mh, by the looks of your face I doubt our little redecoration project yielded any success. But I had an even better idea while you were gone - ready to give it another try?", npc, creature)
			npcHandler:setTopic(playerId, 32)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 6 then
			npcHandler:say("So, did you talk to his family? Were you able to convince them?", npc, creature)
			npcHandler:setTopic(playerId, 33)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 8 then
			npcHandler:say("Did you find out what hobby {Jack} has? Did you separate him from this activity? Only if he has a free mind, he can truly get back to his former self! Now all you need to do is talk to him again!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 9 then
			npcHandler:say({
				"Oh you are back already. Hm... I doubt it worked, did it? It DID? Oh well... good job. Really! Now... the thing is - the actual {Jack} wrote. No, no wait. Calm down first. ...",
				"You remember me explaining the fold in time, causing a tiny disturbance in infinity? Well, as I already told you, {Jack} was indeed not transported to the future... but to the past. ...",
				"I received some kind of letter this morning that has been stored for me by the Academy for about 70 years now. ...",
				"It said it should be opened at a specific day 20 years ago to prevent this whole incident but I wasn't even at the Academy by that time. Someone just found the letter earlier today and brought it to my attention. ...",
				"So our {Jack} here was in fact... a completely different person. Now, now... don't get upset, there was no chance for me to warn you earlier! ...",
				"And it wasn't all that bad, was it? Heh... I mean... everyone needs a change in life now and then! And he can still come here if he likes to! ...",
				"Or wait - erm... better not tell him where exactly I live, I have some kind of presentiment concerning that whole affair... yes, we should just leave everything as it is now, indeed we should. ...",
				"Anyway you did a great job and I thank you for... putting your hands into my fire Player... once again.",
			}, npc, creature)
			player:addExperience(6000, true)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 10)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline) < 1 then
			player:addExperience(100, true)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 1)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission1, 1)
			npcHandler:say({
				"That's the spirit! As time is of the essence, we should start right now. ...",
				"A beggar here in Edron brags about how smart he is and that he knows about a man who lost his sanity because of an experiment, but he won't tell anyone any details. Maybe he knows more.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("The device needs a special crystal. It's called {mirror crystal}. The inventor somehow damaged it - with fatal results. He had to give up, as no second crystal was left to try. I, however, know of another one... but are you up to the task?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("One remaining mirror crystal is in the hands of a creature called the collector which collects all kinds of crystals. The only way to get access to its lair is to donate a very rare crystal to a secret well. I need you to get one, will you help me?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 4)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission1, 4)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission2, 1)
			player:addMapMark(Position(33103, 31811, 7), MAPMARK_CROSS, "Lost Mines")
			npcHandler:say({
				"Alright, now listen. West of Edron, near the ocean, you'll find the Lost Mines. Go down there to recover one of its rare crystals. But beware, people say the mine workers who died there years ago in an horrible accident are still digging. ...",
				"I will mark the location of the mines on your map. Be careful when entering these muddy depths and don't forget that you will need a pick to gather the crystals.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Good, because if you wouldn't do it... listen, this well is on one of the isles near Carlin. There you offer the crystal. Once you get access to its lair, find the collector and... convince it to give you the mirror crystal. Understood?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 7)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3, 1)
			player:addItem(9698, 1)
			npcHandler:say("To collect the unbelievably rare, practically unique mirror crystal, you will need to use this special carrying device I developed. If you find the crystal, use it to store it and transport it safely to me. There is no second one.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			if not player:removeItem(9699, 1) then
				npcHandler:say("", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end
			player:addItem(3028, 10)
			player:addItem(3037, 1)
			player:addExperience(1000, true)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3, 4)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 10)
			npcHandler:say({
				"Ah yes, slowly, carefully, careful ...",
				"...and how shiny it is, almost there ...",
				"...now wh- no, NO, NOOO! It just ...",
				"...slipped. And cracked. Don't look at me like that ...",
				"...I need some time to get over this. What? Oh, yes you can take the remains if you like. Just get it out of my sight.",
				"A debacle, catastrophe, disaster - I need time to fully understand what chance just slipped through our hands here... hm? Oh yes, yes through my hands, my hands of course. Now would you please leave me alone?!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 12 then
			npcHandler:say("Of course you are. And here we go. I have to ask some questions first. One: You aint afraid of no ghost, right?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif npcHandler:getTopic(playerId) == 13 then
			npcHandler:say("Good. Two: You know that ghosts exist and/or have found and/or defeated one or more of them?", npc, creature)
			npcHandler:setTopic(playerId, 14)
		elseif npcHandler:getTopic(playerId) == 14 then
			npcHandler:say({
				"Alright. Let's see - yes. ...",
				"Three: You can explain at least three of the following terms, infestations, collective apparitions, ectoplasmic segregations, ecto-magical field phenomena, neuro-speculative sub-conscious awareness of spirits, ghosts and/or ghasts.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 15)
		elseif npcHandler:getTopic(playerId) == 16 then
			npcHandler:say({
				"I recently teamed up with a fellow scientist and friend Sinclair, who is also more of an explorer than me, to combine our discoveries in the field of complex phenomena not that easily to describe just by today's state of magic. ...",
				"Of course I am talking about ghosts. I know, I know. Hard to believe in those times of highly advanced magic we live in. Yet there are some things, we fail to explain. ...",
				"And that is exactly where we come in! Oh, and you of course. We will not only explain them - we will ''remove'' them. Just tell me whenever you are ready to help us with our research.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 17)
		elseif npcHandler:getTopic(playerId) == 18 then
			npcHandler:say("Good. Take this wand - we call it a spirit meter - and go to the graveyard I have marked on your map and take a few measurements on the graves.", npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 1)
			player:addItem(4049, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 19 then
			npcHandler:say("Let me see the spirit meter. Hmmm... those are grave news you bring - uhm, you know what I mean. But this is awesome! Now I know for sure that the calibration is only some short bursts of magically enhanced energy away.", npc, creature)
			player:addExperience(500, true)
			player:addItem(3035, 5)
			player:setStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01, 2)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 27 then
			npcHandler:say({
				"Very well, hmmm, but this one might get a bit - unpleasant. What? No no, not for you. Probably only for the person I want you to help me with. You know, I once had an {intern}. His name was {Jack}. ...",
				"He was as eager as you to help me - quite a nice person, really. At the time he was still around I was working on a device to transport its user to any specified point in time - be it back or to the future if you know what I mean. ...",
				"He was helping me quite a lot, no matter which task I applied to him. And one day we finally did it, our tempus machina was up and running. He was certainly all man of action when he actually stepped into the machine for our first run. ...",
				"The device was designed for one person with enough room for some provisions and one or two books for reading if one would land in some drab solitude. You never know, you know? So we fired it up and yes, it actually worked! ...",
				"He completely disappeared right before my eyes! Eureka! Well ahem, there was but one tiny little problem. ...",
				"As all magical calibration was done from my lab I never thought about adding some sort of control to its interior. In other words {Jack} has travelled in time, without any means to come back. ...",
				"Sleepless days of intensive research, however, brought me to the conclusion that he was not actually travelling to the future, but to another {dimension}, {parallel} to ours. There is still a chance to rescue him - and you can help me. What do you say?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 28)
		elseif npcHandler:getTopic(playerId) == 28 then
			npcHandler:say({
				"You know, in some way you remind me of {Jack}. Well, I am glad you are up to this task - we just have to get him back. I owe that to him and I owe it to science. Alright, now let me explain that whole {dimensional} problem. ...",
				"The bad news is, using the device at that state was not a good idea. We effectively caused a magical distortion in the fabric of time, space and thus folded infinity - just a little. ...",
				"The good news is that {Jack} is still on our world, and not even inconveniently far away. ...",
				"Unfortunately in the current state of time, he was never interested in attending Edron Academy, he never looked for a job to finance his studies and of course has never been one of my interns. ...",
				"Since he was in the magic sphere during the launch, the time fold only affected his own {dimensional} anchoring. ...",
				"The number of parallel {dimensions} is endless and the fold made him slip into one completely different course of time where he never was the person I once knew. ...",
				"Now you know it all. Still want to help?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 29)
		elseif npcHandler:getTopic(playerId) == 29 then
			npcHandler:say({
				"Thank you. So here we are - now how to get {Jack} back to our {dimension}? Well, the answer to that is easy. It is simply not possible. All my tests concerning the reversal of the process failed. ...",
				"But {Jack} is not yet lost to us - if we can get him back to his former self! You have to tell him about his former life, convince him, change his environment. But at first you will need to talk to him and find out who exactly we are dealing with now. ...",
				"I will mark his current location on your map, just ask him about me and see what happens - good luck.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_54.SeaOfLight.Questline, 11)
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 30 then
			npcHandler:say("Yes? And he didn't remember anything? Not even me? That's not good. Then we will have to do everything ourselves. Are you ready to continue?", npc, creature)
			npcHandler:setTopic(playerId, 31)
		elseif npcHandler:getTopic(playerId) == 31 then
			npcHandler:say({
				"A trigger is needed to make him recall what happened. First thing should be to change his environment to be more... familiar. As soon as he will have the things he used to have around him, his memories will come back. ...",
				"I know that he used to have a very comfy red cushioned chair and an old globe which sat near the middle of the room. He also used a smaller telescope and he had that extremely large amphora in a corner. And... there was one other thing. ...",
				"A rocking horse. He just loved it! Find these items, buy them if you need to and place them where {Jack} lives. Ask him about the furniture and don't forget to tell me about his reaction!",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 3)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 32 then
			npcHandler:say({
				"Alright listen. As long as his social environment accepts him as the person he is now, he will never come free from the shackles that bind him to this alternate self. ...",
				"Oh, he has a sister you say? And his mother is living with them? ...",
				"Hm... that's strange, I don't even recall his family. Never knew he had a mother and a sister. Tell them the truth about him - maybe they will understand and even help him getting this over with. ...",
				"But be careful, the {dimensional} shift could mean that they will not even know what you're talking about since they are more closely linked to him than anyone else.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 5)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 33 then
			npcHandler:say({
				"Success!! Now it will be far easier to convince him of his true self! Excellent work. Now the only thing left to do is to separate him from whatever still binds him to that place. Did he develop any habits perhaps? ...",
				"A hobby or something! Yes, ask him about his hobbies! Convince him somehow that anything he is doing there does not match his true self - he didn't have any hobbies except a healthy interest in science - you MUST convince him, no matter what! ...",
				"Or everything we achieved would be in vain. We can still save Jack! Now go and do what you must do.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 7)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "jack") then
		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 10 then
			npcHandler:say({
				"Well you know Jack - after all you talked to him in person. He will get over it. As for the real Jack, my former intern... I am glad that nothing serious happened to him. ...",
				"According to his letter, he did just fine so many years ago. He somehow managed to make a name of himself when he cast some magic we enhanced through our research - of course no one back then had ever seen such spells. ...",
				"Oh and he sends his regards to... how did he put it - 'whoever is currently helping me getting out of whatever mess I am currently in'. I... don't really know how this was meant but I guess this is directed at... you!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "collective apparitions") then
		local qStorage = player:getStorageValue(Storage.Quest.U8_7.SpiritHunters.Mission01)
		if qStorage == -1 then
			if npcHandler:getTopic(playerId) == 15 then
				npcHandler:say("Ah well, let's forget about the scientific details - you will do just fine as long as you do exactly what I say. Ready for me to go on with your task?", npc, creature)
				npcHandler:setTopic(playerId, 16)
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Yes, maybe it was the right decision. Astronomical research is nothing for the faint-hearted.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Well, the... what? You... mean you're no longer interested? I see, well maybe I overestimated your spirit after all.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Alright, alright. You'll never find out the true secrets of life with such attitude, hm.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Come on, this is our only chance to finish the Lightboat.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Thought so. Well, no reason to be ashamed. I'll have to find help elsewhere now, though.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Come back if you made up your mind.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Hmpf. *mumbles*", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	if MsgContains(message, "machine") and player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
		npcHandler:say({
			"Ah, the machine you found at that island. Well, I built this thing to venture far beneath the very soil we walk on. I suspected something there. Something deep down below. Something evil. Even more so than the dreaded bugs which are crawling my study. ...",
			"Drilling hole after hole only to get stuck in another hard, unbreakable sediment again and again, I was about to quit this pointless enterprise. ...",
			"However, the very last day I lingered on that island, I finally fell into a large hollow right under the beach. My drill was shattered and the machine was not mobile anymore. ...",
			"I am well aware that this may sound laughable now - at this part all of my colleagues burst into laughter anyway - but suddenly there were stairs. Incredibly large stairs that led to the underworld. A world deep under the sea - can you believe this?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 21)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 21 and player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
		if player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say({
				"You do? Well, the end of this story was that I had to leave the place. ...",
				"I couldnt explore what lies below the stairs as there was an unpredictable stream. Diving into these waters would have been an uncontrollable risk, even with the means to survive without any air. ...",
				"So I used the portable teleporting device I installed into my machine in case of an emergency and went home. I could only take the most important research documents with me and had to leave most of my equipment in the cave. ...",
				"Of course I also left my final notes with the coordinates there. And for the life of me I cannot remember where I dug that stupid hole. ...",
				"When I arrived at home I immediately started looking for a way to manoeuvre in these chaotic conditions once I rediscovered the lost entrance. I never remembered it, but it seems you found it as you indeed have my original notes. ...",
				"Oh and just in case you want to complete what I have started - feel free to do so. Up to it?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 22 and player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
		if player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say({
				"Well, if you really want to delve into this - I could use some help. So you have found my {machine} on that island? And you found the notes with the coordinates? Then you can find the entrance! ...",
				"Just look for a large staircase with sprawling steps. There is an unpassable stream there that will prevent you from venturing further on. But fear not, you can indeed travel down there - with these small {enhancements} I created. ...",
				"At first, take this gold for the passage by ship and return to the Gray Island from where I started my expedition many years ago. From there you should find a way to reach the Gray Beach of Quirefang as no ordinary ship can land there. ...",
				"I will put this under your footgear. Here you go. And this in your nose. There. And there will be no further problems for you down there. Except- ah, well youll find out yourself soon enough, wont you?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 23)
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 23 and player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
		if player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say("Then off you go! Im sorry that I cannot offer you any further help but Im sure you will find support along your way. And - be careful. The sea can appear pitch black down there.", npc, creature)
			player:setStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor, 4)
			npcHandler:setTopic(playerId, 24)
		end
	elseif MsgContains(message, "task") then
		if player:getStorageValue(Storage.Quest.U8_54.SeaOfLight.Mission3) == 4 then
		end
	end

	if MsgContains(message, "rumours") then
		npcHandler:say({
			"There are rumours of aggressive fishmen in northern Tiquanda. We have to find out if this is even remotely connected to the Njey. ...",
			"What's puzzling me is that they were sighted above ground and then retreated into a temple ruin. If we find that ruin, we could find out if there's a relation. ...",
			"Are you willing to help me?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 25)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 25 then
			npcHandler:say("Excellent, excellent. The rumours pointed to the north of Tiquanda, a sunken temple probably half drowned in water. Return to me if you find anything interesting!", npc, creature)
			if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) < 1 then
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, 1)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end

	if MsgContains(message, "njey") then
		npcHandler:say({
			"Mh? Ah, yes yes. 'Njey' is the native-language term for a very old race of undersea creatures which ...",
			"...hm, wait - only a select few of my colleagues even bothered studying their culture. They are a mere fantasy to the common man - is there anything of importance you want to tell me?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 26)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 26 then
			npcHandler:say({
				"Well, if you really want to delve into this - I could use some help. So you have found my machine on that island? And you found the notes with the coordinates? Then you can find the entrance! ...",
				"Just look for a large staircase with sprawling steps. There is an unpassable stream there that will prevent you from venturing further on. But fear not, you can indeed travel down there - with these small enhancements I created. ...",
				"I will put this under your footgear. Here you go. And this in your nose. There. And there will be no further problems for you down there. Except- ah, well you'll find out yourself soon enough, won't you?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 34)
		elseif npcHandler:getTopic(playerId) == 34 then
			npcHandler:say("Then off you go! I'm sorry that I cannot offer you any further help but I'm sure you will find support along your way. And - be careful. The sea can appear pitch black down there.", npc, creature)
			if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) < 4 then
				player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, 4)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

keywordHandler:addKeyword({ "device" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, probably the most important invention in our history. And I will not rest until I have found a way to put the plan of its inventor into action.",
})
keywordHandler:addKeyword({ "lightboat" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, probably the most important invention in our history. And I will not rest until I have found a way to put the plan of its inventor into action.",
})
keywordHandler:addKeyword({ "magic device" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, probably the most important invention in our history. And I will not rest until I have found a way to put the plan of its inventor into action.",
})
keywordHandler:addKeyword({ "sea of light" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The sea of light is what I call the endless arrangement of shiny stars in the night sky. If we fail to complete the {magic device}, science will probably never uncover its secrets.",
})
keywordHandler:addKeyword({ "mirror crystal" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I found the cause of the initial failure. A rare component, a mirror crystal was used to store magical energy. Miscalculations within the construction damaged this fragile power source. The unleashed energy must have been devastating.",
})
keywordHandler:addKeyword({ "lost mines" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The people of Edron were digging there for minerals and gold. It seemed all that work was of no avail when they finally hit the motherlode. Gems, rare crystals and... water. So much that it flooded the whole system. And not a single soul escaped.",
})
keywordHandler:addKeyword({ "collector" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I heard rumours of a fabled creature whose traces were found on an island near Carlin. It lives solely to collect all kinds of rare gems, crystals and minerals. Offering an item it does not already own, reportedly allows passage into its lair.",
})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! You're late, do you have no concept of time? My mission is of utmost importance. If you are not interested in helping me, you might as well just leave.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes yes. Goodbye |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes yes. Goodbye |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
