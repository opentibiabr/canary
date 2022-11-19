local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_INVISIBLE)
condition:setParameter(CONDITION_PARAM_TICKS, 200000)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Invisibility")
spell:words("utana vid")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:id(45)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(35)
spell:mana(440)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
