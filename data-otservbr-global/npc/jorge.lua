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
	lookFeet = 94,
}

npcConfig.flags = {
	floorchange = false,
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

local function onAddFocus(npc, creature)
	local playerId = creature:getId()
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
end

local items = {
	[1] = { name = "Abacus", id = 19151 },
	[2] = { name = "Assassin Doll", id = 28897 },
	[3] = { name = "Bag of Oriental Spices", id = 23682 },
	[4] = { name = "Bookworm Doll", id = 28895 },
	[5] = { name = "Citizen Doll", id = 43511 },
	[6] = { name = "Crimson Doll", id = 25981 },
	[7] = { name = "Doll of Durin the Almighty", id = 23679 },
	[8] = { name = "Dragon Eye", id = 22027 },
	[9] = { name = "Dragon Goblet", id = 31265 },
	[10] = { name = "Draken Doll", id = 25979 },
	[11] = { name = "Emblem", id = 25980 },
	[12] = { name = "Encyclopedia", id = 23678 },
	[13] = { name = "Friendship Amulet", id = 19153 },
	[14] = { name = "Frozen Heart", id = 19156 },
	[15] = { name = "Golden Falcon", id = 28896 },
	[16] = { name = "Golden Newspaper", id = 23681 },
	[17] = { name = "Goromaphone", id = 34210 },
	[18] = { name = "Hand Puppets", id = 23676 },
	[19] = { name = "Imortus", id = 23683 },
	[20] = { name = "Jade Amulet", id = 31268 },
	[21] = { name = "Key of Numerous Locks", id = 19152 },
	[22] = { name = "Little Adventurer Doll", id = 37058 },
	[23] = { name = "Loremaster Doll", id = 31267 },
	[24] = { name = "Lucky Clover Amulet", id = 37059 },
	[25] = { name = "Mathmaster Shield", id = 25982 },
	[26] = { name = "Medusa Skull", id = 23680 },
	[27] = { name = "Music Box", id = 23677 },
	[28] = { name = "Noble Sword", id = 22028 },
	[29] = { name = "Norseman Doll", id = 19150 },
	[30] = { name = "Old Radio", id = 28894 },
	[31] = { name = "Orc's Jaw Shredder", id = 19155 },
	[32] = { name = "Phoenix Statue", id = 22026 },
	[33] = { name = "Pigeon Trophy", id = 31266 },
	[34] = { name = "Shield of Destiny", id = 43517 },
	[35] = { name = "Shield of Endless Search", id = 37060 },
	[36] = { name = "The Mexcalibur", id = 19154 },
	[37] = { name = "Tibiora's Box", id = 43510 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Implementing the "souvenir" message interaction
	if MsgContains(message, "souvenir") then
		npcHandler:say({
			"In this category I can offer you a Norseman doll, an abacus, a key of numerous locks, a friendship amulet, a mexcalibur sword, an orc shredder, a frozen heart, a phoenix statue, a dragon eye and a noble sword. Or: ...",
			"A hand puppet, a music box, an encyclopedia, a Durin doll, a medusa skull, a newspaper, a bag of spices or an Exhiti imortus. ...",
			"A mathmaster shield, a draken doll, an emblem, a crimson doll, an old radio, a bookworm doll, a golden falcon and an assassin doll. ...",
			"A dragon goblet, a pigeon trophy, a loremaster doll and a jade amulet. ...",
			"All listed souvenirs are at 20 silver raid tokens each. Which one of them do you want?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	end

	-- Checking if the player responded with an item name after "souvenir"
	if npcHandler:getTopic(playerId) == 1 then
		for i = 1, #items do
			if MsgContains(message, items[i].name) then
				if getPlayerItemCount(creature, 19083) >= 20 then
					doPlayerRemoveItem(creature, 19083, 20)
					doPlayerAddItem(creature, items[i].id, 1)
					npcHandler:say("You just swapped 20 silver raid tokens for 1 " .. items[i].name .. ".", npc, creature)
				else
					npcHandler:say("I'm sorry, I need at least 20 silver tokens for that. Please come back when you have them.", npc, creature)
				end
				npcHandler:setTopic(playerId, 0) -- Reset topic after processing
				return true
			end
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
