local internalNpcName = "A Majestic Warwolf"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 3
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	if Player(creature):getStorageValue(Storage.OutfitQuest.DruidHatAddon) < 9 then
		npcHandler:say('GRRRRRRRRRRRRR', npc, creature)
		return false
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if isInArray({'addon', 'outfit'}, message) then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 9 then
			npcHandler:say('I can see in your eyes that you are a honest and friendly person, |PLAYERNAME|. You were patient enough to learn our language and I will grant you a special gift. Will you accept it?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 1 then
		player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 10)
		player:addOutfitAddon(148, 2)
		player:addOutfitAddon(144, 2)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		npcHandler:say(player:getSex() == PLAYERSEX_FEMALE and 'From now on, you shall be known as |PLAYERNAME|, the wolf girl. You shall be fast and smart as Morgrar, the great white wolf. He shall guide your path.' or 'From now on, you shall be known as |PLAYERNAME|, the bear warrior. You shall be strong and proud as Angros, the great dark bear. He shall guide your path.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Interesting. A human who can speak the language of wolves.")
npcHandler:setMessage(MESSAGE_FAREWELL, "YOOOOUHHOOOUU!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "YOOOOUHHOOOUU!")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
