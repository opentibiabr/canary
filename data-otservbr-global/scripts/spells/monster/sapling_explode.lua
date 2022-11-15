local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREAREA)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))


function removeSapling(cid)
	local creature = Creature(cid)
	if not isCreature(creature) then return false end
	creature:remove()
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	addEvent(removeSapling, 1, creature.uid)
	return combat:execute(creature, var)
end

spell:name("sapling explode")
spell:words("###6004")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()