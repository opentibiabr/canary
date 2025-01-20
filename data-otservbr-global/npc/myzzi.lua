local internalNpcName = "Myzzi"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 982,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "You need to find some heroes. Find, find, find!!" },
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

	if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.Questline) < 1 then
		if MsgContains(message, "good") then
			npcHandler:say("I'm just a mere messenger and I'm here to find brave adventurers that might {help} my friends in this time of need.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif MsgContains(message, "help") and npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Lady Alivar of the Summer Court and Lord Cadion of the Winter Court are in need of brave adventurers to avert a great {threat} for the whole world.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif MsgContains(message, "threat") and npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"I know only little and I forget so much. So many things going around my mind! ...",
				"However, I can grant you access to the {Courts} of Summer and Winter if you promise to help! There you can meet with Undal or Vanys, the servants of Lord Cadion and Lady Alivar. They will be able to tell you more about the issue.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif MsgContains(message, "courts") and npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({ "There are {entrances} to the hidden Courts of Summer and Winter in secluded places. You can find the portal to the Winter Court high in the mountains of Tyrsung and the portal to the Summer Court in the meadows of Feyrist. ...", "With my magic you will be able to enter the Courts. Find Undal or Vanys and talk to them." }, npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif MsgContains(message, "entrances") and npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("So, are you willing to help in this time of need?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			if MsgContains(message, "yes") then
				npcHandler:say({ "You are a true hero! Here, take my enchantment and you will be able to pass the portals. Now hurry, my friends are waiting." }, npc, creature)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.Questline, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("What?!", npc, creature)
			end
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello adventurer. It is {good} to see you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Well, bye then.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
