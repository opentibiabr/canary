local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	combat:execute(creature, var)
	addEvent(castEnergyMissile, 150, creature:getId(), var)
	addEvent(castEnergyMissile, 300, creature:getId(), var)
	addEvent(castEnergyMissile, 450, creature:getId(), var)
	return
end

function castEnergyMissile(cid, var)
	local creature = Creature(cid)
	if creature and var then
		combat:execute(creature, var)
	end
end

spell:name("energy barrage")
spell:words("###6038")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
