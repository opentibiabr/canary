local function targetFunction(creature, target)
	local player = creature:getPlayer()

	if target:isPlayer() then
		return false
	end
	if target:getMaster() then
		return true
	end

	local buff = 90
	if creature and creature:getPlayer() then
		local grade = creature:upgradeSpellsWOD("Sap Strength")
		if grade == WHEEL_GRADE_UPGRADED then
			buff = 80
		end
	end

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 16000)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, buff)

	local gradeBuff = 0
	if creature and creature:getPlayer() then
		gradeBuff = creature:upgradeSpellsWOD("Drain_Body_Spells")
	end
	condition:setParameter(CONDITION_PARAM_DRAIN_BODY, gradeBuff)

	target:addCondition(condition)
end

function onTargetCreature(creature, target)
	targetFunction(creature, target)
	return true
end

function onTargetCreatureWOD(creature, target)
	targetFunction(creature, target)
	return true
end

local function createCombat(area, combatFunc)
	local initCombat = Combat()
	initCombat:setCallback(CALLBACK_PARAM_TARGETCREATURE, combatFunc)
	initCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
	initCombat:setArea(createCombatArea(area))
	return initCombat
end

local combat = createCombat(AREA_CIRCLE3X3, "onTargetCreature")
local combatWOD = createCombat(AREA_CIRCLE5X5, "onTargetCreatureWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var, isHotkey)
	local target = creature:getTarget()
	if target then
		var = Variant(target)
	end
	local player = creature:getPlayer()
	if creature and player then
		if player:getWheelSpellAdditionalArea("Sap Strength") then
			return combatWOD:execute(creature, var)
		end
	end
	return combat:execute(creature, var)
end

spell:group("support", "crippling")
spell:id(244)
spell:name("Sap Strength")
spell:words("exori kor")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SAP_STRENGTH)
spell:level(275)
spell:mana(300)
spell:isSelfTarget(true)
spell:cooldown(12 * 1000)
spell:groupCooldown(2 * 1000, 12 * 1000)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:needLearn(false)
spell:register()
