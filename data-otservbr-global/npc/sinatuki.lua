local internalNpcName = "Sinatuki"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 260,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0
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

keywordHandler:addKeyword({'Chuqua'}, StdModule.say, {npcHandler = npcHandler, text = "Chuqua jamjam!! Tiyopa Sinatuki?"})

local fishsID = {7158,7159}

local function creatureSayCallback(npc, creature, type, message)

local player = Player(creature)

	if MsgContains(message, 'Nupi') then
	if player:getStorageValue(Storage.BarbarianTest.Questline) >= 3 and player:getStorageValue(Storage.TheIceIslands.Questline) >=5 then
		for i=1, #fishsID do
			if player:getItemCount(fishsID[i]) >= 100 then
				player:removeItem(fishsID[i], 100)
				player:addItem(7290, 5)
				npcHandler:say("Jinuma, suvituka siq chuqua!! Nguraka, nguraka! <happily takes the food from you and gives you five glimmering crystals>", npc, creature)
			break
			elseif player:getItemCount(fishsID[i]) >= 99 then
				player:removeItem(fishsID[i], 99)
				player:addItem(7290, 5)
				npcHandler:say("Jinuma, suvituka siq chuqua!! Nguraka, nguraka! <happily takes the food from you>", npc, creature)
			break
			else
				npcHandler:say("Kisavuta! <giggles>", npc, creature)
			end
		end
	end
	end
return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
