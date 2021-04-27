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

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 or player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) > 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Whatcha do in my place?")
	elseif player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 2 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
		npcHandler:setMessage(MESSAGE_GREET, "You back. You know, you right. Brother is right. Fist not always good. Tell him that!")
		player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 3)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	-- PREQUEST
	if msgcontains(msg, "mine") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 then
			npcHandler:say("YOURS? WHAT IS YOURS! NOTHING IS YOURS! IS MINE! GO AWAY, YES?!", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("YOU STUPID! STUBBORN! I KILL YOU! WILL LEAVE NOW?!", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("ARRRRRRRRRR! YOU ME DRIVE MAD! HOW I MAKE YOU GO??", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("I GIVE YOU NO!", cid)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "please") then
		if npcHandler.topic[cid] == 4 then
			npcHandler:say("Please? What you mean please? Like I say please you say bye? Please?", cid)
			npcHandler.topic[cid] = 5
		end
	-- OUTFIT
	elseif msgcontains(msg, "gelagos") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 4 then
			npcHandler:say("Annoying kid. Bro hates him, but talking no help. Bro needs {fighting spirit}!", cid)
			npcHandler.topic[cid] = 6
		end
	elseif msgcontains(msg, "fighting spirit") then
		if npcHandler.topic[cid] == 6 then
			npcHandler:say("If you want to help bro, bring him fighting spirit. Magic fighting spirit. Ask Djinn.", cid)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 5)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "present") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 11 then
			npcHandler:say("Bron gave me present. Ugly, but nice from him. Me want to give present too. You help me?", cid)
			npcHandler.topic[cid] = 6
		end
	elseif msgcontains(msg, "ore") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 12 then
			npcHandler:say("You bring 100 iron ore?", cid)
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "iron") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 13 then
			npcHandler:say("You bring crude iron?", cid)
			npcHandler.topic[cid] = 9
		end
	elseif msgcontains(msg, "fangs") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 14 then
			npcHandler:say("You bring 50 behemoth fangs?", cid)
			npcHandler.topic[cid] = 10
		end
	elseif msgcontains(msg, "leather") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 15 then
			npcHandler:say("You bring 50 lizard leather?", cid)
			npcHandler.topic[cid] = 11
		end
	elseif msgcontains(msg, "axe") then
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 16 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
			npcHandler:say("Axe is done! For you. Take. Wear like me.", cid)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 17)
			player:addOutfitAddon(147, 1)
			player:addOutfitAddon(143, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:addAchievement('Brutal Politeness')
		else
			npcHandler:say("Axe is not done yet!", cid)
		end
	-- OUTFIT
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 5 then
			npcHandler:say("Oh. Easy. Okay. Please is good. Now don't say anything. Head aches. ", cid)
			local condition = Condition(CONDITION_FIRE)
			condition:setParameter(CONDITION_PARAM_DELAYED, 1)
			condition:addDamage(10, 2000, -10)
			player:addCondition(condition)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 2)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 60 * 60) -- 1 hour
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif npcHandler.topic[cid] == 6 then
			npcHandler:say({
				"Good! Me make shiny weapon. If you help me, I make one for you too. Like axe I wear. I need stuff. Listen. ...",
				"Me need 100 iron ore. Then need crude iron. Then after that 50 behemoth fangs. And 50 lizard leather. You understand?",
				"Help me yes or no?"
			}, cid)
			npcHandler.topic[cid] = 7
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say("Good. You get 100 iron ore first. Come back.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 12)
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(5880, 100) then
				npcHandler:say("Good! Now bring crude iron.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 13)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 9 then
			if player:removeItem(5892, 1) then
				npcHandler:say("Good! Now bring 50 behemoth fangs.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 14)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 10 then
			if player:removeItem(5893, 50) then
				npcHandler:say("Good! Now bring 50 lizard leather.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 15)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 11 then
			if player:removeItem(5876, 50) then
				npcHandler:say("Ah! All stuff there. I will start making axes now. Come later and ask me for axe.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 16)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 2 * 60 * 60) -- 2 hours
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
