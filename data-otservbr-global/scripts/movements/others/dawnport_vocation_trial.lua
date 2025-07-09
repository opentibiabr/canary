local tutorialEffects = {
	CONST_ME_TUTORIALARROW,
	CONST_ME_TUTORIALSQUARE,
}

local vocationTrials = {
	-- Sorcerer trial
	[25005] = {
		tutorialId = 5,
		effectPosition = { x = 32050, y = 31891, z = 5 },
		storage = Storage.Dawnport.Sorcerer,
		message = "As a sorcerer, you can use the following spells: Magic Patch, Buzz, Scorch.",
		vocation = {
			id = VOCATION.ID.SORCERER,
			name = "sorcerer",
			outfit = {
				lookType = {
					[PLAYERSEX_FEMALE] = 138,
					[PLAYERSEX_MALE] = 130,
				},
				lookHead = 95,
				lookBody = 109,
				lookLegs = 112,
				lookFeet = 128,
			},
		},
		items = {
			{ id = 21348, amount = 1, slot = CONST_SLOT_LEFT }, -- The scorcher
			{ id = 21400, amount = 1, slot = CONST_SLOT_RIGHT }, -- Spellbook of the novice
			{ id = 7876, amount = 2, storage = Storage.Dawnport.SorcererHealthPotion, limit = 1 }, -- Health potion
			{ id = 268, amount = 10, storage = Storage.Dawnport.SorcererManaPotion, limit = 1 }, -- Mana potion
			{ id = 21352, amount = 2, storage = Storage.Dawnport.SorcererLightestMissile, limit = 1 }, -- Lightest missile runes
			{ id = 21351, amount = 2, storage = Storage.Dawnport.SorcererLightStoneShower, limit = 1 }, -- Light stone shower runes
			{ id = 3577, amount = 1, storage = Storage.Dawnport.SorcererMeat, limit = 1 }, -- Meat
		},
	},
	-- Druid trial
	[25006] = {
		tutorialId = 6,
		effectPosition = { x = 32064, y = 31905, z = 5 },
		storage = Storage.Dawnport.Druid,
		message = "As a druid, you can use these spells: Mud Attack, Chill Out, Magic Patch.",
		vocation = {
			id = VOCATION.ID.DRUID,
			name = "druid",
			outfit = {
				lookType = {
					[PLAYERSEX_FEMALE] = 138,
					[PLAYERSEX_MALE] = 130,
				},
				lookHead = 95,
				lookBody = 123,
				lookLegs = 9,
				lookFeet = 118,
			},
		},
		items = {
			{ id = 21350, amount = 1, slot = CONST_SLOT_LEFT }, -- The chiller
			{ id = 21400, amount = 1, slot = CONST_SLOT_RIGHT }, -- Spellbook of the novice
			{ id = 7876, amount = 2, storage = Storage.Dawnport.DruidHealthPotion, limit = 1 }, -- Health potion
			{ id = 268, amount = 10, storage = Storage.Dawnport.DruidManaPotion, limit = 1 }, -- Mana potion
			{ id = 21352, amount = 2, storage = Storage.Dawnport.DruidLightestMissile, limit = 1 }, -- Lightest missile runes
			{ id = 21351, amount = 2, storage = Storage.Dawnport.DruidLightStoneShower, limit = 1 }, -- Light stone shower runes
			{ id = 3577, amount = 1, storage = Storage.Dawnport.DruidMeat, limit = 1 }, -- Meat
		},
	},
	-- Paladin trial
	[25007] = {
		tutorialId = 4,
		effectPosition = { x = 32078, y = 31891, z = 5 },
		storage = Storage.Dawnport.Paladin,
		message = "As a paladin, you can use the following spells: Magic Patch, Arrow Call.",
		vocation = {
			id = VOCATION.ID.PALADIN,
			name = "paladin",
			outfit = {
				lookType = {
					[PLAYERSEX_FEMALE] = 137,
					[PLAYERSEX_MALE] = 129,
				},
				lookHead = 95,
				lookBody = 117,
				lookLegs = 98,
				lookFeet = 78,
			},
		},
		items = {
			{ id = 3350, amount = 1, slot = CONST_SLOT_LEFT }, -- Bow
			{ id = 35562, amount = 1, slot = CONST_SLOT_RIGHT }, -- Quiver
			{ id = 21470, amount = 100 }, -- Simple arrow
			{ id = 7876, amount = 7, storage = Storage.Dawnport.PaladinHealthPotion, limit = 1 }, -- Health potion
			{ id = 268, amount = 5, storage = Storage.Dawnport.PaladinManaPotion, limit = 1 }, -- Mana potion
			{ id = 21352, amount = 1, storage = Storage.Dawnport.PaladinLightestMissile, limit = 1 }, -- Lightest missile rune
			{ id = 21351, amount = 1, storage = Storage.Dawnport.PaladinLightStoneShower, limit = 1 }, -- Light stone shower rune
			{ id = 3577, amount = 1, storage = Storage.Dawnport.PaladinMeat, limit = 1 }, -- Meat
		},
	},
	-- Knight trial
	[25008] = {
		tutorialId = 3,
		effectPosition = { x = 32064, y = 31876, z = 5 },
		storage = Storage.Dawnport.Knight,
		message = "As a knight, you can use the following spells: Bruise Bane.",
		vocation = {
			id = VOCATION.ID.KNIGHT,
			name = "knight",
			outfit = {
				lookType = {
					[PLAYERSEX_FEMALE] = 139,
					[PLAYERSEX_MALE] = 131,
				},
				lookHead = 95,
				lookBody = 38,
				lookLegs = 94,
				lookFeet = 115,
			},
		},
		items = {
			{ id = 3267, amount = 1, slot = CONST_SLOT_LEFT }, -- Dagger
			{ id = 3412, amount = 1, slot = CONST_SLOT_RIGHT }, -- Wooden shield
			{ id = 7876, amount = 10, storage = Storage.Dawnport.KnightHealthPotion, limit = 1 }, -- Health potion
			{ id = 268, amount = 2, storage = Storage.Dawnport.KnightManaPotion, limit = 1 }, -- Mana potion
			{ id = 3577, amount = 1, storage = Storage.Dawnport.KnightMeat, limit = 1 }, -- Meat
		},
	},
	-- Monk trial
	[25000] = {
		tutorialId = 11,
		effectPosition = { x = 32060, y = 31894, z = 4 },
		storage = Storage.Dawnport.Monk,
		message = "As a monk, you can use the following spells: Swift Jab, Tiger Clash.",
		vocation = {
			id = VOCATION.ID.MONK,
			name = "monk",
			outfit = {
				lookType = {
					[PLAYERSEX_FEMALE] = 1825,
					[PLAYERSEX_MALE] = 1824,
				},
				lookHead = 95,
				lookBody = 38,
				lookLegs = 94,
				lookFeet = 115,
			},
		},
		items = {
			{ id = 50166, amount = 1, slot = CONST_SLOT_LEFT }, -- light jo staff
			{ id = 7876, amount = 5, storage = Storage.Dawnport.MonkHealthPotion, limit = 1 }, -- Health potion-
			{ id = 268, amount = 5, storage = Storage.Dawnport.MonkManaPotion, limit = 1 }, -- Mana potion
			{ id = 3577, amount = 1, storage = Storage.Dawnport.MonkMeat, limit = 1 }, -- Meat
		},
	},
}

