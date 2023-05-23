local internalNpcName = "Tigo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
	lookHead = 78,
	lookBody = 6,
	lookLegs = 121,
	lookFeet = 120,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()

	local player = Player(creature)

	if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) < 2 then
		npcHandler:setMessage(MESSAGE_GREET, "There, there initiate. You will now become one of us, as so many before you. One of the {Barkless}. Walk with us and you will walk tall my friend.")
		npcHandler:setTopic(playerId, 1)
	end
	return true
end
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	-- Começou a quest
	if MsgContains(message, "barkless") and npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({"You are now one of us. Learn to endure this world's suffering in every facet and take delight in the soothing eternity that waits for the {purest} of us on the other side."}, npc, creature)
			npcHandler:setTopic(playerId, 2)
			npcHandler:setTopic(playerId, 2)
			if player:getStorageValue(Storage.CultsOfTibia.Questline) < 1 then
			   player:setStorageValue(Storage.CultsOfTibia.Questline, 1)
			end
			if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) < 1 then
			   player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 1)
			   player:setStorageValue(Storage.CultsOfTibia.Barkless.TrialAccessDoor, 1)
			end
	elseif MsgContains(message, "purest") and npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({"Purification is but one of the difficult steps on your way to the other side. The {trial} of tar, sulphur and ice."}, npc, creature)
			npcHandler:setTopic(playerId, 2)
			npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "trial") and npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({"The trial consists of three steps. The trial of tar, where you will suffer unbearable heat and embrace the stigma of misfortune. ...",
							"The trial of sulphur, where you will bathe in burning sulphur and embrace the stigma of vanity. Then, there is the trial of purification. The truest of us will be purified to face judgement from the {Penitent}.",
							"To purge your soul, your body will have to be near absolute zero, the point where life becomes impossible. ...",
							"Something about you is different.  I know that you will find a way to return even if you should die during the purification. And if you do... Leiden will become aware of you and retreat. ...",
							"If he does, follow him into his own chambers. Barkless are neither allowed to go near the throne room, aside from being judged, nor can we actually enter it.",
							"He should be easy to defeat with his back to the wall, find him - and delvier us from whatever became of the Penitent."}, npc, creature)
							npcHandler:setTopic(playerId, 0)
							npcHandler:setTopic(playerId, 0)
		end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
