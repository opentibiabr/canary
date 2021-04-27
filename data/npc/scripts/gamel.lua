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

local voices = { {text = 'Pssst!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.SecretService.AVINMission01) == 1 and player:getItemCount(14326) > 0 then
		player:setStorageValue(Storage.SecretService.AVINMission01, 2)
		npcHandler:say("I don't like the way you look. Help me boys!", cid)
		for i = 1, 2 do
			Game.createMonster("Bandit", Npc():getPosition())
		end
		npcHandler.topic[cid] = 0
	else
		npcHandler:setMessage(MESSAGE_GREET, "Pssst! Be silent. Do you wish to {buy} something?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, "letter") then
		if player:getStorageValue(Storage.SecretService.AVINMission01) == 2 then
			npcHandler:say("You have a letter for me?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:removeItem(14326, 1) then
				player:setStorageValue(Storage.SecretService.AVINMission01, 3)
				npcHandler:say("Oh well. I guess I am still on the hook. Tell your 'uncle' I will proceed as he suggested.", cid)
			else
				npcHandler:say("You don't have any letter!", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye. Tell others about... my little shop here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye. Tell others about... my little shop here.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
