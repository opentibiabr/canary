local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local shop = {
	{id=30686, buy=50, sell=0, name='axe of desctruction'},
	{id=30684, buy=50, sell=0, name='blade of desctruction'},
	{id=30690, buy=50, sell=0, name='bow of desctruction'},
	{id=30687, buy=50, sell=0, name='chopper of desctruction'},
	{id=30691, buy=50, sell=0, name='crossbow of desctruction'},
	{id=30689, buy=50, sell=0, name='hammer of desctruction'},
	{id=30688, buy=50, sell=0, name='mace of desctruction'},
	{id=30693, buy=50, sell=0, name='rod of desctruction'},
	{id=30685, buy=50, sell=0, name='slayer of desctruction'},
	{id=30692, buy=50, sell=0, name='wand of desctruction'},
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
			return player:sendTextMessage(MESSAGE_TRADE, "You don't have enough "..currencyName..".")
		end
	end

	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	return true
end

local products = {
	['strike'] = {
		['basic'] =  {
			text = "The basic bundle for the strike imbuement consists of 20 protective charms. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20},
				[2] = {id = 11228, amount = 25}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the strike imbuement consists of 20 protective charms, 25 sabreteeth and 5 vexclaw talons. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12400, amount = 20},
				[2] = {id = 11228, amount = 25},
				[3] = {id = 25384, amount = 5}
			},
			value = 6
		}
	},
	['vampirism'] = {
		['basic'] =  {
			text = "The basic bundle for the vampirism imbuement consists of 25 vampire teeth. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25},
				[2] = {id = 10550, amount = 15}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the vampirism imbuement consists of 25 vampire teeth, 15 bloody pincers and 5 pieces of dead brain. Would you like to it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 10602, amount = 25},
				[2] = {id = 10550, amount = 15},
				[3] = {id = 10580, amount = 5}
			},
			value = 6
		}
	},
	['void'] = {
		['basic'] =  {
			text = "The basic bundle for the void imbuement consists of 25 rope belts. Would you like to buy it for 2 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12448, amount = 25}
			},
			value = 2,
		},
		['intricate'] =  {
			text = "The intricate bundle for the void imbuement consists of 25 rope belts and 25 silencer claws. Would you like to buy it for 4 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?.",
			itens = {
				[1] = {id = 12448, amount = 25},
				[2] = {id = 22534, amount = 25}
			},
			value = 4,
		},
		['powerful'] = {
			text = "The powerful bundle for the void imbuement consists of 25 rope belts, 25 silencer claws and 5 grimeleech wings. Would you like to buy it for 6 ".. ItemType(Npc():getCurrency()):getPluralName():lower() .."?",
			itens = {
				[1] = {id = 12448, amount = 25},
				[2] = {id = 22534, amount = 25},
				[3] = {id = 25386, amount = 5}
			},
			value = 6,
		}
	},
}

local answerType = {}
local answerLevel = {}

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
	npcHandler.topic[cid] = 0
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, "information") then
		npcHandler:say({"{Tokens} are small objects made of metal or other materials. You can use them to buy superior equipment from token traders like me.",
						"There are several ways to obtain the tokens I'm interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items."}, cid)
	elseif msgcontains(msg, "worth") then
	-- to do: check if Heart of Destruction was killed
	-- after kill msg: 'You disrupted the Heart of Destruction, defeated the World Devourer and bought our world some time. You have proven your worth.'
	npcHandler:say({"Disrupt the Heart of Destruction, fell the World Devourer to prove your worth and you will be granted the power to imbue 'Powerful Strike', 'Powerful Void' and --'Powerful Vampirism'."}, cid)
	elseif msgcontains(msg, "tokens") then
		openShopWindow(cid, shop, onBuy, onSell)
		npcHandler:say("If you have any gold tokens with you, let's have a look! These are my offers.", cid)
	elseif msgcontains(msg, "trade") then
		npcHandler:say({"I have creature products for the imbuements {strike}, {vampirism} and {void}. Make your choice, please!"}, cid)
		npcHandler.topic[cid] = 1
	elseif npcHandler.topic[cid] == 1 then
		local imbueType = products[msg:lower()]
		if imbueType then
			npcHandler:say({"You have chosen "..msg..". {Basic}, {intricate} or {powerful}?"}, cid)
			answerType[cid] = msg
			npcHandler.topic[cid] = 2
		end
	elseif npcHandler.topic[cid] == 2 then
		local imbueLevel = products[answerType[cid]][msg:lower()]
		if imbueLevel then
			answerLevel[cid] = msg:lower()
			local neededCap = 0
			for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
				neededCap = neededCap + ItemType(products[answerType[cid]][answerLevel[cid]].itens[i].id):getWeight() * products[answerType[cid]][answerLevel[cid]].itens[i].amount
			end
			npcHandler:say({imbueLevel.text.."...", 
							"Make sure that you have ".. #products[answerType[cid]][answerLevel[cid]].itens .." free slot and that you can carry ".. string.format("%.2f",neededCap/100) .." oz in addition to that."}, cid)
			npcHandler.topic[cid] = 3
		end
	elseif npcHandler.topic[cid] == 3 then
		if msgcontains(msg, "yes") then
			local neededCap = 0
			for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
				neededCap = neededCap + ItemType(products[answerType[cid]][answerLevel[cid]].itens[i].id):getWeight() * products[answerType[cid]][answerLevel[cid]].itens[i].amount
			end
			if player:getFreeCapacity() > neededCap then
				if player:getItemCount(Npc():getCurrency()) >= products[answerType[cid]][answerLevel[cid]].value then
					for i = 1, #products[answerType[cid]][answerLevel[cid]].itens do
						player:addItem(products[answerType[cid]][answerLevel[cid]].itens[i].id, products[answerType[cid]][answerLevel[cid]].itens[i].amount)
					end
					player:removeItem(Npc():getCurrency(), products[answerType[cid]][answerLevel[cid]].value)
					npcHandler:say("There it is.", cid)
					npcHandler.topic[cid] = 0
				else
					npcHandler:say("I'm sorry but it seems you don't have enough ".. ItemType(Npc():getCurrency()):getPluralName():lower() .." yet. Bring me "..products[answerType[cid]][answerLevel[cid]].value.." of them and we'll make a trade.", cid)
				end
			else
				npcHandler:say("You don\'t have enough capacity. You must have "..neededCap.." oz.", cid)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("Your decision. Come back if you have changed your mind.",cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end



local voices = { {text = 'Trading tokens! First-class equipment available!'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
