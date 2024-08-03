local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLICE)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	combat:execute(creature, var)
	addEvent(castIceMissile, 150, creature:getId(), var)
	addEvent(castIceMissile, 300, creature:getId(), var)
	addEvent(castIceMissile, 450, creature:getId(), var)
	return
end

function castIceMissile(cid, var)
	local creature = Creature(cid)
	if creature and var then
		combat:execute(creature, var)
	end
end

spell:name("ice barrage")
spell:words("###6040")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
