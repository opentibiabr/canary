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
	if msgcontains(msg, "key") then
		if player:getStorageValue(Storage.Quest.Dawnport.TheDormKey) == 1 then
			npcHandler:say("Me not give key! Key my precious now! \z
				By old goblin law all that one has in his pockets for two days is family heirloom! \z
				Me no part with my precious ... hm unless you provide Woblin with some {reward}!", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "reward") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Me good angler but one fish eludes me since many many weeks. I call fish ''Old Nasty''. \z
				You might catch him in this cave, in that pond there. Bring me Old Nasty and I'll give you key!", cid)
			player:setStorageValue(Storage.Quest.Dawnport.TheDormKey, 2)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "old nasty") then
		if player:getStorageValue(Storage.Quest.Dawnport.TheDormKey) == 3 and player:getItemCount(23773) >= 1 then
			npcHandler:say("You bring me Old Nasty?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Wonderful. I don't believe you will find Dormovo alive, though. \z
				He would not have stayed abroad that long without refilling his inkpot for his research notes. \z
				But at least the amulet should be retrieved.", cid)
			player:removeItem(23773, 1)
			key = player:addItem(23763, 1)
			key:setActionId(103)
			player:setStorageValue(Storage.Quest.Dawnport.TheDormKey, 4)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end


keywordHandler:addKeyword({"goblins"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "No part of clan. Me prefer company of precious. Or mirror image. Always nice to see pretty me!"
    }
)
keywordHandler:addKeyword({"quest"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "What you on quest for? Go leave Woblin alone with {precious}"
    }
)
keywordHandler:addKeyword({"precious"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Me not give {key}! Key my precious now! By old goblin law all that one has in his pockets for two days \z
			is family heirloom! Me no part with my precious ... hm unless you provide Woblin with some {reward}!"
    }
)

npcHandler:setMessage(MESSAGE_GREET, "Hi there human!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
