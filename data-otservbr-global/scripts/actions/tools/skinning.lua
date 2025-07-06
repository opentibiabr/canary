local CREATURE_SKINNING_CHANCE = 25000 -- 25% probability
local config = {
	[5908] = {

		-- rabbits
		[4173] = { value = CREATURE_SKINNING_CHANCE, newItem = 12172, after = 4302 },
		[6017] = { value = CREATURE_SKINNING_CHANCE, newItem = 12172, after = 4302 }, -- after being killed

		-- Minotaurs
		[4011] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4012 }, -- minotaur
		[5969] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4012 }, -- minotaur, after being killed
		[4052] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4053 }, -- minotaur archer
		[5982] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4053 }, -- minotaur archer, after being killed
		[4047] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4048 }, -- minotaur mage
		[5981] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4048 }, -- minotaur mage, after being killed
		[4057] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4058 }, -- minotaur guard/invader
		[5983] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 4058 }, -- minotaur guard/invader, after being killed
		[21092] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21093 }, -- mooh'tah warrior
		[21091] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21093 }, -- mooh'tah warrior, after being killed
		[21096] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21097 }, -- minotaur hunter
		[21095] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21097 }, -- minotaur hunter, after being killed
		[21100] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21101 }, -- worm priestess
		[21099] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21101 }, -- worm priestess, after being killed
		[21000] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21002 }, -- minotaur amazon
		[21001] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21002 }, -- minotaur amazon, after being killed
		[21004] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21006 }, -- execowtioner
		[21005] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 21006 }, -- execowtioner, after being killed
		[20996] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 20998 }, -- moohtant
		[20997] = { value = CREATURE_SKINNING_CHANCE, newItem = 5878, after = 20998 }, -- moohtant, after being killed

		-- Low Class Lizards
		[4324] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4325 }, -- lizard sentinel
		[6040] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4325 }, -- lizard sentinel, after being killed
		[4327] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4328 }, -- lizard snakecharmer
		[6041] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4328 }, -- lizard snakecharmer, after being killed
		[4321] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4322 }, -- lizard templar
		[4239] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 4322 }, -- lizard templar, after being killed

		-- High Class Lizards
		[10368] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10369 }, -- lizard chosen,
		[10371] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10369 }, -- lizard chosen, after being killed
		[10360] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10361 }, -- lizard dragon priest
		[10363] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10361 }, -- lizard dragon priest, after being killed
		[10352] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10353 }, -- lizard high guard
		[10355] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10353 }, -- lizard high guard, after being killed
		[10364] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10365 }, -- lizard zaogun
		[10367] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10365 }, -- lizard zaogun, after being killed
		[10356] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10357 }, -- lizard legionnaire
		[10359] = { value = CREATURE_SKINNING_CHANCE, newItem = 5876, after = 10357 }, -- lizard legionnaire, after being killed

		-- Dragons
		[4025] = { value = CREATURE_SKINNING_CHANCE, newItem = 5877, after = 4026 }, -- Dragon
		[5973] = { value = CREATURE_SKINNING_CHANCE, newItem = 5877, after = 4026 }, -- Dragon, after being killed

		-- Dragon Lords
		[4062] = { value = CREATURE_SKINNING_CHANCE, newItem = 5948, after = 4063 },
		[5984] = { value = CREATURE_SKINNING_CHANCE, newItem = 5948, after = 4063 }, -- after being killed

		-- Behemoths
		[4112] = { value = CREATURE_SKINNING_CHANCE, newItem = 5893, after = 4113 },
		[5999] = { value = CREATURE_SKINNING_CHANCE, newItem = 5893, after = 4113 }, -- after being killed

		-- Bone Beasts
		[4212] = { value = CREATURE_SKINNING_CHANCE, newItem = 5925, after = 4213 },
		[6030] = { value = CREATURE_SKINNING_CHANCE, newItem = 5925, after = 4213 }, -- after being killed

		-- Clomp - raw meat
		[22743] = { value = CREATURE_SKINNING_CHANCE, newItem = 22186, after = 22744 },
		[22742] = { value = CREATURE_SKINNING_CHANCE, newItem = 22186, after = 22744 }, -- after being killed

		-- The Mutated Pumpkin
		[12816] = {
			{ value = 5000, newItem = 8032 }, -- spiderwebs
			{ value = 5000, newItem = 8178 }, -- toy spider
			{ value = 5000, newItem = 6491 }, -- bat decoration
			{ value = 20000, newItem = 6525 }, -- skeleton decoration
			{ value = 90000, newItem = 8177, amount = 20 }, -- yummy gummy worm
			{ value = 10000, newItem = 6571 }, -- surprise bag (red)
			{ value = 10000, newItem = 6570 }, -- surprise bag (blue)
			{ value = 50000, newItem = 6574 }, -- bar of chocolate
			{ value = 60000, newItem = 2977 }, -- pumpkinhead
			{ value = 45000, newItem = 3594 }, -- pumpkin
			{ value = 90000, newItem = 3599, amount = 50 }, -- candy cane
			{ value = 90000, newItem = 6569, amount = 50 }, -- candy
			{ value = 2000, newItem = 6574, amount = 50 }, -- bar of chocolate
		},

		-- Marble
		[10426] = {
			{ value = 10000, newItem = 10429, desc = "This little figurine of Tibiasula was masterfully sculpted by |PLAYERNAME|." },
			{ value = 26764, newItem = 10428, desc = "This little figurine made by |PLAYERNAME| has some room for improvement." },
			{ value = 60000, newItem = 10427, desc = "This shoddy work was made by |PLAYERNAME|." },
		},

		-- Ice Cube
		[7441] = { value = 22344, newItem = 7442 },
		[7442] = { value = 22344, newItem = 7444 },
		[7444] = { value = 22344, newItem = 7445 },
		[7445] = { value = 22344, newItem = 7446 },
	},
	[5942] = {
		-- Demon
		[4097] = { value = CREATURE_SKINNING_CHANCE, newItem = 5906, after = 4098 },
		[5995] = { value = CREATURE_SKINNING_CHANCE, newItem = 5906, after = 4098 }, -- after being killed

		-- Vampires
		[4137] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 4138 }, -- vampire
		[6006] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 4138 }, -- vampire, after being killed
		[8738] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 8742 }, -- vampire bride
		[8744] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 8742 }, -- vampire bride, after being killed
		[8109] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 8111 }, -- vampire lord, after being killed (the count, diblis, etc)
		[8110] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 8111 }, -- vampire lord (the count, diblis, etc)
		[18958] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 18959 }, -- vampire viscount
		[18961] = { value = CREATURE_SKINNING_CHANCE, newItem = 5905, after = 18959 }, -- vampire viscount, after being killed
	},
}

