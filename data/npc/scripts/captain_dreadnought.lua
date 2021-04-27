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
	{text = "No smuggling aboard this ship! Only 20 pieces of any creature product allowed!"},
	{text = "No fear! The Sea Cat will ship you safely to the mainland!"},
	{text = "All aboard! Prepare to sail!"},
	{text = "Come hell or high water, we'll reach any port I sail you to!"},
	{text = "This island is too small. I need sea water around me."}
}

npcHandler:addModule(VoiceModule:new(voices))

-- List of all towns to ask about and to sail to
local towns = {
	[TOWNS_LIST.AB_DENDRIEL] = {
		name = "Ab'dendriel",
		about = {
			"Main city of the elves - lots of trees, bug milk and stuff that easily burns ...",
			"... Sorry, just thinking aloud. Ahem. Very cosy and safe I guess if you're fond of nature."
		},
		canBeSailed = true,
		isPremium = false,
		message = "So it's Ab'Dendriel, the tree city of the elves you chose as your new home?",
		destination = {x = 32734, y = 31668, z = 6}
	},
	[TOWNS_LIST.ANKRAHMUN] = {
		name = "Ankrahmun",
		about = {"Desert pyramid city close to the ocean, some underground tombs where I heard it's not bad hunting."},
		canBeSailed = true,
		isPremium = true,
		message = "So it's Ankrahmun, the city you chose as your new home?",
		destination = {x = 33092, y = 32883, z = 6}
	},
	[TOWNS_LIST.CARLIN] = {
		name = "Carlin",
		about = {
			"A city ruled by forthright independent women. \z
			Very clean and safe, but also very strict on the booze, alas. But if that's what you like..."
		},
		canBeSailed = true,
		isPremium = false,
		message = "So it's Carlin, the city under women's rule, a rival to Thais you chose as your new home?",
		destination = {x = 32387, y = 31820, z = 6}
	},
	[TOWNS_LIST.DARASHIA] = {
		name = "Darashia",
		about = {
			"One of the two desert cities. \z
			Built around a lovely oasis. Lions, dragons... decent location for a newcomer."
		},
		canBeSailed = true,
		isPremium = true,
		message = "So it's Darashia, the city you chose as your new home?",
		destination = {x = 33289, y = 32481, z = 6}
	},
	[TOWNS_LIST.EDRON] = {
		name = "Edron",
		about = {
			"Quiet little castle city on an island in the north-eastern part of Tibia. \z
			Trolls, goblins, rotworms... good place for starters, too."
		},
		canBeSailed = true,
		isPremium = true,
		message = "So it's Edron, the city you chose as your new home?",
		destination = {x = 33175, y = 31764, z = 6}
	},
	[TOWNS_LIST.KAZORDOON] = {
		name = "Kazordoon",
		about = {"The underground dwarven city. Doesn't have a real harbour, so I can't bring you there, sorry."},
		canBeSailed = false
	},
	[TOWNS_LIST.LIBERTY_BAY] = {
		name = "Liberty Bay",
		about = {
			"Liberty Bay is on an island group in the South Seas. Ah, home sweet home. Err. I mean, \z
			it's pirates galore. Good deal of tortoises, too. Just be careful, then it's a good hunting location."
		},
		canBeSailed = true,
		isPremium = true,
		message = "So it's Liberty Bay, the city you chose as your new home?",
		destination = {x = 32285, y = 32892, z = 6}
	},
	[TOWNS_LIST.PORT_HOPE] = {
		name = "Port Hope",
		about = {
			"Port Hope is an outpost right in the middle of the jungle. ...",
			"Apes, bananas, hydras, tarantulas... Who'd want to go there? \z
			Except for crazy adventurers like these guys here on the island, obviously."
		},
		canBeSailed = true,
		isPremium = true,
		message = "So it's Port Hope, the city you chose as your new home?",
		destination = {x = 32527, y = 32784, z = 6}
	},
	[TOWNS_LIST.SVARGROND] = {
		name = "Svargrond",
		about = {
			"Negative, can't bring you there. You gotta pass some sort of Barbarian test \z
			before they let you live there. Still, you should go there sometime, I heard it's quite interesting."
		},
		canBeSailed = false
	},
	[TOWNS_LIST.THAIS] = {
		name = "Thais",
		about = {
			"Old-school city. Actually the oldest main city in Tibia. \z
			Be careful on those streets, there are bandits everywhere."
		},
		canBeSailed = true,
		isPremium = false,
		message = "So it's Thais, the oldest of the human kingdoms you chose as your new home?",
		destination = {x = 32310, y = 32210, z = 6}
	},
	[TOWNS_LIST.VENORE] = {
		name = "Venore",
		about = {
			"Hohoh, one of the richest cities, filled with merchants and LOOT! Err. \z
			I mean, it is HIGHLY recommendable for unexperienced and first-time adventurers. \z
			Don't know why they built it over a stinking swamp though."
		},
		canBeSailed = true,
		isPremium = false,
		message =
			"So it's Venore, \z
			the rich swamp city of traders, recommended for new heroes, that you chose as your new home?",
		destination = {x = 32954, y = 32022, z = 6}
	},
	[TOWNS_LIST.YALAHAR] = {
		name = "Yalahar",
		about = {
			"Now that must be one of the biggest cities I've ever seen. \z
			Might be not cosy for a newcomer like yourself, though. And I can't sail there anyway... \z
			they don't let everyone enter their fine pretty harbour, they're a bit particular."
		},
		canBeSailed = false
	}
}

