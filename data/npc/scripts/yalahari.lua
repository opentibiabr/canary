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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.InServiceofYalahar.Questline) == 17 then
			npcHandler:say({
				"With all the coming and going of strangers here, it would be quite tedious to explain everything again and again. So we have written a manifesto. ...",
				"Grab a copy from the room behind me. Let's talk about your further career in our ranks once you've read it."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 18)
			player:setStorageValue(Storage.InServiceofYalahar.Mission03, 3) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			player:setStorageValue(Storage.InServiceofYalahar.NotesAzerus, 0)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.NotesAzerus) == 1 and player:getStorageValue(Storage.InServiceofYalahar.Questline) == 18 then
			npcHandler:say({
				"I'm mildly impressed by your previous deeds in our service. So I'm willing to grant you some more important {missions}. ...",
				"If you please us, a life of luxury as an important person in our city is ensured. If you fail, you will be replaced by someone more capable than you. ...",
				"So if you are up for a challenge, ask me for a {mission}."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 19)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 19 then
			npcHandler:say({
				"The former alchemist quarter was struck by even more disasters than the rest of the city. Fires, explosions, poisonous fumes - all sorts of catastrophes. ...",
				"The worst plague, however, are unknown diseases that have spread in this quarter and eradicated any human population. We must stop it before other quarters areafflicted. We already identified certain carriers responsible for spreading the plague. ...",
				"It will be your task to eliminate them. This spell will protect you from becoming infected yourself. Enter the alchemist quarter and kill the three plague carriers, and atbest anything else you might find there. ...",
				"Even more important, retrieve the last research notes that the local alchemists made before the plague killed them. They might be the key for a cure or something else. ...",
				"At least we have to make sure that these scientists did not die in vain, and honour their researches. So please bring us these research notes. ...",
				"Also, I will inform the guards that you are allowed to pass the centre gate to the alchemist quarter. Just use the gate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 20)
			player:setStorageValue(Storage.InServiceofYalahar.Mission03, 4) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 21 and player:getStorageValue(Storage.InServiceofYalahar.AlchemistFormula) == 1 then
			npcHandler:say("So you have killed the plague carriers. Have you also retrieved the research papers? ", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 22 then
			npcHandler:say({
				"We surely cannot allow some underworld kingpin to rule a significant part of the city. Although, I have to admit that his firm grip on the former trade quarter might be useful....",
				"I expect you to fight your way through his minions and to show him that we are determined and powerful enough to retake the quarter, if necessary by force. Talk to himafter killing some of his henchmen. ...",
				"I'm sure he'll understand that he will succumb to a greater power. That's how his little empire has worked after all. ...",
				"Also, I will inform the guards that you are allowed to pass the centre gate to the trade quarter now. Just use the gate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 23)
			player:setStorageValue(Storage.InServiceofYalahar.Mission04, 1) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 26 then
			npcHandler:say({
				"So he has been too uncooperative for you? Well, you weren't the first we have sent and you won't be the last. ...",
				"However, if you cannot even serve us as a bully, we might have to rethink if you are the right person for us. That was a bad job and we don't tolerate many of them."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 27)
			player:setStorageValue(Storage.InServiceofYalahar.Mission04, 6) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 25 and player:getStorageValue(Storage.InServiceofYalahar.MrWestStatus) == 2 then
			npcHandler:say({
				"I hope you gave this criminal a real scare! I'm sure he'll remember what he has to expect if he arouses our anger again. ...",
				"You have proven yourself as quite valuable with this mission! That was just the first step on your rise through the ranks of our helpers. ...",
				"Just ask me for more missions and we will see what you are capable of!"
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.BadSide, player:getStorageValue(Storage.InServiceofYalahar.BadSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.BadSide) + 1 or 0) -- Side Storage
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 27)
			player:setStorageValue(Storage.InServiceofYalahar.Mission04, 6) -- StorageValue for Questlog "Mission 04: Good to be Kingpin"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 27 then
			npcHandler:say({
				"As you probably noticed, once our city had a park and a zoo around a grand arena. It was a favourite pastime of our citizens to visit this quarter in their spare time. ...",
				"Nowadays, the quarter is lost. The animals are on the loose, and an attempt to revitalise the city with new arena games resulted in a revolt of the foreign gladiators. ...",
				"Now all kinds of beasts roam the park, and gladiators challenge them and visitors to test their skills. One of the residents is an ancient druid that rather cares foranimals than for people. ...",
				"It is said that he is able to use magic to breed animals with changed abilities and appearances. Such skills are of course quite useful for us. ...",
				"We lack the manpower to retake all quarters, or just to defend ourselves adequately. If he bred us some guards and warbeasts, we could strengthen our positionconsiderably. ...",
				"Travel to the arena quarter and gain his assistance for us. I will inform the guards that you are allowed to pass the centre gate to the arena quarter now. Just use thegate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 28)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 1) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 33 then
			npcHandler:say({
				"This druid dares to affront us? We will look into this when we have enough time. But there are other things that needs to be settled. ...",
				"Although, we probably should not do so after your last failure, we are willing to grant you another mission."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 34)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 32 and player:getStorageValue(Storage.InServiceofYalahar.TamerinStatus) == 2 then
			npcHandler:say({
				"So have you won us a new ally? Excellent. I knew you would not dare to ruin this mission. Soon we might be able to strengthen our defences and even relocate some of our guards. ...",
				"Perhaps some day soon, you lead your own unit of men. However, there are more missions that need to be accomplished. Let's talk about them."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.BadSide, player:getStorageValue(Storage.InServiceofYalahar.BadSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.BadSide) + 1 or 0) -- Side Storage
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 34)
			player:setStorageValue(Storage.InServiceofYalahar.Mission05, 8) -- StorageValue for Questlog "Mission 05: Food or Fight"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 34 then
			npcHandler:say({
				"The old cemetery of the city has been abandoned decades ago when the activity of the various undead there became unbearable. The reason for their appearance was never found out or researched. ...",
				"However, those undead could be useful, at least some of them. Particular ghosts consist of a substance that is very similar to the energy source that powered some of our devices. ...",
				"Since we lack most of the original sources, some substitute might come in handy. Take this ghost charm and place it on the strange carving in the cemetery. ...",
				"Use it to attract ghosts and slay them. Then use the residues of the ghosts on the charm to capture the essence. ...",
				"Once it is filled, ghosts will not be attracted any longer. Then return the charm to me. I will inform the guards that you are allowed to pass the centre gate to the cemetery quarter now. Just use the gate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 35)
			player:setStorageValue(Storage.InServiceofYalahar.Mission06, 1) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
			player:addItem(9737, 1)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 38 then
			npcHandler:say({
				"Destroyed you say? That's impossible! I'm not sure if I can trust you in this matter? One might assume, you fled from the ghosts in terror and left the charm there. ...",
				"You will have to work twice as hard on your next missions to restore the trust you have lost."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 39)
			player:setStorageValue(Storage.InServiceofYalahar.Mission06, 5) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 37 then
			if player:removeItem(9742, 1) then
				npcHandler:say({
					"Ah, what an unexpected sight. I can almost feel the energy of the charm. It will help to recover some of the past wealth. ...",
					"You did quite an impressive job. I'm considering to introduce you to my ma.. to my direct superior one day. But there are still other missions to fulfil."
				}, cid)
				player:setStorageValue(Storage.InServiceofYalahar.Questline, 39)
				player:setStorageValue(Storage.InServiceofYalahar.Mission06, 5) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
				player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 2)
				player:setStorageValue(Storage.InServiceofYalahar.BadSide, player:getStorageValue(Storage.InServiceofYalahar.BadSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.BadSide) + 1 or 0) -- Side Storage
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 39 then
			npcHandler:say({
				"Recently, our fishermen have been attacked by a maritime race called the quara. They live in the sunken quarter and are a significant threat to our people. I ask you to enter the sunken quarter and slay all their leaders. ...",
				"We believe that there are three leaders in this area. Your task is simple enough, so you better don't fail! ...",
				"I will inform the guards that you are allowed to pass the centre gate to the sunken quarter now. Just use the gate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 40)
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 1) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 41 and player:getStorageValue(Storage.InServiceofYalahar.QuaraInky) == 1 and player:getStorageValue(Storage.InServiceofYalahar.QuaraSharptooth) == 1 and player:getStorageValue(Storage.InServiceofYalahar.QuaraSplasher) == 1 and player:getStorageValue(Storage.InServiceofYalahar.QuaraState) == 2 then
			npcHandler:say("This will teach these fishmen who is the ruler of that area. You have earned yourself a special privilege. But we will talk about that when we speak about your next mission. ", cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 43)
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 5) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			player:setStorageValue(Storage.InServiceofYalahar.BadSide, player:getStorageValue(Storage.InServiceofYalahar.BadSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.BadSide) + 1 or 0) -- Side Storage
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 43 then
			npcHandler:say({
				"In the past, we had many magical factories providing the citizens with everything they needed. Now that most of these factories are shut down, we have trouble getting enough supplies. ...",
				"We need you to enter one of the lesser damaged factories. Go to the factory district and look for a pattern crystal used for weapon production. Use it on the factory controller. ...",
				"It will ensure that the factory will provide us with a suitable amount of weapons which we dearly need to reclaim and secure the most dangerous parts of the city. ...",
				"I will inform the guards that you are allowed to pass the centre gate to the factory quarter now. Just use the gate mechanism to pass."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 44)
			player:setStorageValue(Storage.InServiceofYalahar.Mission08, 1) -- StorageValue for Questlog "Mission 08: Dangerous Machinations"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 46 then
			if player:getStorageValue(Storage.InServiceofYalahar.MatrixState) == 1 then
				npcHandler:say("Your failure is an outrage! I think we have to talk about the missions you have accomplished so far. ", cid)
				player:setStorageValue(Storage.InServiceofYalahar.GoodSide, player:getStorageValue(Storage.InServiceofYalahar.GoodSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.GoodSide) + 1 or 0) -- Side Storage
			elseif player:getStorageValue(Storage.InServiceofYalahar.MatrixState) == 2 then
				npcHandler:say("Now we will have power we truly deserve!...", cid)
				player:setStorageValue(Storage.InServiceofYalahar.BadSide, player:getStorageValue(Storage.InServiceofYalahar.BadSide) >= 0 and player:getStorageValue(Storage.InServiceofYalahar.BadSide) + 1 or 0) -- Side Storage
			end
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 47)
			player:setStorageValue(Storage.InServiceofYalahar.Mission08, 4) -- StorageValue for Questlog "Mission 08: Dangerous Machinations"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 47 then
			npcHandler:say({
				"I'm impressed by your support for our cause. Still, I'm aware that this scheming Palimuth tried to influence you. Think about who are your real friends and who can assist you in your career. ...",
				"Come back if you have decided to which side you want to belong."
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 48)
			player:setStorageValue(Storage.InServiceofYalahar.Mission09, 1) -- StorageValue for Questlog "Mission 09: Decision"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 49 or player:getStorageValue(Storage.InServiceofYalahar.Questline) == 48 then
			npcHandler:say("So do you want to side with me |PLAYERNAME|? ", cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 50 and player:getStorageValue(Storage.InServiceofYalahar.SideDecision) == 2 then
			npcHandler:say({
				"For your noble deeds, we would like to invite you to a special celebration ceremony. ...",
				"Only the most prominent Yalahari are allowed to join the festivities. I assume you can imagine what honour it is that you'vebeen invited to join us. Meet us in the inner city's centre. ...",
				"As our most trusted ally, you may pass all doors to reach the festivity hall. There you will receive your reward for the achievements you have gained so far. ...",
				"I'm convinced your reward will be beyond your wildest dreams. And that is just the beginning!"
			}, cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 51)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToLastFight, 1)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 2) -- StorageValue for Questlog "Mission 10: The Final Battle"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.InServiceofYalahar.Questline) == 52 and player:getStorageValue(Storage.InServiceofYalahar.SideDecision) == 2 then
			npcHandler:say("Great work, take this outfit and you are able to open the door to the reward room.", cid)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 53)
			player:setStorageValue(Storage.InServiceofYalahar.DoorToReward, 1)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 4) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addOutfit(324, 0)
			player:addOutfit(325, 0)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:removeItem(9733, 1) then
				player:setStorageValue(Storage.InServiceofYalahar.BadSide, 1)
				player:setStorageValue(Storage.InServiceofYalahar.Questline, 22)
				player:setStorageValue(Storage.InServiceofYalahar.Mission03, 6) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
				npcHandler:say("Impressive indeed! Someone with your skills will quickly raise in our ranks of helpers. You have great potential, and if you are upfor further missions, just ask for them. ", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 50)
			player:setStorageValue(Storage.InServiceofYalahar.SideDecision, 2)
			player:setStorageValue(Storage.InServiceofYalahar.Mission09, 2) -- StorageValue for Questlog "Mission 09: Decision"
			npcHandler:say("I knew that you were smart enough to make the right decision! Your next mission will be a special one! ", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.InServiceofYalahar.GoodSide, 1)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 22)
			player:setStorageValue(Storage.InServiceofYalahar.Mission03, 6) -- StorageValue for Questlog "Mission 03: Death to the Deathbringer"
			npcHandler:say({
				"Hm, no sign of any notes you say? That's odd - odd and a bit suspicious. I doubt you have tried hard enough. ...",
				"There are only a few chances to impress us. For those who please us great rewards are in store. If you fail though, you might lose more than you can imagine."
			}, cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
