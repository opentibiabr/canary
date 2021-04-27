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
	if msgcontains(msg, 'stampor') or msgcontains(msg, 'mount') then
		if not player:hasMount(11) then
			npcHandler:say(
				'You did bring all the items I requqested, cuild. Good. \
				Shall I travel to the spirit realm and try finding a stampor compasion for you?',
			cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('You already have stampor mount.', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 8 then
			npcHandler:say(
				'The evil cult has placed a curse on one of the captains here. \
				I need at least five of their pirate voodoo dolls to lift that curse.',
			cid)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 9)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 9 then
			npcHandler:say('Did you bring five pirate voodoo dolls?', cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			if player:removeItem(13299, 50) and player:removeItem(13301, 30) and player:removeItem(13300, 100) then
				npcHandler:say(
					{
						'Ohhhhh Mmmmmmmmmmmm Ammmmmgggggggaaaaaaa ...',
						'Aaaaaaaaaahhmmmm Mmmaaaaaaaaaa Kaaaaaamaaaa ...',
						"Brrt! I think it worked! It's a male stampor. \
						I linked this spirit to yours. You can probably already summon him to you ...",
						'So, since me are done here... I need to prepare another ritual, so please let me work, cuild.'
					},
				cid)
				player:addMount(11)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			else
				npcHandler:say("Sorry you don't have the necessary items.", cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 9 then
				if player:removeItem(5810, 5) then
					npcHandler:say('Finally I can put an end to that curse. I thank you so much.', cid)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 10)
					npcHandler.topic[cid] = 0
				else
					npcHandler:say("You don't have it...", cid)
					npcHandler.topic[cid] = 0
				end
			end
		end
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] > 2 then
		npcHandler:say('Maybe next time.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Shaman Addons
-- If the player can't wear shaman outfit
local function notReadyKeyword(keyword, text)
	keywordHandler:addKeyword(
		{keyword},
		StdModule.say,
		{npcHandler = npcHandler, text = text},
		function(player)
			return not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 158 or 154)
		end
	)
end

notReadyKeyword(
	'outfit',
	{
		"Hum? Sorry, but I don't sense enough spiritual wisdom in you to even allow \
		you to touch the mask and staff I'm wearing... yet. ...",
		'I know of a really wise ape healer, though, who might be able to bless you with shamanic energy. \
		You should become his apprentice first if you desire to become mine.'
	}
)
notReadyKeyword(
	'addon',
	{
		"Hum? Sorry, but I don't sense enough spiritual wisdom in you to even allow \
		you to touch the mask and staff I'm wearing... yet. ...",
		'I know of a really wise ape healer, though, who might be able to bless you with shamanic energy. \
		You should become his apprentice first if you desire to become mine.'
	}
)
notReadyKeyword('task', "The time hasn't come yet, my child. Believe and learn.")

-- Start task
local function addTaskKeyword(text, value, missionStorage)
	local taskKeyword =
		keywordHandler:addKeyword(
		{'task'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[1]},
		function(player)
			return player:getStorageValue(Storage.OutfitQuest.Shaman.AddonStaffMask) == value
		end
	)
	local yesKeyword = taskKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = text[2]})

	yesKeyword:addChildKeyword(
		{'yes'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[3], reset = true},
		nil,
		function(player)
			player:setStorageValue(
				Storage.OutfitQuest.Shaman.AddonStaffMask,
				math.max(0, player:getStorageValue(Storage.OutfitQuest.Shaman.AddonStaffMask)) + 1
			)
			player:setStorageValue(missionStorage, 1)
			player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1)
		end
	)
	yesKeyword:addChildKeyword(
		{'no'},
		StdModule.say,
		{npcHandler = npcHandler, text = 'Would you like me to repeat the task requirements then?', moveup = 2}
	)

	taskKeyword:addChildKeyword(
		{'no'},
		StdModule.say,
		{npcHandler = npcHandler, text = "Well, it seems you aren't ready yet.", reset = true}
	)
	keywordHandler:addAliasKeyword({'addon'})
	keywordHandler:addAliasKeyword({'outfit'})
