local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLHOLY)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	combat:execute(creature, var)
	addEvent(castHolyMissile, 150, creature:getId(), var)
	addEvent(castHolyMissile, 300, creature:getId(), var)
	addEvent(castHolyMissile, 450, creature:getId(), var)
	return
end

function castHolyMissile(cid, var)
	local creature = Creature(cid)
	if creature and var then
		combat:execute(creature, var)
	end
end

spell:name("holy barrage")
spell:words("###6041")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
