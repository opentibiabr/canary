local internalNpcName = "Gnomercy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 507,
	lookHead = 94,
	lookBody = 114,
	lookLegs = 98,
	lookFeet = 115
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

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if (MsgContains(message, "tactical")) then
        npcHandler:say(
            {"With your help and efforts we finally cornered what we think is one of 'those below'! For all you have done and endured you are granted the privilege to be one of the first to fight the true enemy. ...",
             "For all we know your successes have brought some unrest to our enemies and they sent one of their observers to punish their slaves and force them to more fierce attacks. ...",
             "This is our chance to deal the enemy the first blow in this conflict. With reinforcements from Gnomehome we are attacking the troops of the enemy and binding a great deal of their forces in battle. ...",
             "Now it is up to you to fight your way to the heart of the enemy's defences and kill the observer. ...",
             "Our first tries were met with no success though. The observer has brought with him one of his creatures or lieutenants, the lost call the thing Versperoth. I am not sure if it is a name or a race. ...",
             "However Versperoth itself is protected by hoards of minions. Sometimes this thing will withdraw into the ground and let all hell loose in form of its' slaves. ...",
             "You'd better be finished with them before Versperoth re-emerges. ...",
             "Only when you manage to kill Versperoth, will you be able to enter the portal behind him and face the true evil of the observer. ...",
             "Use the GREEN command crystal in the cave to begin the charging of the teleport! Good luck."}, npc,
            creature)
        npcHandler:setTopic(playerId, 0)
    end
    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi there! I'm ready to brief you with {tactical} advice.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and take care!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
