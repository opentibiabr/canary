local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 10)
	local max = (level / 5) + (maglevel * 14)
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, var)
	if creature:isPlayer() and var:getNumber() == creature:getId() then
		creature:sendCancelMessage("You can't cast this spell to yourself.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
	else
		return combat:execute(creature, var)
	end
end
