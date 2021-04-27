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
	{ text = "Alms! Alms for the poor!" },
	{ text = "Sir, Ma'am, have a gold coin to spare?" },
	{ text = "I need help! Please help me!" }
}

npcHandler:addModule(VoiceModule:new(voices))

-- Trade buy window
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addBuyableItem({"shovel"}, 2554, 50, 1)

-- First beggar addon
local function BeggarFirst(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if player:isPremium() then
		if player:getStorageValue(Storage.OutfitQuest.BeggarFirstAddonDoor) == -1 then
			if player:getItemCount(5883) >= 100 and player:getMoney() + player:getBankBalance() >= 20000 then
				if player:removeItem(5883, 100) and player:removeMoneyNpc(20000) then
					npcHandler:say("Ah, right! The beggar beard or beggar dress! Here you go.", cid)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					player:setStorageValue(Storage.OutfitQuest.BeggarFirstAddonDoor, 1)
					player:addOutfitAddon(153, 1)
					player:addOutfitAddon(157, 1)
				end
			else
				npcHandler:say("You do not have all the required items.", cid)
			end
		else
			npcHandler:say("It seems you already have this addon, don't you try to mock me son!", cid)
		end
	end
end

-- Second beggar addon
local function BeggarSecond(cid, message, keywords, parameters, node)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if player:isPremium() then
		if player:getStorageValue(Storage.OutfitQuest.BeggarSecondAddon) == -1 then
			if player:getItemCount(6107) >= 1 then
				if player:removeItem(6107, 1) then
					npcHandler:say("Ah, right! The beggar staff! Here you go.", cid)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
					player:setStorageValue(Storage.OutfitQuest.BeggarSecondAddon, 1)
					player:addOutfitAddon(153, 2)
					player:addOutfitAddon(157, 2)
				end
			else
				npcHandler:say("You do not have all the required items.", cid)
			end
		else
			npcHandler:say("It seems you already have this addon, don't you try to mock me son!", cid)
		end
	end
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "cookie") then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.SimonTheBeggar) ~= 1 then
			npcHandler:say("Have you brought a cookie for the poor?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "help") then
		npcHandler:say("I need gold. Can you spare 100 gold pieces for me?", cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if not player:removeItem(8111, 1) then
				npcHandler:say("You have no cookie that I'd like.", cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.SimonTheBeggar, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say("Well, it's the least you can do for those who live in dire poverty. \z
						A single cookie is a bit less than I'd expected, but better than ... WHA ... WHAT?? \z
						MY BEARD! MY PRECIOUS BEARD! IT WILL TAKE AGES TO CLEAR IT OF THIS CONFETTI!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif npcHandler.topic[cid] == 2 then
			if not player:removeMoneyNpc(100) then
				npcHandler:say("You haven't got enough money for me.", cid)
				npcHandler.topic[cid] = 0
				return true
			end

			npcHandler:say("Thank you very much. Can you spare 500 more gold pieces for me? I will give you a nice hint.", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			if not player:removeMoneyNpc(500) then
				npcHandler:say("Sorry, that's not enough.", cid)
				npcHandler.topic[cid] = 0
				return true
			end

			npcHandler:say("That's great! I have stolen something from Dermot. \z
						You can buy it for 200 gold. Do you want to buy it?", cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 4 then
			if not player:removeMoneyNpc(200) then
				npcHandler:say("Pah! I said 200 gold. You don't have that much.", cid)
				npcHandler.topic[cid] = 0
				return true
			end

			local key = player:addItem(2087, 1)
			if key then
				key:setActionId(3940)
			end
			npcHandler:say("Now you own the hot key.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] ~= 0 then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("I see.", cid)
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Hmm, maybe next time.", cid)
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("It was your decision.", cid)
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Ok. No problem. I'll find another buyer.", cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Node 1
node1 = keywordHandler:addKeyword({"addon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "For the small fee of 20000 gold pieces I will help you mix this potion. \z
					Just bring me 100 pieces of ape fur, which are necessary to create this potion. ... Do we have a deal?"
	}
)
node1:addChildKeyword({"yes"}, BeggarSecond, {})
node1:addChildKeyword({"no"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Alright then. Come back when you got all neccessary items.",
		reset = true
	}
)

-- Node 2
node2 = keywordHandler:addKeyword({"dress"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "For the small fee of 20000 gold pieces I will help you mix this potion. \z
					Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...Do we have a deal?"
	}
)
node2:addChildKeyword({"yes"}, BeggarFirst, {})
node2:addChildKeyword({"no"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Alright then. Come back when you got all neccessary items.",
		reset = true
	}
)

-- Node 3
node3 = keywordHandler:addKeyword({"staff"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "To get beggar staff you need to give me simon the beggar's staff. Do you have it with you?"
	}
)
node3:addChildKeyword({"yes"}, BeggarSecond, {})
node3:addChildKeyword({"no"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Alright then. Come back when you got all neccessary items.",
		reset = true
	}
)

-- Node 4
node4 = keywordHandler:addKeyword({"outfit"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "For the small fee of 20000 gold pieces I will help you mix this potion. \z
					Just bring me 100 pieces of ape fur, which are necessary to create this potion. ...Do we have a deal?"
	}
)
node4:addChildKeyword({"yes"}, BeggarFirst, {})
node4:addChildKeyword({"no"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Alright then. Come back when you got all neccessary items.",
		reset = true
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|. I am a poor man. Please help me.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
