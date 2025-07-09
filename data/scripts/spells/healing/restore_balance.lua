local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel)
	local min = ((level * 0.3 + magicLevel * 7) + 3)
	local max = ((level * 0.3 + magicLevel * 11) + 5)
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return combat:execute(creature, variant)
end

spell:name("Restore Balance")
spell:words("exura tio sio")
spell:group("healing")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_RESTORE_BALANCE)
spell:id(297)
spell:cooldown(2 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(18)
spell:mana(120)
spell:needTarget(true)
spell:hasParams(true)
spell:hasPlayerNameParam(true)
spell:allowOnSelf(false)
spell:isAggressive(false)
spell:isPremium(true)
spell:register()
