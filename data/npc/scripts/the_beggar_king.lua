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
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.DarkTrails.Mission01) == 2 and player:getStorageValue(Storage.DarkTrails.Mission02) == 1 then
			npcHandler:say("So I guess you are the one that the magistrate is sending to look after us, eh? ", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say("You need some quests then come and talk with me again.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			selfSay("Fine. But the first thing you have to know is that we are not the city's problem. We are just trying to survive. We usually seek shelter in the sewers.", cid)
			selfSay("There we are comparatively warm and safe. At least we were. But recently something has changed. There is {something} in the sewers. And it is hunting us.", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "something") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Yeah. No one has seen it and lived to tell the tale. People are missing and sometimes there are {traces} of blood or someone heard a scream, but that's all. We have no idea if the killer is a man or a beast, but there is something out there", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "traces") then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say("Some of the more daring of us tried to follow the tracks that were left, but they always lost the trail close to the {abandoned sewers}, in the east of the sewer system.", cid)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "abandoned sewers") then
		if npcHandler.topic[cid] == 4 then
			npcHandler:say({
				"Some parts of the sewers were abandoned when they were beyond repair due to old age and earthquakes. ...",
				"That part was never truly well liked. There were rumours that the workers found some ancient structures there and that it was ripe with accidents during the construction. ...",
				"The city sealed those parts off, and I have no idea how anything could get in or out without the permission of the magistrate. ... ",
				"But since you are investigating on their behalf, you might work out some agreement with them, if you're mad enough to enter the sewers at all. ... ",
				"However, you will have to talk to one of the Glooth Brothers who are responsible for the sewer system's maintenance. You'll find them somewhere down there."
			}, cid, false, true, 10)
			player:setStorageValue(Storage.DarkTrails.Mission02, 2) -- Mission 2 end
			player:setStorageValue(Storage.DarkTrails.Mission03, 1) -- Mission 3 start
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi! You look like someone on a {mission}.")
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye!') -- Need revision

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
