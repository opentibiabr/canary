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
		if player:getStorageValue(Storage.HiddenCityOfBeregar.GoingDown) < 1 then
			npcHandler:say("Hmmmm, you could indeed help me. See this mechanism? Some son of a rotworm put WAY too much stuff on this elevator and now it's broken. I need 3 gear wheels to fix it. You think you could get them for me?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.GoingDown) == 1 and player:removeItem(9690, 3) then
			player:setStorageValue(Storage.HiddenCityOfBeregar.GoingDown, 2)
			npcHandler:say("HOLY MOTHER OF ALL ROTWORMS! You did it and they are of even better quality than the old ones. You should be the first one to try the elevator, just jump on it. See you my friend.", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.GoingDown, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			npcHandler:say("That would be great! Maybe a blacksmith can forge you some. Come back when you got them and ask me about your mission.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "tunnel") then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) == 1 then
			npcHandler:say({
				"There should be a book in our library about tunnelling. I don't have that much time to talk to you about that. ...",
				"The book about tunnelling is in the library which is located in the north eastern wing of Beregar city."
			}, cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "Who are you? Are you a genius in mechanics? You don't look like one.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
