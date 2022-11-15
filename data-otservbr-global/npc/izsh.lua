local internalNpcName = "Izsh"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 338
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

	if MsgContains(message, 'mission') then
		if Player(creature):getStorageValue(Storage.WrathoftheEmperor.Questline) == 33 then
			npcHandler:say('Oh yez, let me zee ze documentz. Here we go: zree cheztz filled wiz platinum, one houze, a zet of elite armor, and an unending mana cazket. Iz ziz correct?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say({
			'Fine, zo let\'z prozeed. You uzed forged documentz to enter our zity, killed zeveral guardz who enjoyed a quite excluzive and expenzive training, deztroyed rare magical devizez in ze pozzezzion of ze emperor. ...',
			'Ze good newz iz, your zree cheztz of platinum should be nearly enough to pay ze finez. Lucky you, ziz could have left you broke. ...',
			'Zere are alzo zertain noble familiez complaining about ze murder of zeveral of zeir beloved onez. ...',
			'I zink I can make a deal wiz ze noblez by zelling zem your property in ze zity. Your prezenze would ruin ze houze prizez zere anyway. ...',
			'Of courze zat will not zuffize to compenzate zeir grief, zo I guezz you\'ll have to part wiz zat elite armor, too. Zadly, prizez for armor are on an all time low right now. ...',
			'But luckily you ztill have zat mana cazket. Well, you had it. Now we have to zell it. ...',
			'But not all iz lozt my blank-zkinned vizitor. According to my calculationz, zere iz ztill a bit left. ...',
			'I zink we can zave you zome gold and zome treazurez, and you can keep one pieze of your elite armor at leazt. ...',
			'You will find your rewardz in one of ze old zupply zellarz. Beware of ze ratz zough. ...',
			'Ze rednezz of your faze and ze zound you make wiz your teez iz obviouzly a zign of gratitude of your zpeziez! I am flattered, but pleaze leave now az I have to attend to zome important buzinezz.'
		}, npc, creature)
		Player(creature):setStorageValue(Storage.WrathoftheEmperor.Questline, 34)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetingz zcalelezz being.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
