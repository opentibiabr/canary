local internalNpcName = "Maeryn"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 683,
	lookHead = 94,
	lookBody = 101,
	lookLegs = 97,
	lookFeet = 116,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Not enough purple nightshade ... not enough liquid silver. *sigh*" },
	{ text = "You think the full moon is a romantic affair? Think again!" },
	{ text = "This place isn't safe. You should leave this island." }
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

local vocations = {
	['sorcerer'] = 0,
	['druid'] = 1,
	['paladin'] = 2,
	['knight'] = {
		['club'] = 3,
		['axe'] = 4,
		['sword'] = 5,
	}
}

local knightChoice = {}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	knightChoice[playerId] = nil
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, 'tokens') then
	elseif isInArray({'dangerous', 'beasts'}, message:lower()) then
		npcHandler:say("So you don't know it yet. This island, Grimvale, is affected by were-sickness. Many {pitiful}, who are stricken with the curse, dwell in the {tunnels} and caverns underneath the village and the nearby hurst.", npc, creature)
	elseif MsgContains(message, 'pitiful') then
		npcHandler:say("Yes, pitiful. For they are savage beasts now who regularly come up from below to attack the village. But once they were inhabitants of Grimvale, before they {changed}.", npc, creature)
	elseif MsgContains(message, 'changed') then
		npcHandler:say("Through a bite or even a scratch, you may be infected with the were-sickness. If that happens, there is little {hope} - until the next full moon you'll change into a were-creature, depending on the animal that hurt you.", npc, creature)
	elseif MsgContains(message, 'hope') then
		npcHandler:say("There is a plant, the purple nightshade. It blossoms exclusively in the light of the full moon and only underground, where the full moon's light is falling through fissures in the surface. Only this plant's blossoms are able to defeat the {were-sickness}.", npc, creature)
	elseif isInArray({'were-sickness', 'curse'}, message:lower()) then
		npcHandler:say({"It transforms peaceful villagers into savage beasts. We're not sure how this curse found the way into our small village. But one day it began. At first it befell just a few people. ...",
			"In a full moon night they changed into bears and wolves, and tore apart their unsuspecting relatives while they were asleep. ...",
			"Those merely wounded, first thought they were lucky. But then we realised they were changing, too. Later, others assumed the forms of badgers and boars also. ...",
		"But that does not mean they were any less wild or dangerous than the others."}, npc, creature)
	elseif MsgContains(message, 'tunnels') then
		npcHandler:say({"We are not sure what they are doing down there. We're glad if they stay in the caverns and leave us alone. Only at full moon do they come up and threaten the island's surface and village. ...",
		"I, however, have a {hunch} as to why they dwell so deep under the earth."}, npc, creature)
	elseif MsgContains(message, 'hunch') then
		npcHandler:say({"There are old legends about a subterranean temple that was once built in this area. Supposedly many {artefacts} are still hidden down there. ...",
		"I don't have the time to tell you the entire tale, but there is a book downstairs in which you may read the whole story."}, npc, creature)
	elseif MsgContains(message, 'artefacts') then
		npcHandler:say("Yes, the story goes that there are ancient artefacts still hidden in the temple ruins, such as helmets in the form of wolven heads, for example. It is said that moonlight crystals are needed to enchant these artefacts.", npc, creature)
	elseif MsgContains(message, 'moon') then
		npcHandler:say({"Every month around the 13th, the single Tibian moon will by fully visible to us. That's when the curse hits us hardest. ...",
			"The two days around the 13th, the 12th and the 14th, are considered 'Harvest Moon', those are the best to gather {nightshade}. However, only after it has reached its apex on the 13th, the curse strengthens. ...",
			"We do not know what happens down there in those tunnels around that time but there is a presence there, we all feel - yet cannot quite fathom. ...",
			"At full moon, humans transform into wild beasts: wolves, boars, bears and others. Some call it the {curse} of the Full Moon, others think it is a kind of sickness. .",
		"During this time, we try to not leave the house, we shut the windows and hope it will pass. The curse will weaken a bit after that but it returns. Every month."}, npc, creature)
	elseif MsgContains(message, 'nightshade') then
		npcHandler:say("Three of these blossoms should suffice to heal some afflicted persons. But if you bring more I'd be grateful, of course.", npc, creature)
	elseif MsgContains(message, 'name') then
		npcHandler:say("My name is Maeryn.", npc, creature)
	elseif MsgContains(message, 'maeryn') then
		npcHandler:say("Yes, that's me.", npc, creature)
	elseif MsgContains(message, 'time') then
		npcHandler:say("It's exactly " .. getFormattedWorldTime() .. ".", npc, creature)
	elseif MsgContains(message, 'job') then
		npcHandler:say("I'm the protector of this little village. A bit of a self-proclaimed function, I admit, but someone has to watch over {Grimvale}. It is a {dangerous} place.", npc, creature)
	elseif MsgContains(message, 'grimvale') then
		npcHandler:say("The small island you are standing on. For a long time it was a peaceful and placid place. But lately it has become more {dangerous}.", npc, creature)
	elseif MsgContains(message, 'owin') then
		npcHandler:say("He's an experienced hunter and knows much about the woods, the animals that dwell there, and about the {werewolves}. He's devoted himself to finding out everything there is to know about the {Curse}.", npc, creature)
	elseif MsgContains(message, 'werewolves') then
		npcHandler:say("Yes, my friend, werewolves. They dwell here on {Grimvale}, threatening our life. The were-sickness transforms peaceful villagers into savage beasts. We're not sure how this curse found its way into our small village. But undoubtedly it did.", npc, creature)
	elseif MsgContains(message, 'gladys') then
		npcHandler:say("She's an old druid. She's been living here on {Grimvale} since she was a little girl, just like me. She's very interested in were-creature body parts. If you find any, I'm sure she will love to trade with you.", npc, creature)
	elseif MsgContains(message, 'cornell') then
		npcHandler:say("He's basically a ferryman nowadays, but I remember when he was our village's leading fisherman. He offers a ferry service between Grimvale and Edron. You must have met him - he sailed you here.", npc, creature)
	elseif MsgContains(message, 'werewolf helmet') then
		npcHandler:say("You brought the wolven helmet, as i see. Do you want to change something?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("So, which profession would you give preference to when enchanting the helmet: {knight}, {sorcerer}, {druid} or {paladin}?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif isInArray({'knight', 'sorcerer', 'druid', 'paladin'}, message:lower()) and npcHandler:getTopic(playerId) == 2 then
		local helmet = message:lower()
		if not vocations[helmet] then
			return false
		end
		if message:lower() == 'knight' then
			npcHandler:say("And what would be your preferred weapon? {Club}, {axe} or {sword}", npc, creature)
			knightChoice[playerId] = helmet
			npcHandler:setTopic(playerId, 3)
		end
		if npcHandler:getTopic(playerId) == 2 then
			--if (Set storage if player can enchant helmet(need Grim Vale quest)) then
			player:setStorageValue(Storage.Grimvale.WereHelmetEnchant, vocations[helmet])
			npcHandler:say("So this is your choice. If you want to change it, you will have to come to me again.", npc, creature)
			--else
			--npcHandler:say("Message when player do not have quest.", npc, creature)
			--end
			npcHandler:setTopic(playerId, 0)
		end
	elseif isInArray({'axe', 'club', 'sword'}, message:lower()) and npcHandler:getTopic(playerId) == 3 then
		local weapontype = message:lower()
		if not vocations[knightChoice[playerId]][weapontype] then
			return false
		else
			--if (Set storage if player can enchant helmet(need Grim Vale quest)) then
			player:setStorageValue(Storage.Grimvale.WereHelmetEnchant, vocations[knightChoice[playerId]][weapontype])
			npcHandler:say("So this is your choice. If you want to change it, you will have to come to me again.", npc, creature)
			--else
			--npcHandler:say("Message when player do not have quest.", npc, creature)
			--end
			knightChoice[playerId] = nil
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, visitor. I wonder what may lead you to this {dangerous} place.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
