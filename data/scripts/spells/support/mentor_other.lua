local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local conditionTicks = 60 * 1000

local knightCondition = Condition(CONDITION_MENTOROTHER)
knightCondition:setParameter(CONDITION_PARAM_SUBID, MentorOther)
knightCondition:setParameter(CONDITION_PARAM_TICKS, conditionTicks)
knightCondition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, 97)

-- TODO: Add a buff that only increases the auto attack damage
local paladinCondition = Condition(CONDITION_MENTOROTHER)
paladinCondition:setParameter(CONDITION_PARAM_SUBID, MentorOther)
paladinCondition:setParameter(CONDITION_PARAM_TICKS, conditionTicks)
paladinCondition:setParameter(CONDITION_PARAM_BUFF_AUTOATTACKDEALT, 105)

local sorcererCondition = Condition(CONDITION_MENTOROTHER)
sorcererCondition:setParameter(CONDITION_PARAM_SUBID, MentorOther)
sorcererCondition:setParameter(CONDITION_PARAM_TICKS, conditionTicks)
sorcererCondition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 105)

local druidCondition = Condition(CONDITION_MENTOROTHER)
druidCondition:setParameter(CONDITION_PARAM_SUBID, MentorOther)
druidCondition:setParameter(CONDITION_PARAM_TICKS, conditionTicks)
druidCondition:setParameter(CONDITION_PARAM_BUFF_HEALINGDEALT, 105)

local monkCondition = Condition(CONDITION_MENTOROTHER)
monkCondition:setParameter(CONDITION_PARAM_SUBID, MentorOther)
monkCondition:setParameter(CONDITION_PARAM_TICKS, conditionTicks)
monkCondition:setParameter(CONDITION_PARAM_BUFF_HARMONYBONUS, 102)

local CONDITION_BY_VOCATION_BASE_ID = {
	[1] = sorcererCondition,
	[2] = druidCondition,
	[3] = paladinCondition,
	[4] = knightCondition,
	[9] = monkCondition,
}

function onTargetCreature(creature, target)
	local player = target:getPlayer()
	if player then
		local vocationBaseId = player:getVocation():getBaseId()
		if vocationBaseId ~= 0 then
			local cond = CONDITION_BY_VOCATION_BASE_ID[vocationBaseId]
			if cond then
				target:addCondition(cond)
				return true
			end
		end
	end
	return false
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Mentor Other")
spell:words("uteta tio")
spell:group("support")
spell:vocation("monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_HEAL_FRIEND)
spell:id(277)
spell:cooldown(50 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(150)
spell:mana(110)
spell:range(7)
spell:hasParams(true)
spell:hasPlayerNameParam(true)
spell:allowOnSelf(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:register()
