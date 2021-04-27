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

local voices = { {text = 'Gems and jewellery! Best prices in town!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "addon") or msgcontains(msg, "outfit") or msgcontains(msg, "hat") then
		local addonProgress = player:getStorageValue(Storage.OutfitQuest.Citizen.AddonHat)
		if addonProgress < 1 then
			npcHandler:say("Pretty, isn't it? My friend Amber taught me how to make it, but I could help you with one if you like. What do you say?", cid)
			npcHandler.topic[cid] = 1
		elseif addonProgress == 1 then
			npcHandler:say("Oh, you're back already? Did you bring a legion helmet, 100 chicken feathers and 50 honeycombs?", cid)
			npcHandler.topic[cid] = 2
		elseif addonProgress == 2 then
			npcHandler:say('Pretty hat, isn\'t it?', cid)
		end
		return true
	end

	if npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.AddonHat, 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.MissionHat, 1)
			npcHandler:say('Okay, here we go, listen closely! I need a few things... a basic hat of course, maybe a legion helmet would do. Then about 100 chicken feathers... and 50 honeycombs as glue. That\'s it, come back to me once you gathered it!', cid)
		else
			npcHandler:say('Aw, I guess you don\'t like feather hats. No big deal.', cid)
		end
		npcHandler.topic[cid] = 0

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			if player:getItemCount(2480) < 1 then
				npcHandler:say('Sorry, but I can\'t see a legion helmet.', cid)
			elseif player:getItemCount(5890) < 100 then
				npcHandler:say('Sorry, but you don\'t enough chicken feathers.', cid)
			elseif player:getItemCount(5902) < 50 then
				npcHandler:say('Sorry, but you don\'t have enough honeycombs.', cid)
			else
				npcHandler:say('Great job! That must have taken a lot of work. Okay, you put it like this... then glue like this... here!', cid)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

				player:removeItem(2480, 1)
				player:removeItem(5902, 50)
				player:removeItem(5890, 100)

				player:addOutfitAddon(136, 2)
				player:addOutfitAddon(128, 2)

				player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
				player:setStorageValue(Storage.OutfitQuest.Citizen.MissionHat, 0)
				player:setStorageValue(Storage.OutfitQuest.Citizen.AddonHat, 2)
			end
		else
			npcHandler:say('Maybe another time.', cid)
		end
		npcHandler.topic[cid] = 0
	end

	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am a jeweler. Maybe you want to have a look at my wonderful offers.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Hanna.'})

npcHandler:setMessage(MESSAGE_GREET, 'Oh, please come in, |PLAYERNAME|. What do you need? Have a look at my wonderful {offers} in gems and jewellery.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
