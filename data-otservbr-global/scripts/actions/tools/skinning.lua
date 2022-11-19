---- if you want protected corpses (10 second protection after monster being killed) to be skinned/dusted, delete '--#' in the appropriate lines; be careful, it may cause abuses ----
local config = {
	[5908] = {

		-- rabbits
		[4173] = {value = 22344, newItem = 12172, after = 4302},
		[6017] = {value = 22344, newItem = 12172, after = 4302}, -- after being killed

		-- Minotaurs
		[4011] = {value = 22344, newItem = 5878, after = 4012}, -- minotaur
		[5969] = {value = 22344, newItem = 5878, after = 4012},	-- minotaur, after being killed
		[4052] = {value = 22344, newItem = 5878, after = 4053}, -- minotaur archer
		[5982] = {value = 22344, newItem = 5878, after = 4053}, -- minotaur archer, after being killed
		[4047] = {value = 22344, newItem = 5878, after = 4048}, -- minotaur mage
		[5981] = {value = 22344, newItem = 5878, after = 4048}, -- minotaur mage, after being killed
		[4057] = {value = 22344, newItem = 5878, after = 4058}, -- minotaur guard/invader
		[5983] = {value = 22344, newItem = 5878, after = 4058}, -- minotaur guard/invader, after being killed
		[21092] = {value = 22344, newItem = 5878, after = 21093}, -- mooh'tah warrior
		[21091] = {value = 22344, newItem = 5878, after = 21093}, -- mooh'tah warrior, after being killed
		[21096] = {value = 22344, newItem = 5878, after = 21097}, -- minotaur hunter
		[21095] = {value = 22344, newItem = 5878, after = 21097}, -- minotaur hunter, after being killed
		[21100] = {value = 22344, newItem = 5878, after = 21101}, -- worm priestess
		[21099] = {value = 22344, newItem = 5878, after = 21101}, -- worm priestess, after being killed
		[21000] = {value = 22344, newItem = 5878, after = 21002}, -- minotaur amazon
		[21001] = {value = 22344, newItem = 5878, after = 21002}, -- minotaur amazon, after being killed
		[21004] = {value = 22344, newItem = 5878, after = 21006}, -- execowtioner
		[21005] = {value = 22344, newItem = 5878, after = 21006}, -- execowtioner, after being killed
		[20996] = {value = 22344, newItem = 5878, after = 20998}, -- moohtant
		[20997] = {value = 22344, newItem = 5878, after = 20998}, -- moohtant, after being killed

		-- Low Class Lizards
		[4324] = {value = 22344, newItem = 5876, after = 4325}, -- lizard sentinel
		[6040] = {value = 22344, newItem = 5876, after = 4325}, -- lizard sentinel, after being killed
		[4327] = {value = 22344, newItem = 5876, after = 4328}, -- lizard snakecharmer
		[6041] = {value = 22344, newItem = 5876, after = 4328}, -- lizard snakecharmer, after being killed
		[4321] = {value = 22344, newItem = 5876, after = 4322}, -- lizard templar
		[4239] = {value = 22344, newItem = 5876, after = 4322}, -- lizard templar, after being killed

		-- High Class Lizards
		[10368] = {value = 22344, newItem = 5876, after = 10369}, -- lizard chosen,
		[10371] = {value = 22344, newItem = 5876, after = 10369}, -- lizard chosen, after being killed
		[10360] = {value = 22344, newItem = 5876, after = 10361}, -- lizard dragon priest
		[10363] = {value = 22344, newItem = 5876, after = 10361}, -- lizard dragon priest, after being killed
		[10352] = {value = 22344, newItem = 5876, after = 10353}, -- lizard high guard
		[10355] = {value = 22344, newItem = 5876, after = 10353}, -- lizard high guard, after being killed
		[10364] = {value = 22344, newItem = 5876, after = 10365}, -- lizard zaogun
		[10367] = {value = 22344, newItem = 5876, after = 10365}, -- lizard zaogun, after being killed
		[10356] = {value = 22344, newItem = 5876, after = 10357}, -- lizard legionnaire
		[10359] = {value = 22344, newItem = 5876, after = 10357}, -- lizard legionnaire, after being killed

		-- Dragons
		[4025] = {value = 22344, newItem = 5877, after = 4026},	-- Dragon
		[5973] = {value = 22344, newItem = 5877, after = 4026}, -- Dragon, after being killed

		-- Dragon Lords
		[4062] = {value = 22344, newItem = 5948, after = 4063},
		[5984] = {value = 22344, newItem = 5948, after = 4063}, -- after being killed

		-- Behemoths
		[4112] = {value = 28468, newItem = 5893, after = 4113},
		[5999] = {value = 28468, newItem = 5893, after = 4113}, -- after being killed

		-- Bone Beasts
		[4212] = {value = 22344, newItem = 5925, after = 4213},
		[6030] = {value = 22344, newItem = 5925, after = 4213}, -- after being killed

		-- Clomp - raw meat
		[22743] = {value = 22344, newItem = 22186, after = 22744},
		[22742] = {value = 22344, newItem = 22186, after = 22744}, -- after being killed

		-- The Mutated Pumpkin
		[12816] = { { value = 5000, newItem = 123 }, { value = 10000, newItem = 653 }, { value = 20000, 6491 }, { value = 26764, newItem = 8032 }, { value = 45000, newItem = 3594 }, { value = 60000, newItem = 2977 }, { value = 90000, newItem = 8177, amount = 50 } },

		-- Marble
		[10426] = { { value = 10000, newItem = 10429, desc = "This little figurine of Tibiasula was masterfully sculpted by |PLAYERNAME|." }, {value = 26764, newItem = 10428, desc = "This little figurine made by |PLAYERNAME| has some room for improvement." }, {value = 60000, newItem = 10427, desc = "This shoddy work was made by |PLAYERNAME|." } },

		-- Ice Cube
		[7441] = {value = 22344, newItem = 7442},
		[7442] = {value = 22344, newItem = 7444},
		[7444] = {value = 22344, newItem = 7445},
		[7445] = {value = 22344, newItem = 7446},
	},
	[5942] = {
		-- Demon
		[4097] = {value = 22344, newItem = 5906, after = 4098},
		[5995] = {value = 22344, newItem = 5906, after = 4098}, -- after being killed

		-- Vampires
		[4137] = {value = 22344, newItem = 5905, after = 4138}, -- vampire
		[6006] = {value = 22344, newItem = 5905, after = 4138}, -- vampire, after being killed
		[8738] = {value = 22344, newItem = 5905, after = 8742}, -- vampire bride
		[8744] = {value = 22344, newItem = 5905, after = 8742}, -- vampire bride, after being killed
		[8109] = {value = 22344, newItem = 5905, after = 8111},	 -- vampire lord, after being killed (the count, diblis, etc)
		[8110] = {value = 22344, newItem = 5905, after = 8111}, -- vampire lord (the count, diblis, etc)
		[18958] = {value = 22344, newItem= 5905, after = 18959}, -- vampire viscount
		[18961] = {value = 22344, newItem= 5905, after = 18959} -- vampire viscount, after being killed
	}
}

