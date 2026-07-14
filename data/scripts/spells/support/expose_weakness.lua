local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOW_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Aura of Exposed Weakness")
spell:words("exori moe tempo")
spell:group("support", "crippling")
spell:vocation("master sorcerer;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_EXPOSE_WEAKNESS)
spell:id(312)
spell:stance("crippling")
spell:cooldown(30 * 1000)
spell:groupCooldown(2 * 1000, 30 * 1000)
spell:level(175)
spell:mana(1500)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)

spell:register()
