local internalNpcName = "Erick Jacquin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1114,
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

local coinType = 22516
local coinAmount = 2

local ingredients = {
	[1] = { { 3577, 2 }, { 8010, 20 }, { 8015, 1 }, { 8197, 1 }, { 3603, 5 }, { 2874, 2, 3 }, {coinType, coinAmount}, reward = 9079},
	[2] = { { 7250, 2 }, { 3596, 2 }, { 8014, 1 }, { 3606, 2 }, { 3741, 1 }, { 2874, 1, 15 }, {coinType, coinAmount}, reward = 9080},
	[3] = { { 4363, 1 }, { 8016, 3 }, { 3602, 5 }, { 3606, 2 }, { 3739, 1 }, { 3724, 5 }, {coinType, coinAmount}, reward = 9081},
	[4] = { { 4330, 1 }, { 8013, 2 }, { 3586, 2 }, { 5096, 2 }, { 2874, 2, 15 }, { 3735, 1 }, {coinType, coinAmount}, reward = 9082},
	[5] = { { 6574, 1 }, { 904, 1 }, { 3587, 2 }, { 2874, 2, 6 }, { 3738, 1 }, { 3736, 1 }, {coinType, coinAmount}, reward = 9083},
	[6] = { { 3595, 2 }, { 3596, 2 }, { 3597, 2 }, { 8014, 2 }, { 8015, 1 }, { 8197, 1 }, { 3607, 1 }, { 3723, 20 }, { 3725, 5 }, {coinType, coinAmount}, reward = 9084},
	[7] = { { 8016, 10 }, { 3607, 2 }, { 3741, 1 }, { 3740, 1 }, { 2874, 1, 43 }, { 3606, 2 }, {coinType, coinAmount}, reward = 9085},
	[8] = { { 3582, 1 }, { 8011, 5 }, { 8015, 1 }, { 8017, 2 }, { 3594, 1 }, { 8016, 2 }, {coinType, coinAmount}, reward = 9086},
	[9] = { { 3580, 1 }, { 7158, 1 }, { 7159, 1 }, { 3581, 5 }, { 3601, 2 }, { 3737, 1 }, {coinType, coinAmount}, reward = 9088},
	[10] = { { 3595, 5 }, { 2874, 1, 6 }, { 8013, 1 }, { 3603, 10 }, { 3606, 2 }, { 3598, 10 }, { 841, 2 }, {coinType, coinAmount}, reward = 9087},
	[11] = { { 2874, 5, 14 }, { 3725, 5 }, { 3724, 5 }, { 10329, 10 }, { 3581, 10 }, {coinType, coinAmount}, reward =  11584},
	[12] = { { 10456, 5 }, { 2874, 2, 1 }, { 3595, 20 }, { 8010, 10 }, { 8016, 3 }, {coinType, coinAmount}, reward =  11586},
	[13] = { { 6569, 3 }, { 3599, 3 }, { 6574, 2 }, { 6500, 15 }, { 6558, 1 }, {coinType, coinAmount}, reward = 11587},
	[14] = { { 3606, 40 }, { 5096, 20 }, { 5902, 10 }, { 8758, 1 }, { 5942, 1 }, {coinType, coinAmount}, reward = 11588},
}


local function playerHasIngredients(creature, topic)
	local player = Player(creature)
	local table = ingredients[topic]
	if table then
		for i = 1, #table do
			local itemCount = player:getItemCount(table[i][1], table[i][3] or -1)
			if itemCount < table[i][2] then
				itemCount = table[i][2] - itemCount
				return false
			end
		end
	end

	for i = 1, #table do
		player:removeItem(unpack(table[i]))
	end
	player:addItem(table.reward, 1)

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	local topic = npcHandler:getTopic(playerId)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "prepare") then
		npcHandler:say("Introducing our delectable menu featuring a tantalizing array of dishes for your culinary delight: {Rotworm Stew}, {Hydra Tongue Salad}, {Roasted Dragon Wings}, {Tropical Fried Terrorbird}, {Banana Chocolate Shake}, {Veggie Casserole}, {Filled Jalapeno Peppers}, {Blessed Steak}, {Northern Fishburger}, {Carrot Cake}, {Coconut Shrimp Bake}, {Blackjack}, {Demonic Candy Balls}", npc, creature)
	elseif MsgContains(message, "rotworm stew") then
			npcHandler:say("Did you gather all necessary ingredients to cook Rotworm Stew with me?", npc, creature)
			npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "hydra tongue salad") then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Hydra Tongue Salad with me?", npc, creature)
			npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "roasted dragon wings") then
			npcHandler:say("Did you gather all necessary ingredients to prepare Roasted Dragon Wings with me?", npc, creature)
			npcHandler:setTopic(playerId, 3)
	elseif MsgContains(message, "tropical fried terrorbird") then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Tropical Fried Terrorbird with me?", npc, creature)
			npcHandler:setTopic(playerId, 4)
	elseif MsgContains(message, "banana chocolate shake") then
			npcHandler:say("Did you gather all necessary ingredients to make a Banana Chocolate Shake with me?", npc, creature)
			npcHandler:setTopic(playerId, 5)
	elseif MsgContains(message, "veggie casserole") then
			npcHandler:say("Did you gather all necessary ingredients to cook a Veggie Casserole with me?", npc, creature)
			npcHandler:setTopic(playerId, 6)
	elseif MsgContains(message, "filled jalapeño peppers") then
			npcHandler:say("Did you gather all necessary ingredients to prepare Filled Jalapeño Peppers with me?", npc, creature)
			npcHandler:setTopic(playerId, 7)
	elseif MsgContains(message, "blessed steak") then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Blessed Steak with me?", npc, creature)
			npcHandler:setTopic(playerId, 8)
	elseif MsgContains(message, "northern fishburger") then
			npcHandler:say("Did you gather all necessary ingredients to make a Northern Fishburger with me?", npc, creature)
			npcHandler:setTopic(playerId, 9)
	elseif MsgContains(message, "carrot cake") then
			npcHandler:say("Did you gather all necessary ingredients to bake a Carrot Cake with me?", npc, creature)
			npcHandler:setTopic(playerId, 10)
	elseif MsgContains(message, "coconut shrimp bake") then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Coconut Shrimp Bake with me?", npc, creature)
			npcHandler:setTopic(playerId, 11)
	elseif MsgContains(message, "blackjack") then
			npcHandler:setTopic(playerId, 12)
	elseif MsgContains(message, "demonic candy ball") then
			npcHandler:say("Did you gather all necessary ingredients to make Demonic Candy Balls with me?", npc, creature)
			npcHandler:setTopic(playerId, 13)
	elseif MsgContains(message, "sweet mangonaise elixir") then
		npcHandler:say("Did you gather all necessary ingredients to mix Sweet Mangonaise Elixir with me?", npc, creature)
		npcHandler:setTopic(playerId, 14)
	elseif MsgContains(message, "no") then
		npcHandler:say("No?, come back when you are ready to cook.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yes") then
		if playerHasIngredients(creature, topic) then
			npcHandler:say("Prepare for a taste sensation of cosmic proportions! Take this dish, and may it grant you culinary superpowers.", npc, creature)
		else
			npcHandler:say("Unfortunately, you don't have all the necessary ingredients to prepare the dish", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Well, I'm not a simple cook. I travel the whole Tibian continent for the most artfully seasoned recipes and constantly develop new ones. What delectable dish may I {prepare} for you ?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