-- First items, added only in first step and having no vocation
local function addFirstItems(player)
	local firstItems = {
		slots = {
			[CONST_SLOT_HEAD] = Game.createItem(3355),
			[CONST_SLOT_ARMOR] = Game.createItem(3562),
			[CONST_SLOT_LEGS] = Game.createItem(3559),
			[CONST_SLOT_FEET] = Game.createItem(3552),
		},
	}
	for slot, item in pairs(firstItems.slots) do
		local ret = player:addItemEx(item, false, sot)
		if not ret then
			player:addItemEx(item, false, INDEX_WHEREEVER, 0)
		end
	end
end

-- On step in tiles, for first step, second and third or more steps
local function tileStep(player, trial)
	-- First Step
	local vocationId = player:getVocation():getId()
	if vocationId == VOCATION.ID.NONE then
		for i = 1, #tutorialEffects do
			Position(trial.effectPosition):sendMagicEffect(tutorialEffects[i])
		end
		player:sendTutorial(trial.tutorialId)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As this is the first time you try out a vocation, the Guild has kitted you out. " .. trial.message)
		addFirstItems(player)
		-- Second step
	elseif player:getStorageValue(trial.storage) == -1 and vocationId ~= VOCATION.ID.NONE then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			string.format("As this is your first time as a \z
		" .. trial.vocation.name .. ", you received a few extra items. " .. trial.message)
		)
		player:setStorageValue(trial.storage, 1)
		player:sendTutorial(trial.tutorialId)
		-- Other steps
	elseif player:getStorageValue(trial.storage) == 1 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			string.format("You have received the weapons of a \z
		" .. trial.vocation.name .. ". " .. trial.message)
		)
	end
	return true
