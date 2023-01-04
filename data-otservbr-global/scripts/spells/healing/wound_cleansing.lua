local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel) -- already compared to the official tibia | compared date: 08/03/21(m/d/y)
	local min = (level * 0.2 + magicLevel * 4) + 25
	local max = (level * 0.2 + magicLevel * 7.95) + 51
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Wound Cleansing")
spell:words("exura ico")
spell:group("healing")
spell:vocation("knight;true", "elite knight;true")
spell:id(123)
spell:cooldown(1 * 1000)
spell:groupCooldown(1 * 1000)
spell:level(8)
spell:mana(40)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:register()
