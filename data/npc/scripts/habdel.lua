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
	if msgcontains(msg, 'outfit') then
		if player:getSex() == PLAYERSEX_FEMALE then
			npcHandler:say('My scimitar? Well, mylady, I do not want to sound rude, but I don\'t think a scimitar would fit to your beautiful outfit. If you are looking for an accessory, why don\'t you talk to Ishina?', cid)
			return true
		end
		if player:getStorageValue(Storage.OutfitQuest.firstOrientalAddon) < 1 then
			npcHandler:say('My scimitar? Yes, that is a true masterpiece. Of course I could make one for you, but I have a small request. Would you fulfil a task for me?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'comb') then
		if player:getSex() == PLAYERSEX_FEMALE then
			npcHandler:say('Comb? This is a weapon shop.', cid)
			return true
		end
		if player:getStorageValue(Storage.OutfitQuest.firstOrientalAddon) == 1 then
			npcHandler:say('Have you brought a mermaid\'s comb for Ishina?', cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				'Listen, um... I know that Ishina has been wanting a comb for a long time... not just any comb, but a mermaid\'s comb. She said it prevents split ends... or something. ...',
				'Do you think you could get one for me so I can give it to her? I really would appreciate it.'
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			player:setStorageValue(Storage.OutfitQuest.firstOrientalAddon, 1)
			npcHandler:say('Brilliant! I will wait for you to return with a mermaid\'s comb then.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if not player:removeItem(5945, 1) then
				npcHandler:say('No... that\'s not it.', cid)
				npcHandler.topic[cid] = 0
				return true
			end
			player:setStorageValue(Storage.OutfitQuest.firstOrientalAddon, 2)
			player:addOutfitAddon(150, 1)
			player:addOutfitAddon(146, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say('Yeah! That\'s it! I can\'t wait to give it to her! Oh - but first, I\'ll fulfil my promise: Here is your scimitar! Thanks again!', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] ~= 0 then
		npcHandler:say('Ah well. Doesn\'t matter.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'weapons'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell the finest weapons in town. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome |PLAYERNAME|! See the fine {weapons} I sell.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Come back soon.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye. Come back soon.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
