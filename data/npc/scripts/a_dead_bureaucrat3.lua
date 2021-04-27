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

local voices = {
	{ text = 'Now where did I put that form?' },
	{ text = 'Hail Pumin. Yes, hail.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Hello " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "beautiful lady" or "handsome gentleman") .. ", welcome to the atrium of Pumin's Domain. We require some information from you before we can let you pass. Where do you want to go?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local vocation = Vocation(player:getVocation():getBase():getId())

	if msgcontains(msg, "pumin") then
		if player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 2 then
			npcHandler:say("Tell me if you liked it when you come back. What is your name?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, player:getName()) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Alright |PLAYERNAME|. Vocation?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, vocation:getName()) then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("I was a " .. vocation:getName() .. ", too, before I died!! What do you want from me?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "145") then
		if npcHandler.topic[cid] == 3 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 3)
			npcHandler:say("That's right, you can get Form 145 from me. However, I need Form 411 first. Come back when you have it.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 6 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 7)
			npcHandler:say("Well done! You have form 411!! Here is Form 145. Have fun with it.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
