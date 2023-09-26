local internalNpcName = "NPC BETA"
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
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}


local products = {
	["strike"] = {
		["basic"] = {
			text = "The basic bundle for the strike imbuement consists of 20 protective charms. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 11444, amount = 20 },
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 gold tokens??",
			itens = {
				[1] = { id = 11444, amount = 20 },
				[2] = { id = 10311, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the strike imbuement consists of 20 protective charms, 25 sabreteeth and 5 vexclaw talons. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 11444, amount = 20 },
				[2] = { id = 10311, amount = 25 },
				[3] = { id = 22728, amount = 5 },
			},
			value = 6,
		},
	},
	["vampirism"] = {
		["basic"] = {
			text = "The basic bundle for the vampirism imbuement consists of 25 vampire teeth. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 9685, amount = 25 },
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the strike imbuement consists of 20 protective charms and 25 sabreteeth. Would you like to buy it for 4 gold tokens??",
			itens = {
				[1] = { id = 9685, amount = 25 },
				[2] = { id = 9633, amount = 15 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the vampirism imbuement consists of 25 vampire teeth, 15 bloody pincers and 5 pieces of dead brain. Would you like to it for 6 gold tokens??",
			itens = {
				[1] = { id = 9685, amount = 25 },
				[2] = { id = 9633, amount = 15 },
				[3] = { id = 9663, amount = 5 },
			},
			value = 6,
		},
	},
	["void"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 rope belts. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 11492, amount = 25 },
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 rope belts and 25 silencer claws. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 11492, amount = 25 },
				[2] = { id = 20200, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 25 rope belts, 25 silencer claws and 5 grimeleech wings. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 11492, amount = 25 },
				[2] = { id = 20200, amount = 25 },
				[3] = { id = 22730, amount = 5 },
			},
			value = 6,
		},
	},
	["epiphany"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 elvish talismans. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 9635, amount = 25},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 elvish talismans and 15 broken shamanic staffs. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 9635, amount = 25 },
				[2] = { id = 11452, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 25 elvish talismans and 15 broken shamanic staffs and 15 strands of medusa hair. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 9635, amount = 25 },
				[2] = { id = 11452, amount = 25 },
				[3] = { id = 10309, amount = 5 },
			},
			value = 6,
		},
	},
	["axe"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 20 orc teeth. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 10196, amount = 20},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 20 orc teeth and 25 battle stones. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 10196, amount = 20 },
				[2] = { id = 11447, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 20 orc teeth and 25 battle stones and 20 moohtant horns. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 10196, amount = 20 },
				[2] = { id = 11447, amount = 25 },
				[3] = { id = 21200, amount = 20 },
			},
			value = 6,
		},
	},
	["distance"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 elven scouting glasses. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 11464, amount = 25},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 elven scouting glasses and 20 elven hoofs. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 11464, amount = 25 },
				[2] = { id = 18994, amount = 20 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 25 elven scouting glasses and 20 elven hoofs and 10 metal spikes. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 11464, amount = 20 },
				[2] = { id = 18994, amount = 20 },
				[3] = { id = 10298, amount = 10 },
			},
			value = 6,
		},
	},
	["shielding"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 20 pieces of scarab shell. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 9641, amount = 20},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 20 pieces of scarab shell and 25 brimstone shells. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 9641, amount = 20 },
				[2] = { id = 11703, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 20 pieces of scarab shell and 25 brimstone shells and 25 frazzle skins. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 9641, amount = 20 },
				[2] = { id = 11703, amount = 25 },
				[3] = { id = 20199, amount = 25 },
			},
			value = 6,
		},
	},
	["club"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 20 cyclops toes. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 9657, amount = 20},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 20 cyclops toes and 15 ogre nose rings. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 9657, amount = 20 },
				[2] = { id = 11447, amount = 15 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 20 cyclops toes and 15 ogre nose rings and 10 warmaster's wristguards. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 9657, amount = 20 },
				[2] = { id = 11447, amount = 25 },
				[3] = { id = 10405, amount = 10 },
			},
			value = 6,
		},
	},
	["sword"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 lion's mane. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 9691, amount = 25},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 lion's mane and 25 mooh'tah shells. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 9691, amount = 25 },
				[2] = { id = 21202, amount = 25 },
			},
			value = 4,
		},
		["powerful"] = {
			text = "The powerful bundle for the void imbuement consists of 25 lion's mane and 25 mooh'tah shells and 5 war crystals. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 9691, amount = 25 },
				[2] = { id = 21202, amount = 25 },
				[3] = { id = 9654, amount = 5 },
			},
			value = 6,
		},
	},
	["capacity"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 20 fairy wings. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 25694, amount = 20},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 20 fairy wings and 10 little bowls of myrrh. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 25694, amount = 20 },
				[2] = { id = 25702, amount = 10 },
			},
			value = 4,
		},
		["capacity"] = {
			text = "The powerful bundle for the void imbuement consists of 20 fairy wings and 10 little bowls of myrrh and 5 goosebump leather. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 25694, amount = 20 },
				[2] = { id = 25702, amount = 10 },
				[3] = { id = 20205, amount = 5 },
			},
			value = 6,
		},
	},
	["speed"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 15 damselfly wings. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 17458, amount = 15},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 15 damselfly wings and 25 compasses. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 17458, amount = 15 },
				[2] = { id = 10302, amount = 25 },
			},
			value = 4,
		},
		["capacity"] = {
			text = "The powerful bundle for the void imbuement consists of 15 damselfly wings and 25 compasses and 20 waspoid wings. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 25694, amount = 15 },
				[2] = { id = 10302, amount = 25 },
				[3] = { id = 14081, amount = 20 },
			},
			value = 6,
		},
	},
	["death protection"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 flasks of embalming fluid. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 11466, amount = 25},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 flasks of embalming fluid and 20 gloom wolf furs. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 11466, amount = 25 },
				[2] = { id = 22007, amount = 20 },
			},
			value = 4,
		},
		["capacity"] = {
			text = "The powerful bundle for the void imbuement consists of 25 flasks of embalming fluid and 20 gloom wolf furs and 5 mystical hourglasses. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 11466, amount = 25 },
				[2] = { id = 22007, amount = 20 },
				[3] = { id = 9660, amount = 5 },
			},
			value = 6,
		},
	},
	["earth protection"] = {
		["basic"] = {
			text = "The basic bundle for the void imbuement consists of 25 pieces of swampling wood. Would you like to buy it for 2 gold tokens??",
			itens = {
				[1] = { id = 17823, amount = 25},
			},
			value = 2,
		},
		["intricate"] = {
			text = "The intricate bundle for the void imbuement consists of 25 pieces of swampling wood and 20 snake skins. Would you like to buy it for 4 gold tokens??.",
			itens = {
				[1] = { id = 17823, amount = 25 },
				[2] = { id = 9694, amount = 20 },
			},
			value = 4,
		},
		["capacity"] = {
			text = "The powerful bundle for the void imbuement consists oof 25 pieces of swampling wood and 20 snake skins and 10 brimstone fangs. Would you like to buy it for 6 gold tokens??",
			itens = {
				[1] = { id = 17823, amount = 25 },
				[2] = { id = 9694, amount = 20 },
				[3] = { id = 11702, amount = 5 },
			},
			value = 6,
		},
	},
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Axe, Sword, Club, Distance, Magic Level, Shielding
	if MsgContains(message, "attack") then
		npcHandler:say({ "I have creature products for the imbuements {strike}, {vampirism} and {void}. Make your choice, please!" }, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "skill") then
		npcHandler:say({ "I have creature products for the imbuements {axe}, {sword}, {club}, {distance}, {magic level}, {shielding}. Make your choice, please!" }, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "support") then
		npcHandler:say({ "I have creature products for the imbuements {capacity}, {speed}. Make your choice, please!" }, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "protective") then
		npcHandler:say({ "I have creature products for the imbuements {death protection}, {earth protection}, {fire protection}, {ice protection}, {energy protection}, {holy protection}. Make your choice, please!" }, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 then
		local imbueType = products[message:lower()]
		if imbueType then
			npcHandler:say({ "You have chosen " .. message .. ". {Basic}, {intricate} or {powerful}?" }, npc, creature)
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
			npcHandler:say({ imbueLevel.text .. "...", "Make sure that you have " .. #products[answerType[playerId]][answerLevel[playerId]].itens .. " free slot and that you can carry " .. string.format("%.2f", neededCap / 100) .. " oz in addition to that." }, npc, creature)
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
					npcHandler:say("I'm sorry but it seems you don't have enough " .. ItemType(npc:getCurrency()):getPluralName():lower() .. " ..? yet. Bring me " .. products[answerType[playerId]][answerLevel[playerId]].value .. " of them and we'll make a trade.", npc, creature)
				end
			else
				npcHandler:say("You don't have enough capacity. You must have " .. neededCap .. " oz.", npc, creature)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("Your decision. Come back if you have changed your mind.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end


npcHandler:setMessage(MESSAGE_GREET, "Hello, adventurers! I can offer a wide range of imbuement items, including {Attack Imbuements}, {Support Imbuements}, {Protective Imbuements}, {Skill Imbuements} all available for gold tokens. These enhancements will grant you significant advantages in combat, exploration, and overall gameplay. Ready to boost your power?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, false)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
