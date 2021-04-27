---- if you want protected corpses (10 second protection after monster being killed) to be skinned/dusted, delete '--#' in the appropriate lines; be careful, it may cause abuses ----
local config = {
	[5908] = {

		-- rabbits
		[2992] = {value = 25000, newItem = 13159, after = 2993},
		[6017] = {value = 25000, newItem = 13159, after = 2993}, -- after being killed

		-- Minotaurs
		[3090] = {value = 25000, newItem = 5878, after = 2831}, -- minotaur
		[5969] = {value = 25000, newItem = 5878, after = 2831},	-- minotaur, after being killed
		[2871] = {value = 25000, newItem = 5878, after = 2872}, -- minotaur archer
		[5982] = {value = 25000, newItem = 5878, after = 2872}, -- minotaur archer, after being killed
		[2866] = {value = 25000, newItem = 5878, after = 2867}, -- minotaur mage
		[5981] = {value = 25000, newItem = 5878, after = 2867}, -- minotaur mage, after being killed
		[2876] = {value = 25000, newItem = 5878, after = 2877}, -- minotaur guard/invader
		[5983] = {value = 25000, newItem = 5878, after = 2877}, -- minotaur guard/invader, after being killed
		[23463] = {value = 25000, newItem = 5878, after = 23464}, -- mooh'tah warrior
		[23462] = {value = 25000, newItem = 5878, after = 23464}, -- mooh'tah warrior, after being killed
		[23467] = {value = 25000, newItem = 5878, after = 23468}, -- minotaur hunter
		[23466] = {value = 25000, newItem = 5878, after = 23468}, -- minotaur hunter, after being killed
		[23471] = {value = 25000, newItem = 5878, after = 23472}, -- worm priestess
		[23470] = {value = 25000, newItem = 5878, after = 23472}, -- worm priestess, after being killed
		[23371] = {value = 25000, newItem = 5878, after = 23373}, -- minotaur amazon
		[23372] = {value = 25000, newItem = 5878, after = 23373}, -- minotaur amazon, after being killed
		[23375] = {value = 25000, newItem = 5878, after = 23377}, -- execowtioner
		[23376] = {value = 25000, newItem = 5878, after = 23377}, -- execowtioner, after being killed
		[23367] = {value = 25000, newItem = 5878, after = 23369}, -- moohtant
		[23368] = {value = 25000, newItem = 5878, after = 23369}, -- moohtant, after being killed

		-- Low Class Lizards
		[4259] = {value = 25000, newItem = 5876, after = 4260}, -- lizard sentinel
		[6040] = {value = 25000, newItem = 5876, after = 4260}, -- lizard sentinel, after being killed
		[4262] = {value = 25000, newItem = 5876, after = 4263}, -- lizard snakecharmer
		[6041] = {value = 25000, newItem = 5876, after = 4263}, -- lizard snakecharmer, after being killed
		[4256] = {value = 25000, newItem = 5876, after = 4257}, -- lizard templar
		[4251] = {value = 25000, newItem = 5876, after = 4257}, -- lizard templar, after being killed

		-- High Class Lizards
		[11285] = {value = 25000, newItem = 5876, after = 11286}, -- lizard chosen,
		[11288] = {value = 25000, newItem = 5876, after = 11286}, -- lizard chosen, after being killed
		[11277] = {value = 25000, newItem = 5876, after = 11278}, -- lizard dragon priest
		[11280] = {value = 25000, newItem = 5876, after = 11278}, -- lizard dragon priest, after being killed
		[11269] = {value = 25000, newItem = 5876, after = 11270}, -- lizard high guard
		[11272] = {value = 25000, newItem = 5876, after = 11270}, -- lizard high guard, after being killed
		[11281] = {value = 25000, newItem = 5876, after = 11282}, -- lizard zaogun
		[11284] = {value = 25000, newItem = 5876, after = 11282}, -- lizard zaogun, after being killed

		-- Dragons
		[3104] = {value = 25000, newItem = 5877, after = 3105},
		[2844] = {value = 25000, newItem = 5877, after = 3105},
		[5973] = {value = 25000, newItem = 5877, after = 3105}, -- after being killed

		-- Dragon Lords
		[2881] = {value = 25000, newItem = 5948, after = 2882},
		[5984] = {value = 25000, newItem = 5948, after = 2882}, -- after being killed

		-- Behemoths
		[2931] = {value = 35000, newItem = 5893, after = 2932},
		[5999] = {value = 35000, newItem = 5893, after = 2932}, -- after being killed

		-- Bone Beasts
		[3031] = {value = 25000, newItem = 5925, after = 3032},
		[6030] = {value = 25000, newItem = 5925, after = 3032}, -- after being killed

		-- Clomp - raw meat
		[25399] = {value = 25000, newItem = 24842, after = 25400},
		[25398] = {value = 25000, newItem = 24842, after = 25400}, -- after being killed

		-- The Mutated Pumpkin
		[8961] = { { value = 5000, newItem = 7487 }, { value = 10000, newItem = 7737 }, { value = 20000, 6492 }, { value = 30000, newItem = 8860 }, { value = 45000, newItem = 2683 }, { value = 60000, newItem = 2096 }, { value = 90000, newItem = 9005, amount = 50 } },

		-- Marble
		[11343] = { { value = 10000, newItem = 11346, desc = "This little figurine of Tibiasula was masterfully sculpted by |PLAYERNAME|." }, {value = 30000, newItem = 11345, desc = "This little figurine made by |PLAYERNAME| has some room for improvement." }, {value = 60000, newItem = 11344, desc = "This shoddy work was made by |PLAYERNAME|." } },

		-- Ice Cube
		[7441] = {value = 25000, newItem = 7442},
		[7442] = {value = 25000, newItem = 7444},
		[7444] = {value = 25000, newItem = 7445},
		[7445] = {value = 25000, newItem = 7446},
	},
	[5942] = {
		-- Demon
		[2916] = {value = 25000, newItem = 5906, after = 2917},
		[5995] = {value = 25000, newItem = 5906, after = 2917}, -- after being killed

		-- Vampires
		[2956] = {value = 25000, newItem = 5905, after = 2957}, -- vampire
		[6006] = {value = 25000, newItem = 5905, after = 2957}, -- vampire, after being killed
		[9654] = {value = 25000, newItem = 5905, after = 9658}, -- vampire bride
		[9660] = {value = 25000, newItem = 5905, after = 9658}, -- vampire bride, after being killed
		[8937] = {value = 25000, newItem = 5905, after = 8939},	 -- vampire lord, after being killed (the count, diblis, etc)
		[8938] = {value = 25000, newItem = 5905, after = 8939}, -- vampire lord (the count, diblis, etc)
		[21275] = {value = 25000, newItem= 5905, after = 21276}, -- vampire viscount
		[21278] = {value = 25000, newItem= 5905, after = 21276} -- vampire viscount, after being killed
	}
}