local defaultTown = TOWNS_LIST.VENORE
local townNames = {all = "", free = "", premium = ""}

-- Function to build town names strings and adds additional data to sailable/premium towns about
function buildStrings()
	local townsList = {all = {}, free = {}, premium = {}}
	for id, town in pairs(towns) do
		if town.canBeSailed then
			if town.isPremium then
				table.insert(townsList.premium, "{" .. town.name .. "}")
				town.about[1] = "Only for {premium} travellers! " .. town.about[1]
			else
				table.insert(townsList.premium, "{" .. town.name .. "}")
				table.insert(townsList.free, "{" .. town.name .. "}")
			end
			town.about[#town.about] = town.about[#town.about] .. " I can {sail} there if you like."
		end
		table.insert(townsList.all, "{" .. town.name .. "}")
	end
	for list, townList in pairs(townsList) do
		if #townList == 1 then
			townNames[list] = townList[1]
		elseif #townList > 1 then
			table.sort(townList, function(a, b) return a:upper() < b:upper() end)
			local lastTown = table.remove(townList, #townList)
			townNames[list] = table.concat(townList, ", ")  .. " or " .. lastTown
		end
	end
end

buildStrings()

-- Function to handle donations and its messages
local function donationHandler(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
        return false
    end
	local player = Player(cid)
	if (parameters.confirm ~= true) and (parameters.decline ~= true) then
		npcHandler:say(
			"So you want to donate " .. (player:getMoney() - 500) .. " gold coins? \z
			The little kiddies are going to appreciate it.",
			cid
		)
	elseif (parameters.confirm == true) then
		if player:getMoney() > 500 then
			player:removeMoney((player:getMoney() - 500))
			npcHandler:say(
				"Well, that's really generous of you. That'll feed a lot of hungry mouths for a while. \z
				Right, now which {city} did you say you wanted to go to?",
				cid
			)
			npcHandler:resetNpc(cid)
		else
			npcHandler:say("Well, har har. Very funny. Come on, pick up the gold you just dropped.", cid)
		end
	elseif (parameters.decline == true) then
		if player:getMoney() > 500 then
			npcHandler:say(
				"By tempest! What's all this gold weighing us down? Don't you think that's a little risky with all \z
				these pirates around? You can take 500 with you, but that's it. Drop the rest or {donate} it to the \z
				Adventurers' Orphans Fund, really.",
				cid
			)
		end
	end
	return true
end

-- Function to handle town travel and its messages
local function townTravelHandler(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
        return false
    end
    local player = Player(cid)
	if (parameters.confirm ~= true) and (parameters.decline ~= true) and parameters.townId then
		local town = towns[parameters.townId]
		if town.canBeSailed == false then
			if player:isPremium() then
				npcHandler:say("What? Whatever that is, it's not a port I sail to. " .. townNames.premium .. "?", cid)
			else
				npcHandler:say("What? Whatever that is, it's not a port I sail to. " .. townNames.free .. "?", cid)
			end
		elseif town.isPremium == true and not player:isPremium() then
			npcHandler:say(
				"Negative, can't bring you there without a premium account. \z
				You should be glad you get to travel by ship - usually that's a premium service too, you know.",
				cid
			)
		else
			npcHandler:say(town.message .. " What do you say, {yes} or {no}?", cid)
		end
	elseif (parameters.confirm == true) then
		-- Handle money excess at confirm or it may be dropped and picked up in previous steps
		if player:getMoney() > 500 then
			npcHandler:say(
				"By tempest! What's all this gold weighing us down? Don't you think that's a little risky with all \z
				these pirates around? You can take 500 with you, but that's it. Drop the rest or {donate} it to the \z
				Adventurers' Orphans Fund, really.",
				cid
			)
			return true
		end
		local parentNode = node:getParent()
        local parentParameters = parentNode:getParameters()
		local townId = parentParameters.townId or parameters.townId
		local town = Town(townId)
		player:setTown(town)
		player:teleportTo(towns[townId].destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.Dawnport.Mainland, 1)
		npcHandler:say(
			"Cast off! Don't forget to talk to the guide at the port for directions to nearest bars... err, shops and \z
			bank and such!",
			cid
		)
		npcHandler:resetNpc(cid)
		npcHandler:releaseFocus(cid)
	elseif (parameters.decline == true) then
		if player:isPremium() then
			npcHandler:say("Changed your mind? Which city do you want to head to, " .. townNames.premium .. "?", cid)
		else
			npcHandler:say("Changed your mind? Which city do you want to head to, " .. townNames.free .. "?", cid)
		end
		npcHandler.keywordHandler:moveUp(cid, 1)
	elseif (parameters.sailableTowns == true) and parameters.text then
		if player:isPremium() then
			npcHandler:say(string.gsub(parameters.text, "|TOWNS|", townNames.premium), cid)
		else
			npcHandler:say(string.gsub(parameters.text, "|TOWNS|", townNames.free), cid)
		end
	end
	return true
end
-- Other topics
keywordHandler:addKeyword({"name"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Ruby Dreadnought. But it's Captain Dreadnought to you!"
})
keywordHandler:addKeyword({"job"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "I'm captain of this little sloop here, the Sea Cat."
})
keywordHandler:addKeyword({"ship"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "She's pretty, isn't she? Will ship you safely to any port. Though a young landlubber such as you should \z
	consider to travel to Venore first. The travel is for free. Just once though! You have to ask for a {passage}."
})
keywordHandler:addKeyword({"mainland"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "You chose a peaceful world. Not much danger from other adventurers. Just beware the monsters. \z
	Want go there, ask for a {passage}."
})
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "That old place? Sorry, I don't sail there, no loot to be had."
})
keywordHandler:addKeyword({"adventurers guild"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Those fellows help still green adventurers like you, so you learn the lay of the Tibian Mainlands. \z
		With the adventurer's stone you can reach their guild hall from all major temples. ...", 
		"I recommend you travel there as soon as possible."
	}
})
keywordHandler:addKeyword({"premium"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Some regions in the world can't be accessed by everyone. Gotta pay, you know? \z
	If you spend some real cash for premium time, I can bring you to much more challenging locations."
})
keywordHandler:addKeyword({"tibia"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "That's what the whole place is called."
})
-- Main topic nodes
local readyNode = keywordHandler:addKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Good. Got all you want to take to the mainland, {yes}? Gear, limbs, loot?"
})
local notReadyNode = keywordHandler:addKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "What? Then what DO you want? Learn about the main Tibian {cities}?"
})
-- Main subtopic nodes
-- hi, yes, ...
local defaultTownNode = readyNode:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = {
		"Quick learner, good answer. For inexperienced newcomers, \z
		I'd recommend the city of {" .. towns[defaultTown].name .. "}. Great place to start! ...",
		"Though I can tell you about the other main Tibian {cities} too, if you wish. \z
		So, ready to set sail for {" .. towns[defaultTown].name .. "}?"
	}
})
readyNode:addChildKeyword({"no"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "While you take time to ponder, I will just stroll over there and pretend not to listen to you thinking.",
	ungreet = true
})
-- hi, no, ...
local aboutTownsNode = notReadyNode:addChildKeyword({"yes"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Well, I can tell you stuff about " .. townNames.all .. "."
})
local aboutSailNode = notReadyNode:addChildKeyword({"no"}, townTravelHandler,
{
	sailableTowns = true,
	text = "So you know it all, huh? Where do you want me to bring you to, kid? |TOWNS|?"
})
-- hi, yes, yes, ...
defaultTownNode:addChildKeyword({"yes"}, townTravelHandler, {confirm = true, townId = defaultTown})
defaultTownNode:addAliasKeyword({towns[defaultTown].name:lower()})
defaultTownNode:addChildKeyword({"no"}, townTravelHandler, {decline = true})
-- Towns topic nodes
local townsNode = keywordHandler:addKeyword({"cities"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "Do you want to know about " .. townNames.all .. "?"
})
for id, town in pairs(towns) do
	local townNode = KeywordNode:new({town.name:lower()}, StdModule.say, {npcHandler = npcHandler, text = town.about})
	townsNode:addChildKeywordNode(townNode)
	aboutTownsNode:addChildKeywordNode(townNode)
