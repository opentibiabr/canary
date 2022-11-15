local internalNpcName = "A Weakened Forest Fury"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 569,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
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

-- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = ' My name is now known only to the wind and it shall remain like this until I will return to my kin.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I was a guardian of this glade. I am the last one... everyone had to leave.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "This glade's time is growing short if nothing will be done soon."})
keywordHandler:addKeyword({'forest fury'}, StdModule.say, {npcHandler = npcHandler, text = "Take care, guardian."})
keywordHandler:addKeyword({'orclops'}, StdModule.say, {npcHandler = npcHandler, text = "Cruel beings. Large and monstrous, with a single eye, staring at their prey. "})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "distress") or MsgContains(message, "mission") then
		npcHandler:say({
			"My pride is great but not greater than reason. I am not too proud to ask for help as this is a dark hour. ... ",
			"This glade has been desecrated. We kept it secret for centuries, yet evil has found a way to sully and destroy what was our most sacred. ...",
			"There is only one way to reinvigorate its spirits, a guardian must venture down there and bring life back into the forest. ... ",
			"Stolen {seeds} need to be wrested from the {intruders} and planted where the soil still hungers. ... ",
			"The purest {water} from the purest well needs to be brought there and poured and {birds} that give life need to be brought back to the inner sanctum of the glade. ...",
			"Will you be our guardian?"
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
			"Indeed, you will. Take one of these cages, which have been crafted generations ago to rob a creature of its freedom for that it may earn it again truthfully. Return the birds back to their home in the glade. ...",
			"You will find {phials} for water near this sacred well which will take you safely to the glade. No seeds are left, they are in the hands of the intruders now. Have faith in yourself, guardian."
			}, npc, creature)
			player:setStorageValue(Storage.ForgottenKnowledge.BirdCage, 1)
			player:addItem(23812, 1)
		end
	elseif MsgContains(message, "seeds") then
			if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
			"Seeds to give life to strong trees, blooming and proud. The {intruders} robbed us from them."
			}, npc, creature)
		end
	elseif MsgContains(message, "intruders") then
			if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
			"The intruders appeared in the blink of an eye. Out of thin air, as if they came from nowhere. They overrun the glade within ours and drove away what was remaining from us within the day."
			}, npc, creature)
		end
	elseif MsgContains(message, "water") then
			if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
			"The purest water flows through this well. For centuries we concealed it, for other beings to not lay their eyes on it."
			}, npc, creature)
		end
	elseif MsgContains(message, "birds") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Take care, guardian."
			}, npc, creature)
		end
	elseif MsgContains(message, "phials") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Phials for the purest water from our sacred well. They are finely crafted and very fragile. We keep a small supply up here around the well. Probably the only thing the intruders did not care for."
			}, npc, creature)
		end
	end
	if MsgContains(message, "cages") and player:getStorageValue(Storage.ForgottenKnowledge.BirdCage) == 1 then
		npcHandler:say({
			"Crafted generations ago to rob a creature of its freedom for that it may earn it again truthfully. You will need them if you plan on returning the birds to their rightful home in the glade. ... ",
			"Are you in need of another one? "
		}, npc, creature)
		npcHandler:setTopic(playerId, 2)
	end
	if MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"I already handed a cage to you. If you are in need of another one, you will have to return to me later."
			}, npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
