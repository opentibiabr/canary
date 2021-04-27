local mType = Game.createMonsterType("Mirror Image")
local monster = {}

monster.description = "a mirror image"
monster.experience = 0
monster.outfit = {
	lookType = 136,
	lookHead = 76,
	lookBody = 114,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 0
monster.speed = 235
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Delusional!", yell = false},
	{text = "I'll be your worst nightmare", yell = true},
	{text = "The mirrors can't contain the night.", yell = true},
	{text = "What a lovely reflection.", yell = true}
}

monster.loot = {
}

monster.attacks = {

	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ICEDAMAGE, minDamage = -450, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true},
	{name ="combat", interval = 2000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -1000, radius = 4, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -550, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -450, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true}
	-- Chain: const_me-> CONST_ME_BLUE_ENERGY_SPARK, combat_t->COMBAT_ICEDAMAGE
}

monster.defenses = {
	defense = 75,
	armor = 100
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

monster.events = {
	"MirrorImageTransform"
}

mType:register(monster)

local mirrorImageTransform = CreatureEvent("MirrorImageTransform")

function mirrorImageTransform.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if attacker:isPlayer() then
		local newForm = nil
		if attacker:isSorcerer() then
			newForm = "Sorcerer's Apparition"
		elseif attacker:isDruid() then
			newForm = "Druid's Apparition"
		elseif attacker:isPaladin() then
			newForm = "Paladin's Apparition"
		elseif attacker:isKnight() then
			newForm = "Knight's Apparition"
		end
		if newForm then
			creature:setType(newForm)
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

mirrorImageTransform:register()
