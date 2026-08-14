local internalNpcName = "Chester Kahs"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 9,
	lookBody = 28,
	lookLegs = 47,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Too many possibilities to become a servant of darkness to trust ANYONE!" },
	{ text = "Don't tell me I didn't warn you." },
	{ text = "It's all a big conspiracy, mark my words." },
	{ text = "Not everything that walks our streets is human ... or even living." },
	{ text = "We are surrounded by myths, living and dead." },
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

local fire = Condition(CONDITION_FIRE)
fire:setParameter(CONDITION_PARAM_DELAYED, true)
fire:setParameter(CONDITION_PARAM_FORCEUPDATE, true)
fire:addDamage(25, 9000, -10)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "gamel") or MsgContains(message, "rebel") or MsgContains(message, "gamel rebel") then
		npcHandler:say("Are you saying that Gamel is a member of the rebellion?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Do you know what his plans are about?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(3061, 1) then
				npcHandler:say("Thank you! Take this ring. If you ever need a healing, come, bring the scroll, and ask me to {heal}.", npc, creature)
				player:addItem(3052, 1)
			else
				npcHandler:say("Sorry, but you have none.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(3052, 1) then
				npcHandler:say("So be healed!", npc, creature)
				player:addHealth(player:getMaxHealth())
				npc:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			else
				npcHandler:say("Sorry, you are not worthy!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 1)
			npcHandler:say("Then I welcome you to the TBI. This is a great moment for you, remember it well. Talk to me about your missions whenever you feel ready.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01, 3)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 3)
			npcHandler:say("I think they understood the warning the way it was meant. If not, you will have to visit Venore soon again. But for now it's settled.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(5956, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission02, 2)
				player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 5)
				npcHandler:say("I can only hope that this information are as valuable as we expected it. A good man died for them.", npc, creature)
			else
				npcHandler:say("Please bring me some proof of his whereabouts.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(5952, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03, 3)
				player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 7)
				npcHandler:say("I can only hope that this information are as valuable as we expected it. A good man died for them.", npc, creature)
			else
				npcHandler:say("Please bring me some valuable information!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:removeItem(348, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission04, 2)
				player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 9)
				npcHandler:say("Ah yes, very interesting. Almost as I suspected. It's a good thing that we got those documents in our hands.", npc, creature)
			else
				npcHandler:say("We need those intelligence reports, do whatever you need to do agent!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 10 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05, 3)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 11)
			npcHandler:say("Now that Venore is of nearly no importance anymore, there is only Carlin left to deal with.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 11 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06, 3)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 13)
			npcHandler:say("I already heard that our little trick worked quite well. Several officials of Carlin are already on their way to repair the damage done to their diplomatic efforts. It will not only cost them much money but also quite some time.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 12 then
			if player:removeMoneyBank(1000) then
				player:addItem(397, 1)
				npcHandler:say("Here you are. Better don't loose it again.", npc, creature)
			else
				npcHandler:say("You don't have enough money", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 13 then
			if player:removeItem(396, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.Mission07, 2)
				player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 15)
				player:addItem(897, 1)
				npcHandler:say("You have done superb work agent, I grant you the title of Top Agent! Here's a little gift you might find useful.", npc, creature)
			else
				npcHandler:say("Please bring me proof of the mad technomancers defeat!", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Then don't bother me with it. I'm a busy man.", npc, creature)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Traitor!", npc, creature)
			player:addCondition(fire)
			player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
			npc:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			player:removeItem(3061, 1)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(npc, creature)
		else
			npcHandler:say("As you wish.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "magic") and MsgContains(message, "crystal") and MsgContains(message, "lugri") and MsgContains(message, "deathcurse") then
			npcHandler:say("That's terrible! Will you give me the crystal?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say("Tell me precisely what he asked you to do! It's important!", npc, creature)
		end
	elseif MsgContains(message, "heal") then
		npcHandler:say("Do you need the healing now?", npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif MsgContains(message, "join") then
		if player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) < 1 then
			npcHandler:say({
				"Our bureau is an old and traditional branch of the Thaian government. It takes more than lip service to join our ranks ...",
				"Absolute loyalty to the crown and the Thaian cause as well as courage face-to-face with the enemy is the least we expect from our members ...",
				"You will swear allegiance to Thais alone and abandon the service of any other city. So is it really your wish to become one of our field agents?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 1 and player:getStorageValue(Storage.Quest.U8_1.SecretService.AVINMission01) < 1 and player:getStorageValue(Storage.Quest.U8_1.SecretService.CGBMission01) < 1 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 2)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01, 1)
			npcHandler:say({
				"Your first task is to deliver a warning. Illegally, the Venoreans are crafting more ships than the Thaian authorities have allowed them ...",
				"Our sources have told us that those ships often end up in the hands of pirates or smugglers ...",
				"An official note would strain the relationship between Thais and Venore too much as this would mean that we had to admit officially that we know about those activities ...",
				"Still, we can't allow them to continue like this. It will be your task to let them know that we do not tolerate such behaviour. Get a fire bug from Liberty Bay and set their shipyard on fire ...",
				"Use the fire bug on some flammable material there to start the fire. It might take a while to find some wood that's dry enough for the fire to spread. Just keep trying ... ",
				"If you get captured or killed during your mission, we will deny any contact with you.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01) == 2 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission01) == 3 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 3 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 4)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission02, 1)
			npcHandler:say({
				"Your next mission concerns an internal matter for our agency. Some decades ago, one of our most talented field agents vanished in the Green Claw Swamp ...",
				"Nowadays, that more and more adventurers are swarming this area, there is an increasing number of reports on some sinister goings-on and mysterious ruins in the middle of the swamp ...",
				"We got some credible clues that there might be a connection between the ruins and the disappearance of our agent ...",
				"As he is already missing since decades it is unlikely that he is still alive. Nevertheless, we want you to find out something about the whereabouts of our agent in the ruins in the Green Claw Swamp, north west of Venore ...",
				"He used to write diaries, maybe you can find one of those, or some other hints, or even his remains. You have to understand that he was a member of a prestigious Thaian family. Very influential people are interested in his whereabouts ...",
				"The Green Claw Swamp is treacherous and dangerous. You will have a hard time to find any clues ...",
				"As a small incentive I think its worthy to mention that he was wearing a quite impressive armor. You may keep it for yourself if you stumble across it.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission02) == 1 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission02) == 2 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 5 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 6)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03, 1)
			npcHandler:say({
				"One of our agents is missing. He was investigating the cause for the slow growth of our colony Port Hope ...",
				"You will continue these investigations at the point where the information that the lost agent has sent us ends. Some of the traders in Port Hope must have connections to persons who are interested in sabotaging our efforts in Tiquanda ...",
				"Search their personal belongings to find some sort of evidence that we could need!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03) == 2 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission03) == 3 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 7 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 8)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission04, 1)
			npcHandler:say({
				"Just recently we were able to secretly help our elven friends to exposure an agitator sent by Carlin to poison our connections with them. The elves' reaction wasswift and without compromise ...",
				"They banished the delinquent in a place they call 'Hellgate'. Unfortunately, we learnt later that the convict was sent there with several of his belongings and it is very likely that he took vital papers with him ...",
				"These papers can tell us much about Carlin's plans in the North. We need you to enter 'Hellgate' and to retrieve the papers for us ...",
				"We don't care how you get them. Do whatever you think is necessary.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission04) == 1 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission04) == 2 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 9 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 10)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05, 1)
			player:addItem(349, 1)
			npcHandler:say({
				"It's bad enough that Carlin got a solid foothold in the far North but now the Venoreans also try to move in. They try to gain influence on the barbarian raiders by bribing their leaders or making them great promises ...",
				"We want you to cause some bad blood in this relationship. Travel to their most southern camp, enter the ice tower of their leaders and kill some of them ...",
				"Here is a signet ring that the Venorean emissaries use to wear. 'Lose' the ring in the north-western corner of the highest level of the tower. They will surely find it there.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05) == 2 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission05) == 3 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 11 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 12)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06, 1)
			player:addItem(397, 1)
			npcHandler:say({
				"The women of Carlin have the northern city Svargrond in the firm grip of her manicured hands. At the moment, there is little we can do about it but there is one thing that plays into our hands ...",
				"The barbarians have surely at least heard about the fact that alcohol is outlawed in Carlin ...",
				"If some amazonian warrior would smash a beer or ale cask in front of some witnesses, the relationship would surely suffer a bit. So go and disguise yourself as an amazon. Then use a crowbar to destroy a cask.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06) == 2 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06) == 3 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Quest) == 13 then
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Quest, 14)
			player:setStorageValue(Storage.Quest.U8_1.SecretService.Mission07, 1)
			npcHandler:say({
				"Great, you are here. We need your service in a mission of utmost urgency ...",
				"A mad dwarven technomancer that listens to the name of Blowbeard sent us a blackmailing letter. He demands to deliver all of Thais's gold to him. Else he will destroy the city with an artificial earthquake caused by one of his machines! ...",
				"We need you to find his base in Kazordoon and to kill him before he can use his infernal machine. Bring us his beard as proof of your success.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06) == 3 and player:getStorageValue(Storage.Quest.U8_1.SecretService.Mission07) == 1 then
			npcHandler:say("Have you fulfilled your current mission?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		end
	elseif MsgContains(message, "disguise") then
		if player:getStorageValue(Storage.Quest.U8_1.SecretService.TBIMission06) == 1 then
			npcHandler:say("If you lost or wasted your disguise kit I can replace it. It will cost you 1000 gold though since you lost royal property. Is that ok for you?", npc, creature)
			npcHandler:setTopic(playerId, 12)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Salutations, stranger.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care out there!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care out there!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "berfasmur is ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, that's what I figured out, too. Just one of his disguises." })
keywordHandler:addKeyword({ "underground ruins" }, StdModule.say, { npcHandler = npcHandler, text = "We have no clue what happened to the civilization that once dwelled underground, but their complete extinction should be a warning to us!" })
keywordHandler:addKeyword({ "necromants nectar" }, StdModule.say, { npcHandler = npcHandler, text = "Followers of evil are investigating about that, though I guess even they don't know what it's good for. Perhaps just a myth of evil." })
keywordHandler:addKeyword({ "ruthless seven" }, StdModule.say, { npcHandler = npcHandler, text = "We know little about them, but even that gives me nightmares! But it's your lucky day, since this information is confidential, it can't bother you." })
keywordHandler:addKeyword({ "investigation" }, StdModule.say, { npcHandler = npcHandler, text = "We collect information about people and incidents." })
keywordHandler:addKeyword({ "secret police" }, StdModule.say, { npcHandler = npcHandler, text = "Are you joking? What's secret in Tibia at all?" })
keywordHandler:addKeyword({ "silver guard" }, StdModule.say, { npcHandler = npcHandler, text = "The king's best. But is the best good enough to fight what stalks the nights?" })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I am troubled by all the mysteries out there." })
keywordHandler:addKeyword({ "ab'dendriel" }, StdModule.say, { npcHandler = npcHandler, text = "The elves of Ab'Dendriel are hard to understand. We better keep an eye on them." })
keywordHandler:addKeyword({ "liberty bay" }, StdModule.say, { npcHandler = npcHandler, text = "There is still resistance to our leadership. It might take generations to wipe it out." })
keywordHandler:addKeyword({ "dogs of war" }, StdModule.say, { npcHandler = npcHandler, text = "Even they can't stop a handful of demons." })
keywordHandler:addKeyword({ "incidents" }, StdModule.say, { npcHandler = npcHandler, text = "There are things that must be kept secret." })
keywordHandler:addKeyword({ "kazordoon" }, StdModule.say, { npcHandler = npcHandler, text = "The dwarfs of Kazordoon are our allies. They are brave and very well skilled in warcraft, still they are hiding in some mountain. So I'm asking myself: What do they know that we don't?" })
keywordHandler:addKeyword({ "ankrahmun" }, StdModule.say, { npcHandler = npcHandler, text = "Well, that's a creepy town with an enigmatic religion and a dangerous leader." })
keywordHandler:addKeyword({ "port hope" }, StdModule.say, { npcHandler = npcHandler, text = "Port Hope is our foothold in an unknown territory full of new challenges and secrets." })
keywordHandler:addKeyword({ "svargrond" }, StdModule.say, { npcHandler = npcHandler, text = "There is a small group of Carliners in Svargrond. It seems they only try to establish some trade. Still, as the mines could not be retaken, one has to wonder what they are actually doing there." })
keywordHandler:addKeyword({ "criminals" }, StdModule.say, { npcHandler = npcHandler, text = "There are so many murderers and thieves out there that I wonder if there is some greater force of evil subtly encouraging that." })
keywordHandler:addKeyword({ "red guard" }, StdModule.say, { npcHandler = npcHandler, text = "They are at my command now and then ... but it's a mistake to rely on anyone except yourself." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Some say he's the avatar of Zathroth himself, but perhaps the truth about him is even darker than the worst rumours can imagine." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "We are surrounded by myths, living and dead. How can someone doubt that there IS something like Excalibug somewhere?" })
keywordHandler:addKeyword({ "rebellion" }, StdModule.say, { npcHandler = npcHandler, text = "I have far too little information about the rebellion, but we suspect the followers of Zathroth to be behind it." })
keywordHandler:addKeyword({ "berfasmur" }, StdModule.say, { npcHandler = npcHandler, text = "Strange name, isn't it? Play around with the letters and you might be surprised." })
keywordHandler:addKeyword({ "citizens" }, StdModule.say, { npcHandler = npcHandler, text = "I only can give you some official information about our citizens. About whom do you wish to talk?" })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "Something happened to him that snapped his mind. Do we know what else has happened to him unnoticed?" })
keywordHandler:addKeyword({ "mcronald" }, StdModule.say, { npcHandler = npcHandler, text = "Have you ever wondered what these caves under their farm are good for? And have you noticed how many adventurers go down there and never return? Well, think about it!" })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I think it could be quite a good trick to pretend not to remember anything. That's why I never tell that guy anything, who knows what he would do with that knowledge." })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "In my opinion it's questionable that Darashia was only built so remote to provide solitariness." })
keywordHandler:addKeyword({ "superior" }, StdModule.say, { npcHandler = npcHandler, text = "I report directly to the king himself." })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know where they got their secret spells in the first place, and even most sorcerer don't." })
keywordHandler:addKeyword({ "disturb" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the head of the TBI." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "A peaceful man. But nowadays peace is just an illusion. We are surrounded by enemies and dangers." })
keywordHandler:addKeyword({ "paladin" }, StdModule.say, { npcHandler = npcHandler, text = "They should be noble warriors, but how brave is it to shoot someone from a distance? The former paladins were virtuous heroes, the ones you meet today are nothing than simple treasure hunters." })
keywordHandler:addKeyword({ "enemies" }, StdModule.say, { npcHandler = npcHandler, text = "The people of the northern city, the minotaurs, the followers of Zathroth, the demons, and countless others!" })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, text = "Monsters lurk in each corner of the dungeons." })
keywordHandler:addKeyword({ "bureau" }, StdModule.say, { npcHandler = npcHandler, text = "We collect information about people and incidents." })
keywordHandler:addKeyword({ "people" }, StdModule.say, { npcHandler = npcHandler, text = "We know much about the citizens and some other people." })
keywordHandler:addKeyword({ "secret" }, StdModule.say, { npcHandler = npcHandler, text = "Certain information is not for the eyes and ears of everyone. Please understand that." })
keywordHandler:addKeyword({ "harsky" }, StdModule.say, { npcHandler = npcHandler, text = "He's one of the few people I trust." })
keywordHandler:addKeyword({ "stutch" }, StdModule.say, { npcHandler = npcHandler, text = "He's one of the few people I trust." })
keywordHandler:addKeyword({ "partos" }, StdModule.say, { npcHandler = npcHandler, text = "This criminal was wanted for many crimes. At last he got caught and put into jail." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "Who knows what power drove those women to break from the Thaian rule? There might be sinister powers at work." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "Venore makes its moves behind the scenes but they are noticed by those who learnt to watch." })
keywordHandler:addKeyword({ "report" }, StdModule.say, { npcHandler = npcHandler, text = "My reports are confidential and for the ears and eyes of the king only." })
keywordHandler:addKeyword({ "guards" }, StdModule.say, { npcHandler = npcHandler, text = "I think we can't trust the guards anymore." })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "The castle isn't safe! I warned them about the entrance to the dungeons, but no one is listening. How many people have to die before they do something about that?" })
keywordHandler:addKeyword({ "fiends" }, StdModule.say, { npcHandler = npcHandler, text = "Not everything that walks our streets is human ... or even living." })
keywordHandler:addKeyword({ "knight" }, StdModule.say, { npcHandler = npcHandler, text = "It's too easy to become a knight. If you look at the streets, you see what happens if you give training and a flashy title to almost everyone." })
keywordHandler:addKeyword({ "danger" }, StdModule.say, { npcHandler = npcHandler, text = "Danger is just as common as day and night for a Tibian who keeps his eyes open." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "Have you noticed how easy it would be to poison his supplies and so to kill a great deal of people?" })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "She puts her trust in the help of beings she can't understand. Do you really think that's clever?" })
keywordHandler:addKeyword({ "aruda" }, StdModule.say, { npcHandler = npcHandler, text = "This woman is a clever thief, so watch out when you're talking to her." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "Thais is a proud and ancient city. This leads to envy which, in turn, leads to enemies." })
keywordHandler:addKeyword({ "trust" }, StdModule.say, { npcHandler = npcHandler, text = "Too many possibilities to become a servant of darkness to trust ANYONE!" })
keywordHandler:addKeyword({ "spies" }, StdModule.say, { npcHandler = npcHandler, text = "Polymorphed minotaurs, shapeshifting demons, possessed innocents ... who can tell for sure." })
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "Let me ask you how good it is to sell runes to the highest bidder, no matter who that might be? I think you get the point!" })
keywordHandler:addKeyword({ "enemy" }, StdModule.say, { npcHandler = npcHandler, text = "The people of the northern city, the minotaurs, the followers of Zathroth, the demons, and countless others!" })
keywordHandler:addKeyword({ "demon" }, StdModule.say, { npcHandler = npcHandler, text = "They say there are just two of them in the underground ruins! Such fools! There are dozens of them, and most of them much stronger than these two!" })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, all interesting news are confidential." })
keywordHandler:addKeyword({ "avin" }, StdModule.say, { npcHandler = npcHandler, text = "Officially we have to accept their status as a harmless organisation to promote trade. Still, it's an open secret that they have a quite active part in the fields of interest of the Venorean traders." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He isn't the fool he pretends to be. So what is he up to?" })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "A man too concerned about profit to be trustworthy. This kind of man sells his soul to the highest bidder. The questions is if he has done it already or if he will do it soon." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus III is our leader and my direct superior." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "The city is open to almost everyone. That literally opens doors for all kinds of criminals and fiends." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "Our army might be infested with spies already." })
keywordHandler:addKeyword({ "gods" }, StdModule.say, { npcHandler = npcHandler, text = "We are just the pawns of the gods. The best we can expect is that our play amuses them enough to keep their interest in us, so we might live a day or two longer." })
keywordHandler:addKeyword({ "tbi" }, StdModule.say, { npcHandler = npcHandler, text = "The Tibian Bureau of Investigation, the secret service of His Royal Highness ... The TBI is an old institution with tradition. Since centuries we are the protectors of our king and country ... We successfully fight intrigues and corruption from within and enemies from without. Only the most talented individuals are allowed to join." })
keywordHandler:addKeyword({ "cgb" }, StdModule.say, { npcHandler = npcHandler, text = "An amateurish attempt of Carlin to establish a secret service. It's nothing than a 'make-believe' game for little girls ... They should rather play salesman and customer or mother and child instead of pretending to be secret agents." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "I say it was a mistake to rely on a single person for such vital services but having those Venoreans here is even worse." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
