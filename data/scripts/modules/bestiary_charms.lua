--
-- Wound charm
--
local charm_1 = Game.createBestiaryCharm(0)
local charm_t1 = {}

charm_t1.name = "Wound"
charm_t1.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as physical damage once."
charm_t1.type = CHARM_OFFENSIVE
charm_t1.damageType = COMBAT_PHYSICALDAMAGE
charm_t1.percent = 10
charm_t1.chance = 20
charm_t1.messageCancel = "You wounded the monster."
charm_t1.messageServerLog = "[Wound charm]"
charm_t1.effect = CONST_ME_HITAREA
charm_t1.points = 600

Bestiaryregister(charm_1, charm_t1)
--
-- Enflame charm
--
local charm_2 = Game.createBestiaryCharm(1)
local charm_t2 = {}

charm_t2.name = "Enflame"
charm_t2.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as fire damage once."
charm_t2.type = CHARM_OFFENSIVE
charm_t2.damageType = COMBAT_FIREDAMAGE
charm_t2.percent = 10
charm_t2.chance = 20
charm_t2.messageCancel = "You enflamed the monster."
charm_t2.messageServerLog = "[Enflame charm]"
charm_t2.effect = CONST_ME_HITBYFIRE
charm_t2.points = 1000

Bestiaryregister(charm_2, charm_t2)
--
-- Poison charm
--
local charm_3 = Game.createBestiaryCharm(2)
local charm_t3 = {}

charm_t3.name = "Poison"
charm_t3.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as earth damage once."
charm_t3.type = CHARM_OFFENSIVE
charm_t3.damageType = COMBAT_EARTHDAMAGE
charm_t3.percent = 10
charm_t3.chance = 20
charm_t3.messageCancel = "You poisoned the monster."
charm_t3.messageServerLog = "[Poison charm]"
charm_t3.effect = CONST_ME_GREEN_RINGS
charm_t3.points = 600

Bestiaryregister(charm_3, charm_t3)
--
-- Freeze charm
--
local charm_4 = Game.createBestiaryCharm(3)
local charm_t4 = {}

charm_t4.name = "Freeze"
charm_t4.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as ice damage once."
charm_t4.type = CHARM_OFFENSIVE
charm_t4.damageType = COMBAT_ICEDAMAGE
charm_t4.percent = 10
charm_t4.chance = 20
charm_t4.messageCancel = "You frozen the monster."
charm_t4.messageServerLog = "[Freeze charm]"
charm_t4.effect = CONST_ME_ICEATTACK
charm_t4.points = 800

Bestiaryregister(charm_4, charm_t4)
--
-- Zap charm
--
local charm_5 = Game.createBestiaryCharm(4)
local charm_t5 = {}

charm_t5.name = "Zap"
charm_t5.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as energy damage once."
charm_t5.type = CHARM_OFFENSIVE
charm_t5.damageType = COMBAT_ENERGYDAMAGE
charm_t5.percent = 10
charm_t5.chance = 20
charm_t5.messageCancel = "You eletrocuted the monster."
charm_t5.messageServerLog = "[Zap charm]"
charm_t5.effect = CONST_ME_ENERGYHIT
charm_t5.points = 800

Bestiaryregister(charm_5, charm_t5)
--
-- Curse charm
--
local charm_6 = Game.createBestiaryCharm(5)
local charm_t6 = {}

charm_t6.name = "Curse"
charm_t6.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as death damage once."
charm_t6.type = CHARM_OFFENSIVE
charm_t6.damageType = COMBAT_DEATHDAMAGE
charm_t6.percent = 10
charm_t6.chance = 20
charm_t6.messageCancel = "You curse the monster."
charm_t6.messageServerLog = "[Curse charm]"
charm_t6.effect = CONST_ME_SMALLCLOUDS
charm_t6.points = 900

Bestiaryregister(charm_6, charm_t6)


--
-- Cripple charm
--
local charm7 = Game.createBestiaryCharm(6)
local charm_t7 = {}

charm_t7.name = "Cripple"
charm_t7.description = "Cripples the creature with a certain chance and paralyzes it for 10 seconds."
charm_t7.type = CHARM_OFFENSIVE
charm_t7.chance = 20
charm_t7.messageCancel = "You cripple the monster."
charm_t7.points = 500

Bestiaryregister(charm7, charm_t7)
--
-- Parry charm
--
local charm_8 = Game.createBestiaryCharm(7)
local charm_t8 = {}

charm_t8.name = "Parry"
charm_t8.description = "Any damage taken is reflected to the aggressor with a certain chance."
charm_t8.type = CHARM_DEFENSIVE
charm_t8.damageType = COMBAT_PHYSICALDAMAGE
charm_t8.chance = 10
charm_t8.messageCancel = "You parry the attack."
charm_t8.messageServerLog = "[Parry charm]"
charm_t8.effect = CONST_ME_EXPLOSIONAREA
charm_t8.points = 1000

Bestiaryregister(charm_8, charm_t8)
--
-- Dodge charm
--
local charm_9 = Game.createBestiaryCharm(8)
local charm_t9 = {}

charm_t9.name = "Dodge"
charm_t9.description = "Dodges an attack with a certain chance without taking any damage at all."
charm_t9.type = CHARM_DEFENSIVE
charm_t9.chance = 20
charm_t9.messageCancel = "You dodge the attack."
charm_t9.effect = CONST_ME_POFF
charm_t9.points = 600

