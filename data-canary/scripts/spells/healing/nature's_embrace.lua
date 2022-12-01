local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 2.5) + (maglevel * 20)
	local max = (level / 2.5) + (maglevel * 28) -- TODO: Formulas (TibiaWiki says x2 but need more acurracy)
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if creature:isPlayer() and var:getNumber() == creature:getId() then
		creature:sendCancelMessage("You can't cast this spell to yourself.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	return false
	else
		return combat:execute(creature, var)
	end
end

spell:group("healing")
spell:id(242)
spell:name("Nature's Embrace")
spell:words("exura gran sio")
spell:level(300)
spell:mana(400)
spell:isPremium(true)
spell:needTarget(true)
spell:cooldown(1 * 1000)
spell:groupCooldown(1 * 1000)
spell:isAggressive(false)
spell:isBlockingWalls(true)
spell:hasParams(true)
spell:hasPlayerNameParam(true)
spell:vocation("druid;true", "elder druid;true")
spell:needLearn(false)
spell:register()