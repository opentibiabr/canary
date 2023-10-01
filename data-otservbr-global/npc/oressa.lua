local internalNpcName = "Oressa"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 148,
	lookHead = 114,
	lookBody = 78,
	lookLegs = 96,
	lookFeet = 114,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "You can't take it all with you - sell your Dawnport things before \z
		you receive the gear of your definite vocation!"},
	{text = "Leave all Dawnport things behind you and choose your destiny!"},
	{text = "Come to me if you need healing!"},
	{text = "Choose your vocation and explore the mainland!"},
	{text = "Talk to me to choose your definite vocation! Become a knight, paladin, druid or sorcerer!"},
	{text = "World needs brave adventurers like you. Choose your vocation and sail to the mainland!"},
	{text = "Poisoned? Bleeding? Wounded? I can help!"}
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

-- Basic keywords
keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I am Oressa Fourwinds, the {healer}. "
	}
)
keywordHandler:addKeyword({"healer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If you are hurt my child, I will {heal} your wounds."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I can {heal} you if you are hurt. I can also help you choose your {vocation}. "
	}
)
keywordHandler:addKeyword({"doors"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Behind each of those doors, the equipment and skills of one vocation lies - \z
		sorcerer, paladin, knight or druid. ...",
		"When you have reached level 8, you can choose your definite vocation. You have to talk to me to receive it, \z
		and then you may open one of the doors, take up your vocation's gear, and leave the island. But be aware: ...",
		"Once you have chosen your vocation and stepped through a door, you cannot go back or choose a different vocation. \z
		So choose well!"
	}
)
keywordHandler:addKeyword({"inigo"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He has seen much, and likes to help the younger ones. If you have questions about what to do, \z
			or whom to ask for anything, go to Inigo."
	}
)
keywordHandler:addKeyword({"richard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Found a new way of living and took to it like a fish to water."
	}
)
keywordHandler:addKeyword({"coltrayne"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah. Some wounds never heal. <sighs> Shipwrecked in body and mind. Nowhere to go, so he doesn't leave."
	}
)
keywordHandler:addKeyword({"morris"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He broods over problems he won't share. But maybe you can help him with a little quest or two."
	}
)
keywordHandler:addKeyword({"hamish"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He lives only for his experiments and potions"
	}
)
keywordHandler:addKeyword({"dawnport"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {
			"This is a strange place. Many beings are called to it. I dreamed of it long before I came here. ...",
			"Something spoke to me, telling me I had to be its voice; a voice of the Oracle here for the sake of \z
			the adventurers that would come to defend {World} against evil and need to {choose} their destiny."
		}
	}
)
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have heard of it, yes."
	}
)

