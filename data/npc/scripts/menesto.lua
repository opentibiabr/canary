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

function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.Tutorial) < 1 then
		npcHandler:say(
			{
				"Finally, reinforcements - oh but no, you came through the crystal portal, like the others! \z
					I am ser Menesto, I guard the portal. That beast caught me by surprise, I lost my dagger and had to retreat. ...",
				"... ...",
				"Hmm. ...",
				"You look hungry, you should eat regularly to reagain your strength! \z
					See what you can find while hunting. Or buy food in a city shop. \z
					Here, have some of my rations, I'll take my dagger. Tell me when you're {ready}."
			},
		cid, false, true, 10)
		player:addItem(2666, 1)
		player:setStorageValue(Storage.Dawnport.Tutorial, 1)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "ready") then
		if player:getStorageValue(Storage.Dawnport.Tutorial) == 1 then
			npcHandler:say(
				{
					"I'll stay here till reinforcements come. Go up the ladder to reach the surface. \z
						You'll need a rope for the ropestot that comes after the ladder - here, take my spare equipment. ...",
					"And remember: Tibia is a world with many dangers and mysteries, so be careful! Farewell, friend."
				},
			cid, false, true, 10)
			player:setStorageValue(Storage.Dawnport.Tutorial, 2)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
