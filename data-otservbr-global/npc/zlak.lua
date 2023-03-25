local internalNpcName = "Zlak"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 339
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 22 then
			npcHandler:say({
				"Ze rumour mill iz quite fazt. Ezpecially when zomeone unuzual az you enterz ze zity. Zoon zey will learn zat you have no reazon to be here and our raze will be buzted. ...",
				"Zo we have to ztrike fazt and quickly. You will have to eliminate zome high ranking key officialz. I zink killing four of zem should be enough. ...",
				"Ziz will dizrupt ze order in ze zity zignificantly zinze zo much dependz on bureaucracy and ze chain of command. Only chaoz and dizorganization will enable me to help you with ze next ztep in ze plan."
			}, npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.TeleportAccess.Zlak, 1)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 23)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission05, 3) --Questlog, Wrath of the Emperor "Mission 05: New in Town"
			player:setStorageValue(Storage.WrathoftheEmperor.Mission06, 0) --Questlog, Wrath of the Emperor "Mission 06: The Office Job"
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 23 and player:getStorageValue(Storage.WrathoftheEmperor.Mission06) == 4 then
			npcHandler:say({
				"Chaoz and panic are already zpreading. Your barbaric brutality iz frightening effectively. I could acquire a key zat we need to get you into ze palaze itzelf. But zere are ztill too many guardz and elite zquadz even for you to fight. ...",
				"I need you to enter ze zity and zlay at leazt zix noblez. Ze otherz will feel zreatened and call guardz to zemzelvez, and ze dragon kingz will accuze each ozer to be rezponzible for zlaying zeir pet noblez. ...",
				"Zat should enable uz to give you at leazt a chanze to attack ze palaze."
			}, npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 24)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission07, 0) --Questlog, Wrath of the Emperor "Mission 07: A Noble Cause"
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 24 and player:getStorageValue(Storage.WrathoftheEmperor.Mission07) == 6 then
			if npcHandler:getTopic(playerId) ~= 1 then
				npcHandler:say({
					"Word of your deedz iz already zpreading like a wildfire. Zalamon'z plan to unleash zome murderouz beaztz in ze zity workz almozt too well. You are already becoming zome kind of legend with which motherz frighten zeir unruly hatchlingz. ...",
					"Your next {mizzion} will be a ztrike into ze heart of ze empire."
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say({
					"Your eagernezz for killing and bloodshed iz frightening, but your next mizzion will zuit your tazte. Wiz ze zity in chaoz and defenzez diverted, ze ztage iz zet for our final ztrike. ...",
					"A large number of rebelz have arrived undercover in ze zity. Zey will attack ze palaze and zome loyal palaze guardz will let zem in. ...",
					"Meanwhile, you will take ze old ezcape tunnel zat leadz from ze abandoned bazement in ze norz of ze miniztry to a lift zat endz zomewhere in ze palaze. ...",
					"When everyzing workz according to ze plan, you will meet Zalamon zomewhere in the underground part of ze palaze."
				}, npc, creature)
				player:setStorageValue(Storage.WrathoftheEmperor.Mission08, 1) --Questlog, Wrath of the Emperor "Mission 08: Uninvited Guests"
				player:setStorageValue(Storage.WrathoftheEmperor.Questline, 25)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end
npcHandler:setMessage(MESSAGE_GREET, {
"Ah, ze human everyone iz talking about. Your victory over ze champion waz quite imprezzive. ...",
"Alzough, for many ziz only provez what a huge zreat you blank-zkinz ztill poze. What do you {want}?"})
npcHandler:setMessage(MESSAGE_FAREWELL, "Juzt leave me alone.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
