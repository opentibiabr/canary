local internalNpcName = "Testserver Assistant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {
	amountMoney = 100, --1kk
	amountLevel = 100,
	maxLevel = 800,
}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 60,
	lookBody = 24,
	lookLegs = 38,
	lookFeet = 0,
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "money") or MsgContains(message, "gold") then
		npcHandler:say("There you have", npc, creature)
		player:addItem(3043, npcConfig.amountMoney)
	end

	if MsgContains(message, "exp") or MsgContains(message, "experience") then
		if player:getLevel() > npcConfig.maxLevel then
			npcHandler:say("You can not take it anymore", npc, creature)
		else
			npcHandler:say("Here you are |PLAYERNAME|.", npc, creature)
			local level = player:getLevel() + npcConfig.amountLevel - 1
			local experience = ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
			player:addExperience(experience - player:getExperience(), true, true)
		end
	end

	if MsgContains(message, "bless") or MsgContains(message, "blessing") then
		local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or true
		donthavefilter = function(p, b)
			return not p:hasBlessing(b)
		end
		local missingBless = player:getBlessings(nil, donthavefilter)
		local missingBlessAmt = #missingBless + (hasToF and 0 or 1)

		if missingBlessAmt == 0 then
			player:sendTextMessage(MESSAGE_STATUS, "You are already blessed.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end

		for i, v in ipairs(missingBless) do
			player:addBlessing(v.id, 1)
		end
		npcHandler:say("You have been blessed by all gods, |PLAYERNAME|.", npc, creature)
		player:sendTextMessage(MESSAGE_STATUS, "You received the remaining " .. missingBlessAmt .. " blesses.")
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	end

	if MsgContains(message, "reset") then
		if player:getLevel() > 8 then
			local level = 7
			local experience = ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
			player:removeExperience(player:getExperience() - experience)
		else
			npcHandler:say("You can not take it anymore", npc, creature)
		end
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hey |PLAYERNAME|. I'm Testserver Assistant and I can give {money}, {experience} and {blessing} which will be useful for testing on " .. configManager.getString(configKeys.SERVER_NAME) .. " server." .. " You can too to back to level 8 with {reset}.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
