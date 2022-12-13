local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

function onTargetCreature(creature, target)
	local min = 200
	local max = 300

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

spell:name("spawn of the welter heal2")
spell:words("###396")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()