local skinning = Action()

function skinning.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local skin = config[item.itemid][target.itemid]

	if item.itemid == 5908 then
		if target.itemid == 38613 then
			local chance = math.random(1, 10000)
			target:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			target:remove(1)
			if chance <= 9556 then
				player:addItem(38614, 1)
			else
				player:addItem(38615, 1)
			end
			return true
			-- Wrath of the emperor quest
		elseif target.itemid == 12295 then
			target:transform(12287)
			player:say("You carve a solid bowl of the chunk of wood.", TALKTYPE_MONSTER_SAY)
			return true
			-- An Interest In Botany Quest
		elseif target.itemid == 11691 and player:getItemCount(12655) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 1 then
			player:say("The plant feels cold but dry and very soft. You streak the plant gently with your knife and put a fragment in the almanach.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 2)
			return true
		elseif target.itemid == 11653 and player:getItemCount(12655) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 2 then
			player:say("You cut a leaf from a branch and put it in the almanach. It smells strangely sweet and awfully bitter at the same time.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 3)
			return true
		elseif target.itemid == 9009 and player:getStorageValue(789100) <= 1 then
			player:say("You got Neutral matter.", TALKTYPE_MONSTER_SAY)
			player:addItem(8310, 1)
			player:setStorageValue(789100, 1)
			return true
		elseif target.itemid == 9010 and player:getStorageValue(789100) <= 1 then
			player:say("You got Neutral matter.", TALKTYPE_MONSTER_SAY)
			player:addItem(8310, 1)
			player:setStorageValue(789100, 2)
			return true
		end
	end

	if not skin then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local charmMType, chanceRange = player:getCharmMonsterType(CHARM_SCAVENGE), 100000
	if charmMType then
		local charmCorpse = charmMType:getCorpseId()
		if charmCorpse == target.itemid or ItemType(charmCorpse):getDecayId() == target.itemid then
			chanceRange = chanceRange * ((100 - GLOBAL_CHARM_SCAVENGE)/100)
		end
	end

	local random, effect, transform = math.random(1, chanceRange), CONST_ME_MAGIC_GREEN, true
	if type(skin[1]) == 'table' then
		local added = false
		local _skin
		for i = 1, #skin do
			_skin = skin[i]
			if random <= _skin.value then
				if target.itemid == 11343 then
					target:getPosition():sendMagicEffect(CONST_ME_ICEAREA)
					local gobletItem = player:addItem(_skin.newItem, _skin.amount or 1)
					if gobletItem then
						gobletItem:setDescription(_skin.desc:gsub('|PLAYERNAME|', player:getName()))
					end
					target:remove()
					added = true
				else
					target:transform(_skin.newItem, _skin.amount or 1)
					added = true
				end
				break
			end
		end

		if not added and target.itemid == 8961 then
			effect = CONST_ME_POFF
			transform = false
		elseif not added and target.itemid == 11343 then
			effect = CONST_ME_POFF
			transform = false
			target:remove()
		end
	elseif random <= skin.value then
		if isInArray({7441, 7442, 7444, 7445}, target.itemid) then
			if skin.newItem == 7446 then
				player:addAchievement('Ice Sculptor')
			end
			target:transform(skin.newItem, 1)
			effect = CONST_ME_HITAREA
		else
			player:addItem(skin.newItem, skin.amount or 1)
		end
	else
		if isInArray({7441, 7442, 7444, 7445}, target.itemid) then
			player:say('The attempt of sculpting failed miserably.', TALKTYPE_MONSTER_SAY)
			effect = CONST_ME_HITAREA
			target:remove()
		else
			effect = CONST_ME_POFF
		end
	end
	-- SE BUGAR, PEGAR SCRIPT ANTIGO
	toPosition:sendMagicEffect(effect)
	if transform then
		target:transform(skin.after or target:getType():getDecayId() or target.itemid + 1)
	else
		target:remove()
	end

	return true
end

skinning:id(5908, 5942)
skinning:register()
