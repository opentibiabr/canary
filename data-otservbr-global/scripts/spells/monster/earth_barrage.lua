local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	combat:execute(creature, var)
	addEvent(castEarthMissile, 150, creature:getId(), var)
	addEvent(castEarthMissile, 300, creature:getId(), var)
	addEvent(castEarthMissile, 450, creature:getId(), var)
	return
end

function castEarthMissile(cid, var)
	local creature = Creature(cid)
	if creature and var then
		combat:execute(creature, var)
	end
end

spell:name("earth barrage")
spell:words("###6039")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
