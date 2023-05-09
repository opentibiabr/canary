local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local skill = Condition(CONDITION_ATTRIBUTES)
skill:setParameter(CONDITION_PARAM_SUBID, 5)
skill:setParameter(CONDITION_PARAM_TICKS, 13000)
skill:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, 220)
skill:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 65)
skill:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, 85)
skill:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
combat:addCondition(skill)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	if creature:getCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 5) then
		creature:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, 5)
	end
	return combat:execute(creature, variant)
end

spell:name("Protector")
spell:words("utamo tempo")
spell:group("support", "focus")
spell:vocation("knight;true", "elite knight;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_PROTECTOR)
spell:id(132)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000, 2 * 1000)
spell:level(55)
spell:mana(200)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
