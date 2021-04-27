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
	{text = "Precisely."},
	{text = "So my initial calculations had been correct!"},
	{text = "Looks like I have to find another way then."},
	{text = "Hm, I need to recapitulate my equipment..."}
}

npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.SeaOfLight.Questline) < 10 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Hello |PLAYERNAME|! You're late, do you have no concept of time? My mission is of utmost importance. If you are not interested in helping me, you might as well just leave."
		)
		npcHandler.topic[cid] = 0
	else
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Ah hello again |PLAYERNAME|! I still have one or two other {missions} for you. There are also some {tasks} someone needs to attend to."
		)
		npcHandler.topic[cid] = 0
	end
	return true
end

local function releasePlayer(cid)
	if not Player(cid) then
		return
	end

	npcHandler:releaseFocus(cid)
	npcHandler:resetNpc(cid)
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "research") then
		local qStorage = player:getStorageValue(Storage.SpiritHunters.Mission01)
		local tombsStorage = player:getStorageValue(Storage.SpiritHunters.TombUse)
		if qStorage == -1 then
			if npcHandler.topic[cid] == 17 then
				npcHandler:say(
					{
						"Alright. Let's go. At first we need to find out more about ghosts in general. ...",
						"I still need more information and values to properly calibrate the magical orientation of orange \z
						and turquoise sparkle attractors which we will need to actually contain ghost-emissions. ...",
						"So are you in?"
					},
					cid,
					false,
					true,
					200
				)
				npcHandler.topic[cid] = 18
			else
				npcHandler:say(
					{
						"I fine-tuned another set of devices. You are the lucky candidate to first lay eyes on some revolutionary \z
						new concepts. ...",
						"Are you ready to help science once again?"
					},
					cid,
					false,
					true,
					200
				)
				npcHandler.topic[cid] = 12
			end
		elseif qStorage == 1 and tombsStorage >= 2 then
			npcHandler:say("You are back, how did the measurements go? Did you recognise anything of interest?", cid)
			npcHandler.topic[cid] = 19
		elseif qStorage == 2 then
			npcHandler:say(
				{
					"Alright, now that we have enough results, the analysing can start. While I do this, I will need you \z
						to test the magically enhanced cage Sinclair developed to contain spirits effectively. ...",
					"Take the spirit cage from him and use it on the essence of a common ghost. Its essence will then be \z
						sucked into the cage and we can study him right here in the safety of the academy walls."
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.SeaOfLight.Questline) == -1 then
			npcHandler:say(
				"Alright, you look bright enough to fulfil my requests - at least you do not fall asleep while standing there. \z
					Ahem... I heard about a certain inventor who created a {magic device} to actually sail the {sea of light}. \z
					Will you help me find him?",
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 1 then
			npcHandler:say(
				"You should find the beggar somewhere in Edron. Stay persistent, \z
				I'm sure he knows more than he wants to tell us.",
				cid
			)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 2 then
			if not player:removeItem(10613, 1) then
				npcHandler:say(
					"o have you talked to the beggar? What did he tell you? Where are the plans...? Wh...? He did? He is? \z
					You've already got the plans? Beautiful!! Amazing! Alright it will take some time to recapitulate these plans.",
					cid,
					false,
					true,
					200
				)
				return true
			end

			player:addExperience(400, true)
			player:setStorageValue(Storage.SeaOfLight.Questline, 3)
			player:setStorageValue(Storage.SeaOfLight.Mission1, 3)
			player:setStorageValue(Storage.SeaOfLight.StudyTimer, os.time() + 1800)
			npcHandler:say(
				"So have you talked to the beggar? What did he tell you? Where are the plans...? Wh...? He did? He is? \z
				You've already got the plans? Beautiful!! Amazing! Alright it will take some time to recapitulate these plans.",
				cid,
				false,
				true,
				200
			)
			addEvent(releasePlayer, 1000, cid)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 3 then
			local timeStorage = player:getStorageValue(Storage.SeaOfLight.StudyTimer)
			if timeStorage > os.time() then
				npcHandler:say(
					"It will take some time to work out the initial problem of the device. Come back when I've found the \z
					component needed to finish it. Alright, B connects to D and another two nails marked with S go... hmmm.",
					cid,
					false,
					true,
					200
				)
			elseif timeStorage > 0 and timeStorage < os.time() then
				npcHandler:say(
					"...connects to N942. Alright!! That's it! I just finished a prototype device! And it looks like I \z
					figured out the initial failure. A very special crystal is needed for the device to work. Aren't \z
					you as curious as me to know what went wrong?",
					cid,
					false,
					true,
					200
				)
				npcHandler.topic[cid] = 2
			end
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 4 then
			npcHandler:say(
				"Did you enter the Lost Mines yet? They are west of Edron, close to the sea. You will also need a \z
				pick once you get to the crystal deposit.",
				cid,
				false,
				true,
				200
			)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 5 then
			if player:getItemCount(10614) == 0 then
				npcHandler:say(
					"Hm, so did you find a rare crystal? Show me... hey! That's not a rare crystal. What... where did \z
					you get that anyway? Please return to me with the right crystal.",
					cid,
					false,
					true,
					200
				)
				return true
			end
			player:addExperience(500, true)
			player:setStorageValue(Storage.SeaOfLight.Questline, 6)
			player:setStorageValue(Storage.SeaOfLight.Mission2, 3)
			npcHandler:say(
				{
					"Did you find a rare crystal? Show me... Amazing, absolutely amazing. This crystal alone is worth \z
					a small fortune. Ahem, of course I'm glad you brought it to me for further research instead of \z
					bringing it to a merchant. ...",
					"Please return here if you want to continue helping me with another mission."
				},
				cid,
				false,
				true,
				200
			)
			addEvent(releasePlayer, 1000, cid)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 6 then
			npcHandler:say(
				"Well, the only thing left to do would be to offer the crystal at the well of the collector. There \z
				must be a pedestal near the well, where you need to put your donation. Ha, do you think you could do that?",
				cid
			)
			npcHandler.topic[cid] = 5
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 7 then
			npcHandler:say(
				"Found the well yet? Look on one of the ice isles near Carlin. I'm perfectly sure that the well \z
				with the pedestal is located on one of them. And be careful with the carrying device, I only have \z
				this one prototype.",
				cid,
				false,
				true,
				200
			)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 8 then
			npcHandler:say(
				"So have you found the well and entered the lair? I hope you can find the {mirror crystal}\z
			in there. It is the only way to finish the {Lightboat}.",
				cid
			)
		elseif player:getStorageValue(Storage.SeaOfLight.Questline) == 9 then
			if player:getItemCount(10616) == 0 then
				npcHandler:say(
					"Put the mirror crystal into the special carrying device \z
					I gave you and bring it directly to me.",
					cid
				)
				return true
			end
			npcHandler:say(
				"Do you have the mirror crystal? Unbelievable! Alright I will extract the crystal from the device \z
				myself, would you please give me the device with the crystal and step back?",
				cid
			)
			npcHandler.topic[cid] = 7
		elseif
			(player:getStorageValue(Storage.SeaOfLight.Questline) == 10) and
				(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) < 1)
		 then
			npcHandler:say(
				"After the debacle with the crystal, I started focussing on other things. There are also some {tasks} \z
				that still need to be done. If you can spare the time to continue helping me, it shall not be to your \z
				disadvantage. So are you in for another mission?",
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 27
		elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 2 then
			npcHandler:say("So you found him? Have you talked to {Jack} yet?", cid)
			npcHandler.topic[cid] = 30
		elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 4 then
			npcHandler:say(
				"You're back from {Jack}! Mh, by the looks of your face I doubt our little redecoration \z
				project yielded any success. But I had an even better idea while you were gone - ready to give it another try?",
				cid
			)
			npcHandler.topic[cid] = 32
		elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 6 then
			npcHandler:say("So, did you talk to his family? Were you able to convince them?", cid)
			npcHandler.topic[cid] = 33
		elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 8 then
			npcHandler:say(
				"Did you find out what hobby {Jack} has? Did you separate him from this activity? \z
				Only if he has a free mind, he can truly get back to his former self! Now all you need to do is talk to him again!",
				cid
			)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 9 then
			npcHandler:say(
				{
					"Oh you are back already. Hm... I doubt it worked, did it? It DID? Oh well... good job. Really! \z
					Now... the thing is - the actual {Jack} wrote. No, no wait. Calm down first. ...",
					"You remember me explaining the fold in time, causing a tiny disturbance in infinity? Well, as I \z
					already told you, {Jack} was indeed not transported to the future... but to the past. ...",
					"I received some kind of letter this morning that has been stored for me by the Academy for \z
					about 70 years now. ...",
					"It said it should be opened at a specific day 20 years ago to prevent this whole incident but I \z
					wasn't even at the Academy by that time. Someone just found the letter earlier today and brought \z
					it to my attention. ...",
					"So our {Jack} here was in fact... a completely different person. Now, now... don't get upset, \z
					there was no chance for me to warn you earlier! ...",
					"And it wasn't all that bad, was it? Heh... I mean... everyone needs a change in life now and then! \z
						And he can still come here if he likes to! ...",
					"Or wait - erm... better not tell him where exactly I live, I have some kind of presentiment concerning \z
					that whole affair... yes, we should just leave everything as it is now, indeed we should. ...",
					"Anyway you did a great job and I thank you for... putting your hands into my fire Player... once again."
				},
				cid
			)
			player:addExperience(6000, true)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 10)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:addExperience(100, true)
			player:setStorageValue(Storage.SeaOfLight.Questline, 1)
			player:setStorageValue(Storage.SeaOfLight.Mission1, 1)
			npcHandler:say(
				{
					"That's the spirit! As time is of the essence, we should start right now. ...",
					"A beggar here in Edron brags about how smart he is and that he knows about a man who lost his \z
					sanity because of an experiment, but he won't tell anyone any details. Maybe he knows more."
				},
				cid,
				false,
				true,
				200
			)
			addEvent(releasePlayer, 1000, cid)
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say(
				"The device needs a special crystal. It's called {mirror crystal}. The inventor somehow damaged it \z
				- with fatal results. He had to give up, as no second crystal was left to try. I, however, know of \z
				another one... but are you up to the task?",
				cid
			)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say(
				"One remaining mirror crystal is in the hands of a creature called the collector which collects all \z
				kinds of crystals. The only way to get access to its lair is to donate a very rare crystal to a secret \z
				well. I need you to get one, will you help me?",
				cid
			)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 4 then
			player:setStorageValue(Storage.SeaOfLight.Questline, 4)
			player:setStorageValue(Storage.SeaOfLight.Mission1, 4)
			player:setStorageValue(Storage.SeaOfLight.Mission2, 1)
			player:addMapMark(Position(33103, 31811, 7), MAPMARK_CROSS, "Lost Mines")
			npcHandler:say(
				{
					"Alright, now listen. West of Edron, near the ocean, you'll find the Lost Mines. Go down there \z
					to recover one of its rare crystals. But beware, people say the mine workers who died there years \z
					ago in an horrible accident are still digging. ...",
					"I will mark the location of the mines on your map. Be careful when entering these muddy depths and \z
					don't forget that you will need a pick to gather the crystals."
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			npcHandler:say(
				"Good, because if you wouldn't do it... listen, this well is on one of the isles near Carlin. \z
				There you offer the crystal. Once you get access to its lair, find the collector and... convince it to give \z
				you the mirror crystal. Understood?",
				cid
			)
			npcHandler.topic[cid] = 6
		elseif npcHandler.topic[cid] == 6 then
			player:setStorageValue(Storage.SeaOfLight.Questline, 7)
			player:setStorageValue(Storage.SeaOfLight.Mission3, 1)
			player:addItem(10615, 1)
			npcHandler:say(
				"To collect the unbelievably rare, practically unique mirror crystal, you will need to use this \z
				special carrying device I developed. If you find the crystal, use it to store it and transport it \z
				safely to me. There is no second one.",
				cid
			)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			if not player:removeItem(10616, 1) then
				npcHandler:say("", cid)
				npcHandler.topic[cid] = 0
				return true
			end
			player:addItem(2145, 10)
			player:addItem(2154, 1)
			player:addExperience(1000, true)
			player:setStorageValue(Storage.SeaOfLight.Mission3, 4)
			player:setStorageValue(Storage.SeaOfLight.Questline, 10)
			npcHandler:say(
				{
					"Ah yes, slowly, carefully, careful ...",
					"...and how shiny it is, almost there ...",
					"...now wh- no, NO, NOOO! It just ...",
					"...slipped. And cracked. Don't look at me like that ...",
					"...I need some time to get over this. What? Oh, yes you can take the remains if you like. \z
					Just get it out of my sight."
				},
				cid,
				false,
				true,
				200
			)
			addEvent(releasePlayer, 1000, cid)
		elseif npcHandler.topic[cid] == 12 then
			npcHandler:say(
				"Of course you are. And here we go. I have to ask some questions first. One: You aint \z
				afraid of no ghost, right?",
				cid
			)
			npcHandler.topic[cid] = 13
		elseif npcHandler.topic[cid] == 13 then
			npcHandler:say(
				"Good. Two: You know that ghosts exist and/or have found and/or defeated \z
				one or more of them?",
				cid
			)
			npcHandler.topic[cid] = 14
		elseif npcHandler.topic[cid] == 14 then
			npcHandler:say(
				{
					"Alright. Let's see - yes. ...",
					"Three: You can explain at least three of the following terms, infestations, \z
					collective apparitions, ectoplasmic segregations, ecto-magical field phenomena, \z
					neuro-speculative sub-conscious awareness of spirits, ghosts and/or ghasts."
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 15
		elseif npcHandler.topic[cid] == 16 then
			npcHandler:say(
				{
					"I recently teamed up with a fellow scientist and friend Sinclair, who is also more \z
					of an explorer than me, to combine our discoveries in the field of complex phenomena \z
					not that easily to describe just by today's state of magic. ...",
					"Of course I am talking about ghosts. I know, I know. Hard to believe in those times \z
					of highly advanced magic we live in. Yet there are some things, we fail to explain. ...",
					"And that is exactly where we come in! Oh, and you of course. We will not only explain \z
					them - we will ''remove'' them. Just tell me whenever you are ready to help us with our research."
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 17
		elseif npcHandler.topic[cid] == 18 then
			npcHandler:say(
				"Good. Take this wand - we call it a spirit meter - and go to the graveyard I have \z
				marked on your map and take a few measurements on the graves.",
				cid
			)
			player:setStorageValue(Storage.SpiritHunters.Mission01, 1)
			player:addItem(12670, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 19 then
			npcHandler:say(
				"Let me see the spirit meter. Hmmm... those are grave news you bring - uhm, you \z
				know what I mean. But this is awesome! Now I know for sure that the calibration is \z
				only some short bursts of magically enhanced energy away.",
				cid
			)
			player:addExperience(500, true)
			player:addItem(2152, 5)
			addEvent(releasePlayer, 1000, cid)
			player:setStorageValue(Storage.SpiritHunters.Mission01, 2)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 27 then
			npcHandler:say(
				{
					"Very well, hmmm, but this one might get a bit - unpleasant. What? No no, not for you. Probably only \z
					for the person I want you to help me with. You know, I once had an {intern}. His name was {Jack}. ...",
					"He was as eager as you to help me - quite a nice person, really. At the time he was still around I was \z
					working on a device to transport its user to any specified point in time - be it back or to the future \z
					if you know what I mean. ...",
					"He was helping me quite a lot, no matter which task I applied to him. And one day we finally did it, our \z
					tempus machina was up and running. He was certainly all man of action when he actually stepped into the \z
					machine for our first run. ...",
					"The device was designed for one person with enough room for some provisions and one or two books for reading \z
					if one would land in some drab solitude. You never know, you know? So we fired it up and yes, it actually \z
					worked! ...",
					"He completely disappeared right before my eyes! Eureka! Well ahem, there was but one tiny little problem. ...",
					"As all magical calibration was done from my lab I never thought about adding some sort of control to its \z
					interior. In other words {Jack} has travelled in time, without any means to come back. ...",
					"Sleepless days of intensive research, however, brought me to the conclusion that he was not actually \z
					travelling to the future, but to another {dimension}, {parallel} to ours. There is still a chance to rescue \z
					him - and you can help me. What do you say?"
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 28
		elseif npcHandler.topic[cid] == 28 then
			npcHandler:say(
				{
					"You know, in some way you remind me of {Jack}. Well, I am glad you are up to this task - we just have \z
					to get him back. I owe that to him and I owe it to science. Alright, now let me explain that whole \z
					{dimensional} problem. ...",
					"The bad news is, using the device at that state was not a good idea. We effectively caused a magical \z
					distortion in the fabric of time, space and thus folded infinity - just a little. ...",
					"The good news is that {Jack} is still on our world, and not even inconveniently far away. ...",
					"Unfortunately in the current state of time, he was never interested in attending Edron Academy, he \z
					never looked for a job to finance his studies and of course has never been one of my interns. ...",
					"Since he was in the magic sphere during the launch, the time fold only affected his own {dimensional} \z
					anchoring. ...",
					"The number of parallel {dimensions} is endless and the fold made him slip into one completely different \z
					course of time where he never was the person I once knew. ...",
					"Now you know it all. Still want to help?"
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 29
		elseif npcHandler.topic[cid] == 29 then
			npcHandler:say(
				{
					"Thank you. So here we are - now how to get {Jack} back to our {dimension}? Well, the answer to that \z
					is easy. It is simply not possible. All my tests concerning the reversal of the process failed. ...",
					"But {Jack} is not yet lost to us - if we can get him back to his former self! You have to tell him \z
					about his former life, convince him, change his environment. But at first you will need to talk to him \z
					and find out who exactly we are dealing with now. ...",
					"I will mark his current location on your map, just ask him about me and see what happens - good luck."
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.SeaOfLight.Questline, 11)
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 30 then
			npcHandler:say(
				"Yes? And he didn't remember anything? Not even me? That's not good. Then we will have to \z
				do everything ourselves. Are you ready to continue?",
				cid
			)
			npcHandler.topic[cid] = 31
		elseif npcHandler.topic[cid] == 31 then
			npcHandler:say(
				{
					"A trigger is needed to make him recall what happened. First thing should be to change his \z
					environment to be more... familiar. As soon as he will have the things he used to have around \z
					him, his memories will come back. ...",
					"I know that he used to have a very comfy red cushioned chair and an old globe which sat near \z
					the middle of the room. He also used a smaller telescope and he had that extremely large amphora \z
					in a corner. And... there was one other thing. ...",
					"A rocking horse. He just loved it! Find these items, buy them if you need to and place them \z
					where {Jack} lives. Ask him about the furniture and don't forget to tell me about his reaction!"
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 3)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 32 then
			npcHandler:say(
				{
					"Alright listen. As long as his social environment accepts him as the person he is now, \z
					he will never come free from the shackles that bind him to this alternate self. ...",
					"Oh, he has a sister you say? And his mother is living with them? ...",
					"Hm... that's strange, I don't even recall his family. Never knew he had a mother and a \z
					sister. Tell them the truth about him - maybe they will understand and even help him getting \z
					this over with. ...",
					"But be careful, the {dimensional} shift could mean that they will not even know what you're \z
					talking about since they are more closely linked to him than anyone else."
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 5)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 33 then
			npcHandler:say(
				{
					"Success!! Now it will be far easier to convince him of his true self! Excellent work. \z
					Now the only thing left to do is to separate him from whatever still binds him to that place. \z
						Did he develop any habits perhaps? ...",
					"A hobby or something! Yes, ask him about his hobbies! Convince him somehow that anything he is \z
					doing there does not match his true self - he didn't have any hobbies except a healthy interest in \z
					science - you MUST convince him, no matter what! ...",
					"Or everything we achieved would be in vain. We can still save Jack! Now go and do what you must do."
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 7)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "jack") then
		if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 10 then
			npcHandler:say(
				{
					"Well you know Jack - after all you talked to him in person. He will get over it. \z
					As for the real Jack, my former intern... I am glad that nothing serious happened to him. ...",
					"According to his letter, he did just fine so many years ago. He somehow managed to make a \z
					name of himself when he cast some magic we enhanced through our research - of course no one \z
					back then had ever seen such spells. ...",
					"Oh and he sends his regards to... how did he put it - 'whoever is currently helping me getting \z
					out of whatever mess I am currently in'. I... don't really know how this was meant but I \z
					guess this is directed at... you!"
				},
				cid
			)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "collective apparitions") then
		local qStorage = player:getStorageValue(Storage.SpiritHunters.Mission01)
		if qStorage == -1 then
			if npcHandler.topic[cid] == 15 then
				npcHandler:say(
					"Ah well, let's forget about the scientific details - you will do just fine as \z
					long as you do exactly what I say. Ready for me to go on with your task?",
					cid
				)
				npcHandler.topic[cid] = 16
			end
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say(
				"Yes, maybe it was the right decision. Astronomical research is \z
				nothing for the faint-hearted.",
				cid
			)
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say(
				"Well, the... what? You... mean you're no longer interested? I see, well \z
				maybe I overestimated your spirit after all.",
				cid
			)
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("Alright, alright. You'll never find out the true secrets of life with such attitude, hm.", cid)
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Come on, this is our only chance to finish the Lightboat.", cid)
		elseif npcHandler.topic[cid] == 5 then
			npcHandler:say("Thought so. Well, no reason to be ashamed. I'll have to find help elsewhere now, though.", cid)
		elseif npcHandler.topic[cid] == 6 then
			npcHandler:say("Come back if you made up your mind.", cid)
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say("Hmpf. *mumbles*", cid)
		end
		npcHandler.topic[cid] = 0
	end

	if msgcontains(msg, "machine") and player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3 then
		npcHandler:say(
			{
				"Ah, the machine you found at that island. Well, I built this thing to venture far beneath \z
				the very soil we walk on. I suspected something there. Something deep down below. Something evil. \z
				Even more so than the dreaded bugs which are crawling my study. ...",
				"Drilling hole after hole only to get stuck in another hard, unbreakable sediment again and again, \z
				I was about to quit this pointless enterprise. ...",
				"However, the very last day I lingered on that island, I finally fell into a large hollow right \z
				under the beach. My drill was shattered and the machine was not mobile anymore. ...",
				"I am well aware that this may sound laughable now - at this part all of my colleagues burst into \z
				laughter anyway - but suddenly there were stairs. Incredibly large stairs that led to the underworld. \z
				A world deep under the sea - can you believe this?"
			},
			cid,
			false,
			true,
			200
		)
		npcHandler.topic[cid] = 21
	elseif
		msgcontains(msg, "yes") and npcHandler.topic[cid] == 21 and
			player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3
	 then
		if player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say(
				{
					"You do? Well, the end of this story was that I had to leave the place. ...",
					"I couldnt explore what lies below the stairs as there was an unpredictable stream. Diving \z
					into these waters would have been an uncontrollable risk, even with the means to survive without any air. ...",
					"So I used the portable teleporting device I installed into my machine in case of an emergency and went home. \z
					I could only take the most important research documents with me and had to leave \z
					most of my equipment in the cave. ...",
					"Of course I also left my final notes with the coordinates there. And for the life of me I cannot remember where \z
					I dug that stupid hole. ...",
					"When I arrived at home I immediately started looking for a way to manoeuvre in these chaotic conditions once \z
					I rediscovered the lost entrance. I never remembered it, but it seems you found it as you \z
					indeed have my original notes. ...",
					"Oh and just in case you want to complete what I have started - feel free to do so. Up to it?"
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 22
		end
	elseif
		msgcontains(msg, "yes") and npcHandler.topic[cid] == 22 and
			player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3
	 then
		if player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say(
				{
					"Well, if you really want to delve into this - I could use some help. So you have \z
					found my {machine} on that island? And you found the notes with the coordinates? \z
					Then you can find the entrance! ...",
					"Just look for a large staircase with sprawling steps. There is an unpassable stream \z
					there that will prevent you from venturing further on. But fear not, you can indeed \z
					travel down there - with these small {enhancements} I created. ...",
					"At first, take this gold for the passage by ship and return to the Gray Island from \z
					where I started my expedition many years ago. From there you should find a way to reach \z
					the Gray Beach of Quirefang as no ordinary ship can land there. ...",
					"I will put this under your footgear. Here you go. And this in your nose. There. And \z
					there will be no further problems for you down there. Except- ah, well youll find \z
					out yourself soon enough, wont you?"
				},
				cid,
				false,
				true,
				200
			)
			npcHandler.topic[cid] = 23
		end
	elseif
		msgcontains(msg, "yes") and npcHandler.topic[cid] == 23 and
			player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3
	 then
		if player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 3 then
			npcHandler:say(
				{
					"Then off you go! Im sorry that I cannot offer you any further help but Im \z
					sure you will find support along your way. And - be careful. The sea can \z
					appear pitch black down there."
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.LiquidBlackQuest.Visitor, 4)
			npcHandler.topic[cid] = 24
		end
	elseif msgcontains(msg, "task") then
		if player:getStorageValue(Storage.SeaOfLight.Mission3) == 4 then
		end
	end

	if msgcontains(msg, "rumours") then
		npcHandler:say(
			{
				"There are rumours of aggressive fishmen in northern Tiquanda. We have to \z
					find out if this is even remotely connected to the Njey. ...",
				"What's puzzling me is that they were sighted above ground and then retreated \z
					into a temple ruin. If we find that ruin, we could find out if there's a relation. ...",
				"Are you willing to help me?"
			},
			cid,
			false,
			true,
			200
		)
		npcHandler.topic[cid] = 25
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 25 then
		if npcHandler.topic[cid] == 25 then
			npcHandler:say(
				{
					"Excellent, excellent. The rumours pointed to the north of Tiquanda, a \z
					sunken temple probably half drowned in water. Return to me if you find \z
					anything interesting!"
				},
				cid,
				false,
				true,
				200
			)
			player:setStorageValue(Storage.TheSecretLibrary.LiquidDeath, 1)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

keywordHandler:addKeyword(
	{"jack"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He was the first one I ever hired as an intern to help me with my studies and research. He \z
		did an exceptionally good job and I certainly don't know where I would stand today without him. \z
		We have to save him |PLAYERNAME|!"
	}
)
keywordHandler:addKeyword(
	{"device"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, \z
		probably the most important invention in our history. And I will not rest until I have found a way to \z
		put the plan of its inventor into action."
	}
)
keywordHandler:addKeyword(
	{"lightboat"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, \z
		probably the most important invention in our history. And I will not rest until I have found a way to \z
		put the plan of its inventor into action."
	}
)
keywordHandler:addKeyword(
	{"magic device"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I heard of a device which would allow man to sail the sea of light. I call it the {Lightboat}, \z
		probably the most important invention in our history. And I will not rest until I have found a way to \z
		put the plan of its inventor into action."
	}
)
keywordHandler:addKeyword(
	{"sea of light"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The sea of light is what I call the endless arrangement of shiny stars in the night sky. If we \z
		fail to complete the {magic device}, science will probably never uncover its secrets."
	}
)
keywordHandler:addKeyword(
	{"mirror crystal"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I found the cause of the initial failure. A rare component, a mirror crystal was used to store \z
		magical energy. Miscalculations within the construction damaged this fragile power source. The unleashed \z
		energy must have been devastating."
	}
)
keywordHandler:addKeyword(
	{"lost mines"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The people of Edron were digging there for minerals and gold. It seemed all that work was of \z
		no avail when they finally hit the motherlode. Gems, rare crystals and... water. So much that it flooded \z
		the whole system. And not a single soul escaped."
	}
)
keywordHandler:addKeyword(
	{"collector"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I heard rumours of a fabled creature whose traces were found on an island near Carlin. It \z
		lives solely to collect all kinds of rare gems, crystals and minerals. Offering an item it does not \z
		already own, reportedly allows passage into its lair."
	}
)

npcHandler:setMessage(
	MESSAGE_GREET,
	"Hello |PLAYERNAME|! You're late, do you have no concept of time? \z
My mission is of utmost importance. If you are not interested in helping me, you might as well just leave."
)
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes yes. Goodbye |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes yes. Goodbye |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
