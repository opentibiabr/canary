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

	if msgcontains(msg, "nokmir") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 2 then
			npcHandler:say("Oh well, I liked Nokmir. He used to be a good dwarf until that day on which he stole the ring from {Rerun}.", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "rerun") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 3)
			npcHandler:say("Yeah, he's the lucky guy in this whole story. I heard rumours that emperor Rehal had plans to promote Nokmir, but after this whole thievery story, he might pick Rerun instead.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard) < 1 then
			npcHandler:say("Got any dwarven brown ale?? I DON'T THINK SO....and Bolfana, the tavern keeper, won't sell you anything. I'm sure about that...she doesn't like humans... I tell you what, if you get me a cask of dwarven brown ale, I allow you to enter the mine. Alright?", cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard) == 1 and player:removeItem(9689, 1) then
			player:setStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard, 2)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DoorSouthMine, 1)
			npcHandler:say("HOW?....WHERE?....AHHHH, I don't mind....SLUUUUUURP....tastes a little flat but I had worse. Thank you. Just don't tell anyone that I let you in.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.TheGoodGuard, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("Haha, fine! Don't waste time and get me the ale. See you.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "STOP RIGHT THERE!..... Oh, just a human. What's up big guy?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
