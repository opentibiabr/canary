local internalNpcName = "Dancing Fairy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 25747
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

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "spell") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) == 1
		and player:getStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple) == 1 then
			npcHandler:say({
				"So, you are searching for a way to transform Aurita's fishtail into legs temporarily. As you might already have figured out you need some magic for this purpose. There is a place on Feyrist where you can find the arcane energies you need. ...",
				"Northeast from here you'll discover a big lake with a small island. Take a swim there and you will find a magical fountain. If you play the panpipes while standing near this fountain, you will create some magical music notes. ...",
				"Collect them and give them to Aurita. Each of those notes will grant her a walk on the beach with Taegen."
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say({
				"Each of those notes will grant her a walk on the beach with Taegen."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"That's very kind of you, my friend! Listen: I know there is a spell to transform my fishtail into legs. It is a temporary effect, so I could return to the ocean as soon as the spell ends. Unfortunately I don't know how to cast this spell. ...",
				"But there is a fairy who once told me about it. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist."
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Then not.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Nature's blessing!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path always be even.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path always be even.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
