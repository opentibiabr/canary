function onTargetCreature(creature, target)
	if target:getName() == "Goshnar's Malice" then
		logger.debug("Monster {} Healing {}", creature:getName(), target:getName())
		local min = 15000
		local max = 30000
		doTargetCombatHealth(target, target, COMBAT_HEALING, min, max)
	end
	return true
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Heal Malice")
spell:words("#####462")
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
