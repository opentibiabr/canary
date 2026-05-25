local internalNpcName = "Julius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 289,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 114,
	lookFeet = 113,
	lookAddons = 3,
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

local BB = Storage.Quest.U8_4.BloodBrothers

local function getMissionStage(player)
	if player:getStorageValue(BB.Mission10) >= 1 then
		return 10
	end
	if player:getStorageValue(BB.Mission09) >= 1 then
		return 9
	end
	if player:getStorageValue(BB.Mission08) >= 1 then
		return 8
	end
	if player:getStorageValue(BB.Mission07) >= 1 then
		return 7
	end
	if player:getStorageValue(BB.Mission06) >= 1 then
		return 6
	end
	if player:getStorageValue(BB.Mission05) == 4 then
		return 54
	end
	if player:getStorageValue(BB.Mission05) == 3 then
		return 53
	end
	if player:getStorageValue(BB.Mission05) == 2 then
		return 52
	end
	if player:getStorageValue(BB.Mission05) == 1 then
		return 51
	end
	if player:getStorageValue(BB.Mission04) == 2 then
		return 42
	end
	if player:getStorageValue(BB.Mission04) == 1 then
		return 41
	end
	if player:getStorageValue(BB.Mission03) == 3 then
		return 33
	end
	if player:getStorageValue(BB.Mission03) >= 1 then
		return 31
	end
	if player:getStorageValue(BB.Mission02) == 2 then
		return 22
	end
	if player:getStorageValue(BB.Mission02) == 1 then
		return 21
	end
	if player:getStorageValue(BB.Mission01) == 4 then
		return 14
	end
	if player:getStorageValue(BB.Mission01) == 3 then
		return 13
	end
	if player:getStorageValue(BB.Mission01) == 2 then
		return 12
	end
	if player:getStorageValue(BB.Mission01) == 1 then
		return 11
	end
	if player:getStorageValue(BB.Trust) == 1 then
		return 1
	end
	return 0
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	if player:getStorageValue(BB.Trust) < 0 then
		npcHandler:setMessage(MESSAGE_GREET, "Be greeted, adventurer |PLAYERNAME|. I assume you have read the {note} about the {vampire} threat in this city.")
	elseif player:getStorageValue(BB.Trust) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Be greeted, adventurer |PLAYERNAME|. Please excuse me if I appear {distracted}!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, |PLAYERNAME|.")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local stage = getMissionStage(player)

	if MsgContains(message, "mission") or MsgContains(message, "note") or MsgContains(message, "vampire") then
		if stage == 0 then
			npcHandler:say("Our nightly blood-sucking visitors put the inhabitants of Yalahar in constant danger. The worst thing is that anyone in this city could be a vampire. Maybe an outsider like you could help us. Would you try?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif stage == 11 then
			local neckItem = player:getSlotItem(CONST_SLOT_NECKLACE)
			if neckItem and neckItem.itemid == 3083 then
				npcHandler:say("Hmm, I see, I see. That necklace is only a small indication though... I think I need another proof, just to make sure. Say... have you ever baked {garlic bread}?", npc, creature)
				player:setStorageValue(BB.Mission01, 2)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say("I fear that will not do. Sorry.", npc, creature)
			end
		elseif stage == 12 then
			npcHandler:say("Have you baked the garlic bread yet? Remember, mix flour with holy water, use that dough on garlic, and bake it. Can you do that?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif stage == 13 then
			if player:getItemCount(8194) >= 1 then
				npcHandler:say("Let me check - yes indeed, there's garlic in it. Now eat one, in front of my eyes. Right now! Say '{aaah}' when you've chewed it all down so that I can see you're not hiding it!", npc, creature)
				npcHandler:setTopic(playerId, 4)
			else
				npcHandler:say("You don't have the garlic bread with you. Come back once you have baked it.", npc, creature)
			end
		elseif stage == 14 then
			npcHandler:say("So, are you ready for your first real task?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif stage == 21 then
			npcHandler:say("Are you back with confirmed names of possible vampires?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif stage == 22 then
			npcHandler:say({
				"Listen, I thought of something. If we could somehow figure out who among those five is their leader and manage to defeat him, the others might give up too. ...",
				"Without their leader they will at least be much weaker. Before I explain my plan, do you think you could do that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif stage == 31 then
			npcHandler:say("Oh! You look horrible - I mean, rather weary. What happened? Who is the master vampire?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif stage == 33 then
			npcHandler:say({
				"You know, I came to think that the spell didn't work because there is another, greater power behind all of this. I fear that if we don't find the source of the vampire threat we can't defeat them. ...",
				"I heard that there is an island not far from here. Unholy and fearsome things are said to happen there, and maybe that means vampires are not far away. ...",
				"I want you to try and convince someone with a boat to bring you to this island, Vengoth. I'll give you an empty map. Please map the area for me and pay special attention to unusual spots. ...",
				"Mark them on my map and come back once you have found at least five remarkable places on Vengoth. Can you do that for me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif stage == 41 then
			npcHandler:say("Are you back with a useful map of Vengoth?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif stage == 42 then
			npcHandler:say({
				"The spots you found on Vengoth are really interesting, especially the castle. There's something dark and spooky surrounding all of these places. ...",
				"I think if we found a way to get into the castle, we might get to the bottom of all this. Are you prepared to help me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 19)
		elseif stage == 51 then
			npcHandler:say("As I said, I don't know where you might get a blood crystal - but did you find one?", npc, creature)
			npcHandler:setTopic(playerId, 21)
		elseif stage == 52 then
			npcHandler:say("Ah! I can see in your eyes that you found someone! Do you have that charged crystal?", npc, creature)
			npcHandler:setTopic(playerId, 23)
		elseif stage == 53 then
			npcHandler:say("Ah! Welcome back! So you have been inside the castle? Was it as spooky as in the stories told by people?", npc, creature)
			npcHandler:setTopic(playerId, 26)
		elseif stage == 54 then
			npcHandler:say("Did you find anything of interest inside the castle?", npc, creature)
			npcHandler:setTopic(playerId, 28)
		elseif stage == 6 then
			if player:getStorageValue(BB.CastleBook) == 1 and player:getItemCount(28483) >= 1 then
				npcHandler:say("Ah, you found something! Let me see that book, please?", npc, creature)
				npcHandler:setTopic(playerId, 28)
			else
				npcHandler:say("Have you uncovered more about the dark history of the castle? Keep searching for hidden passages and documents.", npc, creature)
			end
		elseif stage == 7 then
			npcHandler:say("Impressive. A plant-crazy vampire... didn't think something like that existed. Have you got proof of his death?", npc, creature)
			npcHandler:setTopic(playerId, 30)
		elseif stage == 8 then
			npcHandler:say("A vain vampire hoping to see his image in the mirror once again some day... how ironic. Have you got proof of his death?", npc, creature)
			npcHandler:setTopic(playerId, 31)
		elseif stage == 9 then
			npcHandler:say("I can't help but to feel sorry about Marziel... he seemed to have been a decent guy according to his diary. But - have you got proof of his death?", npc, creature)
			npcHandler:setTopic(playerId, 32)
		elseif stage == 10 then
			npcHandler:say("You are back! You truly are a hero and a fierce vampire slayer! Have you got proof of Arthei's death?", npc, creature)
			npcHandler:setTopic(playerId, 33)
		end
	elseif MsgContains(message, "garlic bread") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Well, you need to mix flour with holy water and use that dough on garlic to create a special dough. Bake it like normal bread, but I guarantee that no vampire can eat that. Are you following me?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "aaah") then
		if npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(8194, 1) then
				npcHandler:say("Very well. I think I can trust you now. Sorry that I had to put you through this embarassing procedure, but I'm sure you understand. So, are you ready for your first real task?", npc, creature)
				player:setStorageValue(BB.Mission01, 4)
				npcHandler:setTopic(playerId, 5)
			else
				npcHandler:say("No, no, you didn't eat it! Vampire Brood! Say '{aaah}' once you have eaten the bread or get out of here instantly!", npc, creature)
			end
		end
	elseif message:lower() == "alori mort" then
		if npcHandler:getTopic(playerId) == 10 then
			npcHandler:say("Good. Don't play around with the spell, only use it when standing in front of those vampires. Come back and report to me about your progress later.", npc, creature)
			player:setStorageValue(BB.Mission03, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "armenius") then
		if npcHandler:getTopic(playerId) == 11 then
			npcHandler:say("I see... so Armenius is the master, and the spell didn't even cause a scratch on him... Well, that went worse than expected. Let me think for a moment and then ask me about a mission again.", npc, creature)
			player:setStorageValue(BB.Mission03, 3)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Armenius) == 1 then
				npcHandler:say("Ahh, I always thought something was suspicious about him. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BB.Cookies.Armenius, 2)
			elseif player:getStorageValue(BB.Cookies.Armenius) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif MsgContains(message, "maris") then
		if npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Maris) == 1 then
				npcHandler:say("He really doesn't look like the man of the sea he pretends to be, does he? Noted down! Any other name?", npc, creature)
				player:setStorageValue(BB.Cookies.Maris, 2)
			elseif player:getStorageValue(BB.Cookies.Maris) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif MsgContains(message, "ortheus") then
		if npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Ortheus) == 1 then
				npcHandler:say("I always thought that there is not really a poor beggar hidden under those ragged clothes. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BB.Cookies.Ortheus, 2)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif MsgContains(message, "serafin") then
		if npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Serafin) == 1 then
				npcHandler:say("Nice angelic name for a vampire. But he didn't escape your attention, well done. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BB.Cookies.Serafin, 2)
			elseif player:getStorageValue(BB.Cookies.Serafin) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif MsgContains(message, "lisander") then
		if npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Lisander) == 1 then
				npcHandler:say("Yes, that pale skin and those black eyes speak volumes. Noted down! Any other name?", npc, creature)
				player:setStorageValue(BB.Cookies.Lisander, 2)
			elseif player:getStorageValue(BB.Cookies.Lisander) == 2 then
				npcHandler:say("You already reported that name. Any new ones?", npc, creature)
			else
				npcHandler:say("Hm. You don't look so sure about that one. You should not report suspects that you did not confirm yourself! Any others?", npc, creature)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Well, there's one problem. How would I know I can trust you? You might be one of them... hm. Can you think of something really unlikely for a vampire? If you know a way to prove it to me, ask me about your {mission}.", npc, creature)
			player:setStorageValue(BB.Trust, 1)
			player:setStorageValue(BB.Mission01, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Fine then. Talk to me again about your mission once you have the garlic bread. You can get holy water from a member of the inquisition.", npc, creature)
			player:setStorageValue(BB.Mission01, 3)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say({
				"As I already told you, anyone in this city could really be a vampire, even the most unsuspicious citizen. I want you to find that brood. ...",
				"You can possibly identify the vampires by using a trick with hidden garlic, but better put it into something unsuspicious, like... cookies maybe! ...",
				"Just bake a few by using holy water on flour, then use that holy water dough on garlic, use the garlic dough on a baking tray and finally place the tray on an oven. Then just play little girl scout and distribute some cookies to the citizens. ...",
				"Watch their reaction! If it's suspicious, write down the name and let me know. Then we'll work something out against them. Agreed?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Fine. Good luck! Talk to me again about your mission once you have confirmed the names of five suspects.", npc, creature)
			player:setStorageValue(BB.Mission02, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Alright, wait a moment. Tell me one name at a time so I can note them down carefully. Who is a suspect?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say({
				"Great, now here's my plan. As I said, my strength lies not on the battlefield, but it's theory and knowledge. While you were distributing cookies I developed a spell. ...",
				"This spell is designed to reveal the identity of the master vampire and force him to show his true face. It is even likely that it instantly defeats him. ...",
				"I want you to go to the five vampires you detected and try out the magic formula on them. One of them - the oldest and most powerful - will react to it, I'm sure of it. The words are: '{Alori Mort}'. Please repeat them.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 12 then
			npcHandler:say({
				"Here is the map. When you are standing near a remarkable spot, use it to mark that spot on the map. Don't forget, come back with at least five marks! ...",
				"Also, they say there is a castle on this island. That mark HAS to be included, it's far too important to leave it out. Good luck!",
			}, npc, creature)
			player:addItem(8200)
			player:setStorageValue(BB.Mission04, 1)
			player:setStorageValue(BB.VengothAccess, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 13 then
			if player:getStorageValue(BB.MapMarks_CastleEntrance) == 1 then
				local marks = player:getStorageValue(BB.MapMarks) or 0
				local text = "five"
				if marks == 6 then
					text = "seven"
				elseif marks == 7 then -- entrace does not count
					text = "eight"
				end
				npcHandler:say("Well done, you even marked " .. text .. " places! I'll grant you a little bonus for that. Come back later and ask me about your next mission. I have to think.", npc, creature)
				player:setStorageValue(BB.Mission04, 2)
				player:removeItem(8200, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You haven't mapped enough places yet. Come back once you have found at least five remarkable places, including the castle.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 19 then
			npcHandler:say({
				"Good, now listen to what I've thought of. From what I've heard, there's a strong magic barrier blocking the entrance to the castle. ...",
				"If we could somehow redirect or focus that energy somewhere else, it might be possible to pass that door. I heard of a rare stone called 'blood crystal'. ...",
				"It is said to have the power to store magic energy. If you could find such a stone we might be able to charge it with energy that will attract the dark power floating around the castle. ...",
				"Unfortunately I have no idea where to look for a blood crystal. I think you might have to ask around in Yalahar, maybe someone knows where you could find one. Can you do that?",
			}, npc, creature)
			player:setStorageValue(BB.Mission05, 1)
			player:setStorageValue(BB.BloodCrystalDoor, 1)
			npcHandler:setTopic(playerId, 20)
		elseif npcHandler:getTopic(playerId) == 20 then
			npcHandler:say("Fine then. Good luck!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 21 then
			if player:getItemCount(8453) >= 1 then
				npcHandler:say({
					"Oh, look how it shimmers... such a pretty sight... now we just need to get it filled with magic energy. Maybe if you could find someone ...",
					"... someone who lost something or someone dear to him or her. Sometimes those people unknowingly emit massive amounts of energy - during their life and even after their death. ...",
					"If you can find someone like that, I'm sure that you will be able to charge the blood crystal. That's the only help I can give you though. Are you willing to try?",
				}, npc, creature)
				player:setStorageValue(BB.Mission05, 2)
				npcHandler:setTopic(playerId, 22)
			else
				npcHandler:say("You haven't found a blood crystal yet. Keep looking around Yalahar.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 22 then
			npcHandler:say("Once you have a charged crystal, hurry back to me. I don't know how long that power will last. Good luck!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 23 then
			npcHandler:say({
				"Very good, now don't lose that precious crystal! I doubt you'll be able to get another one. While you've been on the road, I wasn't lazy either. ...",
				"I have good news and bad news. Do you want to hear it?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 24)
		elseif npcHandler:getTopic(playerId) == 24 then
			npcHandler:say({
				"Well, in that case I'll tell you the good news first. I figured out how you can get into the castle using that blood crystal, quite easy actually. ...",
				"The bad thing is, you can't do it alone, but you need three more people who are also in possession of a charged blood crystal. ...",
				"The four of you have to stand on special spots around the castle. Unfortunately, in my books it doesn't say where exactly, but it mentions strange symbols. ...",
				"Once all four of you are standing on those spots holding a crystal, each of you will attract the castle's dark energy and get attuned to it. ...",
				"I don't know what will happen, but afterwards you should be able to pass the castle gate, if I'm not mistaken. Do you think you can do that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 25)
		elseif npcHandler:getTopic(playerId) == 25 then
			npcHandler:say("Great. You are impressing me more and more. Once you have been to the castle, come back and we will discuss further missions.", npc, creature)
			player:setStorageValue(BB.Mission05, 3)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 26 then
			if player:getStorageValue(BB.CastleEntranceSTG) == 1 then
				npcHandler:say({
					"Well anyway, as it seems there's more than that door protecting the castle, since you were not able to proceed any further - and those ghosts patrolling the hallway seem invulnerable. ...",
					"I wonder what the story behind this place is. Maybe you can somehow find a way past the ghosts and deeper down into the castle. ...",
					"If you could find some documents or books about this place there that would be a great help. Anything that tells us more about the master of this castle and how this place got so cursed. Could you do that?",
				}, npc, creature)
				player:setStorageValue(BB.Mission05, 4)
				npcHandler:setTopic(playerId, 27)
			else
				npcHandler:say("Have you been inside the castle yet?", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 27 then
			npcHandler:say("Fine. You know, those old castles sometimes have hidden passages and stuff like that. That's at least what they say in fairytales. Good luck!", npc, creature)
			player:setStorageValue(BB.CastleHiddenEntrance, 1)
			player:setStorageValue(BB.Mission06, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 28 then
			if player:getStorageValue(BB.CastleBook) == 1 and player:getItemCount(28483) >= 1 then
				player:removeItem(28483, 1)
				npcHandler:say({
					"Thank you so much, I'll grant you a small bonus for that. Let me take a closer look, hmm. There are a lot of pages missing... but that last page is kind of disturbing. ...",
					"The name on the front page says 'Marziel'... and it seems that his brothers and himself have something to do with this place. ...",
					"There are a lot of missing pages... I wonder what happened after March 30th? Listen, should you stumble across any more pages, please bring them to me for a small reward. I'd really like to figure this out. ...",
					"Apart from that, I guess to meet the brothers, you have to explore the castle even more. Maybe you can find another open door somewhere and look where - or who - it leads to?",
				}, npc, creature)
				player:setStorageValue(BB.Mission06, 2)
				player:setStorageValue(BB.Mission07, 1)
				player:setStorageValue(BB.BorethDoor, 1)
				npcHandler:setTopic(playerId, 29)
			else
				npcHandler:say("You haven't found anything useful yet. Keep exploring the castle.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 29 then
			npcHandler:say("Good luck. I mean it.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 30 then
			if player:getItemCount(8717) >= 1 then
				player:removeItem(8717, 1)
				npcHandler:say({
					"That's what I was hoping for! I will start investigating that dust. Maybe we can gain valuable information on how we can defeat the vampire plague once and for all. ...",
					"Listen, brave vampire slayer, I don't think that your task in this castle is done yet. According to the diary you found, there are three other brothers called Lersatio, Marziel and Arthei. ...",
					"We have to seek them all out and destroy them in order to weaken their power over the land. After Boreth's death, it is quite possible that you can gain access to another tower in the castle. ...",
					"That is your chance to find the second brother and awaken him. Good luck - again.",
				}, npc, creature)
				player:setStorageValue(BB.Mission07, 2)
				player:setStorageValue(BB.Mission08, 1)
				player:setStorageValue(BB.LersatioDoor, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Have you defeated Boreth? Bring me proof of his death.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 31 then
			if player:getItemCount(8718) >= 1 then
				player:removeItem(8718, 1)
				npcHandler:say({
					"You are definitely one of the bravest and craziest adventurers I ever met. Each time you prove to me that there is no task too dangerous for you. ...",
					"There are only two brothers left now, and I can feel that their grasp on Yalahar is getting weaker. We cannot stop now but have to finish what we started. ...",
					"See if you can slip into another tower of the castle and climb up to the room of the third brother. Since Arthei is their master, I guess Marziel is who we are going for now. ...",
					"The author of that diary... writing down the cursed story of his life. I hope he will rest in peace. Good luck.",
				}, npc, creature)
				player:setStorageValue(BB.Mission08, 2)
				player:setStorageValue(BB.Mission09, 1)
				player:setStorageValue(BB.Arthei_Marziel_Door, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Have you defeated Lersatio? Bring me proof of his death.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 32 then
			if player:getItemCount(8719) >= 1 then
				player:removeItem(8719, 1)
				npcHandler:say({
					"Well, let's see it this way - I guess he is relieved of his burden now - and so are his victims. Strange that a once such nice person turned out to be almost the cruelest of the brothers. ...",
					"I don't know what is awaiting you when you face Arthei. I hope that you can find a way to break his evil power and shatter his black soul... if a vampire still has a soul. ...",
					"I promise that when you come back with his ashes, your task for me is done and you will be generously rewarded. Don't let me down now.",
				}, npc, creature)
				player:setStorageValue(BB.Mission09, 2)
				player:setStorageValue(BB.Mission10, 1)
				player:setStorageValue(BB.ArtheiDoor, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Have you defeated Marziel? Bring me proof of his death.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 33 then
			if player:getItemCount(8720) >= 1 then
				player:removeItem(8720, 1)
				npcHandler:say({
					"So you really managed to defeat all four of the brothers. Unbelievable. As reward for your deeds, I'll grant you a special crest. ...",
					"I won't reveal what it does, but I'm sure you'll find out for yourself. Thank you very much for your help, I think the city is much safer now.",
				}, npc, creature)
				player:addItem(9041, 1)
				player:setStorageValue(BB.Mission10, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Have you defeated Arthei? Bring me proof of his death.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif message:lower() == "no" then
		if npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(BB.Cookies.Serafin) == 2 and player:getStorageValue(BB.Cookies.Lisander) == 2 and player:getStorageValue(BB.Cookies.Ortheus) == 2 and player:getStorageValue(BB.Cookies.Maris) == 2 and player:getStorageValue(BB.Cookies.Armenius) == 2 then
				npcHandler:say("I guess Armenius, Lisander, Maris, Ortheus and Serafin are all the names we can get for now. Let me think for a moment what we are going to do, talk to me about your mission again later.", npc, creature)
				player:setStorageValue(BB.Mission02, 2)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("No, no, I was asking for one of the names.", npc, creature)
			end
		end
	end

	return true
end

keywordHandler:addKeyword({ "distracted" }, StdModule.say, { npcHandler = npcHandler, text = "I come from a family of {vampire} hunters, but to be honest, I'm more into the theoretic part and strategic planning." })
keywordHandler:addAliasKeyword({ "job" })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "A better name would be Gomorrah, if you ask me." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Julius." })
keywordHandler:addKeyword({ "storkus" }, StdModule.say, { npcHandler = npcHandler, text = "Storkus? Oh yes, I know him. A long time ago we used to hunt together... sometimes." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "It's about time you showed the vampires that they should never bother the citizens again." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Another vampire raid last night. But then again, that's nothing new." })
keywordHandler:addKeyword({ "thank" }, StdModule.say, { npcHandler = npcHandler, text = "Well, I should be the one to thank you I guess." })

keywordHandler:addKeyword({ "map" }, function(npc, creature, type, message)
	local player = creature
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.MapCompleted) == 1 then
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission04) >= 1 then
		local hasMap = player:getItemCount(8200) >= 1

		if not hasMap then
			player:addItem(8200, 1)
			npcHandler:say("Please map the area for me and pay special attention to unusual spots in Vengoth. When you are standing near a remarkable spot, use it to mark that spot on the map.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		local marks = player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.MapMarks) or 0
		local totalLocations = 7

		if marks >= totalLocations then
			player:removeItem(8200, 1)
			npcHandler:say("Well done, you even marked seven places! I'll grant you a little bonus for that.", npc, creature)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.MapCompleted, 1)
			player:addExperience(7500)
		else
			player:removeItem(8200, 1)
			npcHandler:say("Are you back with a useful map of Vengoth? Alright, thanks. Let me know if you want to look for more unusual spots.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
end, { npcHandler = npcHandler })

keywordHandler:addKeyword({ "diary" }, function(npc, creature, type, message)
	local player = Player(creature)

	local diaryStg = player:getStorageValue(BB.DiarySTG)
	if diaryStg < 0 then
		player:setStorageValue(BB.DiarySTG, 0)
		diaryStg = 0
	end

	local hasPage2 = player:getStorageValue(BB.DiaryPage2) == 1
	local hasPage3 = player:getStorageValue(BB.DiaryPage3) == 1
	local hasPage4 = player:getStorageValue(BB.DiaryPage4) == 1
	local hasPage5 = player:getStorageValue(BB.DiaryPage5) == 1
	local hasPage6 = player:getStorageValue(BB.DiaryPage6) == 1
	local hasPage7 = player:getStorageValue(BB.DiaryPage7) == 1

	local pagesCollected = {
		[2] = hasPage2,
		[3] = hasPage3,
		[4] = hasPage4,
		[5] = hasPage5,
		[6] = hasPage6,
		[7] = hasPage7,
	}

	local nextPage = nil
	for page = 2, 7 do
		if pagesCollected[page] and diaryStg < (page - 1) then
			nextPage = page
			break
		end
	end

	local diaryResponses = {
		[2] = "Aha! That's the most interesting bit. They blamed Arthei for the curse...",
		[3] = "Let me see... that's very interesting. So Arthei was basically almost dead...",
		[4] = "Wow... now that is some story. A strange creature over Arthei's bed...",
		[5] = "Hmm... so after that incident, Arthei is a completely changed person...",
		[6] = "How very interesting... so that is how the four brothers got over to that island...",
		[7] = "So... after their arrival, the green island of Vengoth seems to be under a curse... wow... thanks for helping me piece it together!",
	}

	if nextPage then
		if player:removeItem(641, 1) then
			player:setStorageValue(BB.DiarySTG, nextPage - 1)
			player:addExperience(1000)
			npcHandler:say(diaryResponses[nextPage], npc, creature)
		else
			npcHandler:say("You have the page recorded in your memory, but you don't have the physical page with you!", npc, creature)
		end
	elseif diaryStg >= 6 then
		npcHandler:say("I think we have pieced together the whole story already. Thank you!", npc, creature)
	else
		npcHandler:say("You haven't found any diary pages yet. Keep exploring the castle library!", npc, creature)
	end

	return true
end, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. Never trust anyone.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "I'll reward you for every pair of vampire teeth you bring me.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "blood preservation", clientId = 11449, sell = 320 },
	{ itemName = "vampire teeth", clientId = 9685, sell = 275 },
}

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
