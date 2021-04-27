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

local voices = { {text = 'Passages to Kazordoon! Gotta try the beer there.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, text, cost, discount, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text[1], cost = cost, discount = discount})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = text[2], cost = cost, discount = discount, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = text[3], reset = true})
end

addTravelKeyword('farmine', {'Do you seek a ride to Farmine for |TRAVELCOST|?', 'Hold on!', 'You shouldn\'t miss the experience.'}, 110, {'postman', 'new frontier'},
	function(player)
		local destination = Position(33025, 31553, 14)
		if player:getStorageValue(Storage.TheNewFrontier.Mission05) == 7 then --if The New Frontier Quest 'Mission 05: Getting Things Busy' complete then Stage 3
			destination.z = 10
		elseif player:getStorageValue(Storage.TheNewFrontier.Mission03) >= 2 then --if The New Frontier Quest 'Mission 03: Strangers in the Night' complete then Stage 2
			destination.z = 12
		end

		return destination
	end
)
addTravelKeyword('kazordoon', {'Do you want to go to Kazordoon to try the beer there? |TRAVELCOST|?', 'Set the sails!', 'Then not.'}, 160, 'postman', Position(32660, 31957, 15))

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want me take you to {Kazordoon} or {Farmine}?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome, |PLAYERNAME|! May Earth protect you, even whilst sailing!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Until next time.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Until next time.')

npcHandler:addModule(FocusModule:new())
