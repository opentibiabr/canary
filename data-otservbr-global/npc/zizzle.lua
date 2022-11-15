local internalNpcName = "Zizzle"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 114
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

	if(MsgContains(message, "mission")) then
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 25 then
			npcHandler:say("You made it! Az zoon az you are prepared, I will brief you for your nexzt mizzion. ", npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission08, 2) --Questlog, Wrath of the Emperor "Mission 08: Uninvited Guests"
			player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 0) --door access
			player:setStorageValue(Storage.WrathoftheEmperor.TeleportAccess.Zizzle, 3) --teleport access
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 26)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 26 then
			npcHandler:say({
				"Ze dragon emperor controlz ze whole empire wiz hiz willpower. But even he iz not powerful enough to uze ziz control continuouzly wizout zome form of aid. ... ",
				"Wiz ze ancient zeptre zat you acquired for uz earlier, I can charge ozer zeptrez wiz azpectz of power of ze Great Znake. If you manage to touch one of ze tranzmitter cryztalz wiz ze zeptre, itz godly power will realign ze cryztal. ...",
				"Not only will ze cryztal ztop zending ze orderz of ze emperor into ze mindz of my opprezzed people, it will alzo zend a mezzage of freedom and zelf-rezpect inztead. ...",
				"Dizabling ze cryztalz will probably alert ze emperor. It will likely be too late for him to intervene in perzon but a creature of hiz power might have ozer wayz to intervene. ...",
				"But zere iz more. To reach ze emperor, you will need accezz to hiz inner realmz. Ze zecret to enter iz guarded by a dragon. ...",
				"But ziz iz not ze catch - ze catch iz, zat ze key iz buried in hiz vazt mind. Ze emperor haz bound ze dragon to himzelf, forzing him into an eternal zlumber. ...",
				"A zignificant part of ze emperor'z power iz uzed to reztrain ze dragon. Ze only way to free him will be to enter hiz dreamz. Are you prepared for ziz?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)

		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 29 then
			if player:getStorageValue(Storage.WrathoftheEmperor.Questline) < 30 then
				npcHandler:say({
					"You freed ze dragon! And you pozzezz ze key to enter ze inner realmz of ze emperor, well done. ...",
					"Now you are ready to reach ze inner zanctum of ze emperor. Zalamon'z revelationz showed him zat zere are four cryztalz channelling ze will of ze emperor into ze land. ...",
					"Wiz ze relic you gained from Zalamon we were able to create powerful replicaz of ze zeptre. Take ziz wiz you. ...",
					"You will have to realign ze cryztalz one after ze ozer. Ztart wiz ze one in ze norz-wezt and work your way clockwize zrough ze room. ...",
					"Uzing ze zeptre will forze a part of ze emperor'z willpower out of ze cryztal. You will have to kill zoze manifeztationz. ...",
					"Zen uze your zeptre on ze remainz to deztroy ze emperor'z influenze over ze cryztal. ...",
					"I recommend not to go alone becauze it will be very dangerouz - but ALL of you will have to uze zeir zeptre replicaz on ze emperor'z remainz to prozeed! ...",
					"You will need it. Now go to the north of Sleeping Dragon room, {dont need talk} with he! Good luck."
				}, npc, creature)
				player:setStorageValue(Storage.WrathoftheEmperor.TeleportAccess.innerSanctum, 1)
				player:setStorageValue(Storage.WrathoftheEmperor.Questline, 30)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 2) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:setStorageValue(Storage.WrathoftheEmperor.BossStatus, 1)
				player:addItem(11362, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({"Now go to the north of Sleeping Dragon room, {dont need talk} with he!"}, npc, creature)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Didn't exzpect anyzing lezz from you. Alright, zankz to your effortz to build an effective reziztanze, our comradez zalvaged ziz potion and ze formula you need to utter to breach hiz zubconzciouznezz. ...",
				"Drink it and when you are cloze to ze dragon zpeak: Z...z.. well, juzt take ze sheet wiz ze word and read it yourzelf. A lot of rebelz have died to retrieve ziz information, uze it wizely. ...",
				"Now go and try to find a way to reach ze emperor and to free ze land from it'z opprezzor. Onze you have found a way, return to me and I will explain what to do wiz ze cryztalz. May ze Great Znake guide you!"
			}, npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.TeleportAccess.sleepingDragon, 1)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 1) --Questlog, Wrath of the Emperor "Mission 08: Uninvited Guests"
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 27)
			player:addItem(11372, 1)
			player:addItem(11426, 1)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
npcHandler:setMessage(MESSAGE_GREET, "Ah our human {alliez} have finally arrived! I've already feared zat ze emperor'z forzez had caught you. Your rezilienze and prowezz are imprezzive.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
