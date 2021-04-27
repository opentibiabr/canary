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

-- Wooden Stake
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'I think you have forgotten to bring your stake, my child.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 2 and player:getItemCount(5941) == 0 end)

local stakeKeyword = keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, I was informed what to do. Are you prepared to receive my line of the prayer?'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 2 end)
	stakeKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'So receive my prayer: \'Hope may fill your heart - doubt shall be banned\'. Now, bring your stake to Maealil in the elven settlement for the next line of the prayer. I will inform him what to do.', reset = true}, nil,
		function(player) player:setStorageValue(Storage.FriendsandTraders.TheBlessedStake, 3) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end
	)
	stakeKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'I will wait for you.', reset = true})

keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'You should visit Maealil in the elven settlement now, my child.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 3 end)
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'You already received my line of the prayer, dear child.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) > 3 end)
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'A blessed stake? That is a strange request, my child. Maybe Quentin knows more, he is one of the oldest monks after all.'})

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = text},
		function(player) return player:getCondition(condition) ~= nil end,
		function(player)
			player:removeCondition(condition)
			player:getPosition():sendMagicEffect(effect)
		end
	)
end

addHealKeyword('You are burning. Let me quench those flames.', CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword('You are poisoned. Let me soothe your pain.', CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword('You are electrified, my child. Let me help you to stop trembling.', CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You are hurt, my child. I will heal your wounds.'},
	function(player) return player:getHealth() < 40 end,
	function(player)
		local health = player:getHealth()
		if health < 40 then player:addHealth(40 - health) end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'You aren\'t looking that bad. Sorry, I can\'t help you. But if you are looking for additional protection you should go on the {pilgrimage} of ashes or get the protection of the {twist of fate} here.'})

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am a priest of the great pantheon.'})
keywordHandler:addKeyword({'life'}, StdModule.say, {npcHandler = npcHandler, text = 'The teachings of Crunor tell us to honor life and not to harm it.'})
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = 'It is my mission to bring the teachings of the gods to everyone.'})
keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'It is my mission to bring the teachings of the gods to everyone.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Tibra. Your soul tells me that you are |PLAYERNAME|.'})
keywordHandler:addKeyword({'queen'}, StdModule.say, {npcHandler = npcHandler, text = 'Queen Eloise is wise to listen to the proposals of the druidic followers of Crunor.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'The grace of the gods must be earned, it cannot be bought!'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'The world of Tibia is the creation of the gods.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Now, it is |TIME|.'})
keywordHandler:addKeyword({'crypt'}, StdModule.say, {npcHandler = npcHandler, text = 'There\'s something strange in its neighbourhood. But whom we gonna call for help if not the gods?'})
keywordHandler:addKeyword({'monsters'}, StdModule.say, {npcHandler = npcHandler, text = 'Remind: Not everything you call monster is evil to the core!'})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = 'The mythical blade was hidden in ancient times. Its said that powerful wards protect it.'})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = 'The fallen one should be mourned, not feared.'})
keywordHandler:addKeyword({'lugri'}, StdModule.say, {npcHandler = npcHandler, text = 'Only a man can fall as low as he did. His soul rotted away already.'})
keywordHandler:addKeyword({'gods'}, StdModule.say, {npcHandler = npcHandler, text = 'The gods of good guard us and guide us, the gods of evil want to destroy us and steal our souls!'})
keywordHandler:addKeyword({'gods of good'}, StdModule.say, {npcHandler = npcHandler, text = 'The gods we call the good ones are Fardos, Uman, the Elements, Suon, Crunor, Nornur, Bastesh, Kirok, Toth, and Banor.'})
keywordHandler:addKeyword({'fardos'}, StdModule.say, {npcHandler = npcHandler, text = 'Fardos is the creator. The great obsever. He is our caretaker.'})
keywordHandler:addKeyword({'uman'}, StdModule.say, {npcHandler = npcHandler, text = 'Uman is the positive aspect of magic. He brings us the secrets of the arcane arts.'})
keywordHandler:addKeyword({'air'}, StdModule.say, {npcHandler = npcHandler, text = 'Air is one of the primal elemental forces, sometimes worshipped by tribal shamans.'})
keywordHandler:addKeyword({'fire'}, StdModule.say, {npcHandler = npcHandler, text = 'Fire is one of the primal elemental forces, sometimes worshipped by tribal shamans.'})
keywordHandler:addKeyword({'sula'}, StdModule.say, {npcHandler = npcHandler, text = 'Sula is the essence of the elemental power of water.'})
keywordHandler:addKeyword({'suon'}, StdModule.say, {npcHandler = npcHandler, text = 'Suon is the lifebringing sun. He observes the creation with love.'})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = 'Crunor, the great tree, is the father of all plantlife. He is a prominent god for many druids.'})
keywordHandler:addKeyword({'nornur'}, StdModule.say, {npcHandler = npcHandler, text = 'Nornur is the mysterious god of fate. Who knows if he is its creator or just a chronist?'})
keywordHandler:addKeyword({'bastesh'}, StdModule.say, {npcHandler = npcHandler, text = 'Bastesh, the deep one, is the goddess of the sea and its creatures.'})
keywordHandler:addKeyword({'kirok'}, StdModule.say, {npcHandler = npcHandler, text = 'Kirok, the mad one, is the god of scientists and jesters.'})
keywordHandler:addKeyword({'toth'}, StdModule.say, {npcHandler = npcHandler, text = 'Toth, Lord of Death, is the keeper of the souls, the guardian of the afterlife.'})
keywordHandler:addKeyword({'banor'}, StdModule.say, {npcHandler = npcHandler, text = 'Banor, the heavenly warrior, is the patron of all fighters against evil. He is the gift of the gods to inspire humanity.'})
keywordHandler:addKeyword({'evil'}, StdModule.say, {npcHandler = npcHandler, text = 'The gods we call the evil ones are Zathroth, Fafnar, Brog, Urgith, and the Archdemons!'})
keywordHandler:addKeyword({'zathroth'}, StdModule.say, {npcHandler = npcHandler, text = 'Zathroth is the destructive aspect of magic. He is the deciver and the thief of souls.'})
keywordHandler:addKeyword({'fafnar'}, StdModule.say, {npcHandler = npcHandler, text = 'Fafnar is the scorching sun. She observes the creation with hate and jealousy.'})
keywordHandler:addKeyword({'brog'}, StdModule.say, {npcHandler = npcHandler, text = 'Brog, the raging one, is the great destroyer. The berserk of darkness.'})
keywordHandler:addKeyword({'urgith'}, StdModule.say, {npcHandler = npcHandler, text = 'The bonemaster Urgith is the lord of the undead and keeper of the damned souls.'})
keywordHandler:addKeyword({'archdemons'}, StdModule.say, {npcHandler = npcHandler, text = 'The demons are followers of Zathroth. The cruelest are known as the ruthless seven.'})
keywordHandler:addKeyword({'ruthless seven'}, StdModule.say, {npcHandler = npcHandler, text = 'I don\'t want to talk about that subject!'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome in the name of the gods, pilgrim |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|. May the gods be with you to guard and guide you, my child!')

npcHandler:addModule(FocusModule:new())
