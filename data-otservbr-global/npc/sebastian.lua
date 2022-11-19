local internalNpcName = "Sebastian"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 57,
	lookBody = 52,
	lookLegs = 109,
	lookFeet = 115,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if(MsgContains(message, "nargor")) then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToNargor) == 1 then
			npcHandler:say("Do you want to sail Nargor for 50 gold coins?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			if player:getStorageValue(Storage.TheShatteredIsles.AccessToNargor) == 1 then
				if player:removeMoneyBank(50) then
					npcHandler:say("Set the sails!", npc, creature)
					player:teleportTo(Position(32024, 32813, 7))
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					npcHandler:setTopic(playerId, 0)
				end
			end
		end
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = 'Do you want to sail ' .. keyword:titleCase() .. ' for |TRAVELCOST|?',
			cost = cost, discount = 'postman'
		}
	)
	travelKeyword:addChildKeyword({'yes'}, StdModule.travel,
		{
			npcHandler = npcHandler,
			premium = false,
			cost = cost,
			discount = 'postman',
			destination = destination
		}
	)
	travelKeyword:addChildKeyword({'no'}, StdModule.say,
		{
			npcHandler = npcHandler,
			text = 'We would like to serve you some time.',
			reset = true
		}
	)
end

addTravelKeyword('liberty bay', 50, Position(32316, 32702, 7))

-- Basic
keywordHandler:addKeyword({'passage'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Where do you want to go? To {Liberty bay} or to {Nargor}?'
		}
	)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{npcHandler = npcHandler,
	text = 'I am the captain of this ship.'
	}
)
keywordHandler:addKeyword({'captain'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I am the captain of this ship.'
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Greetings, daring adventurer. If you need a {passage}, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh well.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
