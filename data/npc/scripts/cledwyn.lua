local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

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

local shop = {
	{id=25177, buy=100, sell=0, name='earthheart cuirass'},
	{id=25178, buy=100, sell=0, name='earthheart hauberk'},
	{id=25179, buy=100, sell=0, name='earthheart platemail'},
	{id=25191, buy=100, sell=0, name='earthmind raiment'},
	{id=25187, buy=100, sell=0, name='earthsoul tabard'},
	{id=25174, buy=100, sell=0, name='fireheart cuirass'},
	{id=25175, buy=100, sell=0, name='fireheart hauberk'},
	{id=25176, buy=100, sell=0, name='fireheart platemail'},
	{id=25190, buy=100, sell=0, name='firemind raiment'},
	{id=25186, buy=100, sell=0, name='firesoul tabard'},
	{id=25183, buy=100, sell=0, name='frostheart cuirass'},
	{id=25184, buy=100, sell=0, name='frostheart hauberk'},
	{id=25185, buy=100, sell=0, name='frostheart platemail'},
	{id=25193, buy=100, sell=0, name='frostmind raiment'},
	{id=25189, buy=100, sell=0, name='frostsoul tabard'},
	{id=40398, buy=1, sell=0, name='magic shield potion'},
	{id=25180, buy=100, sell=0, name='thunderheart cuirass'},
	{id=25181, buy=100, sell=0, name='thunderheart hauberk'},
	{id=25182, buy=100, sell=0, name='thunderheart platemail'},
	{id=25192, buy=100, sell=0, name='thundermind raiment'},
	{id=25188, buy=100, sell=0, name='thundersoul tabard'},
}

local function setNewTradeTable(table)
	local items, item = {}
	for i = 1, #table do
		item = table[i]
		items[item.id] = {id = item.id, buy = item.buy, sell = item.sell, subType = 0, name = item.name}
	end
	return items
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	local itemsTable = setNewTradeTable(shop)
	if not ignoreCap and player:getFreeCapacity() < ItemType(itemsTable[item].id):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough cap.")
	end
	if itemsTable[item].buy then
		if player:removeItem(Npc():getCurrency(), amount * itemsTable[item].buy) then
			if amount > 1 then
				currencyName = ItemType(Npc():getCurrency()):getPluralName():lower()
			else
				currencyName = ItemType(Npc():getCurrency()):getName():lower()
			end
			player:addItem(itemsTable[item].id, amount)
			return player:sendTextMessage(MESSAGE_TRADE,
						"Bought "..amount.."x "..itemsTable[item].name.." for "..itemsTable[item].buy * amount.." "..currencyName..".")
		else
			return player:sendTextMessage(MESSAGE_FAILURE, "You don't have enough "..currencyName..".")
		end
	end

	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	return true
end

local chargeItem = {
	['pendulet'] = {noChargeID = 34067, ChargeID = 34983},
	['sleep shawl'] = {noChargeID = 34066, ChargeID = 34981},
	['blister ring'] = {noChargeID = 36392, ChargeID = 36456},
	['theurgic amulet'] = {noChargeID = 35236, ChargeID = 35238},
	['ring of souls'] = {noChargeID = 37456, ChargeID = 37471}
}

local function greetCallback(cid)
    return true
end

local voices = {
	{ text = 'Trading tokens! First-class bargains!' },
	{ text = 'Bespoke armor for all vocations! For the cost of some tokens only!' },
	{ text = 'Tokens! Bring your tokens!' }
}