--From topic of vocation to topic of the "yes" message (choosing vocation)
local topicTable = {
	[5] = VOCATION.ID.KNIGHT,
	[6] = VOCATION.ID.PALADIN,
	[7] = VOCATION.ID.DRUID,
	[8] = VOCATION.ID.SORCERER
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local health = player:getHealth()

	local vocationDefaultMessages = {
		"A vocation is your profession and destiny, determining your skills and way of fighting. \z
			There are four vocations in Tibia: {knight}, {sorcerer}, {paladin} or {druid}. \z
			Each one has its unique special abilities. ... ",
		"When you leave the outpost through one of the four gates upstairs, you will be equipped with \z
			training gear of a specific vocation in order to defend yourself against the monsters outside. ... ",
		"You can try them out as often as you wish to. When you have gained enough experience to reach level 8, \z
			you are ready to choose the definite vocation that is to become your destiny. ... ",
		"Think carefully, as you can't change your vocation later on! You will have to choose your vocation in order \z
			to leave Dawnport for the main continent through one of these {doors} behind me. ... ",
		"Talk to me again when you are ready to choose your vocation, and I will set you on your way. "
	}

	-- Heal and help dialog
	if MsgContains(message, "healing") and npcHandler:getTopic(playerId) == 0 then
		if player:getLevel() < 8 then
			if health < 40 or player:getCondition(CONDITION_POISON) then
				if health < 40 then
					player:addHealth(40 - health)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
				end
				if player:getCondition(CONDITION_POISON) then
					player:removeCondition(CONDITION_POISON)
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
				end
				npcHandler:say("You are hurt, my child. I will heal your wounds.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				return npcHandler:say("You do not need any healing right now.", npc, creature)
			end
		end
	elseif MsgContains(message, "help") and npcHandler:getTopic(playerId) == 0 then
		if player:getCondition(CONDITION_POISON) == nil or health > 40 then
			return npcHandler:say("You do not need any healing right now.", npc, creature)
		end
		if health < 40 or player:getCondition(CONDITION_POISON) then
			if health < 40 then
				player:addHealth(40 - health)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			end
			if player:getCondition(CONDITION_POISON) then
				player:removeCondition(CONDITION_POISON)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			end
			npcHandler:say("You are hurt, my child. I will heal your wounds.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	-- Vocation dialog
	elseif npcHandler:getTopic(playerId) == 0 and MsgContains(message, "vocation") then
		npcHandler:say(vocationDefaultMessages,	npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
	-- Choosing dialog start
	elseif MsgContains(message, "choosing") or MsgContains(message, "choose") and npcHandler:getTopic(playerId) == 0 then
		if player:getLevel() >= 8 then
			npcHandler:say("I'll help you decide. \z
				Tell me: Do you like to keep your {distance}, or do you like {close} combat?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say(vocationDefaultMessages, npc, creature, 10)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "distance") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("Tell me: Do you prefer to fight with {bow} and {spear}, or do you want to cast {magic}?", npc, creature)
		npcHandler:setTopic(playerId, 3)
	-- knight
	elseif MsgContains(message, "close") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say(
			{
				"Then you should choose the {vocation} of a knight and become a valiant fighter with sword and shield. ...",
				"Knights are the toughest of all vocations. They can take more damage and carry more items than the other \z
					vocations, but they will deal less damage than paladins, druids or sorcerers. ...",
				"Knights can wield one- or two-handed swords, axes and clubs, and they can cast a few spells to draw a \z
					monster's attention to them. ...",
				"So tell me: DO YOU WISH TO BECOME A VALIANT KNIGHT? Answer with a proud {YES} if that is your choice!"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 5)
	-- Paladin
	elseif MsgContains(message, "bow") or MsgContains(message, "spear") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say(
			{
				"Then you should join the ranks of the paladins, noble hunters and rangers of the wild, who rely on the \z
					swiftness of movement and ranged attacks. ...",
				"Paladins are jacks of all trades. They are tougher than the magically gifted and can carry more items \z
					than druids or sorcerers, but they can take not as much damage as a knight can. ...",
				"Paladins deal more damage than knights but less than druids or sorcerers, and have the longest range \z
					in their distance attacks. ...",
				"They can also use holy magic to slay the unholy and undead in particular. ...",
				"DO YOU WISH TO BECOME A DARING PALADIN? Answer with a proud {YES} if that is your choice!"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 6)
	-- Mage
	elseif MsgContains(message, "magic") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("Tell me: Do you prefer to {heal} and cast the power of nature and ice, or do you want to rain \z
			fire and {death} on your foes?", npc, creature)
		npcHandler:setTopic(playerId, 4)
	-- Druid
	elseif MsgContains(message, "heal") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say(
			{
				"Then you should learn the ways of the druids, healers and powerful masters of natural magic. ...",
				"Druids can heal their friends and allies, but they can also cast powerful ice and earth magic \z
					to kill their enemies. They can do a little energy, fire or death damage as well. ...",
				"Druids cannot take much damage or carry many items, but they deal \z
					much more damage than paladins or knights. ...",
				"So tell me: DO YOU WISH TO BECOME A SAGACIOUS DRUID? Answer with a proud {YES} if that is your choice!"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 7)
	-- Sorcerer
	elseif MsgContains(message, "death") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say(
			{
				"Then you should become a sorcerer, a mighty wielder of deathly energies and arcane fire. ...",
				"Sorcerers are powerful casters of magic. They use fire, energy and death magic to lay low their enemies. \z
					They can do a little ice or earth damage as well. ...",
				"Sorcerers cannot take much damage or carry many items, \z
					but they deal much more damage than paladins or knights. ...",
				"So tell me: DO YOU WISH TO BECOME A POWERFUL SORCERER? Answer with a proud {YES} if that is your choice!"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 8)
	-- Choosing dialog start
	elseif MsgContains(message, "decided") and npcHandler:getTopic(playerId) == 0 then
		npcHandler:say("So tell me, which {vocation} do you want to choose: {knight}, {sorcerer}, {paladin} or {druid}?", npc, creature)
	-- Say vocations name
	elseif MsgContains(message, "sorcerer") and npcHandler:getTopic(playerId) == 0 then
		local message = {
			"Sorcerers are powerful casters of death, energy and fire magic. \z
				They can do a little ice or earth damage as well. ...",
			"Sorcerers cannot take much damage or carry many items, but they deal more damage than paladins or knights, \z
				and can target several enemies. ...",
			"If you wish to be a caster of fire and energy, hurling death magic at your foes, \z
				you should consider choosing the sorcerer vocation."
		}

		if player:getLevel() >= 8 then
			table.insert(message, "So tell me: DO YOU WISH TO BECOME A POWERFUL SORCERER?"..
									" Answer with a proud {YES} if that is your choice!")
			npcHandler:setTopic(playerId, 8)
		else
			npcHandler:setTopic(playerId, 0)
		end

		npcHandler:say(message, npc, creature, 10)
	elseif MsgContains(message, "druid") and npcHandler:getTopic(playerId) == 0 then
		local message = {
			"Druids are healers and powerful masters of ice and earth magic. \z
				They can also do a little energy, fire or death damage as well. ... ",
			"Druids cannot take much damage or carry many items, but they deal more damage than paladins or knights, \z
				and can target several enemies. ... ",
			"If you wish to be a healer and wielder of powerful natural magic, \z
				you should consider choosing the druid vocation."
		}

		if player:getLevel() >= 8 then
			table.insert(message, "So tell me: DO YOU WISH TO BECOME A SAGACIOUS DRUID?"..
									" Answer with a proud {YES} if that is your choice!")
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:setTopic(playerId, 0)
		end

		npcHandler:say(message, npc, creature, 10)
	elseif MsgContains(message, "paladin") and npcHandler:getTopic(playerId) == 0 then
		local message = {
			"Paladins are sturdy distance fighters. They are tougher than druids or sorcerers and can carry more items, \z
				but they are less tough than a knight. ... ",
			"Paladins have the longest attack range, and can deal the most damage on a single target. ... ",
			"They can also use holy magic to slay the unholy and undead in particular. ... ",
			"If you like to keep a distance to your enemy, shooting while you outdistance him, \z
				you should consider choosing the paladin vocation."
		}

		if player:getLevel() >= 8 then
			table.insert(message, "So tell me: DO YOU WISH TO BECOME A DARING PALADIN?"..
									" Answer with a proud {YES} if that is your choice!")
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:setTopic(playerId, 0)
		end

		npcHandler:say(message, npc, creature, 10)
	elseif MsgContains(message, "knight") and npcHandler:getTopic(playerId) == 0 then
		local message = {
			"Knights are stalwart melee fighters, the toughest of all vocations. They can take more damage and carry \z
				more items than the other vocations, but they will deal less damage than paladins, druids or sorcerers. ... ",
			"Knights can wield one- or two-handed swords, axes and clubs, and they can cast a few spells to draw a \z
				monster's attention to them. ... ",
			"If you want to be a tough melee fighter who can resist much longer than anyone else, \z
				you should consider choosing the knight vocation."
		}

		if player:getLevel() >= 8 then
			table.insert(message, "DO YOU WISH TO BECOME A VALIANT KNIGHT? Answer with a proud {YES} if that is your choice!")
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:setTopic(playerId, 0)
		end

		npcHandler:say(message, npc, creature, 10)
	elseif ((npcHandler:getTopic(playerId) >= 5) and (npcHandler:getTopic(playerId) <= 8)) then
		if MsgContains(message, "yes") then
			for index, value in pairs(topicTable) do
				if npcHandler:getTopic(playerId) == index then
					if player:getStorageValue(Storage.Dawnport.DoorVocation) == -1 then
						-- Change to new vocation, convert magic level and skills and set proper stats
						player:changeVocation(value)
						player:setStorageValue(Storage.Dawnport.DoorVocation, value)
					else
						npcHandler:setTopic(playerId, 0)
						return true
					end
				end
			end
			-- Remove Mainland smuggling items
			removeMainlandSmugglingItems(player)
			npcHandler:say(
				{
					"SO BE IT. CAST OFF YOUR TRAINING GEAR AND RISE, NOBLE ".. player:getVocation():getName():upper() .. "! ...",
					"Go through the second door from the right. Open the chest and take the equipment inside \z
						before you leave to the north. ...",
					"Take the ship to reach the Mainland. Farewell, friend and good luck in all you undertake!"
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			local vocationMessage = {
				[5] = "{paladin}, {sorcerer} or {druid}",
				[6] = "{knight}, {sorcerer} or {druid}",
				[7] = "{knight}, {paladin} or {sorcerer}",
				[8] = "{knight}, {paladin} or {druid}"
			}
			npcHandler:say(
				{
					"As you wish. If you wish to learn something about the "..
					vocationMessage[npcHandler:getTopic(playerId)]..
					" vocation, tell me.",
				},
			npc, creature, 10)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getLevel() >= 8 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome, young adventurer. Tell me if you need help in \z
												{choosing} your {vocation}, or if you have {decided} on the {vocation} you want to choose.")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome to the temple of Dawnport, child. \z
												If you need {healing}, I can help you. Ask me about a {vocation} if you need counsel.")
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, child.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
