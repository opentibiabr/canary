local internalNpcName = "Chondur"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 154,
	lookHead = 38,
	lookBody = 113,
	lookLegs = 119,
	lookFeet = 116,
	lookAddons = 3,
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

local function handleAddonMessages(npcHandler, npc, creature, message, playerId)
	local player = Player(creature)

	if MsgContains(message, "addon") then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 158 or 154) then
			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) >= 4 and player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ADjinnInLove) >= 5 and player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) >= 10 and player:getStorageValue(Storage.Quest.U7_8.ShamanOutfits.AddonStaffMask) < 1 then
				npcHandler:say("The time has come, my child. I sense great spiritual wisdom in you and I shall grant you a sign of your progress, if you can fulfil my task.", npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif player:hasOutfit(158, 2) or player:hasOutfit(154, 2) and not (player:hasOutfit(158, 1) or player:hasOutfit(154, 1)) then
				npcHandler:say("You have successfully passed the first task. If you can fulfil my second task, I will grant you a mask like the one I wear. Will you listen to the requirements?", npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		else
			npcHandler:say("You must have the Shaman Outfit to proceed with this task.", npc, creature)
		end
		return true
	elseif MsgContains(message, "task") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say({
			"Deep in the Tiquandian jungle a monster lurks which is seldom seen. It is the revenge of the jungle against humankind. ...",
			"This monster, if slain, carries a rare root called Mandrake. If you find it, bring it to me. Also, gather 5 of the voodoo dolls used by the mysterious dworc voodoomasters. ...",
			"If you manage to fulfil this task, I will grant you your own staff. Have you understood everything and are ready for this test?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 2)
		return true
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("Good! Come back once you found a mandrake and collected 5 dworcish voodoo dolls.", npc, creature)
		player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.AddonStaffMask, 1)
		player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.MissionStaff, 1)
		npcHandler:setTopic(playerId, 0)
		return true
	elseif MsgContains(message, "dworc voodoo doll") or MsgContains(message, "mandrake") then
		npcHandler:say("Have you gathered the mandrake and the 5 voodoo dolls from the dworcs?", npc, creature)
		npcHandler:setTopic(playerId, 5)
		return true
	elseif MsgContains(message, "tribal masks") or MsgContains(message, "banana staff") then
		npcHandler:say("Have you gathered the 5 tribal masks and the 5 banana staves?", npc, creature)
		npcHandler:setTopic(playerId, 6)
		return true
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 5 then
		if player:getItemCount(3002) >= 5 and player:getItemCount(5014) >= 1 then
			player:removeItem(3002, 5)
			player:removeItem(5014, 1)
			player:addOutfitAddon(158, 2)
			player:addOutfitAddon(154, 2)
			player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.AddonStaffMask, 2)
			player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.MissionStaff, 2)
			player:addAchievement("Way of the Shaman")
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			npcHandler:say("I am proud of you, my child, excellent work. This staff shall be yours from now on!", npc, creature)
		else
			npcHandler:say("You don't have the necessary items.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 6 then
		if player:getItemCount(3348) >= 5 and player:getItemCount(3403) >= 5 then
			player:removeItem(3348, 5)
			player:removeItem(3403, 5)
			player:addOutfitAddon(158, 1)
			player:addOutfitAddon(154, 1)
			player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.AddonStaffMask, 4)
			player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.MissionMask, 2)
			player:addAchievement("Way of the Shaman")
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			npcHandler:say("Well done, my child! I hereby grant you the right to wear a shamanic mask. Do it proudly.", npc, creature)
		else
			npcHandler:say("You don't have the necessary items.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say({
			"The dworcs of Tiquanda like to wear certain tribal masks which I would like to take a look at. Please bring me 5 of these masks. ...",
			"Secondly, the high ape magicians of Banuta use banana staves. I would love to learn more about these staves, so please bring me 5 of them also. ...",
			"If you manage to fulfil this task, I will grant you your own mask. Have you understood everything and are ready for this test?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 4)
		return true
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say({
			"Good! Come back once you have collected 5 tribal masks and 5 banana staves.",
			"I shall grant you a sign of your progress as shaman if you can fulfil my task.",
		}, npc, creature)
		player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.AddonStaffMask, 3)
		player:setStorageValue(Storage.Quest.U7_8.ShamanOutfits.MissionMask, 1)
		npcHandler:setTopic(playerId, 0)
		return true
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) > 2 then
		npcHandler:say("Maybe next time.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return false
end

local function handleOtherMessages(npcHandler, npc, creature, message, playerId)
	local player = Player(creature)

	if MsgContains(message, "stampor") or MsgContains(message, "mount") then
		if not player:hasMount(11) then
			npcHandler:say("You did bring all the items I requested, child. Good. Shall I travel to the spirit realm and try finding a stampor companion for you?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:say("You already have stampor mount.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 11 then
			npcHandler:say("The evil cult has placed a curse on one of the captains here. I need at least five of their pirate voodoo dolls to lift that curse.", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 12)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 12 then
			npcHandler:say("Did you bring five pirate voodoo dolls?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 7 then
			if player:removeItem(12312, 50) and player:removeItem(12314, 30) and player:removeItem(12313, 100) then
				npcHandler:say({
					"Ohhhhh Mmmmmmmmmmmm Ammmmmgggggggaaaaaaa ...",
					"Aaaaaaaaaahhmmmm Mmmaaaaaaaaaa Kaaaaaamaaaa ...",
					"Brrt! I think it worked! It's a male stampor. I linked this spirit to yours. You can probably already summon him to you ...",
					"So, since we are done here... I need to prepare another ritual, so please let me work, child.",
				}, npc, creature)
				player:addMount(11)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			else
				npcHandler:say("Sorry you don't have the necessary items.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 12 then
				if player:removeItem(5810, 5) then
					npcHandler:say("Finally I can put an end to that curse. I thank you so much.", npc, creature)
					player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 13)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You don't have it...", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say("This is really not advisable. Behind this barrier, strong forces are raging violently. Are you sure that you want to go there?", npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 10 then
			npcHandler:say({
				"I guess I cannot stop you then. Since you told me about my apprentice, it is my turn to help you. I will perform a ritual for you, but I need a few ingredients. ...",
				"Bring me one fresh dead chicken, one fresh dead rat and one fresh dead black sheep, in that order.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 11 then
			if player:getItemCount(4330) > 0 then
				player:removeItem(4330, 1)
				player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, 2)
				npcHandler:say("Very good! <mumble> 'Your soul shall be protected!' Now, I need a fresh dead rat.", npc, creature)
				return true
			else
				npcHandler:say("You don't have the necessary items.", npc, creature)
				return true
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 12 then
			if player:getItemCount(3994) > 0 then
				player:removeItem(3994, 1)
				player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, 3)
				npcHandler:say("Very good! <chants and dances> 'You shall face black magic without fear!' Now, I need a fresh dead black sheep.", npc, creature)
				return true
			else
				npcHandler:say("You don't have the necessary items.", npc, creature)
				return true
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 13 then
			if player:getItemCount(4095) > 0 then
				player:removeItem(4095, 1)
				player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, 4)
				npcHandler:say("Very good! <stomps staff on ground> 'EVIL POWERS SHALL NOT KEEP YOU ANYMORE! SO BE IT!'", npc, creature)
				return true
			else
				npcHandler:say("You don't have the necessary items.", npc, creature)
				return true
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "stake") then
		if player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 11 then
			npcHandler:say("Ten prayers for a blessed stake? Don't tell me they made you travel whole Tibia for it! Listen, child, if you bring me a wooden stake, I'll bless it for you. <chuckles>", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, 12)
			player:addAchievement("Blessed!")
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		elseif player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 12 then
			if player:getItemCount(5941) == 0 then
				npcHandler:say("You don't have a wooden stake.", npc, creature)
				return true
			elseif player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStakeWaitTime) >= os.time() then
				npcHandler:say("Sorry, but I'm still exhausted from the last ritual. Please come back later.", npc, creature)
				return true
			else
				player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStakeWaitTime, os.time() + 7 * 86400)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:removeItem(5941, 1)
				player:addItem(5942, 1)
				npcHandler:say("<mumblemumble> Sha Kesh Mar!", npc, creature)
				return true
			end
		end
	elseif MsgContains(message, "counterspell") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.DragahsSpellbook) == -1 then
			npcHandler:say("You should not talk about things you don't know anything about.", npc, creature)
			return true
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) == -1 then
			npcHandler:say("You mean, you are interested in a counterspell to cross the energy barrier on Goroma?", npc, creature)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell, 0)
			npcHandler:setTopic(playerId, 9)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) == 1 then
			npcHandler:say("Did you bring the fresh dead chicken?", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) == 2 then
			npcHandler:say("Did you bring the fresh dead rat?", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) == 3 then
			npcHandler:say("Did you bring the fresh dead black sheep?", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.TheCounterspell) == 4 then
			npcHandler:say("Hm. I don't think you need another one of my counterspells to cross the barrier on Goroma.", npc, creature)
			return true
		end
	elseif MsgContains(message, "spellbook") then
		if player:getItemCount(6120) > 0 then
			npcHandler:say("Ah, thank you very much! I'll honour his memory.", npc, creature)
			player:removeItem(6120, 1)
			player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.DragahsSpellbook, 1)
			return true
		else
			npcHandler:say("You don't have the necessary items.", npc, creature)
			return true
		end
	elseif MsgContains(message, "energy field") then
		npcHandler:say("Ah, the energy barrier set up by the cult is maintained by lousy magic, but it's still effective. Without a proper counterspell, you won't be able to pass it.", npc, creature)
		return true
	end

	return false
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if handleAddonMessages(npcHandler, npc, creature, message, playerId) then
		return true
	end

	if handleOtherMessages(npcHandler, npc, creature, message, playerId) then
		return true
	end

	return false
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, child.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "black skull", clientId = 9056, sell = 4000 },
	{ itemName = "blood goblet", clientId = 8531, sell = 10000 },
	{ itemName = "blood herb", clientId = 3734, sell = 500 },
	{ itemName = "enigmatic voodoo skull", clientId = 5669, sell = 4000 },
	{ itemName = "mysterious voodoo skull", clientId = 5668, sell = 4000 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
