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

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local player = Player(cid)
	if(msgcontains(msg, "nargor")) then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToNargor) == 1 then
			npcHandler:say("Do you want to sail Nargor for 50 gold coins?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			if player:getStorageValue(Storage.TheShatteredIsles.AccessToNargor) == 1 then
				if player:removeMoneyNpc(50) then
					npcHandler:say("Set the sails!", cid)
					player:teleportTo(Position(32024, 32813, 7))
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					npcHandler.topic[cid] = 0
				end
			end
		end
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = 'Do you want to sail ' .. keyword:titleCase() .. ' for |TRAVELCOST|?',
			cost = cost, discount = 'postman'
		}
	)
	travelKeyword:addChildKeyword({'yes'}, StdModule.travel,
		{
			npcHandler = npcHandler,
			premium = false,
			cost = cost,
			discount = 'postman',
			destination = destination
		}
	)
	travelKeyword:addChildKeyword({'no'}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = 'We would like to serve you some time.',
			reset = true
		}
	)
end

addTravelKeyword('liberty bay', 50, Position(32316, 32702, 7))

-- Basic
keywordHandler:addKeyword({'passage'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Where do you want to go? To {Liberty bay} or to {Nargor}?'
		}
	)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{npcHandler = npcHandler,
	text = 'I am the captain of this ship.'
	}
)
keywordHandler:addKeyword({'captain'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I am the captain of this ship.'
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Greetings, daring adventurer. If you need a {passage}, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
