local spell = Spell("instant")

local MENTOR_BUFF_DURATION = 60 * 1000
local AttrSubId_MentorOther = 3000

function spell.onCastSpell(creature, variant)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local target = Player(variant:getNumber())
	if not target or target:getId() == player:getId() then
		return false
	end

	local conditionTarget = Condition(CONDITION_ATTRIBUTES)
	conditionTarget:setParameter(CONDITION_PARAM_SUBID, AttrSubId_MentorOther)
	conditionTarget:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	conditionTarget:setParameter(CONDITION_PARAM_TICKS, MENTOR_BUFF_DURATION)

	if target:isKnight() then
		conditionTarget:setParameter(CONDITION_PARAM_DEFENSEPERCENT, 103)
	elseif target:isPaladin() then
		conditionTarget:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 105)
	elseif target:isSorcerer() then
		conditionTarget:setParameter(CONDITION_PARAM_MAGICLEVELPERCENT, 105)
	elseif target:isDruid() then
		conditionTarget:setParameter(CONDITION_PARAM_HEALINGPERCENT, 105)
	elseif target:isMonk() then
		conditionTarget:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, 102)
	end

	target:addCondition(conditionTarget)
	target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	local conditionMonk = Condition(CONDITION_ATTRIBUTES)
	conditionMonk:setParameter(CONDITION_PARAM_SUBID, AttrSubId_MentorOther)
	conditionMonk:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	conditionMonk:setParameter(CONDITION_PARAM_TICKS, MENTOR_BUFF_DURATION)
	conditionMonk:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, 102)

	player:addCondition(conditionMonk)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	return true
end

spell:group("support")
spell:id(277)
spell:name("Mentor Other")
spell:words("uteta tio")
spell:level(150)
spell:mana(110)
spell:isPremium(false)
spell:needLearn(false)
spell:groupCooldown(2 * 1000)
spell:cooldown(2 * 1000)
spell:hasPlayerNameParam(true)
spell:hasParams(true)
spell:needTarget(true)
spell:allowOnSelf(false)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
