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
	[VOCATION.CLIENT_ID.SORCERER] = "wand",
	[VOCATION.CLIENT_ID.DRUID] = "rod",
	[VOCATION.CLIENT_ID.PALADIN] = "bow",
	[VOCATION.CLIENT_ID.KNIGHT] = "sword"
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
		if npcHandler.topic[cid] == 0 and player:getStorageValue(Storage.PitsOfInferno.ThronePumin) < 1 then
			npcHandler:say("Sure, where else. Everyone likes to meet my master, he is a great demon, isn't he? Your name is ...?", cid)
			npcHandler.topic[cid] = 1
		elseif npcHandler.topic[cid] == 3 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 1)
			npcHandler:say("How very interesting. I need to tell that to my master immediately. Please go to my colleagues and ask for Form 356. You will need it in order to proceed.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, player:getName()) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Alright |PLAYERNAME|. Vocation?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, Vocation(vocationId):getName()) then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Huhu, please don't hurt me with your " .. config[vocationClientId] .. "! Reason of your visit?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "411") then
		if player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 3 then
			npcHandler:say("Form 411? You need Form 287 to get that! Do you have it?", cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 5 then
			npcHandler:say("Form 411? You need Form 287 to get that! Do you have it?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 4 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 4)
			npcHandler:say("Oh, what a pity. Go see one of my colleagues. I give you the permission to get Form 287. Bye!", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 5 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 6)
			npcHandler:say("Great. Here you are. Form 411. Come back anytime you want to talk. Bye.", cid)
		end
	elseif msgcontains(msg, "356") then
		if player:getStorageValue(Storage.PitsOfInferno.ThronePumin) == 8 then
			player:setStorageValue(Storage.PitsOfInferno.ThronePumin, 9)
			npcHandler:say("INCREDIBLE, you did it!! Have fun at Pumin's Domain!", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