end
keywordHandler:addAliasKeyword({"city"})
-- Sail topic nodes
local sailNode = keywordHandler:addKeyword({"sail"}, StdModule.say,
{
	npcHandler = npcHandler,
	text = "So, you've decided on your new home city? Which one will it be?"
})
local confirmNode = KeywordNode:new({"yes"}, townTravelHandler, {confirm = true})
local declineNode = KeywordNode:new({"no"}, townTravelHandler, {decline = true})
for id, town in pairs(towns) do
	local townSailNode = KeywordNode:new({town.name:lower()}, townTravelHandler, {townId = id})	
	townSailNode:addChildKeywordNode(confirmNode)
    townSailNode:addChildKeywordNode(declineNode)
	sailNode:addChildKeywordNode(townSailNode)
	aboutSailNode:addChildKeywordNode(townSailNode)
end
keywordHandler:addAliasKeyword({"passage"})
keywordHandler:addAliasKeyword({"travel"})
-- Donate topic nodes
local donateNode = keywordHandler:addKeyword({"donate"}, donationHandler, {}, 
function(player) return player:getMoney() > 500 end
)
donateNode:addChildKeywordNode(KeywordNode:new({"yes"}, donationHandler, {confirm = true}))
donateNode:addChildKeywordNode(KeywordNode:new({"no"}, donationHandler, {decline = true}))

local function greetCallback(cid)
	local player = Player(cid)
	npcHandler:setMessage(
		MESSAGE_GREET,
		"Well, well, a new " .. player:getVocation():getName():lower() .. "! Want me to bring you somewhere nice? \z
		Just say {yes}."
	)
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local currentNode = keywordHandler:getLastNode(cid)
	-- Handle other words for nodes while still handling (bye, farewell) keywords
	if #currentNode.children == 0 then
		npcHandler:say(
			"Kid, listen. Answering with a clear {yes} or {no} will get you much further in Tibia. \z
			Most people are not as sharp-eared as I am. Got that?",
			cid
		)
	elseif currentNode == readyNode then
		npcHandler:say("Errr... was that a foreign language? Could you just answer with a clear {yes} or {no}?", cid)
	elseif currentNode == notReadyNode then
		npcHandler:say(
		"Aw, come on! Talk to me in human words! {Yes}, {no}, or mention a city's name, that kind of stuff.",
		cid
	)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(
	MESSAGE_FAREWELL,
	"You sure you want to spend time on this piece of rock? I can show you the world! Huh."
)

npcHandler:addModule(FocusModule:new())
