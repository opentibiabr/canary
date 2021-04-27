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

--Feito por Master Viciado 18/08/2016

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Greetings, " .. Player(cid):getName() .. ". Well, we all know what time it is. Always when we meet, the citizens of rathleton voted for the {Glooth Fairy}! ... Well, the rules are as simples as always. Ask me for a {fight} and I\'ll teleport you into the room with the lever, therefore I\'ll charge one voting right. ... From this room there is no way back to me. Pull the trigger and after one minute you and your buddies will face the {Glooth Fairy}.", cid)
	npcHandler.topic[cid] = 0
	return true
end

local function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	if(msgcontains(msg, "fight")) then
		npcHandler:say("Do you really want to enter the Glooth Fairy\'s hideout. There is no chickening out and I also have to charge one voting right! {Yes} or {no}?", cid)
			npcHandler.topic[cid] = 1
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("Here you go!", cid)
			local pos = {x=33660, y=31936, z=9}
			doTeleportThing(cid, pos)
			doSendMagicEffect(pos, CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
		end
	elseif(msgcontains(msg, "no")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("Okay...", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Come back soon.')
npcHandler:setMessage(MESSAGE_WALKAWAY, '')
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
