local internalNpcName = "Chrak"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 115
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "battle") then
		if player:getStorageValue(TheNewFrontier.Questline) == 24 then
			npcHandler:say({
				"Zo you want to enter ze arena, you know ze rulez and zat zere will be no ozer option zan deaz or victory?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(TheNewFrontier.Questline) == 24 then
			npcHandler:say({
				"Ze tournament iz ze ultimate challenge of might and prowrezz. Ze rulez may have changed over ze centuriez but ze ezzence remained ze zame. ...",
				"If you know ze rulez, you might enter ze arena for ze {battle}."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(TheNewFrontier.Questline) == 27 then
			npcHandler:say({
				"You have done ze impozzible and beaten ze champion. Your mazter will be pleazed. Hereby I cleanze ze poizon from your body. You are now allowed to leave. ...",
				"For now ze mazter will zee zat you and your alliez are zpared of ze wraz of ze dragon emperor az you are unimportant for hiz goalz. ...",
				"You may crawl back to your alliez and warn zem of ze gloriouz might of ze dragon emperor and hiz minionz."
			}, npc, creature)
			player:setStorageValue(TheNewFrontier.Questline, 28)
			player:setStorageValue(TheNewFrontier.Mission09[1], 3) --Questlog, "Mission 09: Mortal Combat"
			player:setStorageValue(TheNewFrontier.Mission10[1], 1) --Questlog, "Mission 10: New Horizons"
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("I grant you ze permizzion to enter ze arena. Remember, you'will have to enter ze arena az a team of two. If you are not familiar wiz ze rulez, I can explain zem to you once again.", npc, creature)
			player:setStorageValue(TheNewFrontier.Questline, 25)
			player:setStorageValue(TheNewFrontier.Mission09.ArenaDoor, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
