local SPELL_BASE_POWER = 100

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHIRLWIND_BLOW_WHITE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)
combat:setArea(createCombatArea(AREA_GREATER_FLURRY_OF_BLOWS))

function onGetFormulaValues(player, skill, attack, factor)
	local damageHealing = player:calculateFlatDamageHealing()

	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + damageHealing

	local min = damage - (damage / 10)
	local max = damage + (damage / 10)

	return min, max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(289)
spell:name("Greater Flurry of Blows")
spell:words("exori gran mas pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BERSERK)
spell:level(90)
spell:mana(300)
spell:isPremium(true)
spell:needDirection(true)
spell:cooldown(16 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:monkSpellType(MonkSpell_Builder)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
