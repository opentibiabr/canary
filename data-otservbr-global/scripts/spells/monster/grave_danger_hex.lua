for _, greater in ipairs({ false, true }) do
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_AGGRESSIVE, true)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STUN)
	combat:setArea(createCombatArea(greater and AREA_BEAM7 or AREA_CIRCLE3X3))
	local condition = Condition(greater and CONDITION_GREATERHEX or CONDITION_LESSERHEX)
	condition:setParameter(CONDITION_PARAM_TICKS, 30000)
	condition:setParameter(CONDITION_PARAM_BUFF_HEALINGRECEIVED, 50)
	if greater then
		condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 50)
		condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, 40)
	end
	combat:addCondition(condition)
	local spell = Spell("instant")
	function spell.onCastSpell(creature, var)
		return combat:execute(creature, var)
	end
	spell:name(greater and "grave danger greater hex" or "grave danger lesser hex")
	spell:words(greater and "###gravegreaterhex" or "###gravelesserhex")
	spell:needDirection(greater)
	spell:needLearn(true)
	spell:isAggressive(true)
	spell:register()
end
