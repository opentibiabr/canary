local SPELL_BASE_POWER = 40

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ETHEREAL_BARRAGE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, skill, attack, factor)
	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + player:calculateFlatDamageHealing()
	return -damage * 0.9, -damage * 1.1
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:group("attack")
spell:id(303)
spell:name("Ethereal Barrage")
spell:words("exori dir moe")
spell:level(60)
spell:mana(135)
spell:isAggressive(true)
spell:isPremium(true)
spell:range(7)
spell:optionalTarget(true)
spell:blockWalls(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
