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
	if isInArray({"enchanted chicken wing", "boots of haste", "Enchanted Chicken Wing", "Boots of Haste"}, msg) then
		npcHandler:say('Do you want to trade Boots of haste for Enchanted Chicken Wing?', cid)
		npcHandler.topic[cid] = 1
	elseif isInArray({"warrior sweat", "warrior helmet", "Warrior Sweat", "Warrior Helmet"}, msg) then
		npcHandler:say('Do you want to trade 4 Warrior Helmet for Warrior Sweat?', cid)
		npcHandler.topic[cid] = 2
	elseif isInArray({"fighting spirit", "royal helmet", "Fighting Spirit", "Royal Helmet"}, msg) then
		npcHandler:say('Do you want to trade 2 Royal Helmet for Fighting Spirit', cid)
		npcHandler.topic[cid] = 3
	elseif isInArray({"magic sulphur", "fire sword", "Magic Sulphur", "Fire Sword"}, msg) then
		npcHandler:say('Do you want to trade 3 Fire Sword for Magic Sulphur', cid)
		npcHandler.topic[cid] = 4
	elseif isInArray({"job", "items", "Items", "Job"}, msg) then
		npcHandler:say('I trade Enchanted Chicken Wing for Boots of Haste, Warrior Sweat for 4 Warrior Helmets, Fighting Spirit for 2 Royal Helmet Magic Sulphur for 3 Fire Swords', cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.Djinn) ~= 1 then
			npcHandler:say('You brought cookies! How nice of you! Can I have one?', cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg,'yes') then
		if npcHandler.topic[cid] >= 1 and npcHandler.topic[cid] <= 4 then
			local trade = {
					{ NeedItem = 2195, Ncount = 1, GiveItem = 5891, Gcount = 1}, -- Enchanted Chicken Wing
					{ NeedItem = 2475, Ncount = 4, GiveItem = 5885, Gcount = 1}, -- Flask of Warrior's Sweat
					{ NeedItem = 2498, Ncount = 2, GiveItem = 5884, Gcount = 1}, -- Spirit Container
					{ NeedItem = 2392, Ncount = 3, GiveItem = 5904, Gcount = 1}  -- Magic Sulphur
			}
			if player:getItemCount(trade[npcHandler.topic[cid]].NeedItem) >= trade[npcHandler.topic[cid]].Ncount then
				player:removeItem(trade[npcHandler.topic[cid]].NeedItem, trade[npcHandler.topic[cid]].Ncount)
				player:addItem(trade[npcHandler.topic[cid]].GiveItem, trade[npcHandler.topic[cid]].Gcount)
				return npcHandler:say('Here you are.', cid)
			else
				npcHandler:say('Sorry but you don\'t have the item.', cid)
			end
		elseif npcHandler.topic[cid] == 5 then
			if not player:removeItem(8111, 1) then
				npcHandler:say('You have no cookie that I\'d like.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.Djinn, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('You see, good deeds like this will ... YOU ... YOU SPAWN OF EVIL! I WILL MAKE SURE THE MASTER LEARNS ABOUT THIS!', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg,'no') then
		if npcHandler.topic[cid] >= 1 and npcHandler.topic[cid] <= 4 then
			npcHandler:say('Ok then.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			npcHandler:say('I see.', cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

local function onTradeRequest(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		npcHandler:say('I\'m sorry, but you don\'t have Malor\'s permission to trade with me.', cid)
		return false
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, human |PLAYERNAME|. How can a humble djinn be of service?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, human.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")
npcHandler:setMessage(MESSAGE_SENDTRADE, 'At your service, just browse through my wares.')

npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
