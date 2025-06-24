local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel)
	local min = ((level * 0.2 + magicLevel * 12) + 75)
	local max = ((level * 0.2 + magicLevel * 20) + 125)
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Spirit Mend")
spell:words("exura gran tio")
spell:group("healing")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SPIRIT_MEND)
spell:id(273)
spell:cooldown(1000)
spell:groupCooldown(1000)
spell:level(80)
spell:mana(210)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
