local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	combat:execute(creature, var)
	addEvent(castDeathMissile, 150, creature:getId(), var)
	addEvent(castDeathMissile, 300, creature:getId(), var)
	addEvent(castDeathMissile, 450, creature:getId(), var)
	return
end

function castDeathMissile(cid, var)
	local creature = Creature(cid)
	if creature and var then
		combat:execute(creature, var)
	end
end

spell:name("death barrage")
spell:words("###6042")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
