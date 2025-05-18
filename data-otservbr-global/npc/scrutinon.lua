local internalNpcName = "Scrutinon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 19131,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "quirefang") then
		npcHandler:say({
			"This island is cleft. Go there only prepared or you will meet your end. The surface of this forgotten rock is a barren wasteland full of hostile creatures. ...",
			"Its visage is covered with holes and tunnels in which its leggy inhabitants are hiding. Its bowels filled with the strangest creatures, waiting to feast on whatever dares to disturb their hive. ...",
			"And you will find no shelter in Quirefang's black depths, where the creatures of the deep are fulfilling a dark prophecy. ...",
			"It is impossible to reach it by ship or boat. However, there was one before you. A {visitor} who found a way to enter the island.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 and MsgContains(message, "visitor") then
		npcHandler:say({
			"He travelled on the very ground to reach the hostile shores of Quirefang. He used something that turned the soil and carved a way to the island. ...",
			"You will need to follow his trail if you want to reach it.",
		}, npc, creature)
		if player:getStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Questline) < 1 then
			player:setStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Questline, 1)
			player:setStorageValue(Storage.Quest.U9_4.LiquidBlackQuest.Visitor, 1)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

-- Travel
local function addTravelKeyword(keyword, destination)
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to sail " .. keyword:titleCase() .. "?" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })
end

addTravelKeyword("ab'dendriel", Position(32734, 31668, 6))
addTravelKeyword("edron", Position(33175, 31764, 6))
addTravelKeyword("venore", Position(32954, 32022, 6))
addTravelKeyword("darashia", Position(33289, 32480, 6))

-- Basic
keywordHandler:addKeyword({ "name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"My name is Scrutinon. However, there are not many people calling my name nowadays. Not many captains even dare to land on this island. It is too close to {Quirefang}. ...",
		"Most of them do not know this island by that name. Some call it Demon Horn, others the Dragon's Tooth or the Gray Beach as none of them ever came closer than a fair distance. ...",
		"There are drifts and storms surrounding that place that are far too dangerous to navigate through even for the most versed captains. They often sail not closer than to this island here and drop off whoever dares to explore near this dreaded coast.",
	},
})

npcHandler:setMessage(MESSAGE_GREET, "|PLAYERNAME|. I have been watching your fate for quite some time. It's about time you came here. Do you seek to enter the riven island of Quirefang or travel back from where you came?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
