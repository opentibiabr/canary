local internalNpcName = "Zoltan"
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
	lookHead = 95,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 76,
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

	-- The paradox tower quest
	if MsgContains(message, "yenny the gentle") then
		npcHandler:say("Ah, Yenny the Gentle was one of the founders of the druid order called Crunor's Caress, that has been originated in her hometown Carlin.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "crunor's caress") then
		if player:getStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo) == 1 then
			-- Questlog: The Feared Hugo (Padreia)
			player:setStorageValue(Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo, 2)
		end
		npcHandler:say("A quite undruidic order of druids they were, as far as we know. I have no more enlightening knowledge about them though.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "proof") then
		npcHandler:say("... I cannot believe my eyes. You retrieved this hat from Ferumbras' remains? That is incredible. If you give it to me, I will grant you the right to wear this hat as addon. What do you say?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif npcHandler:getTopic(playerId) == 1 then
		if player:getSex() == PLAYERSEX_MALE and not player:hasOutfit(130, 2) then
			if MsgContains(message, "yes") then
				if player:getItemCount(5903) == 1 then
					npcHandler:say("I bow to you, player, and hereby grant you the right to wear Ferumbras' hat as accessory. Congratulations!", npc, creature)
					player:removeItem(5903, 1)
					player:addOutfitAddon(130, 2) -- male mage addon
					player:addOutfitAddon(141, 2) -- female summoner addon
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
				else
					npcHandler:say("Sorry you don't have the Ferumbras' hat.", npc, creature)
				end
			else
				npcHandler:say("This task is only available for male players who don't already have the addon.", npc, creature)
			end
		end
	elseif MsgContains(message, "myra") then
		if player:getSex() == PLAYERSEX_FEMALE and player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 10 and not player:hasOutfit(138, 2) then
			npcHandler:say({
				"Bah, I know. I received some sort of 'nomination' from our outpost in Port Hope. ...",
				"Usually it takes a little more than that for an award though. However, I honour Myra's word. ...",
				"I hereby grant you the right to wear a special sign of honour, acknowledged by the academy of Edron. Since you are a woman, I guess you don't want manly stuff. There you go.",
			}, npc, creature, 100)
			player:addOutfitAddon(138, 2) -- female mage addon
			player:addOutfitAddon(141, 2) -- female summoner addon
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak, 11)
			player:setStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.MissionHatCloak, 0)
		elseif player:getStorageValue(Storage.Quest.U7_8.MageAndSummonerOutfits.AddonHatCloak) == 11 then
			npcHandler:say("Stop bothering me. I am a far too busy man to be constantly giving out awards.", npc, creature)
		else
			npcHandler:say("What the hell are you talking about?", npc, creature)
		end
	end

	return true
end

local node1 = keywordHandler:addKeyword({ "blood rage" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {blood rage} magic spell for 8000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "blood rage", vocation = { 4, 8 }, price = 8000, level = 60 })

local node2 = keywordHandler:addKeyword({ "eternal winter" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {eternal winter} magic spell for 8000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "eternal winter", vocation = { 2, 6 }, price = 8000, level = 60 })

local node3 = keywordHandler:addKeyword({ "hell's core" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {hell's core} magic spell for 8000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "hell's core", vocation = { 1, 5 }, price = 8000, level = 60 })

local node4 = keywordHandler:addKeyword({ "protector" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {protector} magic spell for 6000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "protector", vocation = { 4, 8 }, price = 6000, level = 55 })

local node5 = keywordHandler:addKeyword({ "rage of the skies" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {rage of the skies} magic spell for 6000 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "rage of the skies", vocation = { 1, 5 }, price = 6000, level = 55 })

local node6 = keywordHandler:addKeyword({ "sharpshooter" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {sharpshooter} magic spell for 8000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "sharpshooter", vocation = { 3, 7 }, price = 8000, level = 60 })

local node7 = keywordHandler:addKeyword({ "swift foot" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {swift foot} magic spell for 6000 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "swift foot", vocation = { 3, 7 }, price = 6000, level = 55 })

local node8 = keywordHandler:addKeyword({ "ultimate energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate energy strike} magic spell for 15000 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate energy strike", vocation = { 1, 5 }, price = 15000, level = 100 })

local node9 = keywordHandler:addKeyword({ "ultimate flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate flame strike} magic spell for 15000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate flame strike", vocation = { 1, 5 }, price = 15000, level = 90 })

local node10 = keywordHandler:addKeyword({ "ultimate ice strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate ice strike} magic spell for 15000 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate ice strike", vocation = { 2, 6 }, price = 15000, level = 100 })

local node11 = keywordHandler:addKeyword({ "ultimate terra strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate terra strike} magic spell for 15000 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate terra strike", vocation = { 2, 6 }, price = 15000, level = 90 })

local node12 = keywordHandler:addKeyword({ "wrath of nature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {wrath of nature} magic spell for 6000 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "wrath of nature", vocation = { 2, 6 }, price = 6000, level = 55 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I can teach you {support} and {attack} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}." })
keywordHandler:addKeyword({ "support" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Support spells: {Blood Rage} (Knight), {Protector} (Knight), {Sharpshooter} (Paladin), {Swift Foot} (Paladin)." })
keywordHandler:addKeyword({ "attack" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Attack spells: {Eternal Winter} (Druid), {Hell's Core} (Sorcerer), {Rage of the Skies} (Sorcerer), {Ultimate Energy Strike} (Sorcerer), {Ultimate Flame Strike} (Sorcerer), {Ultimate Ice Strike} (Druid), {Ultimate Terra Strike} (Druid), {Wrath of Nature} (Druid)." })

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I have spells for level {100}, {90}, {60} and {55}." })

nodeLevels:addChildKeyword({ "100" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 100 I have {Ultimate Energy Strike} for 15000 gold and {Ultimate Ice Strike} for 15000 gold." })
nodeLevels:addChildKeyword({ "90" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 90 I have {Ultimate Flame Strike} for 15000 gold and {Ultimate Terra Strike} for 15000 gold." })
nodeLevels:addChildKeyword({ "60" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 60 I have {Blood Rage} for 8000 gold, {Eternal Winter} for 8000 gold, {Hell's Core} for 8000 gold and {Sharpshooter} for 8000 gold." })
nodeLevels:addChildKeyword({ "55" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 55 I have {Protector} for 6000 gold, {Rage of the Skies} for 6000 gold, {Swift Foot} for 6000 gold and {Wrath of Nature} for 6000 gold." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|, student of the arcane arts. I teach the fiercest {spells} available.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Use your knowledge wisely, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
