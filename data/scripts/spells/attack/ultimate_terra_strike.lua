local SPELL_BASE_POWER = 195

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CARNIPHILA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)

function onGetFormulaValues(player, level, maglevel)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * maglevel) + (SPELL_BASE_POWER / 4)
	return -(damage * 0.9), -(damage * 1.1)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack", "ultimatestrikes")
spell:id(157)
spell:name("Ultimate Terra Strike")
spell:words("exori max tera")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
spell:impactSound(SOUND_EFFECT_TYPE_SPELL_ULTIMATE_TERRA_STRIKE)
spell:level(90)
spell:mana(100)
spell:isPremium(true)
spell:range(7)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(30 * 1000)
spell:groupCooldown(2 * 1000, 30 * 1000)

spell:vocation("druid;true", "elder druid;true")
spell:register()