end

-- Staff
addTaskKeyword(
	{
		"If you fulfil a task for me, I'll grant you a staff like the one I'm wearing. \
		Do you want to hear the requirements?",
		{
			'Deep in the Tiquandian jungle a monster lurks which is seldom seen. \
			It is the revenge of the jungle against humankind. ...',
			'This monster, if slain, carries a rare root called Mandrake. If you find it, bring it to me. \
			Also, gather 5 of the voodoo dolls used by the mysterious dworc voodoomasters. ...',
			'If you manage to fulfil this task, I will grant you your own staff. \
			Have you understood everything and are ready for this test?'
		},
		"Good! Come back once you've found a mandrake and collected 5 dworcish voodoo dolls."
	},
	-1,
	Storage.OutfitQuest.Shaman.MissionStaff
)

-- Mask
addTaskKeyword(
	{
		"You have successfully passed the first task. \
		If you can fulfil my second task, I'll grant you a mask like the one I'm wearing. \
		Do you want to hear the requirements?",
		{
			"The dworcs of Tiquanda like to wear certain tribal masks which I'd like to take a look at. \
			Please bring me 5 of these masks. ...",
			"Secondly, the high ape magicians of Banuta use banana staffs. \
			I'd love to learn more about theses staffs, so please bring me 5 of them, too. ...",
			"If you manage to fulfil this task, I'll grant you your own mask. \
			Have you understood everything and are you ready for this test?"
		},
		'Good! Come back once you have collected 5 tribal masks and 5 banana staffs.'
	},
	2,
	Storage.OutfitQuest.Shaman.MissionMask
)

-- Hand in task items
local function addItemKeyword(keyword, aliasKeyword, text, value, item, addonId, missionStorage, achievement)
	local itemKeyword =
		keywordHandler:addKeyword(
		{keyword},
		StdModule.say,
		{npcHandler = npcHandler, text = text[1]},
		function(player)
			return player:getStorageValue(Storage.OutfitQuest.Shaman.AddonStaffMask) == value
		end
	)
	itemKeyword:addChildKeyword(
		{'yes'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[2], reset = true},
		function(player)
			return player:getItemCount(item[1].itemId) < item[1].count or player:getItemCount(item[2].itemId) < item[2].count
		end
	)

	itemKeyword:addChildKeyword(
		{'yes'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[3], reset = true},
		function(player)
			return player:getItemCount(item[1].itemId) >= item[1].count and player:getItemCount(item[2].itemId) >= item[2].count
		end,
		function(player)
			player:removeItem(item[1].itemId, item[1].count)
			player:removeItem(item[2].itemId, item[2].count)
			player:addOutfitAddon(158, addonId)
			player:addOutfitAddon(154, addonId)
			player:setStorageValue(
				Storage.OutfitQuest.Shaman.AddonStaffMask,
				player:getStorageValue(Storage.OutfitQuest.Shaman.AddonStaffMask) + 1
			)
			player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
			player:setStorageValue(missionStorage, 0)
			if achievement then
				player:addAchievement('Way of the Shaman')
			end
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		end
	)
	itemKeyword:addChildKeyword(
		{'no'},
		StdModule.say,
		{npcHandler = npcHandler, text = "Well, it seems you aren't ready yet.", reset = true}
	)
	keywordHandler:addAliasKeyword({aliasKeyword})
	keywordHandler:addKeyword(
		{keyword},
		StdModule.say,
		{npcHandler = npcHandler, text = aliasKeyword and text[4] or text[3]}
	)
end

