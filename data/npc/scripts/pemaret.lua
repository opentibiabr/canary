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
	if msgcontains(msg, "marlin") then
		if player:getItemCount(7963) > 0 then
			npcHandler:say("WOW! You have a marlin!! I could make a nice decoration for your wall from it. May I have it?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		if player:removeItem(7963, 1) then
			npcHandler:say("Yeah! Now let's see... <fumble fumble> There you go, I hope you like it!", cid)
			player:addItem(7964, 1)
		else
			npcHandler:say("You don't have the fish.", cid)
		end
		npcHandler.topic[cid] = 0
	end
	if msgcontains(msg, "no") and npcHandler.topic[cid] == 1 then
		npcHandler:say("Then no.", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, text, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe later.', reset = true})
end

addTravelKeyword('edron', 'Do you want to get to Edron for |TRAVELCOST|?', 20, Position(33176, 31764, 6))
addTravelKeyword('eremo', 'Oh, you know the good old sage Eremo. I can bring you to his little island. Do you want me to do that?', 0, Position(33314, 31883, 7))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33293, 31957, 6), Position(33294, 31955, 6), Position(33294, 31958, 6)}})

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a fisherman and I take along people to Edron. You can also buy some fresh fish.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a fisherman and I take along people to Edron. You can also buy some fresh fish.'})
keywordHandler:addKeyword({'fish'}, StdModule.say, {npcHandler = npcHandler, text = 'My fish is of the finest quality you could find. Ask me for a trade to check for yourself.'})
keywordHandler:addKeyword({'cormaya'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s a lovely and peaceful isle. Did you already visit the nice sandy beach?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Pemaret, the fisherman.'})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, young man. Looking for a passage or some fish, |PLAYERNAME|?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
