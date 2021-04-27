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

local playerTopic = {}
local playerLastResp = {}
local function greetCallback(cid)

	local player = Player(cid)
	if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) == 13 then
		npcHandler:setMessage(MESSAGE_GREET, "Enter answers for the following {questions}:")
		playerTopic[cid] = 1
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end
	npcHandler:addFocus(cid)
	return true
end

local quiz1 = {
	[1] = {p ="The sum of first and second digit?", r = function(player)player:setStorageValue(Storage.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.CultsOfTibia.MotA.Stone2))return player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)end},
	[2] = {p ="The sum of second and third digit?", r = function(player)player:setStorageValue(Storage.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.CultsOfTibia.MotA.Stone2) + player:getStorageValue(Storage.CultsOfTibia.MotA.Stone3))return player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)end},
	[3] = {p ="The sum of first and third digit?", r = function(player)player:setStorageValue(Storage.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.CultsOfTibia.MotA.Stone3))return player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)end},
	[4] = {p ="The digit sum?", r = function(player)player:setStorageValue(Storage.CultsOfTibia.MotA.Answer, player:getStorageValue(Storage.CultsOfTibia.MotA.Stone1) + player:getStorageValue(Storage.CultsOfTibia.MotA.Stone2) + player:getStorageValue(Storage.CultsOfTibia.MotA.Stone3))return player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)end},
}

local quiz2 = {
	[1] = {p = "Is the number prime?", r =
		function(player)
			local stg = player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)
			if stg < 1 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if(stg % i == 0)then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end
	},
	[2] = {p = "Does the number belong to a prime twing?", r =
		function(player)
			local stg = player:getStorageValue(Storage.CultsOfTibia.MotA.Answer)
			if stg < 2 then
				return 0
			end
			if stg == 1 or stg == 2 then
				return 1
			end
			local incr = 0
			for i = 1, stg do
				if(stg % i == 0)then
					incr = incr + 1
				end
			end
			return (incr == 2 and 1 or 0)
		end
	},
	-- [2] = {p = "", r = ""},
}

local quiz3 = {
	[1] = {p = "Is the number divisible by 3?", r = function(player)return (player:getStorageValue(Storage.CultsOfTibia.MotA.Answer) % 3 == 0 and 1 or 0)end},
	[2] = {p = "Is the number divisible by 2?", r = function(player)return (player:getStorageValue(Storage.CultsOfTibia.MotA.Answer) % 2 == 0 and 1 or 0)end},
}


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	npcHandler.topic[cid] = playerTopic[cid]
	local player = Player(cid)
	-- Começou a quest
	if msgcontains(msg, "questions") and npcHandler.topic[cid] == 1 then
		npcHandler:say("Ready to {start}?", cid)
		npcHandler.topic[cid] = 2
		playerTopic[cid] = 2
	elseif msgcontains(msg, "start") and npcHandler.topic[cid] == 2 then
		local perguntaid = math.random(#quiz1)
		player:setStorageValue(Storage.CultsOfTibia.MotA.QuestionId, perguntaid)
		npcHandler:say(quiz1[perguntaid].p, cid)
		npcHandler.topic[cid] = 3
		playerTopic[cid] = 3
	elseif (npcHandler.topic[cid] == 3) then
		npcHandler:say(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[cid] = tonumber(msg)
		npcHandler.topic[cid] = 4
		playerTopic[cid] = 4
	elseif (npcHandler.topic[cid] == 4) then
		if msgcontains(msg, "yes") then
			local resposta = quiz1[player:getStorageValue(Storage.CultsOfTibia.MotA.QuestionId)].r
			if playerLastResp[cid] ~= (tonumber(resposta(player))) then
				npcHandler:say("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				npcHandler:say("Correct. {Next} question?", cid)
				npcHandler.topic[cid] = 5
				playerTopic[cid] = 5
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif msgcontains(msg, "next") and npcHandler.topic[cid] == 5 then
		local perguntaid = math.random(#quiz2)
		player:setStorageValue(Storage.CultsOfTibia.MotA.QuestionId, perguntaid)
		npcHandler:say(quiz2[perguntaid].p, cid)
		npcHandler.topic[cid] = 6
		playerTopic[cid] = 6
	elseif npcHandler.topic[cid] == 6 then
		local resp = 0
		if msgcontains(msg, "no") then
			resp = 0
		elseif msgcontains(msg, "yes") then
			resp = 1
		end
		local resposta = quiz2[player:getStorageValue(Storage.CultsOfTibia.MotA.QuestionId)].r
		if resp == resposta(player) then
			npcHandler:say("Correct. {Next} question?", cid)
			npcHandler.topic[cid] = 7
			playerTopic[cid] = 7
		else
			npcHandler:say("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif npcHandler.topic[cid] == 7 and msgcontains(msg, "next") then
		local perguntaid = math.random(#quiz3)
		player:setStorageValue(Storage.CultsOfTibia.MotA.QuestionId, perguntaid)
		npcHandler:say(quiz3[perguntaid].p, cid)
		npcHandler.topic[cid] = 8
		playerTopic[cid] = 8
	elseif npcHandler.topic[cid] == 8 then
		local resp = 0
		if msgcontains(msg, "no") then
			resp = 0
		elseif msgcontains(msg, "yes") then
			resp = 1
		end
		local resposta = quiz3[player:getStorageValue(Storage.CultsOfTibia.MotA.QuestionId)].r
		if resp == resposta(player) then
			npcHandler:say("Correct. {Last} question?", cid)
			npcHandler.topic[cid] = 9
			playerTopic[cid] = 9
		else
			npcHandler:say("Wrong. SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	elseif npcHandler.topic[cid] == 9 and msgcontains(msg, "last") then
		npcHandler:say("Tell me the correct number?", cid)
		npcHandler.topic[cid] = 10
		playerTopic[cid] = 10
	elseif npcHandler.topic[cid] == 10 then
		npcHandler:say(string.format("Your answer is %s, do you want to continue?", msg), cid)
		playerLastResp[cid] = tonumber(msg)
		npcHandler.topic[cid] = 11
		playerTopic[cid] = 11
	elseif npcHandler.topic[cid] == 11 then
		if msgcontains(msg, "yes") then
			local correct = string.format("%d%d%d", player:getStorageValue(Storage.CultsOfTibia.MotA.Stone1), player:getStorageValue(Storage.CultsOfTibia.MotA.Stone2), player:getStorageValue(Storage.CultsOfTibia.MotA.Stone3))
			if tonumber(playerLastResp[cid]) ~= (tonumber(correct)) then
				npcHandler:say("Wrong. SHUT DOWN.", cid)
				npcHandler:resetNpc(cid)
				npcHandler:releaseFocus(cid)
				return false
			else
				npcHandler:say("Correct. The lower door is now open. The druid of Crunor lies.", cid)
				player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) + 1)
				player:setStorageValue(Storage.CultsOfTibia.MotA.AccessDoorDenominator)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("SHUT DOWN.", cid)
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
			return false
		end
	end

	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
