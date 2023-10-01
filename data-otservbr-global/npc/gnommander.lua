local internalNpcName = "Gnommander"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 59,
	lookBody = 57,
	lookLegs = 39,
	lookFeet = 38,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
local speech = {
	"I'm the operating commander of the Spike, the latest great accomplishment of the gnomish race.",
	"The Spike is a crystal structure, created by our greatest crystal experts. It has grown from a crystal the size of my fist to the structure you see here and now.",
	"Of course this did not happen from one day to the other. It's the fruit of the work of several gnomish generations. Its purpose has changed in the course of time.",
	"At first it was conceived as a fast growing resource node. Then it was planned to become the prototype of a new type of high security base.",
	"Now it has become a military base and a weapon. With our foes occupied elsewhere, we can prepare our strike into the depths of the earth.",
	"This crystal can withstand extreme pressure and temperature, and it's growing deeper and deeper even as we speak.",
	"The times of the fastest growth have come to an end, however, and we have to slow down in order not to risk the structural integrity of the Spike. But we are on our way and have to do everything possible to defend the Spike."
}
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, 'commander') then
		return npcHandler:say('I\'m responsible for the security and reward heroes to our cause. If you are looking for missions, talk to Gnomilly, Gnombold and Gnomagery.', npc, creature)
	end

	if MsgContains(message, 'reward') then
		return npcHandler:say('I can sell special outfit parts. If your fame is high enough, you might be {worthy} of such a reward.', npc, creature)
	end

	if MsgContains(message, 'spike') then
		return npcHandler:say(speech, npc, creature)
	end

	if MsgContains(message, 'worthy') then
		if player:getFamePoints() < 100 then
			return npcHandler:say('You are not worthy of a special reward yet.', npc, creature)
		end

		talkState[playerId] = 'worthy'
		return npcHandler:say('You can acquire the {basic} outfit for 1000 Gold, the {first} addon for 2000 gold and the {second} addon for 3000 gold. Which do you want to buy?', npc, creature)
	end

	if talkState[playerId] == 'worthy' then
		if MsgContains(message, 'basic') then
			if getPlayerLevel(creature) < 25 then
				talkState[playerId] = nil
				return npcHandler:say('You do not have enough level yet.', npc, creature)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[playerId] = nil
				return npcHandler:say('You already have that outfit.', npc, creature)
			end

			talkState[playerId] = 'basic'
			return npcHandler:say('Do you want to buy the basic outfit for 1000 Gold?', npc, creature)
		elseif MsgContains(message, 'first') then
			if getPlayerLevel(creature) < 50 then
				talkState[playerId] = nil
				return npcHandler:say('You do not have enough level yet.', npc, creature)
			end

			if not player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[playerId] = nil
				return npcHandler:say('You do not have the Cave Explorer outfit.', npc, creature)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574, 1) then
				talkState[playerId] = nil
				return npcHandler:say('You already have that addon.', npc, creature)
			end

			talkState[playerId] = 'first'
			return npcHandler:say('Do you want to buy the first addon for 2000 Gold?', npc, creature)
		elseif MsgContains(message, 'second') then
			if getPlayerLevel(creature) < 80 then
				talkState[playerId] = nil
				return npcHandler:say('You do not have enough level yet.', npc, creature)
			end

			if not player:hasOutfit(player:getSex() == 0 and 575 or 574) then
				talkState[playerId] = nil
				return npcHandler:say('You do not have the Cave Explorer outfit.', npc, creature)
			end

			if player:hasOutfit(player:getSex() == 0 and 575 or 574, 2) then
				talkState[playerId] = nil
				return npcHandler:say('You already have that addon.', npc, creature)
			end

			talkState[playerId] = 'second'
			return npcHandler:say('Do you want to buy the second addon for 3000 Gold?', npc, creature)
		end
	end

	if talkState[playerId] == 'basic' then
		if MsgContains(message, 'yes') then
			if not player:removeMoney(1000) then
				talkState[playerId] = nil
				return npcHandler:say('You do not have that money.', npc, creature)
			end
		end
		player:removeFamePoints(100)
		player:addOutfit(player:getSex() == 0 and 575 or 574)
		talkState[playerId] = nil
		return npcHandler:say('Here it is.', npc, creature)
	elseif talkState[playerId] == 'first' then
		if MsgContains(message, 'yes') then
			if not player:removeMoney(2000) then
				talkState[playerId] = nil
				return npcHandler:say('You do not have that money.', npc, creature)
			end
		end
		player:removeFamePoints(100)
		player:addOutfitAddon(player:getSex() == 0 and 575 or 574, 1)
		talkState[playerId] = nil
		return npcHandler:say('Here it is.', npc, creature)
	elseif talkState[playerId] == 'second' then
		if MsgContains(message, 'yes') then
			if not player:removeMoney(3000) then
				talkState[playerId] = nil
				return npcHandler:say('You do not have that money.', npc, creature)
			end
		end
		player:removeFamePoints(100)
		player:addOutfitAddon(player:getSex() == 0 and 575 or 574, 2)
		talkState[playerId] = nil
		return npcHandler:say('Here it is.', npc, creature)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