addItemKeyword(
	'mandrake',
	'voodoo doll',
	{
		'Have you gathered the mandrake and the 5 voodoo dolls from the dworcs?',
		"I'm proud of you my child, excellent work. This staff shall be yours from now on!",
		'A rare root with mysterious powers.',
		{
			'Together with the spirits of the ancestors, I seek for wisdom. \
			Together we can change the flow of magic to do things that are beyond the limits of ordinary magic. ...',
			'In conversations with the spirits, I gain insight into secrets that would have been lost otherwise.'
		}
	},
	1,
	{{itemId = 5015, count = 1}, {itemId = 3955, count = 5}},
	2,
	Storage.OutfitQuest.Shaman.MissionStaff
)
addItemKeyword(
	'tribal mask',
	'banana staff',
	{
		'Have you gathered the 5 tribal masks and the 5 banana staffs?',
		'Well done, my child! I hereby grant you the right to wear a shamanic mask. Do it proudly.',
		'Sometimes dworcs are seen with these masks.',
		'A banana staff is the sign of a high ape magician.'
	},
	3,
	{{itemId = 3966, count = 5}, {itemId = 3967, count = 5}},
	1,
	Storage.OutfitQuest.Shaman.MissionMask,
	true
)

-- Task status
local function addTaskStatusKeyword(keyword, text, value)
	keywordHandler:addKeyword(
		{keyword},
		StdModule.say,
		{npcHandler = npcHandler, text = text},
		function(player)
			return player:getStorageValue(Storage.OutfitQuest.Shaman.AddonStaffMask) == value
		end
	)
	if keyword == 'addon' then
		keywordHandler:addAliasKeyword({'outfit'})
	end
end

addTaskStatusKeyword(
	'task',
	'Your task is to retrieve a mandrake from the Tiquandan jungle and 5 dworcish voodoo dolls.',
	1
)
addTaskStatusKeyword(
	'task',
	'Your task is to retrieve 5 tribal masks from the dworcs and 5 banana staffs from the apes.',
	3
)
addTaskStatusKeyword(
	'task',
	'You have successfully passed all of my tasks. There are no further things I can teach you right now.',
	4
)

addTaskStatusKeyword(
	'addon',
	'The time has come, my child. I sense great spiritual wisdom in you and I shall grant you a \
	sign of your progress if you can fulfil my task.',
	1
)
addTaskStatusKeyword('addon', 'I shall grant you a sign of your progress as a shaman if you can fulfil my task.', 3)
addTaskStatusKeyword(
	'addon',
	'You have successfully passed all of my tasks. There are no further things I can teach you right now.',
	4
)
-- End Shaman Addons

-- Wooden Stake
keywordHandler:addKeyword(
	{'stake'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ten prayers for a blessed stake? Don't tell me they made you travel whole Tibia for it! \
		Listen, child, if you bring me a wooden stake, I'll bless it for you. <chuckles>"
	},
	function(player)
		return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 11
	end,
	function(player)
		player:setStorageValue(Storage.FriendsandTraders.TheBlessedStake, 12)
		player:addAchievement('Blessed!')
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
)

local stakeKeyword =
	keywordHandler:addKeyword(
	{'stake'},
	StdModule.say,
	{npcHandler = npcHandler, text = 'Would you like to receive a spiritual prayer to bless your stake?'},
	function(player)
		return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 12
	end
)

stakeKeyword:addChildKeyword(
	{'yes'},
	StdModule.say,
	{npcHandler = npcHandler, text = "You don't have a wooden stake.", reset = true},
	function(player)
		return player:getItemCount(5941) == 0
	end
)

stakeKeyword:addChildKeyword(
	{'yes'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sorry, but I'm still exhausted from the last ritual. Please come back later.",
		reset = true
	},
	function(player)
		return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStakeWaitTime) >= os.time()
	end
)

stakeKeyword:addChildKeyword(
	{'yes'},
	StdModule.say,
	{npcHandler = npcHandler, text = '<mumblemumble> Sha Kesh Mar!', reset = true},
	function(player)
		return player:getItemCount(5941) > 0
	end,
	function(player)
		player:setStorageValue(Storage.FriendsandTraders.TheBlessedStakeWaitTime, os.time() + 7 * 86400)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:removeItem(5941, 1)
		player:addItem(5942, 1)
	end
)
stakeKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe another time.', reset = true})

