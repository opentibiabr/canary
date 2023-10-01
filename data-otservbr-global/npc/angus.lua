local internalNpcName = "Angus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 133,
	lookHead = 57,
	lookBody = 132,
	lookLegs = 114,
	lookFeet = 113,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Joining
	if MsgContains(message, "join") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) < 1 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1 then
			npcHandler:say("Do you want to join the explorer society?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		-- The New Frontier Start
	elseif MsgContains(message, "farmine") and player:getStorageValue(TheNewFrontier.Questline) == 14 then
		if player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
			npcHandler:say(
			"Oh yes, an interesting topic. We had vivid discussions about this discovery. But what is it that you want?",
			npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say(
			"You bring up this topic again? I don't think our talks make any sense unless you prove that you are a supporter of science. Do you have some proof for your dedication to science?",
			npc, creature)
			npcHandler:setTopic(playerId, 35)
		end
	elseif MsgContains(message, "bluff") and player:getStorageValue(TheNewFrontier.Mission05.AngusKeyword) == 1 and
	player:getStorageValue(TheNewFrontier.Questline) == 14 and
	player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
		if npcHandler:getTopic(playerId) == 1 or npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
				npcHandler:say(
				{"Those stories are just amazing! Men with faces on their stomach instead of heads you say? And hens that lay golden eggs? Whereas, most amazing is this fountain of youth you've mentioned! ...",
				"I'll immediately send some of our most dedicated explorers to check those things out!"}, npc,
				creature)
				player:setStorageValue(TheNewFrontier.Mission05.Angus, 3)
			end
		end
	elseif MsgContains(message, "impress") and player:getStorageValue(TheNewFrontier.Mission05.AngusKeyword) == 2 and
	player:getStorageValue(TheNewFrontier.Questline) == 14 and
	player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
				npcHandler:say(
				{"A whole new land is indeed very tempting. I can hardly imagine all the wonders that await us there. I doubt I could stop our explorers from going there even if I tried to."},
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Angus, 3)
			end
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
				npcHandler:say(
				{"For all I've heard, this is rather a barren isle than a whole new land. There are so many places to explore in this world, I won't send our best explorers on account of a rumour."},
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Angus, 3)
			end
		end
		-- The New Frontier End
		-- Mission Check
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) > 4 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 4 and
		player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) < 26 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 26 or
		player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 8 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 8 or
		player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 17 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 17 or
		player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 5 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 5 then
			npcHandler:say(
			"The missions available for your rank are the {butterfly hunt}, {plant collection} and {ice delivery}.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) > 25 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 35 and
		player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) < 35 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 35 or
		player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 26 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 26 or
		player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 29 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 29 or
		player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 32 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 32 then
			npcHandler:say(
			"The missions available for your rank are {lizard urn}, {bonelord secrets} and {orc powder}.", npc,
			creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) > 34 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 34 and
		player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) < 44 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 44 or
		player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 35 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 35 or
		player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 38 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 38 or
		player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 41 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 41 then
			npcHandler:say(
			"The missions available for your rank are {elven poetry}, {memory stone} and {rune writings}.", npc,
			creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) == 44 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 44 then
			npcHandler:say(
			"The explorer society needs a great deal of help in the research of astral travel. Are you willing to help?",
			npc, creature)
			npcHandler:setTopic(playerId, 27)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheEctoplasm) == 46 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 46 then
			npcHandler:say("Do you have some collected ectoplasm with you?", npc, creature)
			npcHandler:setTopic(playerId, 29)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheEctoplasm) == 47 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 47 then
			npcHandler:say(
			{"The research on ectoplasm makes good progress. Now we need some spectral article. Our scientists think a spectral dress would be a perfect object for their studies ...",
			"The bad news is that the only source to got such a dress is the queen of the banshees. Do you dare to seek her out?"},
			npc, creature)
			npcHandler:setTopic(playerId, 30)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralDress) == 49 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 48 then
			npcHandler:say("Did you bring the dress?", npc, creature)
			npcHandler:setTopic(playerId, 31)
			-- Spectral stone
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralDress) == 50 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 50 then
			npcHandler:say(
			{"With the objects you've provided our researchers will make steady progress. Still we are missing some test results from fellow explorers ...",
			"Please travel to our base in Northport and ask them to mail us their latest research reports. Then return here and ask about new missions."},
			npc, creature)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 51)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 51)
			player:setStorageValue(Storage.ExplorerSociety.SpectralStone, 1)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 51 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 51 and
		player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 2 then
			npcHandler:say("Oh, yes! Tell our fellow explorer that the papers are in the mail already.", npc, creature)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 52)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 52)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 52 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 52 and
		player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 1 then
			npcHandler:say(
			"The reports from Northport have already arrived here and our progress is astonishing. We think it is possible to create an astral bridge between our bases. Are you interested to assist us with this?",
			npc, creature)
			npcHandler:setTopic(playerId, 32)
			-- Spectral stone
			-- Astral portals
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 55 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 55 then
			npcHandler:say(
			{"Both carvings are now charged and harmonised. In theory you should be able to travel in zero time from one base to the other ...",
				"However, you will need to have an orichalcum pearl in your possession to use it as power source. It will be destroyed during the process. I will give you 6 of such pearls and you can buy new ones in our bases ...",
				"In addition, you need to be a premium explorer to use the astral travel. ...",
			"And remember: it's a small teleport for you, but a big teleport for all Tibians! Here is a small present for your efforts!"},
			npc, creature)
			player:setStorageValue(Storage.ExplorerSociety.TheAstralPortals, 56)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 56)
			player:addItem(5021, 6) -- Orichalcum pearl
			player:addItem(9605, 1) -- Crown backpack
			-- Astral portals
		end
		-- Mission check
		-- Pickaxe mission
	elseif MsgContains(message, "pickaxe") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) < 5 or
		player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) > 1 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1 or
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 1 then
			npcHandler:say("Did you get the requested pickaxe from Uzgod in Kazordoon?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
		-- Pickaxe mission
		-- Ice delivery
	elseif MsgContains(message, "ice delivery") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 5 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 5 then
			npcHandler:say(
			{"Our finest minds came up with the theory that deep beneath the ice island of Folda ice can be found that is ancient. To prove this theory we would need a sample of the aforesaid ice ...",
				"Of course the ice melts away quickly so you would need to hurry to bring it here ...",
			"Would you like to accept this mission?"}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 7 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 7 then
			npcHandler:say("Did you get the ice we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
		-- Ice delivery
		-- Butterfly hunt
	elseif MsgContains(message, "butterfly hunt") then
		if player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 8 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 8 then
			npcHandler:say("The mission asks you to collect some species of butterflies, are you interested?", npc,
			creature)
			npcHandler:setTopic(playerId, 7)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 10 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 10 then
			npcHandler:say("Did you acquire the purple butterfly we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 11 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 11 then
			npcHandler:say({"This preparation kit will allow you to collect a blue butterfly you have killed ...",
			"Just use it on the fresh corpse of a blue butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4863, 1)
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 12)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 12)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 13 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 13 then
			npcHandler:say("Did you acquire the blue butterfly we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 14 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 14 then
			npcHandler:say({"This preparation kit will allow you to collect a red butterfly you have killed ...",
			"Just use it on the fresh corpse of a red butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4863, 1)
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 15)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 15)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 16 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 16 then
			npcHandler:say("Did you acquire the red butterfly we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		end
		-- Butterfly Hunt
		-- Plant Collection
	elseif MsgContains(message, "plant collection") then
		if player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 17 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 17 then
			npcHandler:say(
			"In this mission we require you to get us some plant samples from Tiquandan plants. Would you like to fulfil this mission?",
			npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 19 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 19 then
			npcHandler:say("Did you acquire the sample of the jungle bells plant we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 20 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 20 then
			npcHandler:say(
			"Use this botanist's container on a witches cauldron to collect a sample for us. Bring it here and report about your plant collection.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4867, 1)
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 21)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 21)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 22 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 22 then
			npcHandler:say("Did you acquire the sample of the witches cauldron we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 23 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 23 then
			npcHandler:say(
			"Use this botanist\'s container on a giant jungle rose to obtain a sample for us. Bring it here and report about your plant collection.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4867, 1)
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 24)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 24)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 25 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 25 then
			npcHandler:say("Did you acquire the sample of the giant jungle rose we are looking for?", npc, creature)
			npcHandler:setTopic(playerId, 14)
		end
		-- Plant Collection
		-- Lizard Urn
	elseif MsgContains(message, "lizard urn") then
		if player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 26 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 26 then
			npcHandler:say(
			"The explorer society would like to acquire an ancient urn which is some sort of relic to the lizard people of Tiquanda. Would you like to accept this mission?",
			npc, creature)
			npcHandler:setTopic(playerId, 15)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 28 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 27 then
			npcHandler:say("Did you manage to get the ancient urn?", npc, creature)
			npcHandler:setTopic(playerId, 16)
		end
		-- Lizard Urn
		-- Bonelords
	elseif MsgContains(message, "bonelord secrets") then
		if player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 29 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 29 then
			npcHandler:say(
			{"We want to learn more about the ancient race of bonelords. We believe the black pyramid north east of Darashia was originally built by them ...",
				"We ask you to explore the ruins of the black pyramid and look for any signs that prove our theory. You might probably find some document with the numeric bonelord language ...",
			"That would be sufficient proof. Would you like to accept this mission?"}, npc, creature)
			npcHandler:setTopic(playerId, 17)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 31 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 30 then
			npcHandler:say("Have you found any proof that the pyramid was built by bonelords?", npc, creature)
			npcHandler:setTopic(playerId, 18)
		end
		-- Bonelords
		-- Orc Powder
	elseif MsgContains(message, "orc powder") then
		if player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 32 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 32 then
			npcHandler:say(
			{"It is commonly known that orcs of Uldereks Rock use some sort of powder to increase the fierceness of their war wolves and berserkers ...",
				"What we do not know are the ingredients of this powder and its effect on humans ...",
			"So we would like you to get a sample of the aforesaid powder. Do you want to accept this mission?"},
			npc, creature)
			npcHandler:setTopic(playerId, 19)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 34 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 33 then
			npcHandler:say("Did you acquire some of the orcish powder?", npc, creature)
			npcHandler:setTopic(playerId, 20)
		end
		-- Orc Powder
		-- Elven Poetry
	elseif MsgContains(message, "elven poetry") then
		if player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 35 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 35 then
			npcHandler:say(
			{"Some high ranking members would like to study elven poetry. They want the rare book 'Songs of the Forest' ...",
			"For sure someone in Ab'Dendriel will own a copy. So you would just have to ask around there. Are you willing to accept this mission?"},
			npc, creature)
			npcHandler:setTopic(playerId, 21)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 37 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 36 then
			npcHandler:say("Did you acquire a copy of 'Songs of the Forest' for us?", npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
		-- Elven Poetry
		-- Memory Stone
	elseif MsgContains(message, "memory stone") then
		if player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 38 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 38 then
			npcHandler:say(
			{"We acquired some knowledge about special magic stones. Some lost civilisations used it to store knowledge and lore, just like we use books ...",
				"The wisdom in such stones must be immense, but so are the dangers faced by every person who tries to obtain one...",
			"As far as we know the ruins found in the north-west of Edron were once inhabited by beings who used such stones. Do you have the heart to go there and to get us such a stone?"},
			npc, creature)
			npcHandler:setTopic(playerId, 23)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 40 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 39 then
			npcHandler:say("Were you able to acquire a memory stone for our society?", npc, creature)
			npcHandler:setTopic(playerId, 24)
		end
		-- Memory Stone
		-- Rune Writings
	elseif MsgContains(message, "rune writings") then
		if player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 41 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 41 then
			npcHandler:say(
			{"We would like to study some ancient runes that were used by the lizard race. We suspect some relation of the lizards to the founders of Ankrahmun ...",
				"Somewhere under the ape infested city of Banuta, one can find dungeons that were once inhabited by lizards...",
				"Look there for an atypical structure that would rather fit to Ankrahmun and its Ankrahmun Tombs. Copy the runes you will find on this structure...",
			"Are you up to that challenge?"}, npc, creature)
			npcHandler:setTopic(playerId, 25)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) == 43 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 43 then
			npcHandler:say("Did you create a copy of the ancient runes as requested?", npc, creature)
			npcHandler:setTopic(playerId, 26)
		end
		-- Rune Writings
		-- Answer Yes
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say(
			{"Fine, though it takes more then a mere lip service to join our ranks. To prove your dedication to the cause you will have to acquire an item for us ...",
				"The mission should be simple to fulfil. For our excavations we have ordered a sturdy pickaxe in Kazordoon. You would have to seek out this trader Uzgod and get the pickaxe for us ...",
			"Simple enough? Are you interested in this task?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say(
			"We will see if you can handle this simple task. Get the pickaxe from Uzgod in Kazordoon and bring it to one of our bases. Report there about the pickaxe.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 1)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(4845, 1) then
				player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 5)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 5)
				npcHandler:say(
				{"Excellent, you brought just the tool we need! Of course it was only a simple task. However ...",
				"I officially welcome you to the explorer society. From now on you can ask for missions to improve your rank."},
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 6)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 6)
			npcHandler:say(
			{"So listen please: Take this ice pick and use it on a block of ice in the caves beneath Folda. Get some ice and bring it here as fast as you can ...",
			"Should the ice melt away, report on your ice delivery mission anyway. I will then tell you if the time is right to start another mission."},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4872, 1)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(4837, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 8)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 8)
				npcHandler:say("Just in time. Sadly not much ice is left over but it will do. Thank you again.", npc,
				creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 6 then
			player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 6)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 6)
			npcHandler:say(
			"*Sigh* I think the time is right to grant you another chance to get that ice. Hurry up this time.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			-- Butterfly Hunt
		elseif npcHandler:getTopic(playerId) == 7 then
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 9)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 9)
			npcHandler:say({"This preparation kit will allow you to collect a purple butterfly you have killed ...",
			"Just use it on the fresh corpse of a purple butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4863, 1)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:removeItem(4864, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 11)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 11)
				npcHandler:say(
				"A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:removeItem(4865, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 14)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 14)
				npcHandler:say(
				"A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 10 then
			if player:removeItem(4866, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 17)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 17)
				npcHandler:say(
				"That is an extraordinary species you have brought. Thank you! That was the last butterfly we needed.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Butterfly Hunt
			-- Plant Collection
		elseif npcHandler:getTopic(playerId) == 11 then
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 18)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 18)
			npcHandler:say(
			"Fine! Here take this botanist's container. Use it on a jungle bells plant to collect a sample for us. Report about your plant collection when you have been successful.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4867, 1)
		elseif npcHandler:getTopic(playerId) == 12 then
			if player:removeItem(4868, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 20)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 20)
				npcHandler:say(
				"I see. It seems you've got some quite useful sample by sheer luck. Thank you! Just tell me when you are ready to continue with the plant collection.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 13 then
			if player:removeItem(4869, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 23)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 23)
				npcHandler:say(
				"Ah, finally. I started to wonder what took you so long. But thank you! Another fine sample, indeed. Just tell me when you are ready to continue with the plant collection.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 14 then
			if player:removeItem(4870, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 26)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 26)
				npcHandler:say("What a lovely sample! With that you have finished your plant collection missions.", npc,
				creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Plant Collection
			-- Lizard Urn
		elseif npcHandler:getTopic(playerId) == 15 then
			player:setStorageValue(Storage.ExplorerSociety.TheLizardUrn, 27)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 27)
			player:setStorageValue(Storage.ExplorerSociety.ChorurnDoor, 1)
			npcHandler:say(
			{"You have indeed the spirit of an adventurer! In the south-east of Tiquanda is a small settlement of the lizard people ...",
				"Beneath the newly constructed temple there, the lizards hide the said urn. Our attempts to acquire this item were without success ...",
			"Perhaps you are more successful."}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 16 then
			if player:removeItem(4847, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheLizardUrn, 29)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 29)
				npcHandler:say(
				"Yes, that is the prized relic we have been looking for so long. You did a great job, thank you.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Lizard Urn
			-- Bonelords
		elseif npcHandler:getTopic(playerId) == 17 then
			player:setStorageValue(Storage.ExplorerSociety.TheBonelordSecret, 30)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 30)
			player:setStorageValue(Storage.ExplorerSociety.BonelordsDoor, 1)
			npcHandler:say(
			{"Excellent! So travel to the city of Darashia and then head north-east for the pyramid ...",
			"If any documents are left, you probably find them in the catacombs beneath. Good luck!"}, npc,
			creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 18 then
			if player:removeItem(173, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheBonelordSecret, 32)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 32)
				npcHandler:say("You did it! Excellent! The scientific world will be shaken by this discovery!", npc,
				creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Bonelords
			-- Orc Powder
		elseif npcHandler:getTopic(playerId) == 19 then
			player:setStorageValue(Storage.ExplorerSociety.TheOrcPowder, 33)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 33)
			player:setStorageValue(Storage.ExplorerSociety.OrcDoor, 1)
			npcHandler:say(
			{"You are a brave soul. As far as we can tell, the orcs maintain some sort of training facility in some hill in the north-east of their city ...",
			"There you should find lots of their war wolves and hopefully also some of the orcish powder. Good luck!"},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 20 then
			if player:removeItem(13974, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheOrcPowder, 35)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 35)
				npcHandler:say("You really got it? Amazing! Thank you for your efforts.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Orc Powder
			-- Elven Poetry
		elseif npcHandler:getTopic(playerId) == 21 then
			player:setStorageValue(Storage.ExplorerSociety.TheElvenPoetry, 36)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 36)
			player:setStorageValue(Storage.ExplorerSociety.ElvenDoor, 1)
			npcHandler:say(
			"Excellent. This mission is easy but nonetheless vital. Travel to Ab'Dendriel and get the book.", npc,
			creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 22 then
			if player:removeItem(4844, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheElvenPoetry, 38)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 38)
				npcHandler:say(
				"Let me have a look! Yes, that's what we wanted. A copy of 'Songs of the Forest'. I won't ask any questions about those bloodstains.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Elven Poetry
			-- Memory Stone
		elseif npcHandler:getTopic(playerId) == 23 then
			player:setStorageValue(Storage.ExplorerSociety.TheMemoryStone, 39)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 39)
			player:setStorageValue(Storage.ExplorerSociety.MemoryStoneDoor, 1)
			npcHandler:say("In the ruins of north-western Edron you should be able to find a memory stone. Good luck.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 24 then
			if player:removeItem(4841, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheMemoryStone, 41)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 41)
				npcHandler:say(
				"A flawless memory stone! Incredible! It will take years even to figure out how it works but what an opportunity for science, thank you!",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Memory Stone
			-- Rune Writings
		elseif npcHandler:getTopic(playerId) == 25 then
			player:setStorageValue(Storage.ExplorerSociety.TheRuneWritings, 42)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 42)
			npcHandler:say(
			"Excellent! Here, take this tracing paper and use it on the object you will find there to create a copy of the ancient runes.",
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:addItem(4842, 1)
		elseif npcHandler:getTopic(playerId) == 26 then
			if player:removeItem(4843, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheRuneWritings, 44)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 44)
				npcHandler:say("It's a bit wrinkled but it will do. Thanks again.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Rune Writings
			-- Ectoplasm
		elseif npcHandler:getTopic(playerId) == 27 then
			npcHandler:say(
			{"Fine. The society is looking for new means to travel. Some of our most brilliant minds have some theories about astral travel that they want to research further ...",
				"Therefore we need you to collect some ectoplasm from the corpse of a ghost. We will supply you with a collector that you can use on the body of a slain ghost ...",
			"Do you think you are ready for that mission?"}, npc, creature)
			npcHandler:setTopic(playerId, 28)
		elseif npcHandler:getTopic(playerId) == 28 then
			npcHandler:say(
			"Good! Take this container and use it on a ghost that was recently slain. Return with the collected ectoplasm and hand me that container ...",
			npc, creature)
			npcHandler:say("Don't lose the container. They are expensive!", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.ExplorerSociety.TheEctoplasm, 45)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 45)
			player:addItem(4852, 1)
		elseif npcHandler:getTopic(playerId) == 29 then
			if player:removeItem(4853, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheEctoplasm, 47)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 47)
				npcHandler:say(
				"Phew, I had no idea that ectoplasm would smell that ... oh, it's you, well, sorry. Thank you for the ectoplasm.",
				npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Ectoplasm
			-- Spectral Dress
		elseif npcHandler:getTopic(playerId) == 30 then
			npcHandler:say(
			{"That is quite courageous. We know, it's much we are asking for. The queen of the banshees lives in the so called Ghostlands, south west of Carlin. It is rumoured that her lair is located in the deepest dungeons beneath that cursed place ...",
			"Any violence will probably be futile, you will have to negotiate with her. Try to get a spectral dress from her. Good luck."},
			npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralDress, 48)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 48)
		elseif npcHandler:getTopic(playerId) == 31 then
			if player:removeItem(4836, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheSpectralDress, 50)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 50)
				npcHandler:say("Good! Ask me for another mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- Spectral Dress
			-- Spectral Stone
		elseif npcHandler:getTopic(playerId) == 32 then
			npcHandler:say(
			{"Good, just take this spectral essence and use it on the strange carving in this building as well as on the corresponding tile in our base at Northport ...",
			"As soon as you have charged the portal tiles that way, report about the spectral portals."}, npc,
			creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 53)
			player:setStorageValue(Storage.ExplorerSociety.SpectralStoneDoor, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 53)
			player:addItem(4840, 1) -- Spectral stone
			-- Spectral Stone
			-- Skull Of Ratha / Giant Smithhammer
		elseif npcHandler:getTopic(playerId) == 33 then
			if player:removeItem(3207, 1) then
				npcHandler:say(
				"Poor Ratha. Thank you for returning this skull to the society. We will see to a honourable burial of Ratha.",
				npc, creature)
				player:setStorageValue(Storage.ExplorerSociety.SkullOfRatha, 1)
				player:addItem(3035, 2)
				player:addItem(3031, 50)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Come back when you find any information.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 34 then
			if player:removeItem(12510, 1) then
				npcHandler:say("Marvellous! You brought a giant smith hammer for the explorer society!", npc, creature)
				player:setStorageValue(Storage.ExplorerSociety.GiantSmithHammer, 1)
				player:addItem(3035, 2)
				player:addItem(3031, 50)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("No you don\'t.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			-- The New Frontier
		elseif npcHandler:getTopic(playerId) == 35 then
			if player:getStorageValue(TheNewFrontier.Questline) == 14 and
			player:getStorageValue(TheNewFrontier.Mission05.Angus) == 2 and player:removeItem(10011, 1) then
				npcHandler:say(
				"What a strange map. I wonder if any of our explorers recognises this coastal lines. However, you earned yourself another chance to convince me. Why do you think that Farmine would be interesting for us?",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Angus, 1)
				npcHandler:setTopic(playerId, 2)
			end
		end
		-- Answer Yes
		-- Answer No
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("Did it melt away?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 33 then
			npcHandler:say("Come back when you find any information.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 34 then
			npcHandler:say("Come back when you find one.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		-- Answer No
		-- Skull Of Ratha / Giant Smithhammer
	elseif MsgContains(message, "skull of ratha") and player:getStorageValue(Storage.ExplorerSociety.SkullOfRatha) < 1 then
		npcHandler:say(
		{"Ratha was a great explorer and even greater ladies' man. Sadly he never returned from a visit to the amazons. Probably he is dead ...",
		"The society offers a substantial reward for the retrieval of Ratha or his remains. Do you have any news about Ratha?"},
		npc, creature)
		npcHandler:setTopic(playerId, 33)
	elseif MsgContains(message, "giant smith hammer") and
	player:getStorageValue(Storage.ExplorerSociety.GiantSmithHammer) < 1 then
		npcHandler:say(
		"The explorer society is looking for a genuine giant smith hammer for our collection. It is rumoured the cyclopses of the Plains of Havoc might be using one. Did you by chance obtain such a hammer?",
		npc, creature)
		npcHandler:setTopic(playerId, 34)
		-- Skull Of Ratha / Giant Smithhammer
	else
		-- The New Frontier
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and
		player:getStorageValue(TheNewFrontier.Mission05.Angus) == 1 then
			npcHandler:say({"Wrong Word."}, npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Angus, 2)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, what can I do for you?")
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
	npcConfig.shop = {{
		itemName = "atlas",
		clientId = 6108,
		buy = 150
		}, {
		itemName = "botanist s container",
		clientId = 4867,
		buy = 500
		}, {
		itemName = "butterfly conservation kit",
		clientId = 4863,
		buy = 250
		}, {
		itemName = "crown backpack",
		clientId = 9605,
		buy = 800,
		storageKey = Storage.ExplorerSociety.TheAstralPortals,
		storageValue = 56
		}, {
		itemName = "ectoplasm container",
		clientId = 4852,
		buy = 750
		}, {
		itemName = "explorer brooch",
		clientId = 4871,
		sell = 50
		}, {
		itemName = "giant smithhammer",
		clientId = 12510,
		sell = 250
		}, {
		itemName = "hydra egg",
		clientId = 4839,
		sell = 500
		}, {
		itemName = "old parchment",
		clientId = 5956,
		sell = 500
		}, {
		itemName = "orichalcum pearl",
		clientId = 5021,
		buy = 80
		}, {
		itemName = "skull of ratha",
		clientId = 3207,
		sell = 250
}}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
