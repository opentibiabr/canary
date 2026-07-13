local SPELL_BASE_POWER = 130

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DIVINE_BARRAGE)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

function onGetFormulaValues(player, level, magicLevel)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * magicLevel) + (SPELL_BASE_POWER / 4)
	return -damage * 0.9, -damage * 1.1
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:group("attack")
spell:id(302)
spell:name("Divine Barrage")
spell:words("exori dir san")
spell:level(70)
spell:mana(175)
spell:isAggressive(true)
spell:isPremium(true)
spell:range(7)
spell:optionalTarget(true)
spell:blockWalls(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
