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

local function greetCallback(cid)
	if Player(cid):getStorageValue(Storage.DjinnWar.MaridFaction.Mission02) == -1 then
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'spy report') then
		local reportProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.RataMari)
		if reportProgress < 1 then
			npcHandler:say({
				'You have come for the report? Great! I have been working hard on it during the last months. And nobody came to pick it up. I thought everybody had forgotten about me! ...',
				'Do you have any idea how difficult it is to hold a pen when you have claws instead of hands? ...',
				'But - you know - now I have worked so hard on this report I somehow don\'t want to part with it. At least not without some decent payment. ...',
				'All right - listen - I know Fa\'hradin would not approve of this, but I can\'t help it. I need some cheese! I need it now! ...',
				'And I will not give the report to you until you get me some! Meep!'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 1)

		elseif reportProgress == 1 then
			npcHandler:say('Ok, have you brought me the cheese, I\'ve asked for?', cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('I already gave you the report. I\'m not going to write another one!', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			if not player:removeItem(2696, 1) then
				npcHandler:say('No cheese - no report.', cid)
				return true
			end
			player:setStorageValue(Storage.DjinnWar.MaridFaction.RataMari, 2)
			player:addItem(2345, 1)
			npcHandler:say('Meep! Meep! Great! Here is the spyreport for you!', cid)
		else
			npcHandler:say('No cheese - no report.', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Your power of observation is stunning. Yes, I\'m a rat.'})

-- Greeting message
keywordHandler:addGreetKeyword({"piedpiper"}, {npcHandler = npcHandler, text = "Meep? I mean - hello! Sorry, |PLAYERNAME|... Being a {rat} has kind of grown on me."})

npcHandler:setMessage(MESSAGE_GREET, "Meep? I mean - hello! Sorry, |PLAYERNAME|... Being a {rat} has kind of grown on me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Meep!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Meep!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())