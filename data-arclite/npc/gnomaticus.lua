local internalNpcName = "Gnomaticus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 1,
	lookBody = 86,
	lookLegs = 1,
	lookFeet = 95,
	lookAddons = 0
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "shooting") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 11 then
			npcHandler:say({
				"To the left you see our shooting range. Grab a cannon and shoot at the targets. You need five hits to succeed. ...",
				"Shoot at the villain targets that will pop up. DON'T shoot innocent civilians since this will reset your score and you have to start all over. Report to me afterwards."
			}, npc, creature)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 13)
			player:setStorageValue(Storage.BigfootBurden.Shooting, 0)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 13 then
			npcHandler:say("Shoot at the villain targets that will pop up. DON'T shoot innocent civilians since this will reset your score and you have to start all over. {Report} to me afterwards.", npc, creature)
		end
	elseif MsgContains(message, "report") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 14 then
			npcHandler:say("You are showing some promise! Now continue with the recruitment and talk to Gnomewart to the south for your endurance test!", npc, creature)
			player:setStorageValue(Storage.BigfootBurden.Shooting, player:getStorageValue(Storage.BigfootBurden.Shooting) + 1)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 15)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 13 then
			npcHandler:say("Sorry you are not done yet.", npc, creature)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) <= 12 then
			npcHandler:say("You have nothing to report at all.", npc, creature)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hi there! Are you here for the {shooting} test or to {report} your success?')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