end

-- Remove vocation trial equipment items
local function removeItems(player)
	local equipmentItemIds = {
		21348, -- The scorcher
		21350, -- The chiller
		21400, -- Spellbook of the novice
		3350, -- Bow
		3267, -- Dagger
		3412, -- Wooden shield
		35562, -- Quiver
	}
	for i = 1, #equipmentItemIds do
		local equipmentItemAmount = player:getItemCount(equipmentItemIds[i])
		if equipmentItemAmount > 0 then
			player:removeItem(equipmentItemIds[i], equipmentItemAmount)
		end
	end
end

-- Add items to player from trial items data
local function addItems(player, items)
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	for i = 1, #items do
		local extra
		if not items[i].slot then
			extra = true
		else
			local equipped = player:getSlotItem(items[i].slot)
			if equipped and backpack then
				equipped:moveTo(backpack)
			end
		end
		local giveItem = true
		if items[i].limit and items[i].storage then
			local given = math.max(player:getStorageValue(items[i].storage), 0)
			if given >= items[i].limit then
				giveItem = false
			else
				player:setStorageValue(items[i].storage, given + 1)
			end
		end
		if giveItem then
			if extra then
				local itemType = ItemType(items[i].id)
				if itemType:getWeaponType() == WEAPON_AMMO and table.contains({ AMMO_ARROW, AMMO_BOLT }, itemType:getAmmoType()) then
					local equipment = player:getSlotItem(CONST_SLOT_RIGHT)
					local equipmentType = ItemType(equipment.itemid)
					if equipment and equipmentType:isQuiver() then
						equipment:addItem(items[i].id, items[i].amount)
					end
				else
					player:addItemEx(Game.createItem(items[i].id, items[i].amount), true, CONST_SLOT_WHEREEVER)
				end
			else
				player:addItemEx(Game.createItem(items[i].id, items[i].amount), true, items[i].slot)
			end
		end
	end
end

-- Set player outfit from trial outfit data
local function setOutfit(player, outfit)
	player:setOutfit({
		lookTypeEx = 0,
		lookType = outfit.lookType[player:getSex()],
		lookHead = outfit.lookHead,
		lookBody = outfit.lookBody,
		lookLegs = outfit.lookLegs,
		lookFeet = outfit.lookFeet,
		lookAddons = 0,
		lookMount = 0,
	})
end

-- Dawnport trial tiles step event
local dawnportVocationTrial = MoveEvent()

function dawnportVocationTrial.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local trial = vocationTrials[item.actionid]
	if trial then
		-- Center room position
		--local centerPosition = Position(32065, 31891, 5)
		--if centerPosition:getDistance(fromPosition) < centerPosition:getDistance(position) then
		-- Blocks the vocation trial if same vocation or after level 20
		if player:getVocation():getId() == trial.vocation.id or player:getLevel() >= 20 then
			return true
		end
		-- On step in the tile
		tileStep(player, trial)
		-- Change to new vocation, convert magic level and skills and set proper stats
		player:changeVocation(trial.vocation.id)
		-- Remove vocation trial equipment items
		removeItems(player)
		-- Add player item
		addItems(player, trial.items)
		-- Change outfit
		setOutfit(player, trial.vocation.outfit)
		player:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		--	return true
		--end
	end
	return true
end

for index, value in pairs(vocationTrials) do
	dawnportVocationTrial:aid(index)
end

dawnportVocationTrial:register()