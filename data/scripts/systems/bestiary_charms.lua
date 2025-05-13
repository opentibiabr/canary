local charms = {
	-- Wound charm
	[1] = {
		name = "Wound",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as physical damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_PHYSICALDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_HITAREA,
		points = { 240, 360, 1200 },
	},
	-- Enflame charm
	[2] = {
		name = "Enflame",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as fire damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_FIREDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_HITBYFIRE,
		points = { 400, 600, 2000 },
	},
	-- Poison charm
	[3] = {
		name = "Poison",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as earth damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_EARTHDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_GREEN_RINGS,
		points = { 240, 360, 1200 },
	},
	-- Freeze charm
	[4] = {
		name = "Freeze",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as ice damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_ICEDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_ICEATTACK,
		points = { 320, 480, 1600 },
	},
	-- Zap charm
	[5] = {
		name = "Zap",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as energy damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_ENERGYDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_ENERGYHIT,
		points = { 320, 480, 1600 },
	},
	-- Curse charm
	[6] = {
		name = "Curse",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as death damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_DEATHDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_SMALLCLOUDS,
		points = { 360, 540, 1800 },
	},
	-- Cripple charm
	[7] = {
		name = "Cripple",
		description = "Cripples the creature with a certain chance and paralyzes it for 10 seconds.",
		category = CHARM_MINOR,
		type = CHARM_OFFENSIVE,
		chance = { 6, 9, 12 },
		messageCancel = "You crippled a monster. (cripple charm)",
		points = { 100, 150, 225 },
	},
	-- Parry charm
	[8] = {
		name = "Parry",
		description = "Any damage taken is reflected to the aggressor with a certain chance.",
		category = CHARM_MAJOR,
		type = CHARM_DEFENSIVE,
		damageType = COMBAT_PHYSICALDAMAGE,
		chance = { 5, 10, 11 },
		messageCancel = "You parried an attack. (parry charm)",
		effect = CONST_ME_EXPLOSIONAREA,
		points = { 400, 600, 2000 },
	},
	-- Dodge charm
	[9] = {
		name = "Dodge",
		description = "Dodges an attack with a certain chance without taking any damage at all.",
		category = CHARM_MAJOR,
		type = CHARM_DEFENSIVE,
		chance = { 5, 10, 11 },
		messageCancel = "You dodged an attack. (dodge charm)",
		effect = CONST_ME_POFF,
		points = { 240, 360, 1200 },
	},
	-- Adrenaline Burst charm
	[10] = {
		name = "Adrenaline Burst",
		description = "Bursts of adrenaline enhance your reflexes with a certain chance \z
                       after you get hit and let you move faster for 10 seconds.",
		category = CHARM_MINOR,
		type = CHARM_DEFENSIVE,
		chance = { 6, 9, 12 },
		messageCancel = "Your movements where bursted. (adrenaline burst charm)",
		points = { 100, 150, 225 },
	},
	-- Numb charm
	[11] = {
		name = "Numb",
		description = "Numbs the creature with a certain chance after its attack and paralyzes the creature for 10 seconds.",
		category = CHARM_MINOR,
		type = CHARM_DEFENSIVE,
		chance = { 6, 9, 12 },
		messageCancel = "You numbed a monster. (numb charm)",
		points = { 100, 150, 225 },
	},
	-- Cleanse charm
	[12] = {
		name = "Cleanse",
		description = "Cleanses you from within with a certain chance after you get hit and \z
                       removes one random active negative status effect and temporarily makes you immune against it.",
		category = CHARM_MINOR,
		type = CHARM_DEFENSIVE,
		chance = { 6, 9, 12 },
		messageCancel = "You purified an attack. (cleanse charm)",
		points = { 100, 150, 225 },
	},
	-- Bless charm
	[13] = {
		name = "Bless",
		description = "Blesses you and reduces skill and xp loss by 10% when killed by the chosen creature.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		percent = 10,
		chance = { 6, 9, 12 },
		points = { 100, 150, 225 },
	},
	-- Scavenge charm
	[14] = {
		name = "Scavenge",
		description = "Enhances your chances to successfully skin/dust a skinnable/dustable creature.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 60, 90, 120 },
		points = { 100, 150, 225 },
	},
	-- Gut charm
	[15] = {
		name = "Gut",
		description = "Gutting the creature yields 20% more creature products.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 6, 9, 12 },
		points = { 100, 150, 225 },
	},
	-- Low blow charm
	[16] = {
		name = "Low Blow",
		description = "Adds 8% critical hit chance to attacks with critical hit weapons.",
		category = CHARM_MAJOR,
		type = CHARM_PASSIVE,
		chance = { 4, 8, 9 },
		points = { 800, 1200, 4000 },
	},
	-- Divine Wrath charm
	[17] = {
		name = "Divine Wrath",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as holy damage once.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_HOLYDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		effect = CONST_ME_HOLYDAMAGE,
		points = { 600, 900, 3000 },
	},
	-- Vampiric Embrace charm
	[18] = {
		name = "Vampiric Embrace",
		description = "Adds 4% Life Leech to attacks if wearing equipment that provides life leech.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 1.6, 2.4, 3.2 },
		points = { 100, 150, 225 },
	},
	-- Void's Call charm
	[19] = {
		name = "Void's Call",
		description = "Adds 2% Mana Leech to attacks if wearing equipment that provides mana leech.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 0.8, 1.2, 1.6 },
		points = { 100, 150, 225 },
	},
	-- Savage Blow charm
	[20] = {
		name = "Savage Blow",
		description = "Adds critical extra damage to attacks with critical hit weapons.",
		category = CHARM_MAJOR,
		type = CHARM_PASSIVE,
		chance = { 20, 40, 44 },
		points = { 800, 1200, 4000 },
	},
	-- Fatal Hold charm
	[21] = {
		name = "Fatal Hold",
		description = "Prevents creatures from fleeing due to low health for 30 seconds.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 30, 45, 60 },
		messageCancel = "Your enemy is not able to flee now for 30 \z
													seconds. (fatal hold charm)",
		points = { 100, 150, 225 },
	},
	-- Void Inversion charm
	[22] = {
		name = "Void Inversion",
		description = "Chance to gain mana instead of losing it when taking Mana Drain damage.",
		category = CHARM_MINOR,
		type = CHARM_PASSIVE,
		chance = { 20, 30, 40 },
		points = { 100, 150, 225 },
	},
	-- Carnage charm
	[23] = {
		name = "Carnage",
		description = "Killing a monster deals physical damage to others in a small radius.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_NEUTRALDAMAGE,
		percent = 15,
		chance = { 10, 20, 22 },
		messageServerLog = true,
		points = { 600, 900, 3000 },
	},
	-- Overpower charm
	[24] = {
		name = "Overpower",
		description = "Deals physical damage based on your maximum health.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_NEUTRALDAMAGE,
		percent = 5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		points = { 600, 900, 3000 },
	},
	-- Overflux charm
	[25] = {
		name = "Overflux",
		description = "Deals physical damage based on your maximum mana.",
		category = CHARM_MAJOR,
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_NEUTRALDAMAGE,
		percent = 2.5,
		chance = { 5, 10, 11 },
		messageServerLog = true,
		points = { 600, 900, 3000 },
	},
}

