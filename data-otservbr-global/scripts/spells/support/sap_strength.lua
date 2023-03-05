function onTargetCreature(creature, target)
	local player = creature:getPlayer()

	if target:isPlayer() then
		return false
	end
	if target:getMaster() then
		return true
	end

	local buff = 90
	if (creature and creature:getPlayer()) then
		local grade = creature:upgradeSpellsWORD("Sap Strength")
		if (grade == 2) then
			buff = 80
		end
	end

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 16000)
	condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, buff)

	local gradeBuff = 0
	if (creature and creature:getPlayer()) then
		gradeBuff = creature:upgradeSpellsWORD("Drain_Body_Spells")
	end
	condition:setParameter(CONDITION_PARAM_DRAIN_BODY, gradeBuff)

	target:addCondition(condition)
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
onTargetCreatureWOD = loadstring(string.dump(onTargetCreature))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local combatWOD = Combat()
combatWOD:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combatWOD:setArea(createCombatArea(AREA_CIRCLE5X5))
combatWOD:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreatureWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var, isHotkey)
	local target = creature:getTarget()
	if target then
		var = Variant(target)
	end
	if (creature and creature:getPlayer()) then
		if (WheelOfDestinySystem.getPlayerSpellAdditionalArea(creature:getPlayer(), "Sap Strength")) then
			return combatWOD:execute(creature, var)
		end
	end
	return combat:execute(creature, var)
end

spell:group("support", "crippling")
spell:id(244)
spell:name("Sap Strength")
spell:words("exori kor")
spell:level(275)
spell:mana(300)
spell:isSelfTarget(true)
spell:cooldown(12 * 1000)
spell:groupCooldown(2 * 1000, 12 * 1000)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:needLearn(false)
spell:register()