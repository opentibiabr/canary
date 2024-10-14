local internalNpcName = "Thanita"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 139,
	lookHead = 77,
	lookBody = 71,
	lookLegs = 82,
	lookFeet = 71,
	lookAddons = 0,
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

	-- Check if NPC can interact with the creature
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Check if the message contains "mission"
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 1 and player:removeItem(140, 1) then
			npcHandler:say({
				"Oh great! Supplies from Carlin! Let me see ...<she digs into the parcel>...ahh, nothing meaningful at all, like always. Well, before I give you the password for the delivery, you have to help me! ...",
				"I have massive problems with the goblin tribe that lives here. You look strong enough to face their leader but you need to be smart to lure him out. ...",
				"I heard they don't like fire very much, maybe that's worth a try. Their beds are mostly made of straw which is known as easily inflammable. ...",
				"The entrance to their cave is at the pond south east of here.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 2)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Door, 2)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 3 then
			npcHandler:say("Impressive!! I could need someone like you here at the watchtower! Okay, the password you need to tell Bunny is ' password* '. Come back and visit me if you like to!", npc, creature)
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 4)
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "How could you sneak up on me like this? I thought you were one of THEM! Well, since you are not, what brings you to this wilderness?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take good care of yourself traveller. Would be a shame to lose such a courageous wanderer to those green monsters.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take good care of yourself traveller. Would be a shame to lose such a courageous wanderer to those green monsters.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
