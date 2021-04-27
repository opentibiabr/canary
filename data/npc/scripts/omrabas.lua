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
	{ text = 'Typical. Easy come, easy go.' },
	{ text = 'He will PAY for this... They will ALL pay!' },
	{ text = '<groan>' },
	{ text = 'If I ever lay hands on him again...' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.GravediggerOfDrefia.QuestStart) < 1 then
			npcHandler:say("Hmm. You could be of assistance, I presume. I need several body parts. I will reward you adequately. Interested?", cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.QuestStart, 1)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission01) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission02) < 1 then
			npcHandler:say("Ah hello, young friend! Did you bring me two ghoul snacks as requested?", cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission02) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) < 1 then
			npcHandler:say("Ah, young friend, I found a solution! Find me two {demonic skeletal hands}. That should do it. Now run along! Ask me for {mission} when you're done.", cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission03, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission04) < 1 then
			npcHandler:say("Ah hello again! You look as if you could, er, lend me a hand or two? Yes?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission04) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission05) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission05, 1)
			npcHandler:say({
				"I need my heart back. I know where they have hidden it. Too afraid to destroy my beating heart, hah! ...",
				"It is in a dusty amphora in a sealed mass grave in the downmost cellar of my ancient home. The ruins lie to the north at the beach. ...",
				"Crash the amphoras to find my heart, and bring it to me."
			}, cid)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission07) < 1 then
			npcHandler:say({
				"Yes? You have it? You what? Not in the amphoras? You picked it off someone else?!? ...",
				"Well, the important thing is that you have it. Let's see if it's still in good shape. {Give} it to me."
			}, cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission07) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission08) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission08, 1)
			npcHandler:say({
				"I will need brains - don't laugh! Ahem. I will need a stimulated brain, to be precise. ...",
				"Use two half-eaten brains with the Brain Heater Machine in the Necromancer halls and bring me the fused, stimulated brain. Now go!"
			}, cid)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission09) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission10) < 1 then
			npcHandler:say("Yes, yes, hello. Tell me if you lost something. If not, do you have that stimulated brain with you?", cid)
			npcHandler.topic[cid] = 5
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission10) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission11) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission11, 1)
			player:addItem(21402,1)
			npcHandler:say({
				"Now that you have shown you've got the brains, I need you to show initiative. ...",
				"I will need something that can be adequately used as intestines. Something alive. Stuff it into this storage flask and return it to me!"
			}, cid)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission12) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) < 1 then
			npcHandler:say("Hello, hello. Let's come to the point - did you find me some intestines?", cid)
			npcHandler.topic[cid] = 6
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission14) < 1 then
			npcHandler:say({
				"Good. As you may have gathered, the body parts you brought need to be assembled to form a whole body. ...",
				"This will happen through a necromantic ritual that we - or rather, you - now have to prepare. ...",
				"In a first step, it will involve retrieving specific artefacts of dark magic and hallowing the altars of the dark powers with them. ...",
				"After that, you will have to speak an ancient incantation to animate the body and fuse my soul within. ...",
				"But first things first. Are you ready to {undertake} the hallowing of the five altars?"
			}, cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission15) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) < 1 then
			npcHandler:say("Ah hello! Well done there, I felt the old powers settling down. Now, {ready} to hallow the next altar?", cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission16, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) < 1 then
			npcHandler:say({
				"I expected no less. Next is the Bonemarrow Altar, where the Dark Lord feasts upon the hallowed bones of...err. ...",
				"Ahem. Just take a yellowed bone or big bone, and hallow it - you don't know how? ...",
				"Huh. To HALLOW a yellowed bone, use it with one of the hallowed bonepiles in the Gardens Of Night. There are always bones around there - or were, in my days. ...",
				"Then, place the hallowed bone on the firebasin of the Bonemarrow Altar so the Dark Lord can consume it and grants us his power. Return to me after that."
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission17, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission18) < 1 then
			npcHandler:say({
				"Are you still here? Come on, let's not laze about, go to the Gardens of Night - where? ...",
				"East of the Necromancer Halls, you can't miss it, just look for a lot of dark and white sand, dried trees, and priestesses! ...",
				"Or got a {problem} with finding bones? Hah!"
			}, cid)
			npcHandler.topic[cid] = 8
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission20) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) < 1 then
			npcHandler:say({
				"Ah, welcome, welcome! I felt that one! The Dark Lord is pleased with the gift you brought, so now we can proceed with everything as planned. ...",
				"If it had gone wrong though, he would have had your guts for gart... er... well, here you are, so - ready to get some {blood} flowing?"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission21, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) < 1 then
			npcHandler:say({
				"Yes, I said blood. Important ingredient in necromantic rituals, usually. ...",
				"You need to spill some vials of blood tincture for this task. Probably means killing blood priests to get those vials. Ready to do this?"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission22, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission25) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission26) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission26, 1)
			npcHandler:say({
				"Ah, it is invigorating to fell the dark flows, rushing through Drefia, once again! Capital. This has earned you a reward. ...",
				"Now, the next mission awaits, {yes}?"
			}, cid)
			npcHandler.topic[cid] = 9
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission29) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission30) < 1 then
			npcHandler:say({
				"Ah, finally. Exceptional! Don't you feel the earth awakening to our call? No? Oh. ...",
				"Anyway, you succeeded in hallowing the Fireglass Altar! Only one altar remains to be hallowed! Shall we {proceed}?"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission30, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission33) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission34, 1)
			npcHandler:say({
				"Yes! YES! I have felt that! The altars are alive again! Well done! ...",
				"We are close now. Only one important thing remains: the incantation itself. We need the {scroll} for that."
			}, cid)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) < 1 then
			npcHandler:say('Yes? Do you have the {scroll} piece? ', cid)
			npcHandler.topic[cid] = 11
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) < 1 then
			npcHandler:say("Ah, hello! I take it you have the next scroll piece for me, {yes}?", cid)
			npcHandler.topic[cid] = 12
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, cid)
			player:addItem(21489, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			npcHandler:say("Hello - what? You have the {scroll} piece, you say?", cid)
			npcHandler.topic[cid] = 13
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(21464, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...",
				"One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, cid)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) < 1 then
			npcHandler:say("Hello, young apprentice. Do you have that {scroll} piece from the priestess?", cid)
			player:addItem(21464, 1)
			npcHandler.topic[cid] = 14
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) < 1 then
			npcHandler:say({
				"That's the spirit! Speaking of which, you will have to look for a White Shade ...",
				"That's a ghost, in case you don't know. Goes by name of... Zarifan, if I recall correctly. ...",
				"His grave is somewhere to the south, somewhere deeper. And he only reacts to magic words. ...",
				"Err... it's embarrassing... the magic words are <mumble> <mumble> <ahem> ...",
				"'Friendship lives forever.' Silly, really. Untrue, as well. ...",
				"Anyway, say those three words - don't make me repeat them - and the old softie will tell you where the scroll is. Pathetic."
			}, cid)
			player:addItem(21464, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission66, 1)
		--elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then
			--npcHandler:say("Welcome, welcome! Finally! The last scroll piece.... you do have it, haven't you?", cid)
			--npcHandler.topic[cid] = 15
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission71) < 1 then
			npcHandler:say("Don't keep me waiting. The last scroll piece - were you able to {restore} it?", cid)
			npcHandler.topic[cid] = 16
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) == 1 then--and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
			npcHandler:say({
				"It failed! IT FAILED! WHY? What have you done! This must be your fault! ...",
				"You... did... that was a recipe for chicken soup! No wonder the scroll failed! Now... all is lost ...",
				"<sobs drily> I never want to see you again! You and your dirty gravedigger hands! Take this, you ungrateful, useless, imbecile... human! ...",
				"Now... get out! And never, ever, dare come back! You ruined EVERYTHING!"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission73, 2)
			player:addItem(21452, 1)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.QuestStart) == 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission01, 1)
			npcHandler:say({
				"Very sensible of you. I will pay you handsomely for your help. ...",
				"All you have to do is fetch diverse fresh body parts and then prepare the resurrection ritual. Nothing out of the ordinary. ...",
				"First, I need two arms. Ghouls usually carry some as a snack. Two ghoul snacks should not be hard to get! Return when you have them."
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission01) == 1 then
			if player:removeItem(12423, 2) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission02, 1)
				npcHandler:say("Splendid! What? They're half gnawed! There are no hands! Hrmmm. Let me think of a solution. Ask me for a new {mission}.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have two ghoul snacks.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 3 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission03) == 1 then
			if player:removeItem(10564, 2) then
				npcHandler:say("Yes. Those will be adequate. Talk to me again if you want to continue with your next {mission}.", cid)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission04, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have two demonic skeletal hands.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 then
			if player:removeItem(21394, 1) then
				npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", cid)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission07, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my heart.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 5 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission09) == 1 then
			if player:removeItem(21395, 1) then
				npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", cid)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission10, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have the brain.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 6 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission12) == 1 then
			if player:removeItem(21403, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission13, 1)
				npcHandler:say({
					"Ah... interesting. A snake? Not bad, not bad at all. ...",
					"Right. Now, we need to waken the old powers through ritual. Let me know when you are ready for this {mission}."
				}, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my intestine.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission23) < 1 then
			npcHandler:say({
				"Ah, I knew you were a sturdy fellow! Necromancer material if ever I saw one! ...",
				"Well then, the next task is to anoint the Bloodgong Altar. This will animate the dark flows we need for the ritual. ...",
				"You need to spill a vial of blood tincture on each of the four sacrifical stones of the altar in order to anoint them. ...",
				"Then, toll the Bloodgong north of the sacrificial stones to set the dark flows going. Return to me after that."
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission23, 1)
		elseif npcHandler.topic[cid] == 9 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission26) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission27) < 1 then
			npcHandler:say({
				"Excellent. To bind the earthly powers, we, I mean you, must worship at the Fireglass Altar. ...",
				"This means scattering sacred ashes from the Ember Chamber on the sacrificial stones of the Fireglass Altar. ...",
				"To gather the sacred ashes, you have to use magic chalk with the Shadow Fire in the Ember Chamber. ...",
				"Gather the resulting ashes from the Shadow Hearth, and scatter them on the Fireglass Altar's sacrificial stones. Then return here."
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission27, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 10 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) < 1 then
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission35, 1)
			npcHandler:say({
				"Superb! You won't regret this. I will reward you beyond your wildest dreams! ...",
				"I know that one of my former friends joined the blood priests later on. He made it quite high before he was ritually killed. ...",
				"Go find a blood priest you can talk to. Ask him, but subtly. And never tell anyone what the scroll does!"
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 11 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 then
			if player:removeItem(21250, 1) then
				npcHandler:say("This is it! This is it! Well done, well done! And now, on to the {next} scroll piece, {yes}?", cid)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission43, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif npcHandler.topic[cid] == 12 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 then
			if player:removeItem(21250, 1) then
				npcHandler:say("Indeed it is! The second scroll piece! Splendid! Here you go - for your trouble. And now, on to the {next} scroll piece, {yes}? ", cid)
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission51, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, cid)
			player:addItem(21489, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif npcHandler.topic[cid] == 13 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			if player:removeItem(21250, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission58, 1)
				npcHandler:say({
					"Oh, praise the Dark Lord! It is my scroll piece! Give it here! You can have this instead. ...",
					"Ahh, that feels GOOD. Now, only two pieces left to hunt down! On to the {next} scroll piece, yes?"
				}, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(21464, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...", "One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, cid)
		elseif npcHandler.topic[cid] == 15 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then

			if player:removeItem(21250, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission69, 1)
				npcHandler:say({
					"Ahhh, capital, capital. Good girl for keeping it for me. I'll take back my cape now, thank you. ...",
					"Now - the final part of the scroll! Ready to go retrieve it?"
				}, cid)
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission71) < 1 then
			npcHandler:say({
				"That's the spirit! Speaking of which, you will have to look for a White Shade ...",
				"That's a ghost, in case you don't know. Goes by name of... Zarifan, if I recall correctly. ...",
				"His grave is somewhere to the south, somewhere deeper. And he only reacts to magic words. ...",
				"Err... it's embarrassing... the magic words are <mumble> <mumble> <ahem> ...",
				"'Friendship lives forever.' Silly, really. Untrue, as well. ...",
				"Anyway, say those three words - don't make me repeat them - and the old softie will tell you where the scroll is. Pathetic."
			}, cid)
			player:addItem(21464, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission71, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission69, 1)
		elseif npcHandler.topic[cid] == 15 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission72) < 1 then
			if player:removeItem(21250, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission72, 1)
				npcHandler:say({
					"I am so excited! Finally, we - wait. What is this? That... is not the complete scroll piece. ...",
					"I don't care what you say! This is a disaster! We need a complete scr - wait. I have an idea. ...",
					"There must be a copy or something in my old library. something to use with the scroll, to find the missing words. ...",
					"There must be. Go look there. Next to the fiveserrated room, a small library. Go go go!"
				}, cid)
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 17 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission74) < 1 then
			npcHandler:say({
				"Then let's go. Take my skull and the incantation scroll to the working station in the fiveserrated room ...",
				"Where the lava flows and the southern legs of the room meet. Place the Skull on the sacrificial stone and use the scroll ...",
				"AND I shall be made whole, and YOU shall be RICH!"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission74, 1)
			player:addItem(21251, 1)
			player:addItem(21476, 1)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'demonic skeletal hands') or msgcontains(msg, 'demonic skeletal hand') then
		npcHandler:say("What? Hack some off from a demon skeleton, of course! Now get moving.", cid)
	elseif msgcontains(msg, 'give') and npcHandler.topic[cid] == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission06) == 1 then
		if player:removeItem(21394, 1) then
			npcHandler:say("Ah... <sighs> Very good. Just say the word when you are ready for the next {mission}.", cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission07, 1)
			npcHandler.topic[cid] = 0
		else
			npcHandler:say("You don't have my heart.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'undertake') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission13) == 1 and npcHandler.topic[cid] == 7  then
		npcHandler:say({
			"Good! Let's not waste time. The first altar you must hallow is the Dragonsoul Altar, at the eastern side of the room. ...",
			"To hallow it, dig out three dragon tears and place them on the altar to appease the dark powers. ...",
			"What? Oh, you'll find some dragon tears near dragon skulls... where? ...",
			"In the Dragonbone Cemetery, OBVIOUSLY! Must I explain EVERYTHING to you? Now go!"
		}, cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission14, 1)
		player:addItem(21401,3)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'ready') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission16) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) < 1 then
		npcHandler:say({
			"I expected no less. Next is the Bonemarrow Altar, where the Dark Lord feasts upon the hallowed bones of...err. ...",
			"Ahem. Just take a yellowed bone or big bone, and hallow it - you don't know how? ...",
			"Huh. To HALLOW a yellowed bone, use it with one of the hallowed bonepiles in the Gardens Of Night. There are always bones around there - or were, in my days. ...",
			"Then, place the hallowed bone on the firebasin of the Bonemarrow Altar so the Dark Lord can consume it and grants us his power. Return to me after that."
		}, cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission17, 1)
	elseif msgcontains(msg, 'problem') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and npcHandler.topic[cid] == 8 then
		npcHandler:say("What? No bones around you say? Hrmmm. Wait. Check the skull heap here - that's right - hah! There! Now get to work!", cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission18, 1)
		player:addItem(21407, 3)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'blood') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission21) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission22) < 1 then
		npcHandler:say({
			"Yes, I said blood. Important ingredient in necromantic rituals, usually. ...",
			"You need to spill some vials of blood tincture for this task. Probably means killing blood priests to get those vials. Ready to do this?"
		}, cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission22, 1)
	elseif msgcontains(msg, 'proceed') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission30) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission31) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission31, 1)
		player:addItem(21448, 1)
		player:addItem(21482, 1)
		npcHandler:say({
			"<reverential> The final altar that remains to be hallowed... the Shadowthrone. ...",
			"Only a candle made of human tallow placed before each shadow statue in the right order, will awaken it. ...",
			"I say, are you sick? Human tallow candles are a perfectly good tool - don't look at me like that! Be professional about this, will you? ...",
			"I have some candles hidden deep down in the lich caves, east of here. Here's the key that opens the trapdoor to the cache. ...",
			"And take this parchment. Identify the right candles with it, take three with you and place one in front of the three shadowthrone statues, starting counterclockwise. Now go!"
		}, cid)
	elseif msgcontains(msg, 'scroll') then
		if player:getStorageValue(Storage.GravediggerOfDrefia.Mission34) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) < 1 then
			npcHandler:say({
				"Well, it is a rather long story. The short version: I had friends - no need to snigger. ...",
				"We were five highly brilliant dark summoners. We joined our forces to find the scroll of Youth and Life Eternal. ...",
				"But when we finally found it after years of toiling and danger, we quarreled over who could have it. The scroll tore. ...",
				"We each retained one piece of the scroll. Well, that was a long time ago. ...",
				"But I think I have a clue where we can find the first piece of the scroll. Would you go looking?"
			}, cid)
			npcHandler.topic[cid] = 10
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) < 1 then
			npcHandler:say("Yes? Do you have the {scroll} piece?", cid)
			npcHandler.topic[cid] = 11
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) < 1 then
			npcHandler:say("Ah, hello! I take it you have the next {scroll} piece for me, {yes}?", cid)
			npcHandler.topic[cid] = 12
		elseif npcHandler.topic[cid] == 13 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission57) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) < 1 then
			if player:removeItem(21250, 1) then
				player:setStorageValue(Storage.GravediggerOfDrefia.Mission58, 1)
				npcHandler:say({
					"Oh, praise the Dark Lord! It is my scroll piece! Give it here! You can have this instead. ...",
					"Ahh, that feels GOOD. Now, only two pieces left to hunt down! On to the {next} scroll piece, yes?"
				}, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have my scroll.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission65) < 1 then
			npcHandler:say("Hello, young apprentice. Do you have that {scroll} piece from the priestess?", cid)
			player:addItem(21464, 1)

		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) < 1 then
			npcHandler:say("Welcome, welcome! Finally! The last {scroll} piece.... you do have it, haven't you?", cid)
			npcHandler.topic[cid] = 15
		end
	elseif msgcontains(msg, 'next') then
		if player:getStorageValue(Storage.GravediggerOfDrefia.Mission43) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission44) < 1 then
			npcHandler:say({
				"Hah, developed a taste for it, have you? I believe the next scroll piece was hidden somewhere, my old friend being of a somewhat distrustful nature. ...",
				"The scent may not be lost, though - ask a shadow pupil if he can help - but be careful. ...",
				"Those shadow pupils are - strange. Try to find one who will answer and not kill you!"
			}, cid)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission44, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission51) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission52) < 1 then
			npcHandler:say({
				"Good! As you can imagine, I had a scroll piece, too. I hid it in my old quarters, northwest of the library. ...",
				"The door is magically sealed. Use this copper key with it to get inside. ...",
				"Beneath one of the chests is a secret stash, under a loose stone tile. The scroll piece should be inside. Off you go."
			}, cid)
			player:addItem(21489, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission52, 1)
		elseif player:getStorageValue(Storage.GravediggerOfDrefia.Mission58) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) < 1 then
			player:addItem(21464, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission59, 1)
			npcHandler:say({
				"Hahah, eager for it, I like that! ...",
				"One piece stayed in the hands of a beautiful priestess. ...",
				"As they never throw anything away that looks like an incantation - you get my drift. Find out where they still keep it! ...",
				"Oh, one more thing! They only talk to you when you look like a fellow summoner. It's dangerous to go without a cape. Use this."
			}, cid)
		end
	elseif msgcontains(msg, 'restore') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) <= 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission73) < 1 then --and npcHandler.topic[cid] == 15 then
		if player:removeItem(21474, 1) then
			npcHandler:say({
				"I knew it! I knew I had made a copy! Oh, I am so clever! ...",
				"Now, watch this. <mumbles darkly> THERE. THE COMPLETE INCANTATION SCROLL. ...",
				"You have done well. Only one thing remains, and you shall be rich beyond your dreams. Ready for the really final task?"
			}, cid)
			--player:setStorageValue(Storage.GravediggerOfDrefia.Mission72, 1)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission73, 1)
			npcHandler.topic[cid] = 17


		else
			npcHandler:say("You don't have my scroll.", cid)
			npcHandler.topic[cid] = 0
		end
		else npcHandler:say("Chzzzz. wtf??@! leave.", cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "At last, a visitor! Welcome to my... humble abode.")
npcHandler:addModule(FocusModule:new())
