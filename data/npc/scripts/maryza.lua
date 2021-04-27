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

	if msgcontains(msg, 'cookbook') then
		if player:getStorageValue(Storage.MaryzaCookbook) ~= 1 then
			npcHandler:say('The cookbook of the famous dwarven kitchen. You\'re lucky. I have a few copies on sale. Do you like one for 150 gold?', cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('I\'m sorry but I sell only one copy to each customer. Otherwise they would have been sold out a long time ago.', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			if not player:removeMoneyNpc(150) then
				npcHandler:say('No gold, no sale, that\'s it.', cid)
				return true
			end

			npcHandler:say('Here you are. Happy cooking!', cid)
			player:setStorageValue(Storage.MaryzaCookbook, 1)
			player:addItem(2347, 1)
		elseif msgcontains(msg, 'no') then
			npcHandler:say('I have but a few copies, anyway.', cid)
		end
	end
	return true
end

-- Greeting message
keywordHandler:addGreetKeyword({"maryza"}, {npcHandler = npcHandler, text = "Welcome to the Jolly Axeman, |PLAYERNAME|. Have a good time and eat some food!"})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to the Jolly Axeman, |PLAYERNAME|. Have a good time and eat some food!')
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())