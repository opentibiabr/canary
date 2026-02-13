local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_SUBID, AttrSubId_VirtueOfJustice)
condition:setParameter(CONDITION_PARAM_TICKS, -1)
condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, 115)
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local conditionSereneBoost = Condition(CONDITION_ATTRIBUTES)
conditionSereneBoost:setParameter(CONDITION_PARAM_SUBID, AttrSubId_VirtueOfJustice)
conditionSereneBoost:setParameter(CONDITION_PARAM_TICKS, -1)
conditionSereneBoost:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, 130)
conditionSereneBoost:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:removeCondition(CONDITION_ATTRIBUTES, CONDITIONID_COMBAT, AttrSubId_VirtueOfJustice)

	player:setVirtue(Virtue_Justice)

	local hasSerene = player:getCondition(CONDITION_SERENE, CONDITIONID_DEFAULT)
	if hasSerene then
		player:addCondition(conditionSereneBoost)
	else
		player:addCondition(condition)
	end

	return combat:execute(player, variant)
end

spell:name("Virtue of Justice")
spell:words("utito virtu")
spell:group("support", "virtue")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_PROTECTOR)
spell:id(275)
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000, 10 * 1000)
spell:level(20)
spell:mana(210)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