local skinning = Action()

function skinning.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local topItem = false
	local skin = config[item.itemid][target.itemid]
	local tile = Tile(toPosition)
	if tile then
		topItem = tile:getTopDownItem()
		if topItem then
			skin = config[item.itemid][topItem.itemid]
		end
	end

	if item.itemid == 5908 then
		if target:getId() == CONST_FIREWORK_ITEMID_DISASSEMBLE then
			stopEvent(target:getCustomAttribute("event"))
			player:addItem(target:getCustomAttribute("id"), 1)
			target:remove()
			return true
		elseif target.itemid == 33778 then -- raw watermelon tourmaline
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
		elseif target.itemid == 10735 and player:getItemCount(11699) > 0 and player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) == 1 then
			player:say("The plant feels cold but dry and very soft. You streak the plant gently with your knife and put a fragment in the almanach.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 2)
			return true
		elseif target.itemid == 10697 and player:getItemCount(11699) > 0 and player:getStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline) == 2 then
			player:say("You cut a leaf from a branch and put it in the almanach. It smells strangely sweet and awfully bitter at the same time.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U8_6.AnInterestInBotany.Questline, 3)
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
		-- Rottin Wood and the Married Men Quest
		elseif target.itemid == 4301 then
			player:say("You successfully gathered a rabbit's food in excellent condition.", TALKTYPE_MONSTER_SAY)
			player:addItem(12172, 1)
			return true
		end
	end

	if target:getId() == 12816 then
		if player:getStorageValue(Storage.Quest.U8_2.TheMutatedPumpkin.Skinned) > os.time() then
			player:sendCancelMessage("You already used your knife on the corpse.")
			return true
		end

		player:setStorageValue(Storage.Quest.U8_2.TheMutatedPumpkin.Skinned, os.time() + 4 * 60 * 60)
		player:say("Happy Halloween!", TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		player:addAchievement("Mutated Presents")
		local reward = math.random(1, #skin)
		player:addItem(skin[reward].newItem, skin[reward].amount or 1)
		effect = CONST_ME_HITAREA
		return true
	end

	if not skin then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local charmMType, chanceRange = player:getCharmMonsterType(CHARM_SCAVENGE), 100000
	if charmMType then
		local charmCorpse = charmMType:getCorpseId()
		if charmCorpse == target.itemid or ItemType(charmCorpse):getDecayId() == target.itemid then
			local charmChance = player:getCharmChance(CHARM_SCAVENGE)
			charmChance = (charmChance == 0 and 1 or charmChance) -- Guarantee that the chance will neve be 0
			chanceRange = chanceRange * charmChance / 100
		end
	end

	local random, effect, transform = math.random(1, chanceRange), CONST_ME_MAGIC_GREEN, true
	if type(skin[1]) == "table" then
		local added = false
		local _skin
		for i = 1, #skin do
			_skin = skin[i]
			if random <= _skin.value then
				if target.itemid == 10426 then
					target:getPosition():sendMagicEffect(CONST_ME_HITAREA)
					local gobletItem = player:addItem(_skin.newItem, _skin.amount or 1)
					if gobletItem then
						gobletItem:setDescription(_skin.desc:gsub("|PLAYERNAME|", player:getName()))
					end
					if _skin.newItem == 10429 then
						player:addAchievement("Marblelous")
						player:addAchievementProgress("Marble Madness", 5)
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

		if not added and target.itemid == 10426 then
			effect = CONST_ME_HITAREA
			player:say("Your attempt at shaping that marble rock failed miserably.", TALKTYPE_MONSTER_SAY)
			transform = false
			target:remove()
		end
	elseif random <= skin.value then
		if isInArray({ 7441, 7442, 7444, 7445 }, target.itemid) then
			if skin.newItem == 7446 then
				player:addAchievement("Ice Sculptor")
				player:addAchievementProgress("Cold as Ice", 10)
			end
			target:transform(skin.newItem, 1)
			effect = CONST_ME_HITAREA
			return true
		else
			if table.contains({ 5906, 5905 }, skin.newItem) then
				player:addAchievementProgress("Ashes to Dust", 500)
			else
				player:addAchievementProgress("Skin-Deep", 500)
			end
			local container = Container(item:getParent().uid)
			if fromPosition.x == CONTAINER_POSITION and container:getEmptySlots() ~= 0 then
				container:addItem(skin.newItem, skin.amount or 1)
			else
				player:addItem(skin.newItem, skin.amount or 1)
			end
		end
	else
		if isInArray({ 7441, 7442, 7444, 7445 }, target.itemid) then
			player:say("The attempt of sculpting failed miserably.", TALKTYPE_MONSTER_SAY)
			effect = CONST_ME_HITAREA
			target:remove()
		else
			effect = CONST_ME_BLOCKHIT
		end
	end

	if transform then
		topItem:transform(skin.after or topItem:getType():getDecayId() or topItem.itemid + 1)
	else
		target:remove()
	end

	if toPosition.x == CONTAINER_POSITION then
		toPosition = player:getPosition()
	end
	toPosition:sendMagicEffect(effect)

	return true
end

skinning:id(5908, 5942)
skinning:register()