for charmId, charmsTable in ipairs(charms) do
	local charm = Game.createBestiaryCharm(charmId - 1)
	local charmConfig = {}

	local bestiaryRateCharmShopPrice = (configManager.getFloat(configKeys.BESTIARY_RATE_CHARM_SHOP_PRICE) or 1.0)
	if charmsTable.name then
		charmConfig.name = charmsTable.name
	end
	if charmsTable.description then
		charmConfig.description = charmsTable.description
	end
	if charmsTable.category then
		charmConfig.category = charmsTable.category
	end
	if charmsTable.type then
		charmConfig.type = charmsTable.type
	end
	if charmsTable.damageType then
		charmConfig.damageType = charmsTable.damageType
	end
	if charmsTable.percent then
		charmConfig.percent = charmsTable.percent
	end
	if charmsTable.chance then
		charmConfig.chance = charmsTable.chance
	end
	if charmsTable.messageCancel then
		charmConfig.messageCancel = charmsTable.messageCancel
	end
	if charmsTable.messageServerLog then
		charmConfig.messageServerLog = charmsTable.messageServerLog
	end
	if charmsTable.effect then
		charmConfig.effect = charmsTable.effect
	end
	if charmsTable.points then
		charmConfig.points = charmsTable.points
	end

	-- Create charm and egister charmConfig table
	charm:register(charmConfig)
end
