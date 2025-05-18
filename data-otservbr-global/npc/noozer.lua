local internalNpcName = "Noozer"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 430,
	lookHead = 39,
	lookBody = 39,
	lookLegs = 39,
	lookFeet = 19,
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "pass") then
		npcHandler:say({
			"Yes, yes. Or wait - why do you want to.. ah what does it matter. So you want to get through these {caves}, fine. But be warned! ...",
			"...wait a second, I lost it. What was I going to say again? Ah yes - DANGEROUS! These. Caves. Are. Dangerous. No way you get out alive. Ever. Again. ...",
			"Also you should not disturb those... people down there. Yeah. They... hm, wait, they - who are they again? Hey! Who are you? Are you talking to me?! Ah, ah... oh yes, I remember. ...",
			"Wait - I am the guardian here, yes! The keeper of... something... or another, yes, I... guard this place. With my life. Don't I? Of course! ...",
			"Is, er... this the moment where I should try to... stop you? Yes? No? Ah, you know what - you go down there, those guys are angry as dung anyway. Try your luck, return to me when you're done. If you still can. Or not.",
		}, npc, creature)
		if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission) < 2 then
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission, 2)
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.AccessDoor, 1)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "cave") then
		npcHandler:say("I was stationed in this cave to... guard something. Right now I am not even sure what that was.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "job") then
		npcHandler:say("Then don't waste my time. I'm doing some important... business... here. Actually... where am I? If I find out, I will be even more angry than I am now. Out of my sight.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "mission") then
		npcHandler:say("I was on a mission, too - I guess. It was all quite blurry back then. Maybe I'll leave this place after I recovered completely. I have to find out what happened to me.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hm? Oh! Oh, yes a... visitor! Intruder? Benefactor...? Wha- what are you? If you want to pass through this cave, I may have to disappoint you. Or maybe not. It... depends. So, just passing through?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
