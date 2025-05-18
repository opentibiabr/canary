local internalNpcName = "Awarness Of The Emperor"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 231,
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

local function greetCallback(npc, creature)
	if Player(creature):getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) < 31 then
		npcHandler:setMessage(MESSAGE_GREET, "I am not here to fight you, fool. Like it or not, we will have to work together to stop the catastrophe you and that priest have initiated.")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, mortal. Be aware that you are trying my patience while we are talking.")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		local player = Player(creature)
		if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 30 and player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.BossStatus) == 5 then
			npcHandler:say({
				"The amplified force of the snake god is tearing the land apart. It is using my crystals in a reverse way to drain the vital force from the land and its inhabitants to fuel its power. ...",
				"I will withstand its influence as good as possible and slow this process. You will have to fight its worldly incarnation though. ...",
				"It is still weak and disoriented. You might stand a chance - this is our only chance. I will send you to the point to where the vital force is channelled. I have no idea where that might be though. ...",
				"You will probably have to fight some sort of vessel the snake god uses. Even if you defeat it, it is likely that it only weakens the snake. ...",
				"You might have to fight several incarnations until the snake god is worn out enough. Then use the power of the snake's own sceptre against it. Use it on its corpse to claim your victory. ...",
				"Be prepared for the fight of your life! Are you ready?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 32 then
			npcHandler:say({
				"So you have mastered the crisis you invoked with your foolishness. I should crush you for your involvement right here and now. ...",
				"But such an act would bring me down to your own barbaric level and only fuel the corruption that destroys the land that I own. Therefore I will not only spare your miserable life but show your the generosity of the dragon emperor. ...",
				"I will reward you beyond your wildest dreams! ...",
				"I grant you three chests - filled to the lid with platinum coins, a house in the city in which you may reside, a set of the finest armor Zao has to offer, and a casket of never-ending mana. ...",
				"Speak with magistrate Izsh in the ministry about your reward. And now leave before I change my mind!",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.SleepingDragon, 2)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 33)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			local player = Player(creature)
			player:teleportTo(Position(33360, 31397, 9))
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.AwarnessEmperor, 1)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Wote10, 1)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.BossRoom, 1)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 31)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission11, 1) --Questlog, Wrath of the Emperor "Mission 11: Payback Time"
			npcHandler:say("So be it!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
