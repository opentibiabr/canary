local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, maglevel) -- already compared to the official tibia | compared date: 08/03/21(m/d/y) -- possible max limit of 30?, need test in magic level 71+.
	local min = (level * 0 + maglevel * 0.1614) + 8
	local max = (level * 0 + maglevel * 0.2468) + 15
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Magic Patch")
spell:words("exura infir")
spell:group("healing")
spell:vocation("druid;true", "elder druid;true", "paladin;true", "royal paladin;true", "sorcerer;true", "master sorcerer;true", "monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MAGIC_PATCH)
spell:id(174)
spell:cooldown(1 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(1)
spell:mana(6)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:isPremium(false)
spell:register()
