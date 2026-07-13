local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOW_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Divine Defiance")
spell:words("utori hur")
spell:group("support", "stance")
spell:vocation("royal paladin;true")
spell:id(314)
spell:stance("standard")
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000, 10 * 1000)
spell:level(20)
spell:mana(250)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)

spell:register()
