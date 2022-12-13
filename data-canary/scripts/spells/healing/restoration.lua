local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level * 1.4 / 5) + (maglevel * 9.22 * 1.4) + 44 * 1.4
	local max = (level * 1.4 / 5) + (maglevel * 10.79 * 1.4) + 79 * 1.4 -- TODO: Formulas (Right now using 40% extra on Ultimate Healing with closer min and max values to the avg)
	return min, max
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:group("healing")
spell:id(241)
spell:name("Restoration")
spell:words("exura max vita")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_RESTORATION)
spell:level(300)
spell:mana(260)
spell:isSelfTarget(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(1 * 1000)
spell:isAggressive(false)
spell:needLearn(false)
spell:vocation("druid;true", "sorcerer;true", "elder druid;true", "master sorcerer;true")
spell:register()