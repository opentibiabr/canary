local internalNpcName = "Barazbaz"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 76,
	lookBody = 55,
	lookLegs = 49,
	lookFeet = 95,
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

	if MsgContains(message, "ritual") and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission06) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission07) < 1 then
		npcHandler:say({
			"Ancient structures in the sewers you say? Well, our city has had a certain bloody past, even before it has been city at all. But to investigate the archives for what you may have found is a time-consuming process. ...",
			"Usually, I'm too much bound to my duties to the city to sacrifice time for such an endeavour. ...",
			"But on the other hand, just now is the time of an important decision of the magistrate concerning the funding of the archives. It is a matter easily overlooked by our good citizens. ...",
			"If you'd be so kind to place just one of your votes for the funding of the archives, I would be inclined to take the time for your investigation in turn. ...",
			"Just go to Marvin in the magistrate and vote for a greater funding of the archives. Afterwards, I might be able to present you with some first results of my investigations on your behalf.",
		}, npc, creature, 10)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission07, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "abandoned sewers") and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission08) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09) < 1 then
		npcHandler:say({
			"Excellent! Concerning the ancient ruins that you have found, well, if you are not familiar with the city's history, feel free to browse a few books here. I will only refer to some basics here, so I don't waste your time. ...",
			"The first humans that lived here and that we have any records of lived in slavery of an ancient evil. ...",
			"The nature of this evil is up to debate, but there are hints that this evil predated the settlement of men and that it perhaps was part of a more ancient civilisation or caused the downfall of the latter. ...",
			"After that evil had been overcome, much was sealed away. Some say that only forbidden knowledge had been sealed, but others like me were always worried that more had been hidden. ...",
			"Something like the ruins you have found. What you have seen there hints to a new incident, though. As if someone or something was searching for something. In the past, when those ruins were buried, people were primitive and superstitious. ...",
			"Today, we have advanced far more and could have the ruins investigated in a far more efficient way. And that is what I would just recommend you to do: get a necrometer from magistrate Jondrin upstairs and investigate the ruins thoroughly.",
		}, npc, creature, 10)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09, 1)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "notebook") and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission11) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission12) < 1 and player:getItemCount(11450) >= 1 then
		npcHandler:say({
			"I know that handwriting you describe! It belongs to a traveller from far away. Magistrate Sholley introduced him 	to me and she was quite excited to learn more about our city's past. ...",
			"I should have thought of him right in the beginning when I heard the stuff you mentioned. But I haven't seen him for a while. You should ask Sholley about her friend to learn about his whereabouts.",
		}, npc, creature, 10)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission12, 1)
		doPlayerRemoveItem(creature, 11450, 1)
		npcHandler:setTopic(playerId, 0)
	else
		npcHandler:say("You need to kill the {The Ravager}, click on statue and then come here say {ritual}, {abandoned sewers}, {notebook} and after this find Roswitha and talk with she.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Oh, hello there!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
