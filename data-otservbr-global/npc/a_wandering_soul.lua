local internalNpcName = "A Wandering Soul"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 10,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Ooooh... the sadness..." },
	{ text = "Leave me alone in my mourning..." },
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
	local player = Player(creature)

	local missionStatus = player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission05)
	if missionStatus >= 2 and player:getItemCount(8453) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "I saw you... who are you... what do you want from me...?")
	elseif missionStatus >= 2 and player:getItemCount(8225) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "The pain is slightly less... but the crystal is already charged.")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Is that you...? No... it's not... she never woke up again... the pain... cursed... to wander... Leave me alone in my mourning...")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if message == "blood crystal" then
		local missionStatus = player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission05)

		if missionStatus >= 2 then
			if player:getItemCount(8453) >= 1 then
				npcHandler:say("What the...? I don't know anything about that... still... the pain felt a little less intense for a second... relieving... but will never be gone.", npc, creature)
				player:removeItem(8453, 1)
				player:addItem(8225, 1)
				if not player:hasAchievement("Ghostwhisperer") then
					player:addAchievement("Ghostwhisperer")
				end
			else
				npcHandler:say("You speak of a crystal, but you do not carry one that needs my energy.", npc, creature)
			end
		elseif missionStatus < 2 then
			npcHandler:say("A crystal? My mind is too clouded by grief to understand what you mean right now.", npc, creature)
		else
			npcHandler:say("I have already given what I could to your crystal.", npc, creature)
		end
		return true
	end
	return true
end

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "No... I don't think I can help you... leave me alone in my mourning..." })

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Leave me alone in my mourning...")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Ooooh... the sadness...")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
