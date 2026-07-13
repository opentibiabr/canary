local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if creature:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector) then
		creature:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_BloodRageProtector)
	end
	return combat:execute(creature, var)
end

spell:name("Blood Rage")
spell:words("utito tempo")
spell:group("support", "stance")
spell:vocation("elite knight;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BLOOD_RAGE)
spell:id(133)
spell:stance("standard")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000, 2 * 1000)
spell:level(20)
spell:mana(20)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)

spell:register()