Bestiaryregister(charm_9, charm_t9)
--
-- Adrenaline burst charm
--
local charm_10 = Game.createBestiaryCharm(9)
local charm_t10 = {}

charm_t10.name = "Adrenaline Burst"
charm_t10.description = "Bursts of adrenaline enhance your reflexes with a certain chance \z
			after you get hit and let you move faster for 10 seconds."
charm_t10.type = CHARM_DEFENSIVE
charm_t10.chance = 20
charm_t10.messageCancel = "Your movements where bursted."
charm_t10.points = 500

Bestiaryregister(charm_10, charm_t10)
--
-- Numb charm
--
local charm_11 = Game.createBestiaryCharm(10)
local charm_t11 = {}

charm_t11.name = "Numb"
charm_t11.description = "Numbs the creature with a certain chance after its attack and paralyzes the creature for 10 seconds."
charm_t11.type = CHARM_DEFENSIVE
charm_t11.chance = 20
charm_t11.messageCancel = "You numb the monster."
charm_t11.points = 500

Bestiaryregister(charm_11, charm_t11)
--
-- Cleanse charm
--
local charm_12 = Game.createBestiaryCharm(11)
local charm_t12 = {}

charm_t12.name = "Cleanse"
charm_t12.description = "Cleanses you from within with a certain chance after you get hit and \z
			removes one random active negative status effect and temporarily makes you immune against it."
charm_t12.type = CHARM_DEFENSIVE
charm_t12.chance = 20
charm_t12.messageCancel = "You purified the attack."
charm_t12.points = 700

Bestiaryregister(charm_12, charm_t12)
--
-- Bless charm
--
local charm_13 = Game.createBestiaryCharm(12)
local charm_t13 = {}

charm_t13.name = "Bless"
charm_t13.description = "Blesses you and reduces skill and xp loss by 10% \z
			when killed by the chosen creature."
charm_t13.type = CHARM_PASSIVE
charm_t13.percent = 10
charm_t13.chance = 100
charm_t13.points = 800

Bestiaryregister(charm_13, charm_t13)

--
-- Scavenge charm
--
local charm_14 = Game.createBestiaryCharm(13)
local charm_t14 = {}

charm_t14.name = "Scavenge"
charm_t14.description = "Enhances your chances to successfully skin/dust a skinnable/dustable creature."
charm_t14.type = CHARM_PASSIVE
charm_t14.percent = 10
charm_t14.points = 800

GLOBAL_CHARM_SCAVENGE = charm_t14.percent
Bestiaryregister(charm_14, charm_t14)
--
-- Gut charm
--
local charm_15 = Game.createBestiaryCharm(14)
local charm_t15 = {}

charm_t15.name = "Gut"
charm_t15.description = "Gutting the creature yields 20% more creature products."
charm_t15.type = CHARM_PASSIVE
charm_t15.percent = 20
charm_t15.points = 800

GLOBAL_CHARM_GUT = charm_t15.percent
Bestiaryregister(charm_15, charm_t15)
--
-- Low blow charm
--
local charm_16 = Game.createBestiaryCharm(15)
local charm_t16 = {}

charm_t16.name = "Low Blow"
charm_t16.description = "Adds 8% critical hit chance to attacks with critical hit weapons."
charm_t16.type = CHARM_PASSIVE
charm_t16.percent = 8
charm_t16.chance = 0
charm_t16.points = 2000

Bestiaryregister(charm_16, charm_t16)
--
-- Divine wrath charm
--
local charm_17 = Game.createBestiaryCharm(16)
local charm_t17 = {}

charm_t17.name = "Divine Wrath"
charm_t17.description = "Triggers on a creature with a certain chance and deals 5% \z
			of its initial hit points as holy damage once."
charm_t17.type = CHARM_OFFENSIVE
charm_t17.damageType = COMBAT_HOLYDAMAGE
charm_t17.percent = 10
charm_t17.chance = 20
charm_t17.messageCancel = "You divine the monster."
charm_t17.messageServerLog = "[Divine charm]"
charm_t17.effect = CONST_ME_HOLYDAMAGE
charm_t17.points = 1500

Bestiaryregister(charm_17, charm_t17)
--
-- Vampiric embrace charm
--
local charm_18 = Game.createBestiaryCharm(17)
local charm_t18 = {}

charm_t18.name = "Vampiric Embrace"
charm_t18.description = "Adds 4% Life Leech to attacks if wearing equipment that  \z
			provides life leech."
charm_t18.type = CHARM_PASSIVE
charm_t18.percent = 4
charm_t18.chance = 0
charm_t18.points = 1500

Bestiaryregister(charm_18, charm_t18)
--
-- Void's call charm
--
local charm_19 = Game.createBestiaryCharm(18)
local charm_t19 = {}

charm_t19.name = "Void's Call"
charm_t19.description = "Adds 2% Mana Leech to attacks if wearing equipment that  \z
			provides mana leech."
charm_t19.type = CHARM_PASSIVE
charm_t19.percent = 2
charm_t19.chance = 0
charm_t19.points = 1500

Bestiaryregister(charm_19, charm_t19)
