local internalNpcName = "Ruprecht"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 59,
	lookBody = 115,
	lookLegs = 115,
	lookFeet = 38,
	lookAddons = 3
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

local storeTable = {}
local itemsTable = {
	["gingerbreadman"] = {itemId = 6500, count = 1},
	["christmas cookie tray"] = {itemId = 20310, count = 1},
	["gingerbread recipe"] = {itemId = 174, count = 10},
	["jewel case"] = {itemId = 7527, count = 25},
	["santa hat"] = {itemId = 6531, count = 50},
	["santa backpack"] = {itemId = 10346, count = 75},
	["snow flake tapestry"] = {itemId = 20315, count = 75},
	["santa doll"] = {itemId = 6511, count = 100},
	["snowman doll"] = {itemId = 10339, count = 150},
	["snow globe"] = {itemId = 20311, count = 150},
	["frazzlemaw santa"] = {itemId = 20308, count = 250},
	["leaf golem santa"] = {itemId = 20309, count = 250},
	["santa music box"] = {itemId = 20313, count = 250},
	["santa teddy"] = {itemId = 10338, count = 500},
	["maxxen santa"] = {itemId = 21952, count = 250},
	["present bag"] = {itemId = 6496, count = 1},
	["ferumbras' teddy santa"] = {itemId = 22879, count = 250},
	["nightmare beast santa"] = {itemId = 29947, count = 250},
	["orclops santa"] = {itemId = 24394, count = 250},
	["raccoon santa"] = {itemId = 35692, count = 250},
	["santa fox"] = {itemId = 27591, count = 250},
	["santa leech"] = {itemId = 32746, count = 250}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if (MsgContains(message, "offers")) then
		local text = "I have these offers: "
		for i, v in pairs(itemsTable) do
			text = text.. "{" ..i.. "}, "
		end
		npcHandler:say(text, npc, creature)
	end

	if npcHandler:getTopic(playerId) == 0 then
		local table = itemsTable[message]
		if table then
			if (table.itemId ~= 6496) then
				npcHandler:say("So you want to exchange "..message..", for ".. table.count .." christmas tokens?", npc, creature)
				storeTable[playerId] = message
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say("So you want to exchange ".. message .." to "..table.count.." christmas token(s)?", npc, creature)
				storeTable[playerId] = 6526
				npcHandler:setTopic(playerId, 1)
			end
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			if (tonumber(storeTable[playerId]) == 6526) then
				if (player:removeItem(6496, 1)) then
					npcHandler:say("Thank you, here is your 1 christmas token.", npc, creature)
					player:addItem(6526, 1)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You don't have a present bag.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
				return false
			end
			if player:removeItem(6526, itemsTable[storeTable[playerId]].count) then
				npcHandler:say("Thank you, here is your "..storeTable[playerId]..".", npc, creature)
				player:addItem(itemsTable[storeTable[playerId]].itemId, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You don't have enough of tokens.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif npcHandler:getTopic(playerId) > 0 then
		if MsgContains(message, "no") then
			npcHandler:say("Come back when you are ready to trade some tokens!", npc, creature)
		end
	end
	if MsgContains(message, "santa claus") then
		npcHandler:say({
			"Well, he does not really like it if someone tells his story ... but I do! A long, long time ago Santa was nothing but a greedy little dwarf. A real miser, I tell ya ...",
			"He was greedy even by dwarven standards. He would never share anything or give away the cheapest thing in his possession ...",
			"One day a woman came to his house and asked him for a cup of water ...",
			"Of course he refused. He even mocked her for being so naive. But what he did not know was that this woman was some kind of mighty faery or perhaps a goddess in disguise ...",
			"Be it as it may, the woman cursed old Santa, forcing him to share his fortune with everyone he met ...",
			"Santa was horrified. Of course, he could not bear the thought of sharing anything at all. So he went into hiding ...",
			"He hid in the most remote places in the world, but time and again someone found him out, and the curse made him share his wealth ...",
			"And know something? Old Santa actually came to like it! He saw the joy his presents brought, and this opened his old stony heart ...",
			"And he learned that this way his fortune gave him more joy and pleasure than it ever did when he locked it away. ...",
			"Over the years he turned it into a game. He hid somewhere to reward those who found him ...",
			"But once every year, on a very special day which happens to be his curse's anniversary, he goes out and brings presents to the people, and especially to the children ...",
			"Well, that is his story ... Nah, that's not a tear in my eye. It's just the wind, you know."
		}, npc, creature)
	end
	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	storeTable[playerId] = nil
end

npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
