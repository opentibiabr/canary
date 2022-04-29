local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 16000)
condition:setParameter(CONDITION_PARAM_BUFF_DAMAGERECEIVED, 105)

function onTargetCreature(creature, target)
	local player = creature:getPlayer()

	if target:isPlayer() then
		return false
	end
	if target:getMaster() then
		return true
	end

	target:addCondition(condition)
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var, isHotkey)
	local target = creature:getTarget()
	if target then
		var = Variant(target)
	end
	return combat:execute(creature, var)
end

spell:group("support", "crippling")
spell:id(243)
spell:name("Expose Weakness")
spell:words("exori moe")
spell:level(275)
spell:mana(400)
spell:isSelfTarget(true)
spell:cooldown(12 * 1000)
spell:groupCooldown(2 * 1000, 12 * 1000)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:needLearn(false)
spell:register()