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

local config = {
	[VOCATION.CLIENT_ID.SORCERER] = "S O R C E R E R",
	[VOCATION.CLIENT_ID.DRUID] = "D R U I D",
	[VOCATION.CLIENT_ID.PALADIN] = "P A L A D I N",
	[VOCATION.CLIENT_ID.KNIGHT] = "K N I G H T"
}

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Hello " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "beautiful lady" or "handsome gentleman") .. ", welcome to the atrium of Pumin's Domain. We require some information from you before we can let you pass. Where do you want to go?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local vocation = player:getVocation()
	local vocationId = vocation:getId()
	local vocationClientId = vocation:getClientId()

	if msgcontains(msg, "pumin") then
		if player:getStorageValue(Storage.PitsOfInferno.ThronePumin) < 1 then
			npcHandler:say("I'm not sure if you know what you are doing but anyway. Your name is?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, player:getName()) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Alright |PLAYERNAME|. Vocation?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, Vocation(vocationId):getName()) then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say(config[vocationClientId] .. ", is that right?! What do you want from me?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "356") then
		if npcHandler.topic[cid] == 3 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 2)
			npcHandler:say("Sorry, you need Form 145 to get Form 356. Come back when you have it", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 7 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 8)
			npcHandler:say("You are better than I thought! Congratulations, here you are: Form 356!", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
