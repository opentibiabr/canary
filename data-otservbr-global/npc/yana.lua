local internalNpcName = "Yana"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 471,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 68,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Trading tokens! First-class equipment available!'}
}

npcConfig.currency = 22721

npcConfig.shop = {
	{ name = "axe of desctruction", clientId = 27451, buy = 50 },
	{ name = "blade of desctruction", clientId = 27449, buy = 50 },
	{ name = "bow of desctruction", clientId = 27455, buy = 50 },
	{ name = "chopper of desctruction", clientId = 27452, buy = 50 },
	{ name = "crossbow of desctruction", clientId = 27456, buy = 50 },
	{ name = "hammer of desctruction", clientId = 27454, buy = 50 },
	{ name = "mace of desctruction", clientId = 27453, buy = 50 },
	{ name = "rod of desctruction", clientId = 27458, buy = 50 },
	{ name = "slayer of desctruction", clientId = 27450, buy = 50 },
	{ name = "wand of desctruction", clientId = 27457, buy = 50 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

local products = {
	['strike'] = {
		['basic'] =  {
			text = "The basic bundle for the strike imbuement consists of 20 protective charms. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = {id = 11444, amount = 20}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 gold tokens??",
			itens = {
				[1] = {id = 11444, amount = 20},
				[2] = {id = 10311, amount = 25}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the strike imbuement consists of 20 protective charms, 25 sabreteeth and 5 vexclaw talons. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = {id = 11444, amount = 20},
				[2] = {id = 10311, amount = 25},
				[3] = {id = 22728, amount = 5}
			},
			value = 6
		}
	},
	['vampirism'] = {
		['basic'] =  {
			text = "The basic bundle for the vampirism imbuement consists of 25 vampire teeth. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = {id = 9685, amount = 25}
			},
			value = 2
		},
		['intricate'] =  {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 gold tokens??",
			itens = {
				[1] = {id = 9685, amount = 25},
				[2] = {id = 9633, amount = 15}
			},
			value = 4
		},
		['powerful'] = {
			text = "The powerful bundle for the vampirism imbuement consists of 25 vampire teeth, 15 bloody pincers and 5 pieces of dead brain. Would you like to it for 6 gold tokens??",
			itens = {
				[1] = {id = 9685, amount = 25},
				[2] = {id = 9633, amount = 15},
				[3] = {id = 9663, amount = 5}
			},
			value = 6
		}
	},
	['void'] = {
		['basic'] =  {
			text = "The basic bundle for the void imbuement consists of 25 rope belts. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = {id = 11492, amount = 25}
			},
			value = 2,
		},
		['intricate'] =  {
			text = "The intricate bundle for the void imbuement consists of 25 rope belts and 25 silencer claws. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = {id = 11492, amount = 25},
				[2] = {id = 20200, amount = 25}
			},
			value = 4,
		},
		['powerful'] = {
			text = "The powerful bundle for the void imbuement consists of 25 rope belts, 25 silencer claws and 5 grimeleech wings. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = {id = 11492, amount = 25},
				[2] = {id = 20200, amount = 25},
				[3] = {id = 22730, amount = 5}
			},
			value = 6,
		}
	}
}

local answerType = {}
local answerLevel = {}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setTopic(playerId, 0)
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "information") then
		npcHandler:say({"{Tokens} are small objects made of metal or other materials. You can use them to buy superior equipment from token traders like me.",
						"There are several ways to obtain the tokens I'm interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items."}, npc, creature)
	elseif MsgContains(message, "worth") then
	-- to do: check if Heart of Destruction was killed
	-- after kill message: 'You disrupted the Heart of Destruction, defeated the World Devourer and bought our world some time. You have proven your worth.'
	npcHandler:say({"Disrupt the Heart of Destruction, fell the World Devourer to prove your worth and you will be granted the power to imbue 'Powerful Strike', 'Powerful Void' and --'Powerful Vampirism'."}, npc, creature)
	elseif MsgContains(message, "tokens") then
		npc:openShopWindow(creature)
		npcHandler:say("If you have any gold tokens with you, let's have a look! These are my offers.", npc, creature)
	elseif MsgContains(message, "trade") then
		npcHandler:say({"I have creature products for the imbuements {strike}, {vampirism} and {void}. Make your choice, please!"}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 then
		local imbueType = products[message:lower()]
		if imbueType then
			npcHandler:say({"You have chosen "..message..". {Basic}, {intricate} or {powerful}?"}, npc, creature)
			answerType[playerId] = message
			npcHandler:setTopic(playerId, 2)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		local imbueLevel = products[answerType[playerId]][message:lower()]
		if imbueLevel then
			answerLevel[playerId] = message:lower()
			local neededCap = 0
			for i = 1, #products[answerType[playerId]][answerLevel[playerId]].itens do
				neededCap = neededCap + ItemType(products[answerType[playerId]][answerLevel[playerId]].itens[i].id):getWeight() * products[answerType[playerId]][answerLevel[playerId]].itens[i].amount
			end
			npcHandler:say({imbueLevel.text.."...", 
							"Make sure that you have ".. #products[answerType[playerId]][answerLevel[playerId]].itens .." free slot and that you can carry ".. string.format("%.2f",neededCap/100) .." oz in addition to that."}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, "yes") then
			local neededCap = 0
			for i = 1, #products[answerType[playerId]][answerLevel[playerId]].itens do
				neededCap = neededCap + ItemType(products[answerType[playerId]][answerLevel[playerId]].itens[i].id):getWeight() * products[answerType[playerId]][answerLevel[playerId]].itens[i].amount
			end
			if player:getFreeCapacity() > neededCap then
				if player:getItemCount(npc:getCurrency()) >= products[answerType[playerId]][answerLevel[playerId]].value then
					for i = 1, #products[answerType[playerId]][answerLevel[playerId]].itens do
						player:addItem(products[answerType[playerId]][answerLevel[playerId]].itens[i].id, products[answerType[playerId]][answerLevel[playerId]].itens[i].amount)
					end
					player:removeItem(npc:getCurrency(), products[answerType[playerId]][answerLevel[playerId]].value)
					npcHandler:say("There it is.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("I'm sorry but it seems you don't have enough ".. ItemType(npc:getCurrency()):getPluralName():lower().." ..? yet. Bring me "..products[answerType[playerId]][answerLevel[playerId]].value.." of them and we'll make a trade.", npc, creature)
				end
			else
				npcHandler:say("You don\'t have enough capacity. You must have "..neededCap.." oz.", npc, creature)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("Your decision. Come back if you have changed your mind.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
