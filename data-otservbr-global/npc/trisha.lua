local internalNpcName = "Trisha"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 142,
	lookHead = 94,
	lookBody = 67,
	lookLegs = 38,
	lookFeet = 95,
	lookAddons = 1
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

local config = {
	["hardened bones"] = {
		value = 1,
		message = {
			wrongValue = "Well, I'll give you a little hint. They can sometimes be extracted from creatures \z
				that consist only of - you guessed it, bones. You need an obsidian knife though.",
			deliever = "How are you faring with your mission? Have you collected all 100 hardened bones?",
			success = "I'm surprised. That's pretty good for a man. Now, bring us the 100 turtle shells."
		},
		itemId = 5925,
		count = 100
	},
	["turtle shells"] = {
		value = 2,
		message = {
			wrongValue = "Turtles can be found on some idyllic islands which have recently been discovered.",
			deliever = "Did you get us 100 turtle shells so we can make new shields?",
			success = "Well done - for a man. These shells are enough to build many strong new shields. \z
			Thank you! Now - show me fighting spirit."
		},
		itemId = 5899,
		count = 100
	},
	["fighting spirit"] = {
		value = 3,
		message = {
			wrongValue = "You should have enough fighting spirit if you are a true hero. \z
				Sorry, but you have to figure this one out by yourself. Unless someone grants you a wish.",
			deliever = "So, can you show me your fighting spirit?",
			success = "Correct - pretty smart for a man. But the hardest task is yet to come: \z
				the claw from a lord among the dragon lords."
		},
		itemId = 5884
	},
	["dragon claw"] = {
		value = 4,
		message = {
			wrongValue = "You cannot get this special red claw from any common dragon in Tibia. \z
				It requires a special one, a lord among the lords.",
			deliever = "Have you actually managed to obtain the dragon claw I asked for?",
			success = "You did it! I have seldom seen a man as courageous as you. \z
				I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour."
		},
		itemId = 5919
	}
}

local topic = {}

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Salutations, |PLAYERNAME|. What can I do for you?")
	topic[playerId] = nil
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local player, storage = Player(creature), Storage.OutfitQuest.WarriorShoulderAddon
	if npcHandler:getTopic(playerId) == 0 then
		if isInArray({"outfit", "addon"}, message) then
			npcHandler:say("Are you talking about my spiky shoulder pad? You can't buy one of these. \z
				They have to be {earned}.", npc, creature)
		elseif MsgContains(message, "earn") then
			if player:getStorageValue(storage) < 1 then
				npcHandler:say("I'm not sure if you are enough of a hero to earn them. \z
					You could try, though. What do you think?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif player:getStorageValue(storage) >= 1 and player:getStorageValue(storage) < 5 then
				npcHandler:say("Before I can nominate you for an award, please complete your task.", npc, creature)
			elseif player:getStorageValue(storage) == 5 then
				npcHandler:say("You did it! I have seldom seen a man as courageous as you. \z
					I really have to say that you deserve to wear a spike. Go ask Cornelia to adorn your armour.", npc, creature)
			end
		elseif config[message:lower()] then
			local targetMessage = config[message:lower()]
			if player:getStorageValue(storage) ~= targetMessage.value then
				npcHandler:say(targetMessage.message.wrongValue, npc, creature)
				return true
			end

			npcHandler:say(targetMessage.message.deliever, npc, creature)
			npcHandler:setTopic(playerId, 3)
			topic[playerId] = targetMessage
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"Okay, who knows, maybe you have a chance. A really small one though. Listen up: ...",
				"First, you have to prove your guts by bringing me 100 hardened bones. ...",
				"Next, if you actually managed to collect that many, please complete a small task for \z
					our guild and bring us 100 turtle shells. ...",
				"It is said that excellent shields can be created from these. ...",
				"Alright, um, afterwards show me that you have fighting spirit. Any true hero needs plenty of that. ...",
				"The last task is the hardest. You will need to bring me a claw from a mighty dragon king. ...",
				"Did you understand everything I told you and are willing to handle this task?"
			}, npc, creature, 100)
			npcHandler:setTopic(playerId, 2)
		elseif MsgContains(message, "no") then
			npcHandler:say("I thought so. Train hard and maybe some day you will be ready to face this mission.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			player:setStorageValue(storage, 1)
			-- This for default start of outfit and addon quests
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			npcHandler:say("Excellent! Don't forget: Your first task is to bring me 100 hardened bones. Good luck!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("Would you like me to repeat the task requirements then?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		if MsgContains(message, "yes") then
			local targetMessage = topic[playerId]
			if not player:removeItem(targetMessage.itemId, targetMessage.count or 1) then
				npcHandler:say("Why do men always lie?", npc, creature)
				return true
			end

			player:setStorageValue(storage, player:getStorageValue(storage) + 1)
			npcHandler:say(targetMessage.message.success, npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say("Don't give up just yet.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addSpellKeyword({"find", "person"},
	{
		npcHandler = npcHandler,
		spellName = "Find Person",
		price = 80,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"light"},
	{
		npcHandler = npcHandler,
		spellName = "Light",
		price = 0,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"cure", "poison"},
	{
		npcHandler = npcHandler,
		spellName = "Cure Poison",
		price = 150,
		level = 10,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"wound", "cleansing"},
	{
		npcHandler = npcHandler,
		spellName = "Wound Cleansing",
		price = 0,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"great", "light"},
	{
		npcHandler = npcHandler,
		spellName = "Great Light",
		price = 500,
		level = 13,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addKeyword({"healing", "spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Wound Cleansing}'' and '{Cure Poison}''."
	}
)
keywordHandler:addKeyword({"support", "spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Light}', '{Find Person}' and '{Great Light}'."
	}
)
keywordHandler:addKeyword({"spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I can teach you {healing spells} and {support spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that."
	}
)

npcHandler:setMessage(MESSAGE_WALKAWAY, "Be careful on your journeys.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Don't hurt yourself with that weapon, little one.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
