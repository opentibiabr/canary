local internalNpcName = "Broken Servant Sentry"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 395,
	lookHead = 58,
	lookBody = 43,
	lookLegs = 38,
	lookFeet = 76,
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

	if(MsgContains(message, "slime") or MsgContains(message, "mould") or MsgContains(message, "fungus") or MsgContains(message, "sample")) then
		if(getPlayerStorageValue(creature, Storage.ElementalistQuest1) < 1) then
			npcHandler:say("If. You. Bring. Slime. Fungus. Samples. Fro-Fro-Fro-Frrrr*chhhhchrk*From. Other. Tower. You. Must. Be. The. Master. Are. You. There. Master?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif(getPlayerStorageValue(creature, Storage.ElementalistQuest1) == 1) then
			npcHandler:say("If. You. Bring. Slime. Fungus. Samples. Fro-Fro-Fro-Frrrr*chhhhchrk*From. Other. Tower. You. Must. Be. The. Master. Are. You. There. Master?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end

	elseif(MsgContains(message, "cap") or MsgContains(message, "mage")) then
		if(getPlayerItemCount(creature, 12599) >= 1 and getPlayerStorageValue(creature, Storage.ElementalistQuest1) == 2) and getPlayerStorageValue(creature, Storage.ElementalistQuest2) < 1 then
			npcHandler:say("Yo-Yo-Your*chhhrk*. Cap. Is. Slimed. I. Can. Clean. It. *chhhhrrrkchrk* ...", npc, creature)
			npcHandler:say("Here. You. Are. *chhhrrrrkchrk*", npc, creature)
			doPlayerRemoveItem(creature, 12599, 1)
			setPlayerStorageValue(creature, Storage.ElementalistQuest2, 1)
			doPlayerAddOutfit(creature, 437, 1)
			doPlayerAddOutfit(creature, 438, 1)
			npcHandler:setTopic(playerId, 0)
		elseif(getPlayerStorageValue(creature, Storage.ElementalistQuest2) == 1) then
			npcHandler:say("You already have this outfit!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, "staff") or MsgContains(message, "spike")) then
		if(getPlayerItemCount(creature, 12803) >= 1 and getPlayerStorageValue(creature, Storage.ElementalistQuest1) == 2) and getPlayerStorageValue(creature, Storage.ElementalistQuest3) < 1 then
			npcHandler:say({"Yo-Yo-Your*chhhrk*. Cap. Is. Slimed. I. Can. Clean. It. *chhhhrrrkchrk* ...",
				"Here. You. Are. *chhhrrrrkchrk*"}, npc, creature, 4000)
			doPlayerRemoveItem(creature, 12803, 1)
			setPlayerStorageValue(creature, Storage.ElementalistQuest3, 1)
			doPlayerAddOutfit(creature, 437, 2)
			doPlayerAddOutfit(creature, 438, 2)
			npcHandler:setTopic(playerId, 0)
		elseif(getPlayerStorageValue(creature, Storage.ElementalistQuest3) == 1) then
			npcHandler:say("You already have this outfit!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end

	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
				npcHandler:say("I. Greet. You. Ma-Ma-Ma-ster! Did. You. Bring. Mo-Mo-Mo-M*chhhhrrrk*ore. Samples. For. Me. To-To-To. Analyse-lyse-lyse?", npc, creature)
				npcHandler:setTopic(playerId, 2)
		elseif(npcHandler:getTopic(playerId) == 2) then
				npcHandler:say("Thank. I. Will. Start. Analysing. No-No-No-No*chhrrrk*Now.", npc, creature)
				setPlayerStorageValue(creature, Storage.ElementalistQuest1, 1)
				setPlayerStorageValue(creature, Storage.ElementalistOutfitStart, 1) --this for default start of Outfit and Addon Quests
				npcHandler:setTopic(playerId, 0)
		elseif(npcHandler:getTopic(playerId) == 3) then
				npcHandler:say("I. Greet. You. Ma-Ma-Ma-ster! Did. You. Bring. Mo-Mo-Mo-M*chhhhrrrk*ore. Samples. For. Me. To-To-To. Analyse-lyse-lyse?", npc, creature)
				npcHandler:setTopic(playerId, 4)
		elseif(npcHandler:getTopic(playerId) == 4) and getPlayerItemCount(creature, 12601) >= 20 then
				npcHandler:say({"Please. Wait. I. Can. Not. Han-Han-Han*chhhhhrrrchrk*Handle. *chhhhrchrk* This. Is. Enough. Material. *chrrrchhrk* ...",
				"I. Have-ve-ve-veee*chrrrck*. Also. Cleaned. Your. Clothes. Master. It. Is. No-No-No*chhrrrrk*Now. Free. Of. Sample. Stains."}, npc, creature, 4000)
				doPlayerRemoveItem(creature, 12601, 20)
				setPlayerStorageValue(creature, Storage.ElementalistQuest1, 2)
				doPlayerAddOutfit(creature, 437, 0)
				doPlayerAddOutfit(creature, 438, 0)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You do not have all the required items.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
