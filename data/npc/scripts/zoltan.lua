local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	local player = Player(cid)

	-- The paradox tower quest
	if msgcontains(msg, "yenny the gentle") then
		npcHandler:say("Ah, Yenny the Gentle was one of the founders of the druid order called Crunor's Caress, that has been originated in her hometown Carlin.", cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "crunors caress") then
		if player:getStorageValue(Storage.Quest.TheParadoxTower.TheFearedHugo) == 1 then
			-- Questlog: The Feared Hugo (Padreia)
			player:setStorageValue(Storage.Quest.TheParadoxTower.TheFearedHugo, 2)
		end
		npcHandler:say("A quite undruidic order of druids they were, as far as we know. I have no more enlightening knowledge about them though.", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Female Summoner and Male Mage Hat Addon (needs to be rewritten)
local hatKeyword = keywordHandler:addKeyword({'proof'}, StdModule.say, {npcHandler = npcHandler, text = '... I cannot believe my eyes. You retrieved this hat from Ferumbras\' remains? That is incredible. If you give it to me, I will grant you the right to wear this hat as addon. What do you say?'},
		function(player) return not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 141 or 130, 2) end
	)
	hatKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry you don\'t have the Ferumbras\' hat.'}, function(player) return player:getItemCount(5903) == 0 end)
	hatKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I bow to you, player, and hereby grant you the right to wear Ferumbras\' hat as accessory. Congratulations!'}, nil,
		function(player)
			player:removeItem(5903, 1)
			player:addOutfitAddon(141, 2)
			player:addOutfitAddon(130, 2)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		end
	)
	-- hatKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = ''})

keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Bah, I know. I received some sort of \'nomination\' from our outpost in Port Hope. ...',
		'Usually it takes a little more than that for an award though. However, I honour Myra\'s word. ...',
		'I hereby grant you the right to wear a special sign of honour, acknowledged by the academy of Edron. Since you are a man, I guess you don\'t want girlish stuff. There you go.'
	}},
	function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == 10 end,
	function(player)
		player:addOutfitAddon(138, 2)
		player:addOutfitAddon(133, 2)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak, 11)
		player:setStorageValue(Storage.OutfitQuest.MageSummoner.MissionHatCloak, 0)
		player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
	end
)

keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler, text = 'Stop bothering me. I am a far too busy man to be constantly giving out awards.'}, function(player) return player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonHatCloak) == 11 end)
keywordHandler:addKeyword({'myra'}, StdModule.say, {npcHandler = npcHandler, text = 'What the hell are you talking about?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|, student of the arcane arts. I teach the fiercest {spells} available.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Use your knowledge wisely, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
