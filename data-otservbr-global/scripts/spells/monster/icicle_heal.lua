local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onTargetCreature(creature, target)
	local spectators, spectator = Game.getSpectators(creature:getPosition(), false, false, 3, 3, 3, 3)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName():lower() == "dragon egg" then
			creature:setTarget("dragon egg")
			if target:getName():lower() == "dragon egg" then
				target:addHealth(-100)
				return true
			end
		end
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("icicle heal")
spell:words("###436")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
