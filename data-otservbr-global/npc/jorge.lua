local internalNpcName = "Jorge"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
	lookHead = 38,
	lookBody = 77,
	lookLegs = 78,
	lookFeet = 94
}

npcConfig.flags = {
	floorchange = false
}

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

local items = {
	 [1] = {name = "Abacus", id = 19151},
	 [2] = {name = "Assassin Doll", id = 28897},
	 [3] = {name = "Bag of Oriental Spices", id = 10817},
	 [4] = {name = "Bookworm Doll", id = 18343},
	 [5] = {name = "Cateroides Doll", id = 22151},
	 [6] = {name = "Doll of Durin the Almighty", id = 14764},
	 [7] = {name = "Dragon Eye", id = 22027},
	 [8] = {name = "Dragon Goblet", id = 31265},
	 [9] = {name = "Draken Doll", id = 12043},
	 [10] = {name = "Encyclopedia", id = 8149},
	 [11] = {name = "Friendship Amulet", id = 19153},
	 [12] = {name = "Frozen Heart", id = 19156},
	 [13] = {name = "Golden Falcon", id = 28896},
	 [14] = {name = "Golden Newspaper", id = 8153},
	 [15] = {name = "Hand Puppets", id = 9189},
	 [16] = {name = "Imortus", id = 12811},
	 [17] = {name = "Jade Amulet", id = 31268},
	 [18] = {name = "Key of Numerous Locks", id = 19152},
	 [19] = {name = "Loremaster Doll", id = 31267},
	 [20] = {name = "Mathmaster Shield", id = 14760},
	 [21] = {name = "Medusa Skull", id = 14762},
	 [22] = {name = "Music Box", id = 12045},
	 [23] = {name = "Noble Sword", id = 16276},
	 [24] = {name = "Norsemal Doll", id = 19150},
	 [25] = {name = "Old Radio", id = 12813},
	 [26] = {name = "Orcs Jaw Shredder", id = 19155},
	 [27] = {name = "Pigeon Trophy", id = 31266},
	 [28] = {name = "Phoenix Statue", id = 22026},
	 [29] = {name = "The Mexcalibur", id = 19154},
	 [30] = {name = "TibiaHispano Emblem", id = 25980},
	 [31] = {name = "Goromaphone", id = 34210}
}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if message then
		for i = 1, #items do
		  if MsgContains(message, items[i].name) then
				if getPlayerItemCount(creature, 19083) >= 20 then
					doPlayerRemoveItem(creature, 19083, 20)
					doPlayerAddItem(creature, items[i].id, 1)
					selfSay('You just swapped 20 silver raid tokens for 1 '.. getItemName(items[i].name) ..'.', npc, creature)
				else
					selfSay('You need 20 silver raid tokens.', npc, creature)
				end
			end
		end
	end
	return true
end

local function onAddFocus(npc, creature)
	local playerId = creature:getId()
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