local skinning = Action()

function skinning.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local skin = config[item.itemid][target.itemid]

	if item.itemid == 5908 then
		if target.itemid == 33778 then
			local chance = math.random(1, 10000)
			target:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			target:remove(1)
			if chance <= 8640 then
				player:addItem(33779, 1)
			else
				player:addItem(33780, 1)
			end
			return true
			-- Wrath of the emperor quest
		elseif target.itemid == 11339 then
			target:transform(11331)
			player:say("You carve a solid bowl of the chunk of wood.", TALKTYPE_MONSTER_SAY)
			return true
			-- An Interest In Botany Quest
		elseif target.itemid == 10735 and player:getItemCount(11699) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 1 then
			player:say("The plant feels cold but dry and very soft. You streak the plant gently with your knife and put a fragment in the almanach.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 2)
			return true
		elseif target.itemid == 10697 and player:getItemCount(11699) > 0 and player:getStorageValue(Storage.TibiaTales.AnInterestInBotany) == 2 then
			player:say("You cut a leaf from a branch and put it in the almanach. It smells strangely sweet and awfully bitter at the same time.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.TibiaTales.AnInterestInBotany, 3)
			return true
		elseif target.itemid == 8181 and player:getStorageValue(789100) <= 1 then
			player:say("You got Neutral matter.", TALKTYPE_MONSTER_SAY)
			player:addItem(954, 1)
			player:setStorageValue(789100, 1)
			return true
		elseif target.itemid == 8182 and player:getStorageValue(789100) <= 1 then
			player:say("You got Neutral matter.", TALKTYPE_MONSTER_SAY)
			player:addItem(954, 1)
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
				if target.itemid == 10426 then
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

		if not added and target.itemid == 12816 then
			effect = CONST_ME_POFF
			transform = false
		elseif not added and target.itemid == 10426 then
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
