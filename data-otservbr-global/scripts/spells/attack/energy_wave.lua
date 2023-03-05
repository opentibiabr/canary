local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5, AREADIAGONAL_SQUAREWAVE5))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 4.5)
	local max = (level / 5) + (maglevel * 9)
	return -min, -max
end

onGetFormulaValuesWOD = loadstring(string.dump(onGetFormulaValues))
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local combatWOD = Combat()
combatWOD:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatWOD:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combatWOD:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combatWOD:setArea(createCombatArea(AREA_WAVE7, AREADIAGONAL_WAVE7))
 
combatWOD:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValuesWOD")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if (creature and creature:getPlayer()) then
		if (WheelOfDestinySystem.getPlayerSpellAdditionalArea(creature:getPlayer(), "Energy Wave")) then
			return combatWOD:execute(creature, var)
		end
	end
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(13)
spell:name("Energy Wave")
spell:words("exevo vis hur")
spell:level(38)
spell:mana(170)
spell:needDirection(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()