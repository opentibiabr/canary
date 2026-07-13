local SPELL_BASE_POWER = 800

local function getMassHealing(player)
	local healing = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * player:getMagicLevel()) + (SPELL_BASE_POWER / 4)
	return healing * 0.9, healing * 1.1
end

local function getSelfHealing(player)
	local level = player:getLevel()
	local magicLevel = player:getMagicLevel()
	local min = (level * 0.2 + magicLevel * 7.22) + 44
	local max = (level * 0.2 + magicLevel * 12.79) + 79
	return min, max
end

local function targetFunction(creature, target)
	local player = creature:getPlayer()
	local min, max
	if creature == target then
		min, max = getSelfHealing(player)
	else
		min, max = getMassHealing(player)
	end

	local bosses = { "leiden", "ravennous hunger", "dorokoll the mystic", "eshtaba the conjurer", "eliz the unyielding", "mezlon the defiler", "malkhar deathbringer", "containment crystal" }
	local master = target:getMaster()
	if (target:isMonster() and not master) or (master and master:isMonster()) then
		if not table.contains(bosses, target:getName():lower()) then
			return true
		end
	end

	doTargetCombatHealth(creature, target, COMBAT_HEALING, min, max, CONST_ME_NONE, ORIGIN_SPELL, "Mass Spirit Mend")
end

function onTargetCreature(creature, target)
	targetFunction(creature, target)
	return true
end

local function createCombat(area, combatFunc)
	local initCombat = Combat()
	initCombat:setCallback(CALLBACK_PARAM_TARGETCREATURE, combatFunc)
	initCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
	initCombat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
	initCombat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
	initCombat:setArea(createCombatArea(area))
	return initCombat
end

local combat = createCombat(AREA_MASS_SPIRIT_MEND, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Mass Spirit Mend")
spell:words("exura mas nia")
spell:group("healing")
spell:vocation("monk;true", "exalted monk;true")
spell:id(296)
spell:cooldown(12 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(150)
spell:mana(400)
spell:isPremium(true)
spell:isAggressive(false)

spell:castSound(SOUND_EFFECT_TYPE_SPELL_MASS_HEALING)
spell:register()
