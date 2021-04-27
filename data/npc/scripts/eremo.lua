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
	if msgcontains(msg, 'letter') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 4 then
			if player:getItemCount(8188) > 0 then
				if player:removeItem(8188, 1) then
					npcHandler:say(
						'A letter from that youngster Morgan? I believed him dead since years. \
						These news are good news indeed. Thank you very much, my friend.',
					cid)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 5)
				end
			end
		end
	end
	return true
end

-- Wisdom of Solitude
local blessKeyword = keywordHandler:addKeyword({'solitude'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Would you like to receive that protection for a sacrifice of |BLESSCOST| gold, child?'
	}
)
blessKeyword:addChildKeyword({'yes'}, StdModule.bless,
	{
		npcHandler = npcHandler,
		text = 'So receive the wisdom of solitude, pilgrim.',
		cost = '|BLESSCOST|',
		bless = 2
	}
)
blessKeyword:addChildKeyword({''}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Fine. You are free to decline my offer.',
		reset = true
	}
)
keywordHandler:addAliasKeyword({'wisdom'})

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({'heal'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = text
	},
	function(player)
		return player:getCondition(condition) ~= nil
	end,
	function(player)
		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end
)
end

addHealKeyword('You are burning. Let me quench those flames.', CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword('You are poisoned. Let me soothe your pain.', CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword('You are electrified, my child. Let me help you to stop trembling.',
CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({'heal'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'You are hurt, my child. I will heal your wounds.'
	},
	function(player)
		return player:getHealth() < 40
	end,
	function(player)
	local health = player:getHealth()
	if health < 40 then
		player:addHealth(40 - health)
	end
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
end
)
keywordHandler:addKeyword({'heal'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'You aren\'t looking that bad. Sorry, I can\'t help you. But if you are looking for additional \
		protection you should go on the {pilgrimage} of ashes or get the protection of the {twist of fate} here.'
	}
)

-- Teleport back
local teleportKeyword = keywordHandler:addKeyword({'cormaya'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Should I teleport you back to Pemaret?'
	}
)
teleportKeyword:addChildKeyword({'yes'}, StdModule.travel,
	{
		npcHandler = npcHandler,
		text = 'Here you go!',
		premium  = false,
		destination = Position(33288, 31956, 6)
	}
)
teleportKeyword:addChildKeyword({''}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Maybe later.', ungreet = true
	}
)

keywordHandler:addAliasKeyword({'back'})
keywordHandler:addAliasKeyword({'passage'})
keywordHandler:addAliasKeyword({'pemaret'})

-- Basic
keywordHandler:addKeyword({'pilgrimage'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'Whenever you receive a lethal wound, your vital force is damaged and there is a \
		chance that you lose some of your equipment. With every single of the five {blessings} you have, \
		this damage and chance of loss will be reduced.'
	}
)
keywordHandler:addKeyword({'blessings'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'There are five blessings available in five sacred places: the {spiritual} shielding, \
		the spark of the {phoenix}, the {embrace} of Tibia, the fire of the {suns} and the wisdom of {solitude}. \
		Additionally, you can receive the {twist of fate} here.'
	}
)
keywordHandler:addKeyword({'spiritual'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I see you received the spiritual shielding in the whiteflower temple south of Thais.'
	},
	function(player)
		return player:hasBlessing(1)
	end
)
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addKeyword({'embrace'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I can sense that the druids north of Carlin have provided you with the Embrace of Tibia.'
	},
	function(player)
		return player:hasBlessing(2)
	end
)
keywordHandler:addKeyword({'suns'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I can see you received the blessing of the two suns in the suntower near Ab\'Dendriel.'
	},
	function(player)
		return player:hasBlessing(3)
	end
)
keywordHandler:addAliasKeyword({'fire'})
keywordHandler:addKeyword({'phoenix'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I can sense that the spark of the phoenix already was given to you by \
		the dwarven priests of earth and fire in Kazordoon.'
	},
	function(player)
		return player:hasBlessing(4)
	end
)
keywordHandler:addAliasKeyword({'spark'})
keywordHandler:addKeyword({'spiritual'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'You can ask for the blessing of spiritual shielding in the whiteflower temple south of Thais.'
	}
)
keywordHandler:addAliasKeyword({'shield'})
keywordHandler:addKeyword({'embrace'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'The druids north of Carlin will provide you with the embrace of Tibia.'
	}
)
keywordHandler:addKeyword({'suns'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'You can ask for the blessing of the two suns in the suntower near Ab\'Dendriel.'
	}
)
keywordHandler:addAliasKeyword({'fire'})
keywordHandler:addKeyword({'phoenix'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon.'
	}
)
keywordHandler:addAliasKeyword({'spark'})
keywordHandler:addKeyword({'job'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I teach some spells, provide one of the five blessings, and sell some amulets. \
		Ask me for a trade if you like.'
	}
)
keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I am Eremo, an old man who has seen many things.'
	}
)

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to my little garden, adventurer |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'It was a pleasure to help you, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'It was a pleasure to help you, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
