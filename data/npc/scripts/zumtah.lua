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

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 352})
condition:setTicks(-1)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "exit") then
		if player:getStorageValue(Storage.WrathoftheEmperor.ZumtahStatus) ~= 1 then
			if npcHandler.topic[cid] < 1 then
				npcHandler:say("Oh of course, may I show you around a bit before? You want to go straight to the exit? Would you please follow me. Oh right, I am terribly sorry but THERE IS NONE. Will you finally give it up please?", cid)
				npcHandler.topic[cid] = 1
			elseif npcHandler.topic[cid] == 3 then
				npcHandler.topic[cid] = 4
			elseif npcHandler.topic[cid] == 6 then
				npcHandler.topic[cid] = 7
			elseif npcHandler.topic[cid] == 10 then
				npcHandler:say("Oh, you mean - if I have ever been out of here in those 278 years? Well, I - I can't remember. No, I can't remember. Sorry.", cid)
				npcHandler.topic[cid] = 11
			elseif npcHandler.topic[cid] == 11 then
				npcHandler:say("No, I really can't remember. I enjoyed my stay here so much that I forgot how it looks outside of this hole. Outside. The air, the sky, the light. Oh well... well.", cid)
				npcHandler.topic[cid] = 12
			elseif npcHandler.topic[cid] == 12 then
				npcHandler:say("Oh yes, yes. I... I never really thought about how you creatures feel in here I guess. I... just watched all these beings die here. ...", cid)
				npcHandler.topic[cid] = 13
			elseif npcHandler.topic[cid] == 13 then
				npcHandler:say("Oh, excuse me of course, you... wanted to go. Like all... the others. I am sorry, so sorry. You... you can leave. Yes. You can go. You are free. I shall stay here and help every poor soul which ever gets thrown in here from this day onward. ...", cid)
				npcHandler.topic[cid] = 14
			elseif npcHandler.topic[cid] == 14 then
				npcHandler:say({
					"Alright, as I said you are free now. There will not be an outside for the next three centuries, but you - go. ...",
					"Oh and I recovered the strange crate you where hiding in, it will wait for you at the exit since you can't carry it as... a beetle, muhaha. Yes, you shall now crawl through the passage as a beetle. There you go."
				}, cid)
				npcHandler.topic[cid] = 0
				player:setStorageValue(Storage.WrathoftheEmperor.ZumtahStatus, 1)
				player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
				player:addCondition(condition)
			end
		else
			npcHandler:say("It's you, why did they throw you in here again? Anyway, I will just transform you once more. I also recovered your crate which will wait for you at the exit. There, feel free to go.", cid)
			player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 1)
			player:addCondition(condition)
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("You are starting to get on my nerves. Is this the only topic you know?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 4 then
			npcHandler.topic[cid] = 5
		elseif npcHandler.topic[cid] == 7 then
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Pesky, persistent human.", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 5 then
			npcHandler.topic[cid] = 6
		elseif npcHandler.topic[cid] == 8 then
			npcHandler:say("Muhahaha. Then I will give you a test. How many years do you think have I been here? {89}, {164} or {278}?", cid)
			npcHandler.topic[cid] = 9
		end
	elseif msgcontains(msg, "278") and npcHandler.topic[cid] == 9 then
		npcHandler:say("Correct human, and that is not nearly how high you would need to count to tell all the lost souls I've seen dying here. I AM PERPETUAL. Muahahaha.", cid)
		npcHandler.topic[cid] = 10
	elseif (msgcontains(msg, "164") or msgcontains(msg, "89")) and npcHandler.topic[cid] == 9 then
		npcHandler:say("Wrong answer human! Muahahaha.", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
