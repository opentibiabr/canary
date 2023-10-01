local internalNpcName = "Melchior"
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
	lookBody = 25,
	lookLegs = 59,
	lookFeet = 115,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, Player(creature):getSex() == PLAYERSEX_FEMALE and 'Welcome, |PLAYERNAME|! The lovely sound of your voice shines like a beam of light through my solitary darkness!' or 'Greetings, |PLAYERNAME|. I do not see your face, but I can read a thousand things in your voice!')
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'greeting') then
		if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) ~= 0 then
			npcHandler:say({
				'The djinns have an ancient code of honour. This code includes a special concept of hospitality. Anybody who utters the word of greeting must not be attacked even if he is an enemy. Well, at least that is what the code says. ...',
				'I have found out, though, that this does not work at all times. There is no point to say the word of greeting to an enraged djinn. ...',
				'I can tell you the word of greeting if you\'re interested. It is {DJANNI\'HAH}. Remember this word well, stranger. It might save your life one day. ...',
				'And keep in mind that you must choose sides in this conflict. You can only follow the Efreet or the Marid - once you have made your choice there is no way back. I know from experience that djinn do not tolerate double-crossing.'
			}, npc, creature)

			if player:getStorageValue(Storage.Factions) ~= 1 then
				player:setStorageValue(Storage.Factions, 1)
			end
			player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 1)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, stranger. May Uman the Wise guide your steps in this treacherous land.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell, stranger. May Uman the Wise guide your steps in this treacherous land.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
