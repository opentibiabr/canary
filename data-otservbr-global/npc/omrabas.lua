local internalNpcName = "Omrabas"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 3114
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Typical. Easy come, easy go.' },
	{ text = 'He will PAY for this... They will ALL pay!' },
	{ text = '<groan>' },
	{ text = 'If I ever lay hands on him again...' }
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.GravediggerOfDrefia.QuestStart) < 1 then
			npcHandler:say("Hmm. You could be of assistance, I presume. I need several body parts. I will reward you adequately. Interested?", npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.QuestStart, 1)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission01) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission02) < 1 then
			npcHandler:say("Ah hello, young friend! Did you bring me two ghoul snacks as requested?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission02) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) < 1 then
			npcHandler:say("Ah, young friend, I found a solution! Find me two {demonic skeletal hands}. That should do it. Now run along! Ask me for {mission} when you're done.", npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission03, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission04) < 1 then
			npcHandler:say("Ah hello again! You look as if you could, er, lend me a hand or two? Yes?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission04) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission05) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission05, 1)
			npcHandler:say({
				"I need my heart back. I know where they have hidden it. Too afraid to destroy my beating heart, hah! ...",
				"It is in a dusty amphora in a sealed mass grave in the downmost cellar of my ancient home. The ruins lie to the north at the beach. ...",
				"Crash the amphoras to find my heart, and bring it to me."
			}, npc, creature)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission07) < 1 then
			npcHandler:say({
				"Yes? You have it? You what? Not in the amphoras? You picked it off someone else?!? ...",
				"Well, the important thing is that you have it. Let's see if it's still in good shape. {Give} it to me."
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission07) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission08) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission08, 1)
			npcHandler:say({
				"I will need brains - don't laugh! Ahem. I will need a stimulated brain, to be precise. ...",
				"Use two half-eaten brains with the Brain Heater Machine in the Necromancer halls and bring me the fused, stimulated brain. Now go!"
			}, npc, creature)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission09) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission10) < 1 then
			npcHandler:say("Yes, yes, hello. Tell me if you lost something. If not, do you have that stimulated brain with you?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission10) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission11) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission11, 1)
			player:addItem(19085,1)
			npcHandler:say({
				"Now that you have shown you've got the brains, I need you to show initiative. ...",
				"I will need something that can be adequately used as intestines. Something alive. Stuff it into this storage flask and return it to me!"
			}, npc, creature)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission12) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) < 1 then
			npcHandler:say("Hello, hello. Let's come to the point - did you find me some intestines?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission14) < 1 then
			npcHandler:say({
				"Good. As you may have gathered, the body parts you brought need to be assembled to form a whole body. ...",
				"This will happen through a necromantic ritual that we - or rather, you - now have to prepare. ...",
				"In a first step, it will involve retrieving specific artefacts of dark magic and hallowing the altars of the dark powers with them. ...",
				"After that, you will have to speak an ancient incantation to animate the body and fuse my soul within. ...",
				"But first things first. Are you ready to {undertake} the hallowing of the five altars?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission15) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) < 1 then
			npcHandler:say("Ah hello! Well done there, I felt the old powers settling down. Now, {ready} to hallow the next altar?", npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission16, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) < 1 then
			npcHandler:say({
				"I expected no less. Next is the Bonemarrow Altar, where the Dark Lord feasts upon the hallowed bones of...err. ...",
				"Ahem. Just take a yellowed bone or big bone, and hallow it - you don't know how? ...",
				"Huh. To HALLOW a yellowed bone, use it with one of the hallowed bonepiles in the Gardens Of Night. There are always bones around there - or were, in my days. ...",
				"Then, place the hallowed bone on the firebasin of the Bonemarrow Altar so the Dark Lord can consume it and grants us his power. Return to me after that."
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission17, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission18) < 1 then
			npcHandler:say({
				"Are you still here? Come on, let's not laze about, go to the Gardens of Night - where? ...",
				"East of the Necromancer Halls, you can't miss it, just look for a lot of dark and white sand, dried trees, and priestesses! ...",
				"Or got a {problem} with finding bones? Hah!"
			}, npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission20) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) < 1 then
			npcHandler:say({
				"Ah, welcome, welcome! I felt that one! The Dark Lord is pleased with the gift you brought, so now we can proceed with everything as planned. ...",
				"If it had gone wrong though, he would have had your guts for gart... er... well, here you are, so - ready to get some {blood} flowing?"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission21, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) < 1 then
			npcHandler:say({
				"Yes, I said blood. Important ingredient in necromantic rituals, usually. ...",
				"You need to spill some vials of blood tincture for this task. Probably means killing blood priests to get those vials. Ready to do this?"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission22, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission25) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission26) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission26, 1)
			npcHandler:say({
				"Ah, it is invigorating to fell the dark flows, rushing through Drefia, once again! Capital. This has earned you a reward. ...",
				"Now, the next mission awaits, {yes}?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission29) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission30) < 1 then
			npcHandler:say({
				"Ah, finally. Exceptional! Don't you feel the earth awakening to our call? No? Oh. ...",
				"Anyway, you succeeded in hallowing the Fireglass Altar! Only one altar remains to be hallowed! Shall we {proceed}?"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission30, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission33) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission34, 1)
			npcHandler:say({
				"Yes! YES! I have felt that! The altars are alive again! Well done! ...",
				"We are close now. Only one important thing remains: the incantation itself. We need the {scroll} for that."
			}, npc, creature)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) < 1 then
			npcHandler:say('Yes? Do you have the {scroll} piece? ', npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) < 1 then
			npcHandler:say("Ah, hello! I take it you have the next scroll piece for me, {yes}?", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, npc, creature)
			player:addItem(19173, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			npcHandler:say("Hello - what? You have the {scroll} piece, you say?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(19148, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...",
				"One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, npc, creature)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) < 1 then
			npcHandler:say("Hello, young apprentice. Do you have that {scroll} piece from the priestess?", npc, creature)
			player:addItem(19148, 1)
			npcHandler:setTopic(playerId, 14)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) < 1 then
			npcHandler:say({
				"That's the spirit! Speaking of which, you will have to look for a White Shade ...",
				"That's a ghost, in case you don't know. Goes by name of... Zarifan, if I recall correctly. ...",
				"His grave is somewhere to the south, somewhere deeper. And he only reacts to magic words. ...",
				"Err... it's embarrassing... the magic words are <mumble> <mumble> <ahem> ...",
				"'Friendship lives forever.' Silly, really. Untrue, as well. ...",
				"Anyway, say those three words - don't make me repeat them - and the old softie will tell you where the scroll is. Pathetic."
			}, npc, creature)
			player:addItem(19148, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission66, 1)
		--elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then
			--npcHandler:say("Welcome, welcome! Finally! The last scroll piece.... you do have it, haven't you?", npc, creature)
			--npcHandler:setTopic(playerId, 15)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission71) < 1 then
			npcHandler:say("Don't keep me waiting. The last scroll piece - were you able to {restore} it?", npc, creature)
			npcHandler:setTopic(playerId, 16)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) == 1 then--and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
			npcHandler:say({
				"It failed! IT FAILED! WHY? What have you done! This must be your fault! ...",
				"You... did... that was a recipe for chicken soup! No wonder the scroll failed! Now... all is lost ...",
				"<sobs drily> I never want to see you again! You and your dirty gravedigger hands! Take this, you ungrateful, useless, imbecile... human! ...",
				"Now... get out! And never, ever, dare come back! You ruined EVERYTHING!"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission73, 2)
			player:addItem(19136, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.QuestStart) == 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission01, 1)
			npcHandler:say({
				"Very sensible of you. I will pay you handsomely for your help. ...",
				"All you have to do is fetch diverse fresh body parts and then prepare the resurrection ritual. Nothing out of the ordinary. ...",
				"First, I need two arms. Ghouls usually carry some as a snack. Two ghoul snacks should not be hard to get! Return when you have them."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission01) == 1 then
			if player:removeItem(11467, 2) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission02, 1)
				npcHandler:say("Splendid! What? They're half gnawed! There are no hands! Hrmmm. Let me think of a solution. Ask me for a new {mission}.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have two ghoul snacks.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) == 1 then
			if player:removeItem(9647, 2) then
				npcHandler:say("Yes. Those will be adequate. Talk to me again if you want to continue with your next {mission}.", npc, creature)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission04, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have two demonic skeletal hands.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 then
			if player:removeItem(19077, 1) then
				npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", npc, creature)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission07, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my heart.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 5 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission09) == 1 then
			if player:removeItem(19078, 1) then
				npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", npc, creature)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission10, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have the brain.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 6 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission12) == 1 then
			if player:removeItem(19086, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission13, 1)
				npcHandler:say({
					"Ah... interesting. A snake? Not bad, not bad at all. ...",
					"Right. Now, we need to waken the old powers through ritual. Let me know when you are ready for this {mission}."
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my intestine.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission23) < 1 then
			npcHandler:say({
				"Ah, I knew you were a sturdy fellow! Necromancer material if ever I saw one! ...",
				"Well then, the next task is to anoint the Bloodgong Altar. This will animate the dark flows we need for the ritual. ...",
				"You need to spill a vial of blood tincture on each of the four sacrifical stones of the altar in order to anoint them. ...",
				"Then, toll the Bloodgong north of the sacrificial stones to set the dark flows going. Return to me after that."
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission23, 1)
		elseif npcHandler:getTopic(playerId) == 9 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission26) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission27) < 1 then
			npcHandler:say({
				"Excellent. To bind the earthly powers, we, I mean you, must worship at the Fireglass Altar. ...",
				"This means scattering sacred ashes from the Ember Chamber on the sacrificial stones of the Fireglass Altar. ...",
				"To gather the sacred ashes, you have to use magic chalk with the Shadow Fire in the Ember Chamber. ...",
				"Gather the resulting ashes from the Shadow Hearth, and scatter them on the Fireglass Altar's sacrificial stones. Then return here."
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission27, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 10 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission35, 1)
			npcHandler:say({
				"Superb! You won't regret this. I will reward you beyond your wildest dreams! ...",
				"I know that one of my former friends joined the blood priests later on. He made it quite high before he was ritually killed. ...",
				"Go find a blood priest you can talk to. Ask him, but subtly. And never tell anyone what the scroll does!"
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 11 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 then
			if player:removeItem(18933, 1) then
				npcHandler:say("This is it! This is it! Well done, well done! And now, on to the {next} scroll piece, {yes}?", npc, creature)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission43, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif npcHandler:getTopic(playerId) == 12 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 then
			if player:removeItem(18933, 1) then
				npcHandler:say("Indeed it is! The second scroll piece! Splendid! Here you go - for your trouble. And now, on to the {next} scroll piece, {yes}? ", npc, creature)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission51, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, npc, creature)
			player:addItem(19173, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif npcHandler:getTopic(playerId) == 13 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			if player:removeItem(18933, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission58, 1)
				npcHandler:say({
					"Oh, praise the Dark Lord! It is my scroll piece! Give it here! You can have this instead. ...",
					"Ahh, that feels GOOD. Now, only two pieces left to hunt down! On to the {next} scroll piece, yes?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(19148, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...", "One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, npc, creature)
		elseif npcHandler:getTopic(playerId) == 15 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then

			if player:removeItem(18933, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission69, 1)
				npcHandler:say({
					"Ahhh, capital, capital. Good girl for keeping it for me. I'll take back my cape now, thank you. ...",
					"Now - the final part of the scroll! Ready to go retrieve it?"
				}, npc, creature)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission71) < 1 then
			npcHandler:say({
				"That's the spirit! Speaking of which, you will have to look for a White Shade ...",
				"That's a ghost, in case you don't know. Goes by name of... Zarifan, if I recall correctly. ...",
				"His grave is somewhere to the south, somewhere deeper. And he only reacts to magic words. ...",
				"Err... it's embarrassing... the magic words are <mumble> <mumble> <ahem> ...",
				"'Friendship lives forever.' Silly, really. Untrue, as well. ...",
				"Anyway, say those three words - don't make me repeat them - and the old softie will tell you where the scroll is. Pathetic."
			}, npc, creature)
			player:addItem(19148, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission71, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission69, 1)
		elseif npcHandler:getTopic(playerId) == 15 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission72) < 1 then
			if player:removeItem(18933, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission72, 1)
				npcHandler:say({
					"I am so excited! Finally, we - wait. What is this? That... is not the complete scroll piece. ...",
					"I don't care what you say! This is a disaster! We need a complete scr - wait. I have an idea. ...",
					"There must be a copy or something in my old library. something to use with the scroll, to find the missing words. ...",
					"There must be. Go look there. Next to the fiveserrated room, a small library. Go go go!"
				}, npc, creature)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 17 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
			npcHandler:say({
				"Then let's go. Take my skull and the incantation scroll to the working station in the fiveserrated room ...",
				"Where the lava flows and the southern legs of the room meet. Place the Skull on the sacrificial stone and use the scroll ...",
				"AND I shall be made whole, and YOU shall be RICH!"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission74, 1)
			player:addItem(18934, 1)
			player:addItem(19160, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'demonic skeletal hands') or MsgContains(message, 'demonic skeletal hand') then
		npcHandler:say("What? Hack some off from a demon skeleton, of course! Now get moving.", npc, creature)
	elseif MsgContains(message, 'give') and npcHandler:getTopic(playerId) == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 then
		if player:removeItem(19077, 1) then
			npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission07, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You don't have my heart.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'undertake') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) == 1 and npcHandler:getTopic(playerId) == 7  then
		npcHandler:say({
			"Good! Let's not waste time. The first altar you must hallow is the Dragonsoul Altar, at the eastern side of the room. ...",
			"To hallow it, dig out three dragon tears and place them on the altar to appease the dark powers. ...",
			"What? Oh, you'll find some dragon tears near dragon skulls... where? ...",
			"In the Dragonbone Cemetery, OBVIOUSLY! Must I explain EVERYTHING to you? Now go!"
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission14, 1)
		player:addItem(19084,3)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'ready') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) < 1 then
		npcHandler:say({
			"I expected no less. Next is the Bonemarrow Altar, where the Dark Lord feasts upon the hallowed bones of...err. ...",
			"Ahem. Just take a yellowed bone or big bone, and hallow it - you don't know how? ...",
			"Huh. To HALLOW a yellowed bone, use it with one of the hallowed bonepiles in the Gardens Of Night. There are always bones around there - or were, in my days. ...",
			"Then, place the hallowed bone on the firebasin of the Bonemarrow Altar so the Dark Lord can consume it and grants us his power. Return to me after that."
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission17, 1)
	elseif MsgContains(message, 'problem') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and npcHandler:getTopic(playerId) == 8 then
		npcHandler:say("What? No bones around you say? Hrmmm. Wait. Check the skull heap here - that's right - hah! There! Now get to work!", npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission18, 1)
		player:addItem(19090, 3)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'blood') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) < 1 then
		npcHandler:say({
			"Yes, I said blood. Important ingredient in necromantic rituals, usually. ...",
			"You need to spill some vials of blood tincture for this task. Probably means killing blood priests to get those vials. Ready to do this?"
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission22, 1)
	elseif MsgContains(message, 'proceed') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission30) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission31) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission31, 1)
		player:addItem(19132, 1)
		player:addItem(19166, 1)
		npcHandler:say({
			"<reverential> The final altar that remains to be hallowed... the Shadowthrone. ...",
			"Only a candle made of human tallow placed before each shadow statue in the right order, will awaken it. ...",
			"I say, are you sick? Human tallow candles are a perfectly good tool - don't look at me like that! Be professional about this, will you? ...",
			"I have some candles hidden deep down in the lich caves, east of here. Here's the key that opens the trapdoor to the cache. ...",
			"And take this parchment. Identify the right candles with it, take three with you and place one in front of the three shadowthrone statues, starting counterclockwise. Now go!"
		}, npc, creature)
	elseif MsgContains(message, 'scroll') then
		if player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) < 1 then
			npcHandler:say({
				"Well, it is a rather long story. The short version: I had friends - no need to snigger. ...",
				"We were five highly brilliant dark summoners. We joined our forces to find the scroll of Youth and Life Eternal. ...",
				"But when we finally found it after years of toiling and danger, we quarreled over who could have it. The scroll tore. ...",
				"We each retained one piece of the scroll. Well, that was a long time ago. ...",
				"But I think I have a clue where we can find the first piece of the scroll. Would you go looking?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) < 1 then
			npcHandler:say("Yes? Do you have the {scroll} piece?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) < 1 then
			npcHandler:say("Ah, hello! I take it you have the next {scroll} piece for me, {yes}?", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif npcHandler:getTopic(playerId) == 13 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			if player:removeItem(18933, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission58, 1)
				npcHandler:say({
					"Oh, praise the Dark Lord! It is my scroll piece! Give it here! You can have this instead. ...",
					"Ahh, that feels GOOD. Now, only two pieces left to hunt down! On to the {next} scroll piece, yes?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have my scroll.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) < 1 then
			npcHandler:say("Hello, young apprentice. Do you have that {scroll} piece from the priestess?", npc, creature)
			player:addItem(19148, 1)

		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then
			npcHandler:say("Welcome, welcome! Finally! The last {scroll} piece.... you do have it, haven't you?", npc, creature)
			npcHandler:setTopic(playerId, 15)
		end
	elseif MsgContains(message, 'next') then
		if player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, npc, creature)
			player:addItem(19173, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(19148, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...",
				"One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, npc, creature)
		end
	elseif MsgContains(message, 'restore') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) <= 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) < 1 then --and npcHandler:getTopic(playerId) == 15 then
		if player:removeItem(19158, 1) then
			npcHandler:say({
				"I knew it! I knew I had made a copy! Oh, I am so clever! ...",
				"Now, watch this. <mumbles darkly> THERE. THE COMPLETE INCANTATION SCROLL. ...",
				"You have done well. Only one thing remains, and you shall be rich beyond your dreams. Ready for the really final task?"
			}, npc, creature)
			--player:setStorageValue(Storage.GravediggerOfDrefia.Mission72, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission73, 1)
			npcHandler:setTopic(playerId, 17)
		else
			npcHandler:say("You don't have my scroll.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		else npcHandler:say("Chzzzz. wtf??@! leave.", npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "At last, a visitor! Welcome to my... humble abode.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
