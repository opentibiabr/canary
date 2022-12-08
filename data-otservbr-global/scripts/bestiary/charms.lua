local charms = {
	-- Wound charm
	[1] = {
		name = "Wound",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as physical damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_PHYSICALDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You wounded the monster.",
		messageServerLog = "[Wound charm]",
		effect = CONST_ME_HITAREA,
		points = 600
	},
	-- Enflame charm
	[2] = {
		name = "Enflame",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as fire damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_FIREDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You enflamed the monster.",
		messageServerLog = "[Enflame charm]",
		effect = CONST_ME_HITBYFIRE,
		points = 1000
	},
	-- Poison charm
	[3] = {
		name = "Poison",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as earth damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_EARTHDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You poisoned the monster.",
		messageServerLog = "[Poison charm]",
		effect = CONST_ME_GREEN_RINGS,
		points = 600
	},
	-- Freeze charm
	[4] = {
		name = "Freeze",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as ice damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_ICEDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You frozen the monster.",
		messageServerLog = "[Freeze charm]",
		effect = CONST_ME_ICEATTACK,
		points = 800
	},
	--Zap charm
	[5] = {
		name = "Zap",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as energy damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_ENERGYDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You eletrocuted the monster.",
		messageServerLog = "[Zap charm]",
		effect = CONST_ME_ENERGYHIT,
		points = 800
	},
	--Curse charm
	[6] = {
		name = "Curse",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as death damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_DEATHDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You curse the monster.",
		messageServerLog = "[Curse charm]",
		effect = CONST_ME_SMALLCLOUDS,
		points = 900
	},
	-- Cripple charm
	[7] = {
		name = "Cripple",
		description = "Cripples the creature with a certain chance and paralyzes it for 10 seconds.",
		type = CHARM_OFFENSIVE,
		chance = 10,
		messageCancel = "You cripple the monster.",
		points = 500
	},
	-- Parry charm
	[8] = {
		name = "Parry",
		description = "Any damage taken is reflected to the aggressor with a certain chance.",
		type = CHARM_DEFENSIVE,
		damageType = COMBAT_PHYSICALDAMAGE,
		chance = 10,
		messageCancel = "You parry the attack.",
		messageServerLog = "[Parry charm]",
		effect = CONST_ME_EXPLOSIONAREA,
		points = 1000
	},
	-- Dodge charm
	[9] = {
		name = "Dodge",
		description = "Dodges an attack with a certain chance without taking any damage at all.",
		type = CHARM_DEFENSIVE,
		chance = 10,
		messageCancel = "You dodge the attack.",
		effect = CONST_ME_POFF,
		points = 600
	},
	-- Adrenaline burst charm
	[10] = {
		name = "Adrenaline Burst",
		description = "Bursts of adrenaline enhance your reflexes with a certain chance \z
                       after you get hit and let you move faster for 10 seconds.",
		type = CHARM_DEFENSIVE,
		chance = 10,
		messageCancel = "Your movements where bursted.",
		points = 500
	},
	-- Numb charm
	[11] = {
		name = "Numb",
		description = "Numbs the creature with a certain chance after its attack and paralyzes the creature for 10 seconds.",
		type = CHARM_DEFENSIVE,
		chance = 10,
		messageCancel = "You numb the monster.",
		points = 500
	},
	-- Cleanse charm
	[12] = {
		name = "Cleanse",
		description = "Cleanses you from within with a certain chance after you get hit and \z
                       removes one random active negative status effect and temporarily makes you immune against it.",
		type = CHARM_DEFENSIVE,
		chance = 10,
		messageCancel = "You purified the attack.",
		points = 700
	},
	-- Bless charm
	[13] = {
		name = "Bless",
		description = "Blesses you and reduces skill and xp loss by 10% when killed by the chosen creature.",
		type = CHARM_PASSIVE,
		percent = 10,
		chance = 100,
		points = 800
	},
	-- Scavenge charm
	[14] = {
		name = "Scavenge",
		description = "Enhances your chances to successfully skin/dust a skinnable/dustable creature.",
		type = CHARM_PASSIVE,
		percent = 25,
		chance = 100,
		points = 800
	},
	-- Gut charm
	[15] = {
		name = "Gut",
		description = "Gutting the creature yields 20% more creature products.",
		type = CHARM_PASSIVE,
		percent = 20,
		chance = 100,
		points = 800,
	},
	-- Low blow charm
	[16] = {
		name = "Low Blow",
		description = "Adds 8% critical hit chance to attacks with critical hit weapons.",
		type = CHARM_PASSIVE,
		percent = 8,
		chance = 100,
		points = 2000
	},
	-- Divine wrath charm
	[17] = {
		name = "Divine Wrath",
		description = "Triggers on a creature with a certain chance and deals 5% \z
                       of its initial hit points as holy damage once.",
		type = CHARM_OFFENSIVE,
		damageType = COMBAT_HOLYDAMAGE,
		percent = 5,
		chance = 10,
		messageCancel = "You divine the monster.",
		messageServerLog = "[Divine charm]",
		effect = CONST_ME_HOLYDAMAGE,
		points = 1500
	},
	-- Vampiric embrace charm
	[18] = {
		name = "Vampiric Embrace",
		description = "Adds 4% Life Leech to attacks if wearing equipment that provides life leech.",
		type = CHARM_PASSIVE,
		percent = 4,
		chance = 100,
		points = 1500
	},
	-- Void's call charm
	[19] = {
		name = "Void's Call",
		description = "Adds 2% Mana Leech to attacks if wearing equipment that provides mana leech.",
		type = CHARM_PASSIVE,
		percent = 2,
		chance = 100,
		points = 1500
	}
}

for charmId, chamsTable in ipairs(charms) do
	local charm = Game.createBestiaryCharm(charmId - 1)
	local charmConfig = {}

	if chamsTable.name then
		charmConfig.name = chamsTable.name
	end
	if chamsTable.description then
		charmConfig.description = chamsTable.description
	end
	if chamsTable.type then
		charmConfig.type = chamsTable.type
	end
	if chamsTable.damageType then
		charmConfig.damageType = chamsTable.damageType
	end
	if chamsTable.percent then
		charmConfig.percent = chamsTable.percent
	end
	if chamsTable.chance then
		charmConfig.chance = chamsTable.chance
	end
	if chamsTable.messageCancel then
		charmConfig.messageCancel = chamsTable.messageCancel
	end
	if chamsTable.messageServerLog then
		charmConfig.messageServerLog = chamsTable.messageServerLog
	end
	if chamsTable.effect then
		charmConfig.effect = chamsTable.effect
	end
	if chamsTable.points then
		charmConfig.points = chamsTable.points
	end

	-- Create charm and egister charmConfig table
	charm:register(charmConfig)
end
