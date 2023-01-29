local internalNpcName = "King Tibianus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 332
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "farmine") and player:getStorageValue(TheNewFrontier.Questline) == 14 then
		if player:getStorageValue(TheNewFrontier.Mission05.KingTibianus) == 1 then
			npcHandler:say(
			"Ah, I vaguely remember that our little allies were eager to build some base. So speak up, what do you want?",
			npc, creature)
			npcHandler:setTopic(playerId, 10)
		else
			npcHandler:say("Do you have anything that might change my mind?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.KingTibianus) == 1 then
		if npcHandler:getTopic(playerId) == 10 then
			npcHandler:say(
			"Indeed, indeed. Without the help of Thais, our allies stand no chance! Well, I'll send some money to support their cause.",
			npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.KingTibianus, 3)
		end
	elseif (MsgContains(message, "outfit")) or (MsgContains(message, "addon")) then
		npcHandler:say(
		"In exchange for a truly generous donation, I will offer a special outfit. Do you want to make a donation?",
		npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif (MsgContains(message, "yes")) then
		-- Vamos tratar todas condições para YES aqui
		if npcHandler:getTopic(playerId) == 1 then
			-- Para o primeiro Yes, o npc deve explicar como obter o outfit
			npcHandler:say(
			{"Excellent! Now, let me explain. If you donate 1.000.000.000 gold pieces, you will be entitled to wear a unique outfit. ...",
				"You will be entitled to wear the {armor} for 500.000.000 gold pieces, {helmet} for an additional 250.000.000 and the {boots} for another 250.000.000 gold pieces. ...",
			"What will it be?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
			-- O NPC só vai oferecer os addons se o player já tiver escolhido.
		elseif npcHandler:getTopic(playerId) == 2 then
			-- caso o player repita o yes, resetamos o tópico para começar de novo?
			npcHandler:say("In that case, return to me once you made up your mind.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			-- Inicio do outfit
		elseif npcHandler:getTopic(playerId) == 3 then -- ARMOR/OUTFIT
			if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) < 1 then
				if player:getMoney() + player:getBankBalance() >= 500000000 then
					local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
					if inbox and inbox:getEmptySlots() > 0 then
						local decoKit = inbox:addItem(23398, 1)
						local decoItemName = ItemType(31510):getName()
						decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION,
						"Unwrap it in your own house to create a " .. decoItemName .. ".")
						decoKit:setCustomAttribute("unWrapId", 31510)
						npcHandler:say(
						"Take this armor as a token of great gratitude. Let us forever remember this day, my friend!",
						npc, creature)
						player:removeMoneyBank(500000000)
						player:addOutfit(1211)
						player:addOutfit(1210)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.GoldenOutfit, 1)
					else
						npcHandler:say("Please make sure you have free slots in your store inbox.", npc, creature)
					end
				else
					npcHandler:say("You do not have enough money to donate that amount.", npc, creature)
				end
			else
				npcHandler:say("You alread have that addon.", npc, creature)
			end
			npcHandler:setTopic(playerId, 2)
			-- Fim do outfit
			-- Inicio do helmet
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) == 1 then
				if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) < 2 then
					if player:getMoney() + player:getBankBalance() >= 250000000 then
						npcHandler:say(
						"Take this helmet as a token of great gratitude. Let us forever remember this day, my friend. ",
						npc, creature)
						player:removeMoneyBank(250000000)
						player:addOutfitAddon(1210, 2)
						player:addOutfitAddon(1211, 2)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.GoldenOutfit, 2)
						npcHandler:setTopic(playerId, 2)
					else
						npcHandler:say("You do not have enough money to donate that amount.", npc, creature)
						npcHandler:setTopic(playerId, 2)
					end
				else
					npcHandler:say("You alread have that outfit.", npc, creature)
					npcHandler:setTopic(playerId, 2)
				end
			else
				npcHandler:say("You need to donate {armor} outfit first.", npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
			npcHandler:setTopic(playerId, 2)
			-- Fim do helmet
			-- Inicio da boots
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) == 2 then
				if player:getStorageValue(Storage.OutfitQuest.GoldenOutfit) < 3 then
					if player:getMoney() + player:getBankBalance() >= 250000000 then
						npcHandler:say(
						"Take this boots as a token of great gratitude. Let us forever remember this day, my friend. ",
						npc, creature)
						player:removeMoneyBank(250000000)
						player:addOutfitAddon(1210, 1)
						player:addOutfitAddon(1211, 1)
						player:getPosition():sendMagicEffect(171)
						player:setStorageValue(Storage.OutfitQuest.GoldenOutfit, 3)
						npcHandler:setTopic(playerId, 2)
					else
						npcHandler:say("You do not have enough money to donate that amount.", npc, creature)
						npcHandler:setTopic(playerId, 2)
					end
				else
					npcHandler:say("You alread have that outfit.", npc, creature)
					npcHandler:setTopic(playerId, 2)
				end
			else
				npcHandler:say("You need to donate {helmet} addon first.", npc, creature)
				npcHandler:setTopic(playerId, 2)
			end
			-- Fim da boots
			npcHandler:setTopic(playerId, 2)
			-- Reseting word The New Frontier: Mission 5
		elseif npcHandler:getTopic(playerId) == 6 then
			if player:getStorageValue(TheNewFrontier.Questline) == 14 and
			player:getStorageValue(TheNewFrontier.Mission05.KingTibianus) == 2 and player:removeItem(10009, 1) then
				npcHandler:say(
				"Ah, I vaguely remember that our little allies were eager to build some base. So speak up, what do you want?",
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.KingTibianus, 1)
				npcHandler:setTopic(playerId, 10)
			end

		end
		-- inicio das opções armor/helmet/boots
		-- caso o player não diga YES, dirá alguma das seguintes palavras:
	elseif (MsgContains(message, "armor")) and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say(
		"So you wold like to donate 500.000.000 gold pieces which in return will entitle you to wear a unique armor?",
		npc, creature)
		npcHandler:setTopic(playerId, 3) -- alterando o tópico para que no próximo YES ele faça o outfit
	elseif (MsgContains(message, "helmet")) and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say(
		"So you would like to donate 250.000.000 gold pieces which in return will entitle you to wear unique helmet?",
		npc, creature)
		npcHandler:setTopic(playerId, 4) -- alterando o tópico para que no próximo YES ele faça o helmet
	elseif (MsgContains(message, "boots")) and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say(
		"So you would like to donate 250.000.000 gold pieces which in return will entitle you to wear a unique boots?",
		npc, creature)
		npcHandler:setTopic(playerId, 5) -- alterando o tópico para que no próximo YES ele faça a boots
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and
		player:getStorageValue(TheNewFrontier.Mission05.KingTibianus) == 1 then
			npcHandler:say("Wrong Word.", npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.KingTibianus, 2)
		end
	end
	-- fim das opções armor/helmet/boots
