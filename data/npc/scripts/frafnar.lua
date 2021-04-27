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
		if player:getStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake) < 1 then
			npcHandler:say("There is indeed something you could do for me. You must know, I'm in love with Bolfana. I'm sure she'd have a beer with me if I got her a chocolate cake. Problem is that I can't leave this door as I'm on duty. Would you be so kind and help me?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake) == 2 then
			npcHandler:say("So did you tell her that the cake came from me?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("Great! She works in the tavern of Beregar. It's situated in the western part of the city. Bring her a chocolate cake and tell her that it was me who sent it.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.SweetAsChocolateCake, 3)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DoorWestMine, 1)
		npcHandler:say("Great! That's my breakthrough. Now she can't refuse to go out with me. I grant you access to the western part of the mine.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Don't you see that I'm trying to write a poem? <sighs> So what's the matter?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