-- Counterspell
keywordHandler:addKeyword(
	{'counterspell'},
	StdModule.say,
	{npcHandler = npcHandler, text = "You should not talk about things you don't know anything about."},
	function(player)
		return player:getStorageValue(Storage.TheShatteredIsles.DragahsSpellbook) == -1
	end
)
keywordHandler:addAliasKeyword({'energy field'})

-- Start mission
local startcounterspellKeyword =
	keywordHandler:addKeyword(
	{'counterspell'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'You mean, you are interested in a counterspell to cross the energy barrier on Goroma?'
	},
	function(player)
		return player:getStorageValue(Storage.TheShatteredIsles.TheCounterspell) == -1
	end
)
local acceptKeyword =
	startcounterspellKeyword:addChildKeyword(
	{'yes'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'This is really not advisable. Behind this barrier, strong forces are raging violently. \
		Are you sure that you want to go there?'
	}
)
acceptKeyword:addChildKeyword(
	{'yes'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"I guess I cannot stop you then. Since you told me about my apprentice, it's my turn to help you. \
			I'll perform a ritual for you, but I need a few ingredients. ...",
			'Bring me one fresh dead chicken, one fresh dead rat and one fresh dead black sheep, in that order.'
		},
		reset = true
	},
	nil,
	function(player)
		player:setStorageValue(Storage.TheShatteredIsles.TheCounterspell, 1)
	end
)
acceptKeyword:addChildKeyword(
	{'no'},
	StdModule.say,
	{npcHandler = npcHandler, text = "It's much safer for you to stay here anyway, trust me.", reset = true}
)

startcounterspellKeyword:addChildKeyword(
	{'no'},
	StdModule.say,
	{npcHandler = npcHandler, text = "It's much safer for you to stay here anyway, trust me.", reset = true}
)

-- Deliver in corpses
local function addCounterspellKeyword(text, value, itemId)
	local counterspellKeyword =
		keywordHandler:addKeyword(
		{'counterspell'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[1]},
		function(player)
			return player:getStorageValue(Storage.TheShatteredIsles.TheCounterspell) == value
		end
	)
	counterspellKeyword:addChildKeyword(
		{'yes'},
		StdModule.say,
		{npcHandler = npcHandler, text = text[2], reset = true},
		function(player)
			return player:getItemCount(itemId) > 0
		end,
		function(player)
			player:removeItem(itemId, 1)
			player:setStorageValue(Storage.TheShatteredIsles.TheCounterspell, value + 1)
		end
	)
end

addCounterspellKeyword(
	{
		'Did you bring the fresh dead chicken?',
		"Very good! <mumblemumble> 'Your soul shall be protected!' Now, I need a fresh dead rat."
	},
	1,
	4265
)
addCounterspellKeyword(
	{
		'Did you bring the fresh dead rat?',
		"Very good! <chants and dances> 'You shall face black magic without fear!' Now, I need a fresh dead black sheep."
	},
	2,
	2813
)
addCounterspellKeyword(
	{
		'Did you bring the fresh dead black sheep?',
		"Very good! <stomps staff on ground> 'EVIL POWERS SHALL NOT KEEP YOU ANYMORE! SO BE IT!'"
	},
	3,
	2914
)

-- Completed the Counterspell
keywordHandler:addKeyword(
	{'counterspell'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hm. I don't think you need another one of my counterspells to cross the barrier on Goroma."
	}
)

-- Spellbook
keywordHandler:addKeyword(
	{'spellbook'},
	StdModule.say,
	{npcHandler = npcHandler, text = "Ah, thank you very much! I'll honour his memory."},
	function(player)
		return player:getItemCount(6120) > 0
	end,
	function(player)
		player:removeItem(6120, 1)
		player:setStorageValue(Storage.TheShatteredIsles.DragahsSpellbook, 1)
	end
)

-- Energy Field
keywordHandler:addKeyword(
	{'energy field'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, the energy barrier set up by the cult is maintained by lousy magic, but it's still effective. \
		Without a proper counterspell, you won't be able to pass it."
	}
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
