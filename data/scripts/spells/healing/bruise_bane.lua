local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(_player, level, magicLevel) -- already compared to the official tibia | compared date: 08/03/21(m/d/y) (need more chars test accuracy)
	local min = (level * 0.2 + magicLevel * 1.795)
	local max = (level * 0.2 + magicLevel * 1.795) + 5
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Bruise Bane")
spell:words("exura infir ico")
spell:group("healing")
spell:vocation("knight;true", "elite knight;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BRUISE_BANE)
spell:id(170)
spell:cooldown(1000)
spell:groupCooldown(1000)
spell:level(1)
spell:mana(10)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:isPremium(false)
spell:register()