end
-- Promotion
local node1 = keywordHandler:addKeyword({'promot'}, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = 'I can promote you for 20000 gold coins. Do you want me to promote you?'
})
node1:addChildKeyword({'yes'}, StdModule.promotePlayer, {
	npcHandler = npcHandler,
	cost = 20000,
	level = 20,
	text = 'Congratulations! You are now promoted.'
})
node1:addChildKeyword({'no'}, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = 'Alright then, come back when you are ready.',
		reset = true
})
-- Basic
keywordHandler:addKeyword({'eremo'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'It is said that he lives on a small island near Edron. Maybe the people there know more about him.'
})
keywordHandler:addKeyword({'otbr'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Awesome! Please pay a visit to www.otserv.com.br!'
})
keywordHandler:addKeyword({'baah'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Baah is awesome dude that rewrote my outfit script.'
})
keywordHandler:addKeyword({'job'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'I am your sovereign, King Tibianus III, and it\'s my duty to uphold {justice} and provide guidance for my subjects.'
})
keywordHandler:addKeyword({'justice'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'I try my best to be just and fair to our citizens. The army and the {TBI} are a great help in fulfilling this duty.'
})
keywordHandler:addKeyword({'name'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Preposterous! You must know the name of your own King!'
})
keywordHandler:addKeyword({'news'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The latest news is usually brought to our magnificent town by brave adventurers. They recount tales of their journeys at Frodo\'s tavern.'
})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Thank you, I\'m fine.'
})
keywordHandler:addKeyword({'castle'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Rain Castle is my home.'
})
keywordHandler:addKeyword({'sell'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Sell? Sell what? My kingdom isn\'t for sale!'
})
keywordHandler:addKeyword({'god'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Honour the Gods and above all pay your {taxes}.'
})
keywordHandler:addKeyword({'zathroth'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Please ask a priest about the gods.'
})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The citizens of Tibia are my subjects. Ask the old monk Quentin if you want to learn more about them.'
})
keywordHandler:addKeyword({'sam'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He is a skilled blacksmith and a loyal subject.'
})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He is the owner of Frodo\'s Hut and a faithful tax-payer.'
})
keywordHandler:addKeyword({'gorn'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He was once one of Tibia\'s greatest fighters. Now he sells equipment.'
})
keywordHandler:addKeyword({'benjamin'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He was once my greatest general. Now he is very old and senile so we assigned him to work for the Royal Tibia Mail.'
})
keywordHandler:addKeyword({'noodles'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The royal poodle Noodles is my greatest {treasure}!'
})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He is a follower of the evil God Zathroth and responsible for many attacks on us. Kill him on sight!'
})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'He is my royal jester and cheers me up now and then.'
})
keywordHandler:addKeyword({'treasure'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The royal poodle Noodles is my greatest treasure!'
})
keywordHandler:addKeyword({'monster'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Go and hunt them! For king and country!'
})
keywordHandler:addKeyword({'help'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Visit Quentin the monk for help.'
})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'What a disgusting topic!'
})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Dungeons are no places for kings.'
})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Feel free to buy it in our town\'s fine shops.'
})
keywordHandler:addKeyword({'food'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Ask the royal cook for some food.'
})
keywordHandler:addKeyword({'tax collector'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'That tax collector is the bane of my life. He is so lazy. I bet you haven\'t payed any taxes at all.'
})
keywordHandler:addKeyword({'king'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'I am the king, so watch what you say!'
})
keywordHandler:addKeyword({'army'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Ask the soldiers about that.'
})
keywordHandler:addKeyword({'shop'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Visit the shops of our merchants and craftsmen.'
})
keywordHandler:addKeyword({'guild'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The four major guilds are the knights, the paladins, the druids, and the sorcerers.'
})
keywordHandler:addKeyword({'minotaur'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Vile monsters, but I must admit they are strong and sometimes even cunning ... in their own bestial way.'
})
keywordHandler:addKeyword({'good'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The forces of good are hard pressed in these dark times.'
})
keywordHandler:addKeyword({'evil'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'We need all strength we can muster to smite evil!'
})
keywordHandler:addKeyword({'order'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'We need order to survive!'
})
keywordHandler:addKeyword({'chaos'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Chaos arises from selfishness.'
})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'It\'s the sword of the Kings. If you return this weapon to me I will {reward} you beyond your wildest dreams.'
})
keywordHandler:addKeyword({'reward'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Well, if you want a reward, go on a quest to bring me Excalibug!'
})
keywordHandler:addKeyword({'chester'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'A very competent person. A little nervous but very competent.'
})
keywordHandler:addKeyword({'tbi'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'This organisation is an essential tool for holding our enemies in check. Its headquarter is located in the bastion in the northwall.'
})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Soon the whole land will be ruled by me once again!'
})
keywordHandler:addAliasKeyword({'land'})
keywordHandler:addKeyword({'harkath'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Harkath Bloodblade is the general of our glorious {army}.'
})
keywordHandler:addAliasKeyword({'bloodblade'})
keywordHandler:addAliasKeyword({'general'})
keywordHandler:addKeyword({'quest'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'I will call for heroes as soon as the need arises again and then reward them appropriately.'
})
keywordHandler:addAliasKeyword({'mission'})
keywordHandler:addKeyword({'gold'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'To pay your taxes, visit the royal tax collector.'
})
keywordHandler:addAliasKeyword({'money'})
keywordHandler:addAliasKeyword({'tax'})
keywordHandler:addAliasKeyword({'collector'})
keywordHandler:addKeyword({'time'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'It\'s a time for heroes!'
})
keywordHandler:addAliasKeyword({'hero'})
keywordHandler:addAliasKeyword({'adventurer'})
keywordHandler:addKeyword({'enemy'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Our enemies are numerous. The evil minotaurs, Ferumbras, and the renegade city of Carlin to the north are just some of them.'
})
keywordHandler:addAliasKeyword({'enemies'})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'They dare to reject my reign over the whole continent!'
})
keywordHandler:addKeyword({'thais'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Our beloved city has some fine shops, guildhouses and a modern sewerage system.'
})
keywordHandler:addAliasKeyword({'city'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'Ask around about them.'
})
keywordHandler:addAliasKeyword({'craftsmen'})
keywordHandler:addKeyword({'paladin'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The paladins are great protectors for Thais.'
})
keywordHandler:addAliasKeyword({'elane'})
keywordHandler:addKeyword({'knight'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The brave knights are necessary for human survival in Thais.'
})
keywordHandler:addAliasKeyword({'gregor'})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'The magic of the sorcerers is a powerful tool to smite our enemies.'
})
keywordHandler:addAliasKeyword({'muriel'})
keywordHandler:addKeyword({'druid'}, StdModule.say, {
	npcHandler = npcHandler,
	text = 'We need the druidic healing powers to fight evil.'
})
keywordHandler:addAliasKeyword({'marvik'})

-- Greeting message
keywordHandler:addGreetKeyword({"hail king"}, {
	npcHandler = npcHandler,
	text = "I greet thee, my loyal subject |PLAYERNAME|."
})
keywordHandler:addGreetKeyword({"salutations king"}, {
	npcHandler = npcHandler,
	text = "I greet thee, my loyal subject |PLAYERNAME|."
})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'How rude!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
