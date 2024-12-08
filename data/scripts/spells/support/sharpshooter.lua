local spellDuration = 10000

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local speed = Condition(CONDITION_PARALYZE)
speed:setParameter(CONDITION_PARAM_TICKS, spellDuration)
speed:setFormula(0.7, 56, 0.7, 56)
combat:addCondition(speed)

local exhaustHealGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
exhaustHealGroup:setParameter(CONDITION_PARAM_SUBID, 2)
exhaustHealGroup:setParameter(CONDITION_PARAM_TICKS, spellDuration)
combat:addCondition(exhaustHealGroup)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	if combat:execute(creature, variant) then
		local skill = Condition(CONDITION_ATTRIBUTES)
		skill:setParameter(CONDITION_PARAM_SUBID, AttrSubId_Sharpshooter)
		skill:setParameter(CONDITION_PARAM_TICKS, spellDuration)
		local grade = creature:upgradeSpellsWOD("Sharpshooter")
		if grade == WHEEL_GRADE_NONE then
			local exhaustSupportGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
			exhaustSupportGroup:setParameter(CONDITION_PARAM_SUBID, 3)
			exhaustSupportGroup:setParameter(CONDITION_PARAM_TICKS, spellDuration)
			creature:addCondition(exhaustSupportGroup)
		end
		if grade == WHEEL_GRADE_UPGRADED then
			skill:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 145)
		else
			skill:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 140)
		end
		skill:setParameter(CONDITION_PARAM_DISABLE_DEFENSE, true)
		skill:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
		creature:addCondition(skill)
		return true
	end
	return false
end

spell:name("Sharpshooter")
spell:words("utito tempo san")
spell:group("support", "focus")
spell:vocation("paladin;true", "royal paladin;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SHARPSHOOTER)
spell:id(135)
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000, 10 * 1000)
spell:level(60)
spell:mana(450)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(false)
spell:needLearn(false)
spell:register()
