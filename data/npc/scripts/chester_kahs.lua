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
	{ text = 'Too many possibilities to become a servant of darkness to trust ANYONE!' },
	{ text = 'Don\'t tell me I didn\'t warn you.' },
	{ text = 'It\'s all a big conspiracy, mark my words.' },
	{ text = 'Not everything that walks our streets is human ... or even living.' },
	{ text = 'We are surrounded by myths, living and dead.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local fire = Condition(CONDITION_FIRE)
fire:setParameter(CONDITION_PARAM_DELAYED, true)
fire:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
fire:addDamage(25, 9000, -10)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'gamel') and msgcontains(msg, 'rebel') then
		npcHandler:say('Are you saying that Gamel is a member of the rebellion?', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Do you know what his plans are about?', cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(2177, 1) then
				npcHandler:say('Thank you! Take this ring. If you ever need a healing, come, bring the scroll, and ask me to {heal}.', cid)
				player:addItem(2168, 1)
			else
				npcHandler:say('Sorry, but you have none.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 4 then
			if player:removeItem(2168, 1) then
				npcHandler:say('So be healed!', cid)
				player:addHealth(player:getMaxHealth())
				Npc():getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			else
				npcHandler:say('Sorry, you are not worthy!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			player:setStorageValue(Storage.SecretService.Quest, 1)
			npcHandler:say('Then I welcome you to the TBI. This is a great moment for you, remember it well. Talk to me about your missions whenever you feel ready.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 6 then
				player:setStorageValue(Storage.SecretService.TBIMission01, 3)
				player:setStorageValue(Storage.SecretService.Quest, 3)
				npcHandler:say('I think they understood the warning the way it was meant. If not, you will have to visit Venore soon again. But for now it\'s settled.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 7 then
			if player:removeItem(7696, 1) then
				player:setStorageValue(Storage.SecretService.TBIMission02, 2)
				player:setStorageValue(Storage.SecretService.Quest, 5)
				npcHandler:say('Thank you, we can finally let them have some closure regarding this.', cid)
			else
				npcHandler:say('Please bring me some proof of his whereabouts.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(14324, 1) then
				player:setStorageValue(Storage.SecretService.TBIMission03, 3)
				player:setStorageValue(Storage.SecretService.Quest, 7)
				npcHandler:say('I can only hope that this information are as valuable as we expected it. A good man died for them.', cid)
			else
				npcHandler:say('Please bring me some valuable information!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 9 then
			if player:removeItem(14325, 1) then
				player:setStorageValue(Storage.SecretService.TBIMission04, 2)
				player:setStorageValue(Storage.SecretService.Quest, 9)
				npcHandler:say('Ah yes, very interesting. Almost as I suspected. It\'s a good thing that we got those documents in our hands.', cid)
			else
				npcHandler:say('We need those intelligence reports, do whatever you need to do agent!', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 10 then
			player:setStorageValue(Storage.SecretService.TBIMission05, 3)
			player:setStorageValue(Storage.SecretService.Quest, 11)
			npcHandler:say('Now that Venore is of nearly no importance anymore, there is only Carlin left to deal with.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 11 then
			player:setStorageValue(Storage.SecretService.TBIMission06, 3)
			player:setStorageValue(Storage.SecretService.Quest, 13)
			npcHandler:say('I already heard that our little trick worked quite well. Several officials of Carlin are already on their way to repair the damage done to their diplomatic efforts. It will not only cost them much money but also quite some time.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 12 then
			if player:removeMoneyNpc(1000) then
				player:addItem(7700, 1)
				npcHandler:say('Here you are. Better don\'t loose it again.', cid)
			else
				npcHandler:say('You don\'t have enough money', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 13 then
			if player:removeItem(7699, 1) then
				player:setStorageValue(Storage.SecretService.Mission07, 2)
				player:setStorageValue(Storage.SecretService.Quest, 15)
				player:addItem(7960, 1)
				npcHandler:say('You have done superb work agent, I grant you the title of Top Agent! Here\'s a little gift you might find useful.', cid)
			else
				npcHandler:say('Please bring me proof of the mad technomancers defeat!', cid)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Then don\'t bother me with it. I\'m a busy man.', cid)
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say('Traitor!', cid)
			player:addCondition(fire)
			player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
			Npc():getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			player:removeItem(2177, 1)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		else
			npcHandler:say('As you wish.', cid)
		end
		npcHandler.topic[cid] = 0
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'magic') and msgcontains(msg, 'crystal') and msgcontains(msg, 'lugri') and msgcontains(msg, 'deathcurse') then
			npcHandler:say('That\'s terrible! Will you give me the crystal?', cid)
			npcHandler.topic[cid] = 3
		else
			npcHandler:say('Tell me precisely what he asked you to do! It\'s important!', cid)
		end
	elseif msgcontains(msg, 'heal') then
		npcHandler:say('Do you need the healing now?', cid)
		npcHandler.topic[cid] = 4
	elseif msgcontains(msg, 'join') then
		if player:getStorageValue(Storage.SecretService.Quest) < 1 then
			npcHandler:say({
				'Our bureau is an old and traditional branch of the Thaian government. It takes more than lip service to join our ranks ...',
				'Absolute loyalty to the crown and the Thaian cause as well as courage face-to-face with the enemy is the least we expect from our members ...',
				'You will swear allegiance to Thais alone and abandon the service of any other city. So is it really your wish to become one of our field agents?'
			}, cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.SecretService.Quest) == 1 and player:getStorageValue(Storage.SecretService.AVINMission01) < 1 and player:getStorageValue(Storage.SecretService.CGBMission01) < 1 then
			player:setStorageValue(Storage.SecretService.Quest, 2)
			player:setStorageValue(Storage.SecretService.TBIMission01, 1)
			npcHandler:say({
				'Your first task is to deliver a warning. Illegally, the Venoreans are crafting more ships than the Thaian authorities have allowed them ...',
				'Our sources have told us that those ships often end up in the hands of pirates or smugglers ...',
				'An official note would strain the relationship between Thais and Venore too much as this would mean that we had to admit officially that we know about those activities ...',
				'Still, we can\'t allow them to continue like this. It will be your task to let them know that we do not tolerate such behaviour. Get a fire bug from Liberty Bay and set their shipyard on fire ...',
				'Use the fire bug on some flammable material there to start the fire. It might take a while to find some wood that\'s dry enough for the fire to spread. Just keep trying ... ',
				'If you get captured or killed during your mission, we will deny any contact with you.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission01) == 2 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 6
		elseif player:getStorageValue(Storage.SecretService.TBIMission01) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 3 then
			player:setStorageValue(Storage.SecretService.Quest, 4)
			player:setStorageValue(Storage.SecretService.TBIMission02, 1)
			npcHandler:say({
				'Your next mission concerns an internal matter for our agency. Some decades ago, one of our most talented field agents vanished in the Green Claw Swamp ...',
				'Nowadays, that more and more adventurers are swarming this area, there is an increasing number of reports on some sinister goings-on and mysterious ruins in the middle of the swamp ...',
				'We got some credible clues that there might be a connection between the ruins and the disappearance of our agent ...',
				'As he is already missing since decades it is unlikely that he is still alive. Nevertheless, we want you to find out something about the whereabouts of our agent in the ruins in the Green Claw Swamp, north west of Venore ...',
				'He used to write diaries, maybe you can find one of those, or some other hints, or even his remains. You have to understand that he was a member of a prestigious Thaian family. Very influential people are interested in his whereabouts ...',
				'The Green Claw Swamp is treacherous and dangerous. You will have a hard time to find any clues ...',
				'As a small incentive I think its worthy to mention that he was wearing a quite impressive armor. You may keep it for yourself if you stumble across it.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission02) == 1 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.SecretService.TBIMission02) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 5 then
			player:setStorageValue(Storage.SecretService.Quest, 6)
			player:setStorageValue(Storage.SecretService.TBIMission03, 1)
			npcHandler:say({
				'One of our agents is missing. He was investigating the cause for the slow growth of our colony Port Hope ...',
				'You will continue these investigations at the point where the information that the lost agent has sent us ends. Some of the traders in Port Hope must have connections to persons who are interested in sabotaging our efforts in Tiquanda ...',
				'Search their personal belongings to find some sort of evidence that we could need!'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission03) == 2 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 8
		elseif player:getStorageValue(Storage.SecretService.TBIMission03) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 7 then
			player:setStorageValue(Storage.SecretService.Quest, 8)
			player:setStorageValue(Storage.SecretService.TBIMission04, 1)
			npcHandler:say({
				'Just recently we were able to secretly help our elven friends to exposure an agitator sent by Carlin to poison our connections with them. The elves\' reaction wasswift and without compromise ...',
				'They banished the delinquent in a place they call \'Hellgate\'. Unfortunately, we learnt later that the convict was sent there with several of his belongings and it is very likely that he took vital papers with him ...',
				'These papers can tell us much about Carlin\'s plans in the North. We need you to enter \'Hellgate\' and to retrieve the papers for us ...',
				'We don\'t care how you get them. Do whatever you think is necessary.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission04) == 1 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 9
		elseif player:getStorageValue(Storage.SecretService.TBIMission04) == 2 and player:getStorageValue(Storage.SecretService.Quest) == 9 then
			player:setStorageValue(Storage.SecretService.Quest, 10)
			player:setStorageValue(Storage.SecretService.TBIMission05, 1)
			player:addItem(7697, 1)
			npcHandler:say({
				'It\'s bad enough that Carlin got a solid foothold in the far North but now the Venoreans also try to move in. They try to gain influence on the barbarian raiders by bribing their leaders or making them great promises ...',
				'We want you to cause some bad blood in this relationship. Travel to their most southern camp, enter the ice tower of their leaders and kill some of them ...',
				'Here is a signet ring that the Venorean emissaries use to wear. \'Lose\' the ring in the north-western corner of the highest level of the tower. They will surely find it there.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission05) == 2 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 10
		elseif player:getStorageValue(Storage.SecretService.TBIMission05) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 11 then
			player:setStorageValue(Storage.SecretService.Quest, 12)
			player:setStorageValue(Storage.SecretService.TBIMission06, 1)
			player:addItem(7700, 1)
			npcHandler:say({
				'The women of Carlin have the northern city Svargrond in the firm grip of her manicured hands. At the moment, there is little we can do about it but there is one thing that plays into our hands ...',
				'The barbarians have surely at least heard about the fact that alcohol is outlawed in Carlin ...',
				'If some amazonian warrior would smash a beer or ale cask in front of some witnesses, the relationship would surely suffer a bit. So go and disguise yourself as an amazon. Then use a crowbar to destroy a cask.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission06) == 2 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 11
		elseif player:getStorageValue(Storage.SecretService.TBIMission06) == 3 and player:getStorageValue(Storage.SecretService.Quest) == 13 then
			player:setStorageValue(Storage.SecretService.Quest, 14)
			player:setStorageValue(Storage.SecretService.Mission07, 1)
			npcHandler:say({
				'Great, you are here. We need your service in a mission of utmost urgency ...',
				'A mad dwarven technomancer that listens to the name of Blowbeard sent us a blackmailing letter. He demands to deliver all of Thais\'s gold to him. Else he will destroy the city with an artificial earthquake caused by one of his machines! ...',
				'We need you to find his base in Kazordoon and to kill him before he can use his infernal machine. Bring us his beard as proof of your success.'
			}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.SecretService.TBIMission06) == 3 and player:getStorageValue(Storage.SecretService.Mission07) == 1 then
			npcHandler:say('Have you fulfilled your current mission?', cid)
			npcHandler.topic[cid] = 13
		end
	elseif msgcontains(msg, 'disguise') then
		if player:getStorageValue(Storage.SecretService.TBIMission06) == 1 then
			npcHandler:say('If you lost or wasted your disguise kit I can replace it. It will cost you 1000 gold though since you lost royal property. Is that ok for you?', cid)
			npcHandler.topic[cid] = 12
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Salutations, stranger.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care out there!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care out there!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
