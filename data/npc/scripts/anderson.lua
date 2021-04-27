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
	{text = 'Passages to Tibia, Folda and Vega.'}
}

npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = "Do you want a passage to " .. keyword:titleCase() .. " for |TRAVELCOST|?",
			cost = cost,
			discount = "postman"
		}
	)
	travelKeyword:addChildKeyword({"yes"}, StdModule.travel,
		{
			npcHandler = npcHandler,
			text = "Have a nice trip!",
			premium = false,
			cost = cost,
			discount = "postman",
			destination = destination
		}
	)
	travelKeyword:addChildKeyword({"no"}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = "You shouldn't miss the experience.",
			reset = true
		}
	)
end

addTravelKeyword("tibia", 0, {x = 32235, y = 31674, z = 7})
addTravelKeyword("vega", 20, {x = 32020, y = 31692, z = 7})
addTravelKeyword("folda", 20, {x = 32046, y = 31578, z = 7})

-- Basic
keywordHandler:addKeyword({"passage"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Where do you want to go today? We serve the routes to Senja, {Folda} and {Vega} and back to {Tibia}."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We are ferrymen. We transport goods and passengers to the Ice Islands."
	}
)
keywordHandler:addKeyword({"captain"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We are ferrymen. We transport goods and passengers to the Ice Islands."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Ahoi, young man |PLAYERNAME| and welcome to the Nordic Tibia Ferries. If you need a {passage}, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. You are welcome.")

npcHandler:addModule(FocusModule:new())
