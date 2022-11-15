local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onTargetCreature(creature, target)
	local min = 400
	local max = 600

	local master = target:getMaster()
	if target:isPlayer() and not master
			or master and master:isPlayer() then
		return true
	end

	doTargetCombatHealth(0, target, COMBAT_HEALING, min, max, CONST_ME_NONE)
	return true
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("icecle heal")
spell:words("###436")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()