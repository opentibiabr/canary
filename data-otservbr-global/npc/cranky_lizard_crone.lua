local internalNpcName = "Cranky Lizard Crone"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 339
}

npcConfig.flags = {
	floorchange = false
}

 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

-- Messages
local newaddon = 'Here you are, enjoy your brand new addon!'
local noItems = 'You do not have all the required items.'
local already = 'It seems you already have this addon, don\'t you try to mock me son!'

--WAYFARER START --
function WayfarerFirst(npc, creature, message, keywords, parameters, node)
	if isPremium(creature) then
		local addon = getPlayerStorageValue(creature, Storage.WayfarerOutfit)
		if addon == -1 then
			if getPlayerItemCount(creature,11701) >= 1 then
				if doPlayerRemoveItem(creature,11701,1) then
					npcHandler:say(newaddon, npc, creature)
					doSendMagicEffect(getCreaturePosition(creature), 13)
					doPlayerAddOutfit(creature, 366, 1)
					doPlayerAddOutfit(creature, 367, 1)
					setPlayerStorageValue(creature, Storage.WayfarerOutfit,1)
				end
			else
				npcHandler:say(noItems, npc, creature)
			end
		else
			npcHandler:say(already, npc, creature)
		end
	end
end

function WayfarerSecond(npc, creature, message, keywords, parameters, node)
	if isPremium(creature) then
		if getPlayerStorageValue(creature, Storage.WayfarerOutfit + 1) == -1 then
			if getPlayerItemCount(creature,11700) >= 1 then
				if doPlayerRemoveItem(creature,11700,1) then
					npcHandler:say(newaddon, npc, creature)
					doSendMagicEffect(getCreaturePosition(creature), 13)
					doPlayerAddOutfit(creature, 366, 2)
					doPlayerAddOutfit(creature, 367, 2)
					setPlayerStorageValue(creature, Storage.WayfarerOutfit + 1, 1)
				end
			else
				npcHandler:say(noItems, npc, creature)
			end
		else
			npcHandler:say(already, npc, creature)
		end
	end

end
-- WAYFARER END --
keywordHandler:addKeyword({'addons'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I can offer you first & second addons of the following outfit: {Wayfarer}."})

keywordHandler:addKeyword({'storage'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ask about {first addon} or {second addon}."})

keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ask about {first addon} or {second addon}."})

keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ask about {first addon} or {second addon}."})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "llected all the required pieces, say 'yes' and voila - you got yourself an addon!"})

	local node1 = keywordHandler:addKeyword({'first addon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To achieve the first storage addon you need to give me the Old Cape. Do you have them with you?'})
	node1:addChildKeyword({'yes'}, WayfarerFirst, {})
	node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got all neccessary items.', reset = true})

	local node2 = keywordHandler:addKeyword({'second addon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'To achieve the second storage addon you need to give me the Sedge Hat. Do you have them with you?'})
	node2:addChildKeyword({'yes'}, WayfarerSecond, {})
	node2:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then. Come back when you got all neccessary items.', reset = true})
 npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