npcHandler:addModule(VoiceModule:new(voices))

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if not player then
		return false
	end
	if msgcontains(msg, 'token') or msgcontains(msg, 'tokens') then
		npcHandler:say("If you have any {silver} tokens with you, let's have a look! Maybe I can offer you something in exchange.", cid)
	elseif msgcontains(msg, 'information') then
		npcHandler:say("With pleasure. <bows> I trade {token}s. There are several ways to obtain the {token}s I am interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items.", cid)
	elseif msgcontains(msg, 'talk') then
		npcHandler:say({"Why, certainly! I'm always up for some small talk. ...",
                         "The weather continues just fine here, don't you think? Just the day for a little walk around the town! ...",
                         "Actually, I haven't been around much yet, but I'm looking forward to exploring the city once I've finished trading {token}s."}, cid)
	elseif msgcontains(msg, 'silver') then
		openShopWindow(cid, shop, onBuy, onSell)
		npcHandler:say({"Here's the deal, " .. player:getName() .. ". For 100 of your silver tokens, I can offer you some first-class torso armor. These armors provide a solid boost to your main attack skill, as well as ...",
		"some elemental protection of your choice! I also sell a magic shield potion for one silver token. So these are my offers."}, cid)
	elseif msgcontains(msg, 'enchant') then
		npcHandler:say("The following items can be enchanted: {pendulet}, {sleep shawl}, {blister ring}, {theurgic amulet}. Make you choice!", cid)
		npcHandler.topic[cid] = 1
	elseif isInArray({'pendulet', 'sleep shawl', 'blister ring', 'theurgic amulet'}, msg:lower()) and npcHandler.topic[cid] == 1 then
		npcHandler:say("Should I enchant the item pendulet for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?", cid)
		charge = msg:lower()
		npcHandler.topic[cid] = 2
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			if not chargeItem[charge] then
				npcHandler:say("Sorry, you don't have an unenchanted ".. charge ..".",cid)
			else
				if (player:getItemCount(Npc():getCurrency()) >= 2) and (player:getItemCount(chargeItem[charge].noChargeID) >= 1) then
					player:removeItem(Npc():getCurrency(), 2)
					player:removeItem(chargeItem[charge].noChargeID, 1)
					local itemAdd = player:addItem(chargeItem[charge].ChargeID, 1)
					npcHandler:say("Ah, excellent. Here is your " .. itemAdd:getName():lower() .. ".", cid)
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(Npc():getCurrency()):getPluralName():lower() .." and it's a deal.", cid)
				end
				npcHandler.topic[cid] = 0
			end
		elseif msgcontains(msg, 'no') then
			npcHandler:say("Alright, come back if you have changed your mind.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'addon') then
		if player:hasOutfit(846, 0) or player:hasOutfit(845, 0) then
			npcHandler:say("Ah, very good. Now choose your addon: {first} or {second}.", cid)
			npcHandler.topic[cid] = 3
		else
			npcHandler:say("Sorry, friend, but one good turn deserves another. You need to obtain the rift warrior outfit first.", cid)
		end
	elseif isInArray({'first', 'second'}, msg:lower()) and npcHandler.topic[cid] == 3 then
		if msg:lower() == 'first' then
			if not(player:hasOutfit(846, 1)) and not(player:hasOutfit(845, 1)) then
				if player:removeItem(25172, 100) then
					npcHandler:say("Ah, excellent. Obtain the first addon for your rift warrior outfit.", cid)
					player:addOutfitAddon(846, 1)
					player:addOutfitAddon(845, 1)
					if (player:hasOutfit(846, 1) or player:hasOutfit(845, 1)) and (player:hasOutfit(846, 2) or player:hasOutfit(845, 2)) then
						player:addAchievement("Rift Warrior")
					end
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(Npc():getCurrency()):getPluralName():lower() .." and it's a deal.", cid)
				end
			else
				npcHandler:say("Sorry, friend, you already have the first Rift Warrior addon.", cid)
			end
		elseif msg:lower() == 'second' then
			if not(player:hasOutfit(846, 2)) and not(player:hasOutfit(845, 2)) then
				if player:removeItem(25172, 100) then
					npcHandler:say("Ah, excellent. Obtain the second addon for your rift warrior outfit.", cid)
					player:addOutfitAddon(846, 2)
					player:addOutfitAddon(845, 2)
					if (player:hasOutfit(846, 1) or player:hasOutfit(845, 1)) and (player:hasOutfit(846, 2) or player:hasOutfit(845, 2)) then
						player:addAchievement("Rift Warrior")
					end
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(Npc():getCurrency()):getPluralName():lower() .." and it's a deal.", cid)
				end
			else
				npcHandler:say("Sorry, friend, you already have the second Rift Warrior addon.", cid)
			end
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
