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
	{ text = 'Great, another supply ship is due. How is a dwarf supposed to work under these conditions?' },
	{ text = 'Ah, there\'s nothing like the sound of hammers in the morning.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "project") and player:getStorageValue(Storage.TheNewFrontier.Questline) < 1 then
		if npcHandler.topic[cid] == 0 then
			npcHandler:say({
				"Well, it's a long story but you really should listen to understand what is going on here. You can also hear a short version of the story, but then don't blame me if you mess something up due to your undwarfish impatience. ...",
				"So what would you like to hear, the {long} story or the {short} version?"
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "long") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"After centuries the resources beneath and around the Big Old One became alarmingly short. Some decades ago, the imperial mining guild financed a project to search and establish new mines far away from Kazordoon. ...",
				"After several tries with mixed success, the project of the technomancers proved the most successful. Their steamships studied and mapped the great underwater rivers deep beneath the earth. ...",
				"With the help of certain apparatuses, they tracked deposits of ore and compiled ship routes to reach them. These mining bases had some obvious advantages and disadvantages. ...",
				"The suitable spots had no connection to the surface. On the one hand, this meant that the new mines were safe from most kinds of beasts. On the other hand, it meant that all food and material had to be brought there by ship. ...",
				"Special, heavy ships were built to carry ore and supplies back and forth. The only limitation for such bases had been the range of the steamships. ...",
				"Recently, the technomancers with the help of the temples of fire and earth made some crucial discoveries that allowed the ships to extend their cruising range almost limitlessly. ...",
				"The survey ships of the technomancers were once again sent out to find new, promising resources. ...",
				"Sadly some of the ships never returned and others only found minor deposits of ore, not worth the effort. But one of the ships made some groundbreaking discovery - a cave that had a connection to the surface. ...",
				"As far as the explorers could tell, the area had been unknown to dwarfhood and mankind so far. ...",
				"What was more, the said cave system had an abundance of rare ores. The imperial mining guild agreed to fund a new project and to name it 'project far far away'. ...",
				"Don't look at me, I'm not the one who came up with that name! Those technomancers are such an imaginative bunch. But where have we been? Oh, yes, the new project! ...",
				"Well, some ships were sent to establish a first base. ...",
				"It became painfully obvious that the number of workers needed there could not easily be supplied by the ships alone. Also such a base would require an amount of money, expertise and manpower that the guild could not provide. ...",
				"We would need help and additional resources. That's were you come into play. If you are interested, let's talk about possible missions."
			}, cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "short") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"<grumbles> Well, we have found this place here full of promising resources and plan to create a new mining outpost. Of course this takes a lot of effort and organisation. ...",
				"For some of the tasks at hand we need help, even from outsiders like you. So if you are interested in some missions, let me know.",
				"Listen, I can handle the organisation down here and my boys will handle the construction of the base fine enough. Actually, all you do down here is to stand in the workers' way. ...",
				"But there might be something for you to do outside the base. We need to learn more about the land up there. Take the lift and do some exploring. Find a passage leading out of the mountains. ...",
				"Do not explore any further though. You never know whom you might be messing with."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 1)
			player:setStorageValue(Storage.TheNewFrontier.Mission01, 1) --Questlog, The New Frontier Quest "Mission 01: New Land"
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) < 1 and npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"Listen, I can handle the organisation down here and my boys will handle the construction of the base fine enough. Actually, all you do down here is to stand in the workers' way. ...",
				"But there might be something for you to do outside the base. We need to learn more about the land up there. Take the lift and do some exploring. Find a passage leading out of the mountains. ...",
				"Do not explore any further though. You never know whom you might be messing with."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 1)
			player:setStorageValue(Storage.TheNewFrontier.Mission01, 1) --Questlog, The New Frontier Quest "Mission 01: New Land"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 2 then
			npcHandler:say("Excellent. Although we have no idea what awaits us in this foreign land, it is always good to know something more about our surroundings.", cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 3)
			player:setStorageValue(Storage.TheNewFrontier.Mission01, 3) --Questlog, The New Frontier Quest "Mission 01: New Land"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 3 then
			npcHandler:say({
				"Things are running fine so far. Actually so fine that we are short of supplies and men. I'd send a letter home but I guess sending you to get some assistance gives the whole affair a bit more urgency. ...",
				"So please travel back to Kazordoon. In the western mines outside of The Big Old One, you'll find Melfar of the imperial mining guild. Ask him to send some more miners and wood. When you return, I might have some more interesting missions for you."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 4)
			player:setStorageValue(Storage.TheNewFrontier.Mission02, 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 7 then
			npcHandler:say("That's good news for sure. It will give our operation a new impulse. However, only if there is not some unexpected trouble ahead. Well, we'll talk about that when we discuss your next {mission}.", cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 8)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 8 then
			npcHandler:say({
				"Our guards reported some nightly visitors. They chased them through the mountains but lost them when the fugitives climbed up some vines. ...",
				"It could easily be some trap and I'm somewhat reluctant to send you there, but we can't allow some invisible aggressor to spy on us and maybe to prepare an attack. ...",
				"Find these vines in this mountain, climb up there and find out who is spying on us! If they mean harm, get rid of them if possible. ...",
				"If they are too powerful, just retreat and we will have to re-evaluate the situation. If they are harmless, all the better."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 9)
			player:setStorageValue(Storage.TheNewFrontier.Mission03, 1) --Questlog, The New Frontier Quest "Mission 03: Strangers in the Night"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 10 then
			npcHandler:say({
				"Primitive humans you say? These are most startling news, that's for sure. Well, I guess I'll send some victuals we can spare as a sign of our good will. ...",
				"However, our miners encountered another problem in the meantime. I'm afraid this will be your next {mission}"
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 11)
			player:setStorageValue(Storage.TheNewFrontier.Mission03, 3) --Questlog, The New Frontier Quest "Mission 03: Strangers in the Night"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 11 then
			npcHandler:say({
				"It seems things went from bad to worse! First we had some problems with the mine shafts we were building, and now that we found some precious veins in one of the new mines, and it happens to be the holiday resort of some hostile stone creatures! ...",
				"Nothing we dwarfs couldn't handle alone, but I rather thought this could be something interesting for an adventurer like you. ...",
				"So I reserved you the privilege to slay the leader! Use the mining lift to reach mine A07. The more stone creatures you kill, the better. Your mission, however, is to slay their leader, most likely some special stone beast."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 12)
			player:setStorageValue(Storage.TheNewFrontier.Mission04, 1) --Questlog, The New Frontier Quest "Mission 04: The Mine Is Mine"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 13 then
			npcHandler:say("Shortly after you killed that creature, the others crumbled to dust and stone. I hope this incident does not foreshadow similar problems in our mines. However, for now I have other things to take care of and you have other {missions} to accomplish. ", cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 14)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 14 then
			npcHandler:say({
				"Things are getting more and more complicated. You need to convince our friends that some intervention for their part is needed. ...",
				"We've come a long way with our own resources, but now our resources are short and we need the others to step in. I want you to negotiate some more support from our partners. ... ",
				"You'll need all your diplomacy and influence. If you blow the negotiations, look for a guy called Black Bert in Thais. ...",
				"He has access to all kind of odd items, and he might have just the right bribe to convince someone to continue negotiations. ...",
				"It will not be as easy as it might sound. So watch your words and your manners and keep in mind whom you are talking to. ...",
				"Different strategies might be necessary for different people. You may try to FLATTER, THREATEN, IMPRESS, BLUFF, PLEA or to REASON with them. You probably need some luck as well. ... ",
				"And now listen: We need more workers for the mines. The technomancers told us that a guy named Telas, who lives in Edron, copied the worker golem technology from Yalahar. Convince him to send us some of these golems. ... ",
				"Further, we have more ore and end products than we can use right now. So we need someone to buy all the surplus. Convince Leeland Slim in Venore that the local traders step in as resellers. ... ",
				"Another issue at hand is our lack of drilling worms. That should not be a big problem though. Just talk to the worm tamer in Kazordoon. If he does not get mad about you, there should be no problem to get his support. ... ",
				"Also, now that our monetary resources are used up and not much cash is coming in, we need additional help to finance this venture. Thais has promised money in advance, but we haven't seen any of this support, yet. ... ",
				"Convince the Thaian king to send us the promised money right now. ...",
				"Another problem we need to solve is the exploration of our surroundings. We need to know friends and enemies, and find out about the plants and beasts in the vicinity and learn what is edible and what is dangerous. ... ",
				"This is all stuff the Explorer Society is interested in. It should be easy to convince their representative in Port Hope. ...",
				"At last, with the growing numbers of adventurers here, not only the security of the base is growing but also the demand for certain supplies. I'd like the Edron academy to open up a shop in the base. We need to keep you adventurers happy, don't we? ... ",
				"Well, I hope you understand the importance of this mission and got what it takes to fulfil it. So hurry up and get us the needed support."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 15)
			player:setStorageValue(Storage.TheNewFrontier.Mission05, 1) --Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 15 then
			if player:getStorageValue(Storage.TheNewFrontier.BribeKing) == 1 and player:getStorageValue(Storage.TheNewFrontier.BribeLeeland) == 1 and player:getStorageValue(Storage.TheNewFrontier.BribeExplorerSociety) == 1 and player:getStorageValue(Storage.TheNewFrontier.BribeWydrin) == 1 and player:getStorageValue(Storage.TheNewFrontier.BribeTelas) == 1 and player:getStorageValue(Storage.TheNewFrontier.BribeHumgolf) == 1 then
				npcHandler:say("You did an excellent job! With all this help Farmine will grow and prosper. While we put all available resources into building this base, I have another urgent {mission} for you.", cid)
				player:setStorageValue(Storage.TheNewFrontier.Questline, 16)
				npcHandler.topic[cid] = 0
			end
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 16 then
			npcHandler:say({
				"Our new friends, those primitive humans sent us a warning. According to them, the 'green men' of the plains plan an attack on the mountains. ...",
				"Considering their expected number, there is no chance for us to beat them off. We might be able to hold our ground for a while, but without access to the surface and under constant attacks, we might have to abandon the base. ...",
				"Now, I'm aware that you cannot stop an entire army by yourself, but desperate situations call for desperate measures. I ask you to find the leaders of the orcs and - well do something. ...",
				"Scare them, bribe them, give them another target or whatever. As futile as it may sound: Try to talk to their leaders in some way and make them stop their attack plans. This is our only hope."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 17)
			player:setStorageValue(Storage.TheNewFrontier.Mission06, 1) --Questlog, The New Frontier Quest "Mission 06: Days Of Doom"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 20 then
			npcHandler:say({
				"Oh my. What a mess you have gotten yourself into. Well, at least you made it out alive. Whatever the value of a minotaur's promise might be, I guess that is the best we can get. ...",
				"Of course all those revelations lead to new problems and a new mission for you."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 21)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 21 then
			npcHandler:say({
				"Ooook. Now that we managed to keep those orcs and minotaurs at bay at least for a while, we learn that the real meanies over here are some lizardmen. Just great, isn't it?. ...",
				"So you might already guess your next mission: Find a way to hold those lizards off. Find them, contact them, talk to them, scare them, bribe them, whatever. Just keep that snakes away if anyhow possible. ...",
				"If the orcs are right, they are somewhere in or behind those mountains in the north. I doubt you can reason with them in any way, but you'll have to try for the sake of Farmine."
			}, cid)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 22)
			player:setStorageValue(Storage.TheNewFrontier.Mission07, 1) --Questlog, The New Frontier Quest "Mission 07: Messengers Of Peace"
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheNewFrontier.Questline) == 27 then
			npcHandler:say({
				"Oh, my! That sounds like a real mess. For now this dragon empire seems otherwise engaged, but we will be on guard thanks to you my friend. We will continue to fortify the base. ...",
				"This leaves not much to do for you down here. I recommend you continue to explore this strange new land. ...",
				"I'm pretty sure there are several opportunities at hand for an adventurer like you. ...",
				"Perhaps you can help the primitives you encountered. Who knows, maybe even those minotaurs give you a chance to fortify this fragile peace between us. ...",
				"Even some of the people here in the base might offer you some tasks sooner or later. If you prefer, you can also do some exploring, hunting and good ol' plundering on your own of course. ...",
				"This new land is yours to be taken, so to say. Go out and make your fortune! With Farmine you have always a safe haven to return to. ...",
				"Oh and one last thing: We convinced a carpet pilot to join us here. You'll find him on top of our lift in the mountains. I think he can offer you fast access to some cities back home."
			}, cid)
			player:addExperience(8000, true)
			player:addOutfit(335)
			player:addOutfit(336)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.TheNewFrontier.Questline, 28)
			player:setStorageValue(Storage.TheNewFrontier.Mission10, 1) --Questlog, The New Frontier Quest "Mission 10: New Horizons"
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, |PLAYERNAME|. You've come at a good time for our {project}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
