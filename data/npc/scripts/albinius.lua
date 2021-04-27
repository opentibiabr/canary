local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

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

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Albinius, a worshipper of the {Astral Shapers}."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Precisely time."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I find ways to unveil the secrets of the stars. Judging by this question, I doubt you follow my weekly publications concerning this research."})

local runes = {
	{runeid = 27622},
	{runeid = 27623},
	{runeid = 27624},
	{runeid = 27625},
	{runeid = 27626},
	{runeid = 27627}
}

local function getTable()
	local itemsList = {
		{name = "heavy old tome", id = 26654, sell = 30}
	}
	return itemsList
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "shapers") then
		npcHandler:say({
			"The {Shapers} were an advanced civilisation, well versed in art, construction, language and exploration of our world in their time. ...",
			"The foundations of this {temple} are testament to their genius and advanced understanding of complex problems. They were master craftsmen and excelled in magic."
		}, cid)
	end

	if msgcontains(msg, 'temple') then
		npcHandler:say({
			"The temple has been restored to its former glory, yet we strife to live and praise in the {Shaper} ways. Do you still need me to take some old {tomes} from you my child?"
		}, cid)
		npcHandler.topic[cid] = 1
	end
	if msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		if (player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1) then
			npcHandler:say('You already offered enough tomes for us to study and rebuild this temple. Thank you, my child.', cid)
			npcHandler.topic[cid] = 0
		else
			if (player:getItemCount(26654) >= 5) then
				player:removeItem(26654, 5)
				npcHandler:say('Thank you very much for your contribution, child. Your first step in the ways of the {Shapers} has been taken.', cid)
				player:setStorageValue(Storage.ForgottenKnowledge.Tomes, 1)
			else
				npcHandler:say('You need 5 heavy old tome.', cid)
			end
		end
	elseif  msgcontains(msg, "no") and npcHandler.topic[cid] == 1 then
		npcHandler:say('I understand. Return to me if you change your mind, my child.', cid)
		npcHandler:releaseFocus(cid)
	end

	if msgcontains(msg, 'tomes') and player:getStorageValue(Storage.ForgottenKnowledge.Tomes) < 1 then
		npcHandler:say({
			"If you have some old shaper tomes I would {buy} them."
		}, cid)
		npcHandler.topic[cid] = 7
	end

	if msgcontains(msg, 'buy') then
		npcHandler:say("I'm sorry, I don't buy anything. My main concern right now is the bulding of this temple.", cid)
		openShopWindow(cid, getTable(), onBuy, onSell)
	end

	--- ##Astral Shaper Rune##
	if msgcontains(msg, 'astral shaper rune') then
		if player:getStorageValue(Storage.ForgottenKnowledge.LastLoreKilled) >= 1 then
			npcHandler:say('Do you wish to merge your rune parts into an astral shaper rune?', cid)
			npcHandler.topic[cid] = 8
		else
			npcHandler:say("I'm sorry but you lack the needed rune parts.", cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 8 then
		local haveParts = false
		for k = 1, #runes do
			if player:removeItem(runes[k].runeid, 1) then
				haveParts = true
			end
		end
		if haveParts then
			npcHandler:say('As you wish.', cid)
			player:addItem(27628, 1)
			npcHandler:releaseFocus(cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 8 then
		npcHandler:say('ok.', cid)
		npcHandler:releaseFocus(cid)
	end

	--- ####PORTALS###
	-- Ice Portal
	if msgcontains(msg, 'ice portal') then
		if player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say({
				"You may pass this portal if you have 50 fish as offering. Do you have the fish with you?"
			}, cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 2 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessIce) < 1 and player:getItemCount(2667) >= 50 then
			player:removeItem(2667, 50)
			npcHandler:say('Thank you for your offering. You may pass the Portal to the Powers of Ice now.', cid)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessIce, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough fish. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 2 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Holy Portal
	if msgcontains(msg, 'holy portal') then
		if player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say({
				"You may pass this portal if you have 50 incantation notes as offering. Do you have the incantation notes with you?"
			}, cid)
			npcHandler.topic[cid] = 3
		else
			npcHandler:say('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 3 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessGolden) < 1 and player:getItemCount(21246) >= 50 then
			player:removeItem(21246, 50)
			npcHandler:say('Thank you for your offering. You may pass the Portal to the Powers of Holy now.', cid)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessGolden, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough incantation notes. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 3 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Energy Portal
	if msgcontains(msg, 'energy portal') then
		if player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say({
				"You may pass this portal if you have 50 marsh stalker feathers as offering. Do you have the marsh stalker feathers with you?"
			}, cid)
			npcHandler.topic[cid] = 4
		else
			npcHandler:say('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 4 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessViolet) < 1 and player:getItemCount(19742) >= 50 then
			player:removeItem(19742, 50)
			npcHandler:say('Thank you for your offering. You may pass the Portal to the Powers of Energy now.', cid)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessViolet, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough marsh stalker feathers. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 4 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Earth Portal
	if msgcontains(msg, 'earth portal') then
		if player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say({
				"You may pass this portal if you have 50 acorns as offering. Do you have the acorns with you?"
			}, cid)
			npcHandler.topic[cid] = 5
		else
			npcHandler:say('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 5 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessEarth) < 1 and player:getItemCount(11213) >= 50 then
			player:removeItem(11213, 50)
			npcHandler:say('Thank you for your offering. You may pass the Portal to the Powers of Earth now.', cid)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessEarth, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough acorns. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 5 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", cid)
	end

	-- Death Portal
	if msgcontains(msg, 'death portal') then
		if player:getStorageValue(Storage.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say({
				"You may pass this portal if you have 50 pelvis bones as offering. Do you have the pelvis bones with you?"
			}, cid)
			npcHandler.topic[cid] = 6
		else
			npcHandler:say('Sorry, first you need to bring my Heavy Old Tomes.', cid)
		end
	end

	if msgcontains(msg, 'yes') and npcHandler.topic[cid] == 6 then
		if player:getStorageValue(Storage.ForgottenKnowledge.AccessDeath) < 1 and player:getItemCount(12437) >= 50 then
			player:removeItem(12437, 50)
			npcHandler:say('Thank you for your offering. You may pass the Portal to the Powers of Death now.', cid)
			player:setStorageValue(Storage.ForgottenKnowledge.AccessDeath, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough pelvis bones. Return if you can offer fifty of them.", cid)
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 6 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, pilgrim. Welcome to the halls of hope. We are the keepers of this {temple} and welcome everyone willing to contribute.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh... farewell, child.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
