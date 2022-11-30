local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POFF)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setArea(createCombatArea(AREA_BEAM7))

function onTargetCreature(creature, target)
	local min = 200
	local max = 700

	local master = target:getMaster()
	if target:isPlayer() and not master
			or master and master:isPlayer() then
		doTargetCombatHealth(0, target, COMBAT_ICEDAMAGE, min, max, CONST_ME_NONE)
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

spell:name("frozen minion beam")
spell:words("###438")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()