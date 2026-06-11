local SPELL_BASE_POWER = 130

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)

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
spell:id(286)
spell:name("Forceful Uppercut")
spell:words("exori gran pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_ANNIHILATION)
spell:level(110)
spell:mana(325)
spell:isPremium(true)
spell:range(1)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:monkSpellType(MonkSpell_Builder)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
