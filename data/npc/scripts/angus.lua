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
	-- Joining
	if msgcontains(msg, "join") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) < 1
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1 then
			npcHandler:say("Do you want to join the explorer society?", cid)
			npcHandler.topic[cid] = 1
		end
	-- The new frontier
	elseif msgcontains(msg, "farmine") then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) <= 15
		and player:getStorageValue(Storage.TheNewFrontier.BribeExplorerSociety) < 1 then
			npcHandler:say("Oh yes, an interesting topic. We had vivid discussions about this discovery. But what is it that you want?", cid)
			npcHandler.topic[cid] = 30
		end
	elseif msgcontains(msg, "bluff") then
		if npcHandler.topic[cid] == 30 then
			if player:getStorageValue(Storage.TheNewFrontier.BribeExplorerSociety) < 1 then
				npcHandler:say({
					"Those stories are just amazing! Men with faces on their stomach instead of heads you say? And hens that lay golden eggs? Whereas, most amazing is this fountain of youth you've mentioned! ...",
					"I'll immediately send some of our most dedicated explorers to check those things out!"
				}, cid)
				player:setStorageValue(Storage.TheNewFrontier.BribeExplorerSociety, 1)
				--Questlog, The New Frontier Quest "Mission 05: Getting Things Busy"
				player:setStorageValue(Storage.TheNewFrontier.Mission05, player:getStorageValue(Storage.TheNewFrontier.Mission05) + 1)
			end
		end

	-- Mission check
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) > 3
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 3
		and player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) < 26
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 26
		or player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 7
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 7
		or player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 16
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 16
		or player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 4
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 4 then
			npcHandler:say("The missions available for your rank are the {butterfly hunt}, {plant collection} and {ice delivery}.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) > 25
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 35
		and player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) < 35
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 35
		or player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 26
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 26
		or player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 29
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 29
		or player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 32
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 32 then
			npcHandler:say("The missions available for your rank are {lizard urn}, {bonelord secrets} and {orc powder}.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) > 34
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 34
		and player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) < 44
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 44
		or player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 35
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 35
		or player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 38
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 38
		or player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 41
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 41 then
			npcHandler:say("The missions available for your rank are {elven poetry}, {memory stone} and {rune writings}.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) == 44
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 44 then
			npcHandler:say("The explorer society needs a great deal of help in the research of astral travel. Are you willing to help?", cid)
			npcHandler.topic[cid] = 27
		elseif player:getStorageValue(Storage.ExplorerSociety.TheEctoplasm) == 46
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 46 then
			npcHandler:say("Do you have some collected ectoplasm with you?", cid)
			npcHandler.topic[cid] = 29
		elseif player:getStorageValue(Storage.ExplorerSociety.TheEctoplasm) == 47
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 47 then
			npcHandler:say({
				"The research on ectoplasm makes good progress. Now we need some spectral article. Our scientists think a spectral dress would be a perfect object for their studies ...",
				"The bad news is that the only source to got such a dress is the queen of the banshees. Do you dare to seek her out?"
			}, cid)
			npcHandler.topic[cid] = 30
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralDress) == 49
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 48 then
			npcHandler:say("Did you bring the dress?", cid)
			npcHandler.topic[cid] = 31
		-- Spectral stone
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralDress) == 50
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 50 then
			npcHandler:say({
				"With the objects you've provided our researchers will make steady progress. Still we are missing some test results from fellow explorers ...",
				"Please travel to our base in Northport and ask them to mail us their latest research reports. Then return here and ask about new missions."
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 51)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 51)
			player:setStorageValue(Storage.ExplorerSociety.SpectralStone, 1)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 51
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 51
		and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 2 then
			npcHandler:say("Oh, yes! Tell our fellow explorer that the papers are in the mail already.", cid)
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 52)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 52)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 52
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 52
		and player:getStorageValue(Storage.ExplorerSociety.SpectralStone) == 1 then
			npcHandler:say("The reports from Northport have already arrived here and our progress is astonishing. We think it is possible to create an astral bridge between our bases. Are you interested to assist us with this?", cid)
			npcHandler.topic[cid] = 32
			-- Spectral stone
			-- Astral portals
		elseif player:getStorageValue(Storage.ExplorerSociety.TheSpectralStone) == 55
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 55 then
			npcHandler:say({
				"Both carvings are now charged and harmonised. In theory you should be able to travel in zero time from one base to the other ...",
				"However, you will need to have an orichalcum pearl in your possession to use it as power source. It will be destroyed during the process. I will give you 6 of such pearls and you can buy new ones in our bases ...",
				"In addition, you need to be a premium explorer to use the astral travel. ...",
				"And remember: it's a small teleport for you, but a big teleport for all Tibians! Here is a small present for your efforts!"
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.TheAstralPortals, 56)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 56)
			player:addItem(5022, 6) -- Orichalcum pearl
			player:addItem(10522, 1) -- Crown backpack
			-- Astral portals
		end
	-- Mission check
	-- Pickaxe mission
	elseif msgcontains(msg, "pickaxe") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) < 4
		or player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) > 1
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1
		or player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 1 then
			npcHandler:say("Did you get the requested pickaxe from Uzgod in Kazordoon?", cid)
			npcHandler.topic[cid] = 3
		end
	-- Pickaxe mission
	-- Ice delivery
	elseif msgcontains(msg, "ice delivery") then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 4
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 4 then
			npcHandler:say({
				"Our finest minds came up with the theory that deep beneath the ice island of Folda ice can be found that is ancient. To prove this theory we would need a sample of the aforesaid ice ...",
				"Of course the ice melts away quickly so you would need to hurry to bring it here ...",
				"Would you like to accept this mission?"
			}, cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 6
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 6 then
			npcHandler:say("Did you get the ice we are looking for?", cid)
			npcHandler.topic[cid] = 5
		end
	-- Ice delivery
	-- Butterfly hunt
	elseif msgcontains(msg, "butterfly hunt") then
		if player:getStorageValue(Storage.ExplorerSociety.TheIceDelivery) == 7
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 7 then
			npcHandler:say("The mission asks you to collect some species of butterflies, are you interested?", cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 9
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 9 then
			npcHandler:say("Did you acquire the purple butterfly we are looking for?", cid)
			npcHandler.topic[cid] = 8
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 10
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 10 then
			npcHandler:say({
				"This preparation kit will allow you to collect a blue butterfly you have killed ...",
				"Just use it on the fresh corpse of a blue butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 11)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 11)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 12
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 12 then
			npcHandler:say("Did you acquire the blue butterfly we are looking for?", cid)
			npcHandler.topic[cid] = 9
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 13
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 13 then
			npcHandler:say({
				"This preparation kit will allow you to collect a red butterfly you have killed ...",
				"Just use it on the fresh corpse of a red butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 14)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 14)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 15
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 15 then
			npcHandler:say("Did you acquire the red butterfly we are looking for?", cid)
			npcHandler.topic[cid] = 10
		end
	-- Butterfly Hunt
	-- Plant Collection
	elseif msgcontains(msg, "plant collection") then
		if player:getStorageValue(Storage.ExplorerSociety.TheButterflyHunt) == 16
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 16 then
			npcHandler:say("In this mission we require you to get us some plant samples from Tiquandan plants. Would you like to fulfil this mission?", cid)
			npcHandler.topic[cid] = 11
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 18 
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 18 then
			npcHandler:say("Did you acquire the sample of the jungle bells plant we are looking for?", cid)
			npcHandler.topic[cid] = 12
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 19
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 19 then
			npcHandler:say("Use this botanist's container on a witches cauldron to collect a sample for us. Bring it here and report about your plant collection.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 20)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 20)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 21
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 21 then
			npcHandler:say("Did you acquire the sample of the witches cauldron we are looking for?", cid)
			npcHandler.topic[cid] = 13
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 22
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 22 then
			npcHandler:say("Use this botanist\'s container on a giant jungle rose to obtain a sample for us. Bring it here and report about your plant collection.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 23)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 23)
		elseif player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 24
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 24 then
			npcHandler:say("Did you acquire the sample of the giant jungle rose we are looking for?", cid)
			npcHandler.topic[cid] = 14
		end
	-- Plant Collection
	-- Lizard Urn
	elseif msgcontains(msg, "lizard urn") then
		if player:getStorageValue(Storage.ExplorerSociety.ThePlantCollection) == 26
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 26 then
			npcHandler:say("The explorer society would like to acquire an ancient urn which is some sort of relic to the lizard people of Tiquanda. Would you like to accept this mission?", cid)
			npcHandler.topic[cid] = 15
		elseif player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 28
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 27 then
			npcHandler:say("Did you manage to get the ancient urn?", cid)
			npcHandler.topic[cid] = 16
		end
	-- Lizard Urn
	-- Bonelords
	elseif msgcontains(msg, "bonelord secrets") then
		if player:getStorageValue(Storage.ExplorerSociety.TheLizardUrn) == 29 
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 29 then
			npcHandler:say({
				"We want to learn more about the ancient race of bonelords. We believe the black pyramid north east of Darashia was originally built by them ...",
				"We ask you to explore the ruins of the black pyramid and look for any signs that prove our theory. You might probably find some document with the numeric bonelord language ...",
				"That would be sufficient proof. Would you like to accept this mission?"
			}, cid)
			npcHandler.topic[cid] = 17
		elseif player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 31
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 30 then
			npcHandler:say("Have you found any proof that the pyramid was built by bonelords?", cid)
			npcHandler.topic[cid] = 18
		end
	-- Bonelords
	-- Orc Powder
	elseif msgcontains(msg, "orc powder") then
		if player:getStorageValue(Storage.ExplorerSociety.TheBonelordSecret) == 32
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 32 then
			npcHandler:say({
				"It is commonly known that orcs of Uldereks Rock use some sort of powder to increase the fierceness of their war wolves and berserkers ...",
				"What we do not know are the ingredients of this powder and its effect on humans ...",
				"So we would like you to get a sample of the aforesaid powder. Do you want to accept this mission?"
			}, cid)
			npcHandler.topic[cid] = 19
		elseif player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 34
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 33 then
			npcHandler:say("Did you acquire some of the orcish powder?", cid)
			npcHandler.topic[cid] = 20
		end
	-- Orc Powder
	-- Elven Poetry
	elseif msgcontains(msg, "elven poetry") then
		if player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) == 35
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 35 then
			npcHandler:say({
				"Some high ranking members would like to study elven poetry. They want the rare book 'Songs of the Forest' ...",
				"For sure someone in Ab'Dendriel will own a copy. So you would just have to ask around there. Are you willing to accept this mission?"
			}, cid)
			npcHandler.topic[cid] = 21
		elseif player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 37
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 36 then
			npcHandler:say("Did you acquire a copy of 'Songs of the Forest' for us?", cid)
			npcHandler.topic[cid] = 22
		end
		-- ELVEN POETRY

		-- MEMORY STONE
	elseif msgcontains(msg, "memory stone") then
		if player:getStorageValue(Storage.ExplorerSociety.TheElvenPoetry) == 38
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 38 then
			npcHandler:say({
				"We acquired some knowledge about special magic stones. Some lost civilisations used it to store knowledge and lore, just like we use books ...",
				"The wisdom in such stones must be immense, but so are the dangers faced by every person who tries to obtain one...",
				"As far as we know the ruins found in the north-west of Edron were once inhabited by beings who used such stones. Do you have the heart to go there and to get us such a stone?"
			}, cid)
			npcHandler.topic[cid] = 23
		elseif player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 40
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 39 then
			npcHandler:say("Were you able to acquire a memory stone for our society?", cid)
			npcHandler.topic[cid] = 24
		end
	-- Memory Stone
	-- Rune Writings
	elseif msgcontains(msg, "rune writings") then
		if player:getStorageValue(Storage.ExplorerSociety.TheMemoryStone) == 41
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 41 then
			npcHandler:say({
				"We would like to study some ancient runes that were used by the lizard race. We suspect some relation of the lizards to the founders of Ankrahmun ...",
				"Somewhere under the ape infested city of Banuta, one can find dungeons that were once inhabited by lizards...",
				"Look there for an atypical structure that would rather fit to Ankrahmun and its Ankrahmun Tombs. Copy the runes you will find on this structure...",
				"Are you up to that challenge?"
			}, cid)
			npcHandler.topic[cid] = 25
		elseif player:getStorageValue(Storage.ExplorerSociety.TheRuneWritings) == 43
		and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 43 then
			npcHandler:say("Did you create a copy of the ancient runes as requested?", cid)
			npcHandler.topic[cid] = 26
		end
	-- Rune Writings
	-- Answer Yes
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Fine, though it takes more then a mere lip service to join our ranks. To prove your dedication to the cause you will have to acquire an item for us ...",
				"The mission should be simple to fulfil. For our excavations we have ordered a sturdy pickaxe in Kazordoon. You would have to seek out this trader Uzgod and get the pickaxe for us ...",
				"Simple enough? Are you interested in this task?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("We will see if you can handle this simple task. Get the pickaxe from Uzgod in Kazordoon and bring it to one of our bases. Report there about the pickaxe.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 1)
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(4874, 1) then
				player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 4)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 4)
				npcHandler:say({
					"Excellent, you brought just the tool we need! Of course it was only a simple task. However ...",
					"I officially welcome you to the explorer society. From now on you can ask for missions to improve your rank."
				}, cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 then
			player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 5)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 5)
			npcHandler:say({
				"So listen please: Take this ice pick and use it on a block of ice in the caves beneath Folda. Get some ice and bring it here as fast as you can ...",
				"Should the ice melt away, report on your ice delivery mission anyway. I will then tell you if the time is right to start another mission."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4856, 1)
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(4848, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 7)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 7)
				npcHandler:say("Just in time. Sadly not much ice is left over but it will do. Thank you again.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 6 then
			player:setStorageValue(Storage.ExplorerSociety.TheIceDelivery, 5)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 5)
			npcHandler:say("*Sigh* I think the time is right to grant you another chance to get that ice. Hurry up this time.", cid)
			npcHandler.topic[cid] = 0

		-- Butterfly Hunt
		elseif npcHandler.topic[cid] == 7 then
			player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 8)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 8)
			npcHandler:say({
				"This preparation kit will allow you to collect a purple butterfly you have killed ...",
				"Just use it on the fresh corpse of a purple butterfly, return the prepared butterfly to me and give me a report of your butterfly hunt."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(4866, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 10)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 10)
				npcHandler:say("A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 9 then
			if player:removeItem(4867, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 13)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 13)
				npcHandler:say("A little bit battered but it will do. Thank you! If you think you are ready, ask for another butterfly hunt.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 10 then
			if player:removeItem(4868, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheButterflyHunt, 16)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 16)
				npcHandler:say("That is an extraordinary species you have brought. Thank you! That was the last butterfly we needed.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Butterfly Hunt
		-- Plant Collection
		elseif npcHandler.topic[cid] == 11 then
			player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 17)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 17)
			npcHandler:say("Fine! Here take this botanist's container. Use it on a jungle bells plant to collect a sample for us. Report about your plant collection when you have been successful.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
		elseif npcHandler.topic[cid] == 12 then
			if player:removeItem(4870, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 19)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 19)
				npcHandler:say("I see. It seems you've got some quite useful sample by sheer luck. Thank you! Just tell me when you are ready to continue with the plant collection.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 13 then
			if player:removeItem(4871, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 22)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 22)
				npcHandler:say("Ah, finally. I started to wonder what took you so long. But thank you! Another fine sample, indeed. Just tell me when you are ready to continue with the plant collection.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 14 then
			if player:removeItem(4872, 1) then
				player:setStorageValue(Storage.ExplorerSociety.ThePlantCollection, 26)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 26)
				npcHandler:say("What a lovely sample! With that you have finished your plant collection missions.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Plant Collection
		-- Lizard Urn
		elseif npcHandler.topic[cid] == 15 then
			player:setStorageValue(Storage.ExplorerSociety.TheLizardUrn, 27)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 27)
			player:setStorageValue(Storage.ExplorerSociety.ChorurnDoor, 1)
			npcHandler:say({
				"You have indeed the spirit of an adventurer! In the south-east of Tiquanda is a small settlement of the lizard people ...",
				"Beneath the newly constructed temple there, the lizards hide the said urn. Our attempts to acquire this item were without success ...",
				"Perhaps you are more successful."
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 16 then
			if player:removeItem(4858, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheLizardUrn, 29)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 29)
				npcHandler:say("Yes, that is the prized relic we have been looking for so long. You did a great job, thank you.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Lizard Urn
		-- Bonelords
		elseif npcHandler.topic[cid] == 17 then
			player:setStorageValue(Storage.ExplorerSociety.TheBonelordSecret, 30)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 30)
			player:setStorageValue(Storage.ExplorerSociety.BonelordsDoor, 1)
			npcHandler:say({
				"Excellent! So travel to the city of Darashia and then head north-east for the pyramid ...",
				"If any documents are left, you probably find them in the catacombs beneath. Good luck!"
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 18 then
			if player:removeItem(4857, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheBonelordSecret, 32)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 32)
				npcHandler:say("You did it! Excellent! The scientific world will be shaken by this discovery!", cid)
				npcHandler.topic[cid] = 0
			end
		-- Bonelords
		-- Orc Powder
		elseif npcHandler.topic[cid] == 19 then
			player:setStorageValue(Storage.ExplorerSociety.TheOrcPowder, 33)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 33)
			player:setStorageValue(Storage.ExplorerSociety.OrcDoor, 1)
			npcHandler:say({
				"You are a brave soul. As far as we can tell, the orcs maintain some sort of training facility in some hill in the north-east of their city ...",
				"There you should find lots of their war wolves and hopefully also some of the orcish powder. Good luck!"
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 20 then
			if player:removeItem(15389, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheOrcPowder, 35)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 35)
				npcHandler:say("You really got it? Amazing! Thank you for your efforts.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Orc Powder
		-- Elven Poetry
		elseif npcHandler.topic[cid] == 21 then
			player:setStorageValue(Storage.ExplorerSociety.TheElvenPoetry, 36)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 36)
			player:setStorageValue(Storage.ExplorerSociety.ElvenDoor, 1)
			npcHandler:say("Excellent. This mission is easy but nonetheless vital. Travel to Ab'Dendriel and get the book.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 22 then
			if player:removeItem(4855, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheElvenPoetry, 38)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 38)
				npcHandler:say("Let me have a look! Yes, that's what we wanted. A copy of 'Songs of the Forest'. I won't ask any questions about those bloodstains.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Elven Poetry
		-- Memory Stone
		elseif npcHandler.topic[cid] == 23 then
			player:setStorageValue(Storage.ExplorerSociety.TheMemoryStone, 39)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 39)
			player:setStorageValue(Storage.ExplorerSociety.MemoryStoneDoor, 1)
			npcHandler:say("In the ruins of north-western Edron you should be able to find a memory stone. Good luck.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 24 then
			if player:removeItem(4852, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheMemoryStone, 41)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 41)
				npcHandler:say("A flawless memory stone! Incredible! It will take years even to figure out how it works but what an opportunity for science, thank you!", cid)
				npcHandler.topic[cid] = 0
			end
		-- Memory Stone
		-- Rune Writings
		elseif npcHandler.topic[cid] == 25 then
			player:setStorageValue(Storage.ExplorerSociety.TheRuneWritings, 42)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 42)
			npcHandler:say("Excellent! Here, take this tracing paper and use it on the object you will find there to create a copy of the ancient runes.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4853, 1)
		elseif npcHandler.topic[cid] == 26 then
			if player:removeItem(4854, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheRuneWritings, 44)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 44)
				npcHandler:say("It's a bit wrinkled but it will do. Thanks again.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Rune Writings
		-- Ectoplasm
		elseif npcHandler.topic[cid] == 27 then
			npcHandler:say({
				"Fine. The society is looking for new means to travel. Some of our most brilliant minds have some theories about astral travel that they want to research further ...",
				"Therefore we need you to collect some ectoplasm from the corpse of a ghost. We will supply you with a collector that you can use on the body of a slain ghost ...",
				"Do you think you are ready for that mission?"
			}, cid)
			npcHandler.topic[cid] = 28
		elseif npcHandler.topic[cid] == 28 then
			npcHandler:say("Good! Take this container and use it on a ghost that was recently slain. Return with the collected ectoplasm and hand me that container ...", cid)
			npcHandler:say("Don't lose the container. They are expensive!", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.TheEctoplasm, 45)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 45)
			player:addItem(4863, 1)
		elseif npcHandler.topic[cid] == 29 then
			if player:removeItem(8182, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheEctoplasm, 47)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 47)
				npcHandler:say("Phew, I had no idea that ectoplasm would smell that ... oh, it's you, well, sorry. Thank you for the ectoplasm.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Ectoplasm
		-- Spectral Dress
		elseif npcHandler.topic[cid] == 30 then
			npcHandler:say({
				"That is quite courageous. We know, it's much we are asking for. The queen of the banshees lives in the so called Ghostlands, south west of Carlin. It is rumoured that her lair is located in the deepest dungeons beneath that cursed place ...",
				"Any violence will probably be futile, you will have to negotiate with her. Try to get a spectral dress from her. Good luck."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralDress, 48)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 48)
		elseif npcHandler.topic[cid] == 31 then
			if player:removeItem(4847, 1) then
				player:setStorageValue(Storage.ExplorerSociety.TheSpectralDress, 50)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 50)
				npcHandler:say("Good! Ask me for another mission.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Spectral Dress

		-- Spectral Stone
		elseif npcHandler.topic[cid] == 32 then
			npcHandler:say({
				"Good, just take this spectral essence and use it on the strange carving in this building as well as on the corresponding tile in our base at Northport ...",
				"As soon as you have charged the portal tiles that way, report about the spectral portals."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.TheSpectralStone, 53)
			player:setStorageValue(Storage.ExplorerSociety.SpectralStoneDoor, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 53)
			player:addItem(4851, 1) -- Spectral stone
		-- Spectral Stone
		-- Skull Of Ratha / Giant Smithhammer
		elseif npcHandler.topic[cid] == 33 then
			if player:removeItem(2320, 1) then
				npcHandler:say("Poor Ratha. Thank you for returning this skull to the society. We will see to a honourable burial of Ratha.", cid)
				player:setStorageValue(Storage.ExplorerSociety.SkullOfRatha, 1)
				player:addItem(2152, 2)
				player:addItem(2148, 50)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Come back when you find any information.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 34 then
			if player:removeItem(2321, 1) then
				npcHandler:say("Marvellous! You brought a giant smith hammer for the explorer society!", cid)
				player:setStorageValue(Storage.ExplorerSociety.GiantSmithHammer, 1)
				player:addItem(2152, 2)
				player:addItem(2148, 50)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("No you don\'t.", cid)
				npcHandler.topic[cid] = 0
			end
		-- Skull Of Ratha / Giant Smithhammer
		end
	-- Answer Yes
	-- Answer No
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 5 then
			npcHandler:say("Did it melt away?", cid)
			npcHandler.topic[cid] = 6
		elseif npcHandler.topic[cid] == 33 then
			npcHandler:say("Come back when you find any information.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 34 then
			npcHandler:say("Come back when you find one.", cid)
			npcHandler.topic[cid] = 0
		end
	-- Answer No
	-- Skull Of Ratha / Giant Smithhammer
	elseif msgcontains(msg, "skull of ratha")
		and player:getStorageValue(Storage.ExplorerSociety.SkullOfRatha) < 1 then
		npcHandler:say({
			"Ratha was a great explorer and even greater ladies' man. Sadly he never returned from a visit to the amazons. Probably he is dead ...",
			"The society offers a substantial reward for the retrieval of Ratha or his remains. Do you have any news about Ratha?"
		}, cid)
		npcHandler.topic[cid] = 33
	elseif msgcontains(msg, "giant smith hammer")
		and player:getStorageValue(Storage.ExplorerSociety.GiantSmithHammer) < 1 then
		npcHandler:say("The explorer society is looking for a genuine giant smith hammer for our collection. It is rumoured the cyclopses of the Plains of Havoc might be using one. Did you by chance obtain such a hammer?", cid)
		npcHandler.topic[cid] = 34
	-- Skull Of Ratha / Giant Smithhammer
	end
	return true
end

local function onTradeRequest(cid)
	if Player(cid):getStorageValue(Storage.ExplorerSociety.TheAstralPortals) ~= 56 then
		return false
	end

	return true
end

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())